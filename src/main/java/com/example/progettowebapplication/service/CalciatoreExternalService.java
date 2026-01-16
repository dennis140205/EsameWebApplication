package com.example.progettowebapplication.service;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.dao.ICalciatoreDAO;
import com.example.progettowebapplication.model.*;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.util.List;
import java.util.regex.Pattern;
import java.util.Map;
import java.util.Set;
import java.util.HashSet;
import java.util.stream.Collectors;

// Service che gestisce tutto ciò che arriva da fuori: CSV caricati e API Esterne
@Service
public class CalciatoreExternalService {
    // Per calcolare i fantavoti specifici per ogni lega
    @Autowired
    private CalcoloPunteggioService calcoloPunteggioService;

    // Legge le configurazioni dal file application.properties
    @Value("${api.football.key}")
    private String apiKey;

    @Value("${api.football.url}")
    private String apiUrl;
    // Anno di riferimento per l'API delle foto, messo a 2023 perchè è l'ultimo anno gratis disponibile nell'API
    private int stagioneApi = 2023;

    private ICalciatoreDAO getDao() {
        return DbManager.getInstance().getCalciatoreDao();
    }

    // Gestione admin tramite CSV (Stati dei giocatori e voti post-partita)

    // Metodo per aggiornare gli infortunati/squalificati leggendo un file CSV (struttura: id;stato)
    public String aggiornaStatiDaCsv(MultipartFile file) {
        ICalciatoreDAO dao = getDao();
        // Resetta tutti a DISPONIBILE per pulire i vecchi infortuni
        dao.resetTuttiDisponibili();
        int aggiornati = 0;
        // Legge il file riga per riga
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            boolean isFirstLine = true;

            while ((line = reader.readLine()) != null) {
                // Salta l'intestazione e le righe vuote
                if (isFirstLine && line.toLowerCase().startsWith("id")) { isFirstLine = false; continue; }
                if (line.trim().isEmpty()) continue;
                String[] dati = line.split(";");
                try {
                    // Legge ID (codice fantacalcio) e stato dal file
                    int codiceFanta = Integer.parseInt(dati[0].trim());
                    String statoStr = dati[1].trim().toUpperCase();
                    // Cerca il calciatore usando il codice fantacalcio
                    CalciatoreDTO calciatore = dao.getCalciatoreByCodiceApi(codiceFanta);
                    if (calciatore != null) {
                        try {
                            // Aggiorna lo stato nel DB
                            calciatore.setStato(StatoCalciatore.valueOf(statoStr));
                        } catch (IllegalArgumentException e) {
                            System.out.println("Stato non valido: " + statoStr);
                        }
                        dao.updateCalciatore(calciatore);
                        aggiornati++;
                    } else {
                        System.out.println("Nessun calciatore trovato con codice: " + codiceFanta);
                    }
                } catch (Exception e) {
                    System.out.println("Errore riga: " + line + " -> " + e.getMessage());
                }
            }
            return "Reset eseguito. Nuovi stati applicati: " + aggiornati;

        } catch (Exception e) {
            return "Errore lettura file: " + e.getMessage();
        }
    }

    // Metodo per calcolare i voti post-partita leggendo il CSV (struttura: id;voto;gol fatti;gol subiti;rigori parati;rigori sbagliati;autogol;assist;ammonizioni;espulsioni)
    public String caricaVotiDaCsv(MultipartFile file, int giornata) {
        ICalciatoreDAO dao = getDao();
        // Rimuove i voti vecchi di questa giornata
        dao.deleteStatisticheByGiornata(giornata);
        // Recupera tutti i calciatori attivi dal DB
        List<CalciatoreDTO> tuttiCalciatori = dao.getAllCalciatori();
        // Mappa per trovarli velocemente tramite il loro Codice API
        // (codiceApi -> Oggetto Calciatore)
        Map<Integer, CalciatoreDTO> mappaCalciatori = tuttiCalciatori.stream()
                .filter(c -> c.getCodiceApi() != null)
                .collect(Collectors.toMap(CalciatoreDTO::getCodiceApi, c -> c));
        // Tenere traccia di chi abbiamo trovato nel file
        Set<Long> idCalciatoriProcessati = new HashSet<>();
        int inseriti = 0;
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            boolean isFirstLine = true;
            // Legge il CSV e inserisce i voti presenti
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] dati = line.split(";");
                // Salta qualsiasi riga che non inizi con un numero (l'ID)
                if (!dati[0].trim().matches("\\d+")) {
                    continue;
                }
                try {
                    int codiceFanta = Integer.parseInt(dati[0].trim());
                    CalciatoreDTO calciatore = mappaCalciatori.get(codiceFanta);
                    if (calciatore == null) {
                        System.out.println("ID " + codiceFanta + " non trovato nel DB.");
                        continue;
                    }
                    StatisticaDTO stat = new StatisticaDTO();
                    stat.setIdCalciatore(calciatore.getId());
                    stat.setGiornata(giornata);

                    // Mappatura indici corretta per il file
                    // dati[0]=ID, [1]=Ruolo, [2]=Nome, [3]=Voto, [4]=Gf...
                    String votoString = dati[3].replace(",", ".").replace("*", "").trim();
                    try {
                        stat.setVoto(Double.parseDouble(votoString));
                    } catch (NumberFormatException e) {
                        stat.setVoto(null); // S.V.
                    }
                    stat.setGolFatti(Integer.parseInt(dati[4].trim()));      // Gf
                    stat.setGolSubiti(Integer.parseInt(dati[5].trim()));     // Gs
                    stat.setRigoriParati(Integer.parseInt(dati[6].trim()));   // Rp
                    stat.setRigoriSbagliati(Integer.parseInt(dati[7].trim())); // Rs
                    stat.setAutogol(Integer.parseInt(dati[9].trim()));       // Au
                    stat.setAmmonizione(Integer.parseInt(dati[10].trim()) == 1); // Amm
                    stat.setEspulsione(Integer.parseInt(dati[11].trim()) == 1);  // Esp
                    stat.setAssist(Integer.parseInt(dati[12].trim()));       // Ass
                    dao.inserisciStatistica(stat);
                    idCalciatoriProcessati.add(calciatore.getId());
                    inseriti++;
                } catch (Exception e) {
                    System.out.println("Errore riga: " + line + " -> " + e.getMessage());
                }
            }

            // Gestisce i giocatori che non sono nel CSV
            int assentiInseriti = 0;
            for (CalciatoreDTO c : tuttiCalciatori) {
                // Se l'ID del calciatore non è nei processati, vuol dire che non era nel file
                if (!idCalciatoriProcessati.contains(c.getId())) {
                    StatisticaDTO statAssente = new StatisticaDTO();
                    statAssente.setIdCalciatore(c.getId());
                    statAssente.setGiornata(giornata);
                    statAssente.setVoto(null); // Voto nullo
                    // Tutti gli altri valori numerici (gol, assist, ecc.) vengono settati a 0/false esplicitamente
                    statAssente.setGolFatti(0);
                    statAssente.setGolSubiti(0);
                    statAssente.setAmmonizione(false);
                    statAssente.setEspulsione(false);
                    dao.inserisciStatistica(statAssente);
                    assentiInseriti++;
                }
            }

            // Aggiorna subito i voti nelle formazioni degli utenti
            aggiornaVotiLiveNelleFormazioni(giornata);
            return "Giornata " + giornata + " completata. " + inseriti + " voti dal file, " + assentiInseriti + " inseriti come assenti (null).";
        } catch (Exception e) {
            return "Errore critico file: " + e.getMessage();
        }
    }

    // Logica dei voti live
    private void aggiornaVotiLiveNelleFormazioni(int giornata) {
        System.out.println("Avvio aggiornamento LIVE Fantavoti...");
        // Mappa di tutti i voti appena caricati (IdCalciatore -> Statistica)
        List<StatisticaDTO> stats = getDao().getStatisticheByGiornata(giornata);
        Map<Long, StatisticaDTO> mapStats = stats.stream().collect(Collectors.toMap(StatisticaDTO::getIdCalciatore, s -> s));
        // Recupera tutte le squadre esistenti
        List<FantasquadraDTO> allSquadre = DbManager.getInstance().getFantasquadraDao().getAllFantasquadre();
        // Raggruppa le squadre per Lega (per caricare le regole una volta sola)
        Map<Long, List<FantasquadraDTO>> squadrePerLega = allSquadre.stream().collect(Collectors.groupingBy(FantasquadraDTO::getIdLega));
        // Cicla lega per lega
        for (Map.Entry<Long, List<FantasquadraDTO>> entry : squadrePerLega.entrySet()) {
            Long idLega = entry.getKey();
            List<FantasquadraDTO> squadreLega = entry.getValue();
            // Regole di questa lega
            ImpostazioniLegaDTO regole = DbManager.getInstance().getImpostazioniLegaDao().getByIdLega(idLega);
            for (FantasquadraDTO sq : squadreLega) {
                // Prende la formazione di questa squadra
                FormazioneDTO form = DbManager.getInstance().getFormazioneDao().getFormazione(sq.getIdFantasquadra(), giornata);
                if (form != null) {
                    // Aggiorna ogni giocatore schierato
                    for (SchieramentoDTO sch : form.getCalciatori()) {
                        StatisticaDTO stat = mapStats.get(sch.getIdCalciatore());
                        // Se c'è un voto/statistica per lui
                        if (stat != null) {
                            // Calcola il fantavoto al volo
                            Double fantaVoto = calcoloPunteggioService.calcolaFantavoto(stat, regole);
                            // Aggiorna il fanta_voto nel database
                            if (sch.getId() != null) {
                                DbManager.getInstance().getFormazioneDao().aggiornaVotoSchieramento(sch.getId(), fantaVoto);
                            }
                        }
                    }
                }
            }
        }
        System.out.println("Aggiornamento LIVE completato.");
    }

    // Carica il listone iniziale dal file interno al progetto
    public String importListoneCsv() {
        ICalciatoreDAO dao = getDao();
        int inseriti = 0;
        try {
            // Carica il file dalle risorse del progetto
            InputStream is = getClass().getClassLoader().getResourceAsStream("Quotazioni_Fantacalcio_Stagione_2025_26.csv");
            if (is == null) return "Errore: File CSV iniziale non trovato!";
            BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String line;
            reader.readLine(); // Salta intestazione
            while ((line = reader.readLine()) != null) {
                String[] dati = line.split(";");
                String nomeCsv = dati[1];
                String squadraCsv = dati[3];
                int codiceCsv = Integer.parseInt(dati[0]); // ID fantacalcio
                // Controlla se esiste già per non duplicarlo
                CalciatoreDTO esistente = dao.getCalciatoreByNome(nomeCsv);
                if (esistente != null && esistente.getSquadra().equalsIgnoreCase(squadraCsv)) {
                    // Se esiste, aggiorna solo il codice se manca
                    if(esistente.getCodiceApi() == null || esistente.getCodiceApi() != codiceCsv) {
                        esistente.setCodiceApi(codiceCsv);
                        dao.updateCalciatore(esistente);
                    }
                    continue;
                }
                // Creazione nuovo giocatore
                CalciatoreDTO c = new CalciatoreDTO();
                c.setCodiceApi(codiceCsv);
                c.setNome(nomeCsv);
                c.setRuolo(Ruolo.valueOf(dati[2]));
                c.setSquadra(squadraCsv);
                c.setQuotazione(Integer.parseInt(dati[4]));
                try {
                    c.setStato(StatoCalciatore.valueOf(dati[5]));
                } catch (Exception e) {
                    c.setStato(StatoCalciatore.DISPONIBILE);
                }
                dao.insertCalciatore(c);
                inseriti++;
            }
            // Avvia il "download" delle foto
            syncImmagini();
            return "Importazione completata: " + inseriti + " inseriti. Aggiornati codici esistenti.";
        } catch (Exception e) {
            e.printStackTrace();
            return "Errore importazione: " + e.getMessage();
        }
    }

    // Collega all'API esterna per scaricare le foto dei giocatori
    // Ogni volta che si caricano le immagini è richiesto qualche minuto (circa 6,5 secondi per ogni squadra) per via dei limiti dell'API gratuita
    public String syncImmagini() {
        ICalciatoreDAO dao = getDao();
        List<CalciatoreDTO> mieiCalciatori = dao.getAllCalciatori();
        int aggiornati = 0;
        // Se tutti hanno già la foto si ferma subito
        boolean qualcunoSenzaFoto = false;
        for (CalciatoreDTO c : mieiCalciatori) {
            if (c.getUrlImmagine() == null || c.getUrlImmagine().isEmpty()) {
                qualcunoSenzaFoto = true;
                break;
            }
        }
        if (!qualcunoSenzaFoto) {
            return "Tutti i giocatori hanno già la foto. Nessun aggiornamento necessario.";
        }
        // Strumenti per chiamate HTTP
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.set("x-apisports-key", apiKey);
        // Forza una nuova connessione per ogni richiesta per evitare timeout del server
        headers.set("Connection", "close");
        HttpEntity<String> entity = new HttpEntity<>(headers);
        int[] leghe = {135, 136}; // ID API per Serie A e Serie B (visto che risalgono al 2023)
        try {
            for (int lega : leghe) {
                System.out.println("--- SCANSIONE LEGA " + lega + " ---");
                // Scarica elenco squadre della lega
                String urlTeams = apiUrl + "/teams?league=" + lega + "&season=" + stagioneApi;
                try {
                    ResponseEntity<String> responseTeams = restTemplate.exchange(urlTeams, HttpMethod.GET, entity, String.class);
                    ObjectMapper mapper = new ObjectMapper();
                    JsonNode rootTeams = mapper.readTree(responseTeams.getBody());
                    JsonNode teamsNode = rootTeams.get("response");
                    if (teamsNode == null || !teamsNode.isArray()) continue;
                    // Per ogni squadra
                    for (JsonNode teamItem : teamsNode) {
                        int teamId = teamItem.get("team").get("id").asInt();
                        String teamNameApi = teamItem.get("team").get("name").asText();
                        System.out.println("Aggiorno " + teamNameApi + "... attesa 6.5s...");
                        // Pausa per non farsi bloccare dall'API (limite richieste)
                        Thread.sleep(6500);
                        // Se una squadra fallisce, si passa alla prossima
                        try {
                            // Scarica la rosa della squadra
                            String urlSquad = apiUrl + "/players/squads?team=" + teamId;
                            ResponseEntity<String> responseSquad = restTemplate.exchange(urlSquad, HttpMethod.GET, entity, String.class);
                            if (responseSquad.getStatusCode() == HttpStatus.OK) {
                                JsonNode rootSquad = mapper.readTree(responseSquad.getBody());
                                JsonNode responseArr = rootSquad.get("response");
                                if (responseArr.isArray() && responseArr.size() > 0) {
                                    JsonNode playersList = responseArr.get(0).get("players");
                                    // Cerca corrispondenze tra API e il nostro DB
                                    for (JsonNode p : playersList) {
                                        String nomeApi = p.get("name").asText();
                                        String fotoUrl = p.get("photo").asText();
                                        if (fotoUrl == null || fotoUrl.isEmpty()) continue;
                                        for (CalciatoreDTO mioCalciatore : mieiCalciatori) {
                                            // Se c'è già la sua foto lo saltiamo
                                            if (mioCalciatore.getUrlImmagine() != null && !mioCalciatore.getUrlImmagine().isEmpty())
                                                continue;
                                            // Se i nomi coincidono
                                            if (matchNomi(mioCalciatore.getNome(), nomeApi)) {
                                                mioCalciatore.setUrlImmagine(fotoUrl);
                                                dao.updateCalciatore(mioCalciatore);
                                                aggiornati++;
                                                break;
                                            }
                                        }
                                    }
                                } else {
                                    // Controllo errori API (es. quota superata)
                                    JsonNode errors = rootSquad.get("errors");
                                    if (errors != null && !errors.isEmpty()) {
                                        System.err.println("ERRORE API SU SQUADRA " + teamNameApi + ": " + errors.toString());
                                    }
                                }
                            }
                        } catch (Exception ex) {
                            System.err.println("Errore scaricamento rosa " + teamNameApi + ": " + ex.getMessage());
                            // Continua con la prossima squadra
                        }
                    }
                } catch (Exception e) {
                    System.err.println("Errore scaricamento lista squadre lega " + lega + ": " + e.getMessage());
                }
            }
            return "Sync Foto finita. Foto aggiornate: " + aggiornati;
        } catch (Exception e) {
            e.printStackTrace();
            return "Errore Sync: " + e.getMessage();
        }
    }

    // Metodi di supporto per confrontare i nomi
    private String normalize(String s) {
        // Rimuove accenti e caratteri speciali (es. Vlahović -> vlahovic)
        if (s == null) return "";
        String normalized = Normalizer.normalize(s, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(normalized).replaceAll("").toLowerCase().trim();
    }

    private boolean matchNomi(String nomeDB, String stringaApi) {
        if (nomeDB == null || stringaApi == null) return false;
        String db = normalize(nomeDB);
        String api = normalize(stringaApi);
        // Controllo esatto (es. "Romelu Lukaku" == "Romelu Lukaku")
        if (db.equals(api)) return true;
        // Divisione in parole
        String[] paroleDB = db.split("[\\s.-]+");
        String[] paroleAPI = api.split("[\\s.-]+");
        int matchCount = 0;
        int paroleSignificativeDB = 0;
        // Conta le parole significative nel database (lunghezza > 2)
        for (String p : paroleDB) {
            if (p.length() > 2) {
                paroleSignificativeDB++;
            }
        }
        int sogliaMinima = (paroleSignificativeDB > 0) ? 3 : 2;
        // Conta quante parole coincidono
        for (String pDB : paroleDB) {
            if (pDB.length() < sogliaMinima) continue;
            for (String pAPI : paroleAPI) {
                if (pAPI.equals(pDB)) {
                    matchCount++;
                    break;
                }
            }
        }
        // Caso a: se il giocatore nel database ha parole significative devono matchare tutte le parole significative (o almeno 2 se il nome è lunghissimo)
        if (paroleSignificativeDB >= 2) {
            return matchCount >= 2;
        }
        // Caso b: se il giocatore ha solo una parola significativa deve matchare quella parola
        if (paroleSignificativeDB == 1) {
            return matchCount >= 1;
        }
        // Fallback per nomi cortissimi non gestiti
        return false;
    }
}