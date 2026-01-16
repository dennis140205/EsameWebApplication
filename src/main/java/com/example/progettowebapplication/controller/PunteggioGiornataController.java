package com.example.progettowebapplication.controller;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.model.*;
import com.example.progettowebapplication.service.CalcoloGiornataService;
import com.example.progettowebapplication.service.CalcoloPunteggioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/punteggi")
@CrossOrigin(origins = "http://localhost:4200")
public class PunteggioGiornataController {

    @Autowired
    private CalcoloGiornataService calcoloGiornataService;

    // Ottenere l'utente loggato
    private UtenteDTO getUtenteLoggato() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) return null;
        return DbManager.getInstance().getUtenteDao().getUtenteByEmail(auth.getName());
    }

    // Calcola la giornata e aggiorna la classifica
    // POST http://localhost:8080/punteggi/calcola/lega/1/giornata/3
    @PostMapping("/calcola/lega/{idLega}/giornata/{giornata}")
    public ResponseEntity<String> calcolaGiornata(@PathVariable Long idLega, @PathVariable int giornata) {
        try {
            // Solo l'admin della lega può lanciare il calcolo
            UtenteDTO utente = getUtenteLoggato();
            FantasquadraDTO squadraAdmin = DbManager.getInstance().getFantasquadraDao().getByUtenteAndLega(utente.getId(), idLega);
            if (squadraAdmin == null || !squadraAdmin.isAdmin()) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Solo l'admin può calcolare la giornata.");
            }

            // Recupera le impostazioni (soglia gol, fasce, bonus)
            ImpostazioniLegaDTO regole = DbManager.getInstance().getImpostazioniLegaDao().getByIdLega(idLega);

            // Recupera il calendario (chi gioca contro chi)
            List<CalendarioDTO> partite = DbManager.getInstance().getCalendarioDao().getPartiteByLegaAndGiornata(idLega, giornata);
            if (partite.isEmpty()) {
                return ResponseEntity.badRequest().body("Nessuna partita trovata nel calendario per questa giornata.");
            }

            int partiteCalcolate = 0;

            // Ciclo sulle partite
            for (CalendarioDTO partita : partite) {
                if (partita.isGiocata()) {
                    revertSquadra(partita.getIdSquadraCasa(), giornata);
                    revertSquadra(partita.getIdSquadraTrasferta(), giornata);
                }
                // Squadra di casa
                // Calcola il fantavoto (es. 74.5)
                Double fantaPuntiCasa = calcoloGiornataService.calcolaPunteggioSquadra(partita.getIdSquadraCasa(), giornata);
                // Converte in gol (es. 2 gol)
                int golCasa = calcoloGiornataService.convertiPuntiInGol(fantaPuntiCasa, regole);

                // Squadra di trasferta
                Double fantaPuntiTrasf = calcoloGiornataService.calcolaPunteggioSquadra(partita.getIdSquadraTrasferta(), giornata);
                int golTrasf = calcoloGiornataService.convertiPuntiInGol(fantaPuntiTrasf, regole);

                // Assegnazione punti classifica
                int puntiClassificaCasa = 0;
                int puntiClassificaTrasf = 0;
                if (golCasa > golTrasf) {
                    puntiClassificaCasa = 3; // Vince casa
                    puntiClassificaTrasf = 0;
                } else if (golTrasf > golCasa) {
                    puntiClassificaCasa = 0;
                    puntiClassificaTrasf = 3; // Vince trasferta
                } else {
                    puntiClassificaCasa = 1; // pareggio
                    puntiClassificaTrasf = 1;
                }

                // Salva lo storico giornata
                // Salva i dati per casa
                PunteggioGiornataDTO storicoCasa = new PunteggioGiornataDTO(null, partita.getIdSquadraCasa(), giornata, fantaPuntiCasa, golCasa, golTrasf, puntiClassificaCasa);
                DbManager.getInstance().getPunteggioGiornataDao().salvaPunteggio(storicoCasa);

                // Salva i dati per trasferta
                PunteggioGiornataDTO storicoTrasf = new PunteggioGiornataDTO(null, partita.getIdSquadraTrasferta(), giornata, fantaPuntiTrasf, golTrasf, golCasa, puntiClassificaTrasf);
                DbManager.getInstance().getPunteggioGiornataDao().salvaPunteggio(storicoTrasf);

                // Aggiorna la partita nel calendario
                partita.setFantaPunteggioCasa(fantaPuntiCasa);
                partita.setFantaPunteggioTrasferta(fantaPuntiTrasf);
                partita.setGolCasa(golCasa);
                partita.setGolTrasferta(golTrasf);
                partita.setGiocata(true);
                DbManager.getInstance().getCalendarioDao().updateRisultatoPartita(partita);

                // Aggiorna la classifica generale
                // Aggiorna casa
                DbManager.getInstance().getFantasquadraDao().aggiornaClassifica(partita.getIdSquadraCasa(), puntiClassificaCasa, golCasa, golTrasf, fantaPuntiCasa,1);

                // Aggiorna trasferta
                DbManager.getInstance().getFantasquadraDao().aggiornaClassifica(partita.getIdSquadraTrasferta(), puntiClassificaTrasf, golTrasf, golCasa, fantaPuntiTrasf,1);
                partiteCalcolate++;
            }
            return ResponseEntity.ok("Calcolo completato! Aggiornate " + partiteCalcolate + " partite.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Errore nel calcolo: " + e.getMessage());
        }
    }

    // Resetta la giornata
    // POST http://localhost:8080/punteggi/reset/lega/1/giornata/3
    @PostMapping("/reset/lega/{idLega}/giornata/{giornata}")
    public ResponseEntity<String> resetGiornata(@PathVariable Long idLega, @PathVariable int giornata) {
        try {
            // Solo admin
            UtenteDTO utente = getUtenteLoggato();
            FantasquadraDTO squadraAdmin = DbManager.getInstance().getFantasquadraDao().getByUtenteAndLega(utente.getId(), idLega);
            if (squadraAdmin == null || !squadraAdmin.isAdmin()) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Solo l'admin può resettare la giornata.");
            }

            // Recupera le partite di quella giornata
            List<CalendarioDTO> partite = DbManager.getInstance().getCalendarioDao().getPartiteByLegaAndGiornata(idLega, giornata);
            int partiteResettate = 0;
            for (CalendarioDTO partita : partite) {
                // Se la partita non era stata calcolata, la salta
                if (!partita.isGiocata()) continue;
                revertSquadra(partita.getIdSquadraCasa(), giornata);
                revertSquadra(partita.getIdSquadraTrasferta(), giornata);
                partiteResettate++;
            }
            // Resetta il calendario (imposta tutto a 0 e giocata=false)
            DbManager.getInstance().getCalendarioDao().resetPartiteGiornata(idLega, giornata);
            return ResponseEntity.ok("Reset completato. " + partiteResettate + " partite annullate. Ora puoi ricalcolare.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Errore durante il reset: " + e.getMessage());
        }
    }

    // Metodo per annullare una partita
    private void revertSquadra(Long idSquadra, int giornata) {
        // Legge cosa aveva fatto la squadra in quella giornata
        PunteggioGiornataDTO storico = DbManager.getInstance().getPunteggioGiornataDao().getPunteggioBySquadraAndGiornata(idSquadra, giornata);
        if (storico != null) {
            // Sottrae i punti dalla classifica generale
            // Esempio: se aveva preso 3 punti, passiamo -3. Il database farà punti = punti + (-3)
            DbManager.getInstance().getFantasquadraDao().aggiornaClassifica(
                    idSquadra,
                    -storico.getPuntiClassifica(), // Sottrae punti classifica
                    -storico.getGolFatti(),        // Sottrae gol fatti
                    -storico.getGolSubiti(),       // Sottrae gol subiti
                    -storico.getPunteggioTotale(),  // Sottrae fantapunti
                    -1
            );
            // Cancella la riga dallo storico
            DbManager.getInstance().getPunteggioGiornataDao().deletePunteggio(idSquadra, giornata);
        }
    }

    // URL: GET http://localhost:8080/punteggi/live/lega/1/giornata/3
    // Restituisce i risultati in tempo reale basati sui voti caricati finora
    @GetMapping("/live/lega/{idLega}/giornata/{giornata}")
    public ResponseEntity<?> getRisultatiLive(@PathVariable Long idLega, @PathVariable int giornata) {
        try {
            // Recupera le partite previste
            List<CalendarioDTO> partite = DbManager.getInstance().getCalendarioDao().getPartiteByLegaAndGiornata(idLega, giornata);
            if (partite.isEmpty()) return ResponseEntity.ok(partite);

            // Recupera le regole della lega
            ImpostazioniLegaDTO regole = DbManager.getInstance().getImpostazioniLegaDao().getByIdLega(idLega);
            // Calcola i risultati senza salvarli nel database
            for (CalendarioDTO partita : partite) {
                // Se la partita è già conclusa ufficialmente, la lasci così com'è
                if (partita.isGiocata()) continue;
                // Altrimenti, simula il calcolo usando i voti attuali
                Double fantaPuntiCasa = calcoloGiornataService.calcolaPunteggioLive(partita.getIdSquadraCasa(), giornata);
                Double fantaPuntiTrasf = calcoloGiornataService.calcolaPunteggioLive(partita.getIdSquadraTrasferta(), giornata);
                int golCasa = calcoloGiornataService.convertiPuntiInGol(fantaPuntiCasa, regole);
                int golTrasf = calcoloGiornataService.convertiPuntiInGol(fantaPuntiTrasf, regole);

                // Aggiorna l'oggetto DTO solo per la visualizzazione (non update sul database)
                partita.setFantaPunteggioCasa(fantaPuntiCasa);
                partita.setGolCasa(golCasa);
                partita.setFantaPunteggioTrasferta(fantaPuntiTrasf);
                partita.setGolTrasferta(golTrasf);
            }

            return ResponseEntity.ok(partite);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Errore calcolo live: " + e.getMessage());
        }
    }
}