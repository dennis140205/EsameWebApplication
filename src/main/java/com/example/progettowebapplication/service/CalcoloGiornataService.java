package com.example.progettowebapplication.service;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CalcoloGiornataService {

    @Autowired
    private CalcoloPunteggioService calcoloSingoloService;

    // Calcola il punteggio totale di una singola fantasquadra per una specifica giornata
    public Double calcolaPunteggioSquadra(Long idFantasquadra, int giornata) {
        FormazioneDTO formazione = DbManager.getInstance().getFormazioneDao().getFormazione(idFantasquadra, giornata);
        if (formazione == null) return 0.0;
        FantasquadraDTO squadra = DbManager.getInstance().getFantasquadraDao().getFantasquadraById(idFantasquadra);
        ImpostazioniLegaDTO regole = DbManager.getInstance().getImpostazioniLegaDao().getByIdLega(squadra.getIdLega());
        List<StatisticaDTO> tuttiVoti = DbManager.getInstance().getCalciatoreDao().getStatisticheByGiornata(giornata);
        Map<Long, StatisticaDTO> mappaVoti = tuttiVoti.stream().collect(Collectors.toMap(StatisticaDTO::getIdCalciatore, stat -> stat));
        // Calcola e salva il voto per tutti (titolari e panchinari)
        for (SchieramentoDTO s : formazione.getCalciatori()) {
            StatisticaDTO stat = mappaVoti.get(s.getIdCalciatore());
            // Se stat è null (es. partita rinviata) crea un oggetto vuoto
            if (stat == null) {
                stat = new StatisticaDTO();
                stat.setVoto(null);
            }
            Double fantaVoto = calcoloSingoloService.calcolaFantavoto(stat, regole);
            // Imposta il voto nell'oggetto in memoria ù
            s.setFantaVoto(fantaVoto);
            if (s.getId() != null) {
                DbManager.getInstance().getFormazioneDao().aggiornaVotoSchieramento(s.getId(), fantaVoto);
            }
        }

        // Gestione sostituzioni
        double totaleSquadra = 0.0;
        List<SchieramentoDTO> titolari = formazione.getCalciatori().stream().filter(c -> c.getStato() == StatoSchieramento.TITOLARE).toList();
        List<SchieramentoDTO> panchina = formazione.getCalciatori().stream().filter(c -> c.getStato() == StatoSchieramento.PANCHINA)
                .sorted((p1, p2) -> Integer.compare(p1.getOrdine(), p2.getOrdine())).toList();
        List<Long> panchinariUsati = new ArrayList<>();
        // Liste per il modificatore di difesa
        List<StatisticaDTO> votiDifensoriUtili = new ArrayList<>();
        StatisticaDTO votoPortiere = null;

        int sostituzioniEffettuate = 0;
        int maxSostituzioni = 3;
        for (SchieramentoDTO titolare : titolari) {
            boolean haGiocato = (titolare.getFantaVoto() != null);
            Double votoFinale = titolare.getFantaVoto();
            StatisticaDTO statUtilizzata = mappaVoti.get(titolare.getIdCalciatore());
            // Se il titolare non ha giocato, cerca in panchina
            if (!haGiocato) {
                if (sostituzioniEffettuate < maxSostituzioni) {
                    for (SchieramentoDTO riserva : panchina) {
                        // Cerca riserva stesso ruolo, con voto valido, non ancora usata
                        if (riserva.getRuolo() == titolare.getRuolo() && !panchinariUsati.contains(riserva.getIdCalciatore()) && riserva.getFantaVoto() != null) {
                            // Trovata riserva
                            votoFinale = riserva.getFantaVoto();
                            statUtilizzata = mappaVoti.get(riserva.getIdCalciatore());
                            panchinariUsati.add(riserva.getIdCalciatore());
                            haGiocato = true;
                            sostituzioniEffettuate++;
                            break;
                        }
                    }
                }
            }

            // Se alla fine ha giocato (titolare o riserva)
            if (haGiocato && votoFinale != null) {
                totaleSquadra += votoFinale;
                // Raccoglie dati per il modificatore
                if (titolare.getRuolo() == Ruolo.P) votoPortiere = statUtilizzata;
                if (titolare.getRuolo() == Ruolo.D) votiDifensoriUtili.add(statUtilizzata);
            }
        }
        // Calcolo modificatore di difesa
        double bonusDifesa = calcoloSingoloService.calcolaModificatoreDifesa(votiDifensoriUtili, votoPortiere, regole);
        totaleSquadra += bonusDifesa;
        return totaleSquadra;
    }

    // Converte i fantapunti in gol
    public int convertiPuntiInGol(Double punti, ImpostazioniLegaDTO imp) {
        if (punti == null || punti < imp.getSogliaGol()) {
            return 0;
        }
        // Formula: (Punti - Soglia) / Fascia + 1
        // Esempio: (72 - 66) / 6 = 1. -> 1+1 = 2 Gol
        int golExtra = (int) ((punti - imp.getSogliaGol()) / imp.getStepFascia());
        return 1 + golExtra;
    }

    // Somma solo i titolari che hanno già il voto, senza fare sostituzioni
    public Double calcolaPunteggioLive(Long idFantasquadra, int giornata) {
        // Recupera la formazione con i fantavoti già aggiornati dal csv
        FormazioneDTO formazione = DbManager.getInstance().getFormazioneDao().getFormazione(idFantasquadra, giornata);
        if (formazione == null) return 0.0;
        // Recupera le regole per calcolare i bonus/malus
        FantasquadraDTO squadra = DbManager.getInstance().getFantasquadraDao().getFantasquadraById(idFantasquadra);
        ImpostazioniLegaDTO regole = DbManager.getInstance().getImpostazioniLegaDao().getByIdLega(squadra.getIdLega());
        // Recupera tutti i voti di questa giornata
        List<StatisticaDTO> tuttiVoti = DbManager.getInstance().getCalciatoreDao().getStatisticheByGiornata(giornata);
        // Crea una mappa per cercare velocemente i voti (IdCalciatore -> Statistica)
        Map<Long, StatisticaDTO> mappaVoti = tuttiVoti.stream().collect(Collectors.toMap(StatisticaDTO::getIdCalciatore, stat -> stat));
        double totale = 0.0;
        for (SchieramentoDTO s : formazione.getCalciatori()) {
            if (s.getStato() == StatoSchieramento.TITOLARE) {
                StatisticaDTO stat = mappaVoti.get(s.getIdCalciatore());
                if (stat != null) {
                    // Calcola il fantavoto
                    Double fantaVoto = calcoloSingoloService.calcolaFantavoto(stat, regole);
                    if (fantaVoto != null) {
                        totale += fantaVoto;
                    }
                }
            }
        }
        return totale;
    }
}