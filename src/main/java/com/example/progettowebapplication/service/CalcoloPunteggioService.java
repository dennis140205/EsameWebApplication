package com.example.progettowebapplication.service;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.model.CalciatoreDTO;
import com.example.progettowebapplication.model.ImpostazioniLegaDTO;
import com.example.progettowebapplication.model.Ruolo;
import com.example.progettowebapplication.model.StatisticaDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CalcoloPunteggioService {

    //Calcola il fantavoto di un singolo giocatore incrociando le sue statistiche con le impostazioni della lega
    public Double calcolaFantavoto(StatisticaDTO stat, ImpostazioniLegaDTO imp) {
        // Se il giocatore non ha preso voto (S.V.), restituisce null
        if (stat.getVoto() == null) {
            return null;
        }
        double fantavoto = stat.getVoto();
        // Aggiunge bonus
        fantavoto += (stat.getGolFatti() * imp.getBonusGol());
        fantavoto += (stat.getAssist() * imp.getBonusAssist());
        fantavoto += (stat.getRigoriParati() * imp.getBonusRigoreParato());
        // Sottrae malus
        if (stat.isAmmonizione()) {
            fantavoto += imp.getMalusAmmonizione();
        }
        if (stat.isEspulsione()) {
            fantavoto += imp.getMalusEspulsione();
        }
        fantavoto += (stat.getGolSubiti() * imp.getMalusGolSubito());
        fantavoto += (stat.getAutogol() * imp.getMalusAutogol());
        fantavoto += (stat.getRigoriSbagliati() * imp.getMalusRigoreSbagliato());

        // Porta inviolata
        // Se la lega ha attivato l'opzione del bonus porta inviolata, aggiunge un bonus
        if (imp.isPortaInviolata()){
            // Recupera il calciatore dal database usando l'id contenuto nella statistica
            CalciatoreDTO c = DbManager.getInstance().getCalciatoreDao().getCalciatoreById(stat.getIdCalciatore());
            // Controlla che il calciatore esista, che sia un portiere e che non abbia subito gol
            if (c != null && c.getRuolo() == Ruolo.P && stat.getGolSubiti() == 0) {
                fantavoto += 1.0; // Bonus standard +1 per adesso, da vedere
            }
        }
        return fantavoto;
    }

//     Calcola il punteggio del modificatore di difesa
//     Regola classica:
//     - Media voto (Portiere + 3 migliori Difensori) >= 6.0  -> +1
//     - Media voto >= 6.5  -> +3
//     - Media voto >= 7.0  -> +6
//     Richiede almeno 4 difensori a voto
    public double calcolaModificatoreDifesa(List<StatisticaDTO> votiDifensori, StatisticaDTO votoPortiere, ImpostazioniLegaDTO imp) {
        // Controlla se è attivo nella lega
        if (!imp.isModificatoreDifesa()) {
            return 0.0;
        }
        // Controlla il numero minimo difensori (servono almeno 4 difensori a voto)
        if (votiDifensori.size() < 4 || votoPortiere == null || votoPortiere.getVoto() == null) {
            return 0.0;
        }
        // Prende i 3 voti migliori dei difensori
        // Si usa il voto puro, senza bonus/malus
        List<Double> votiPuri = votiDifensori.stream()
                .map(StatisticaDTO::getVoto)
                .filter(v -> v != null) // Rimuove s.v.
                .sorted((v1, v2) -> Double.compare(v2, v1)) // Ordine decrescente
                .limit(3) // Prende i migliori 3
                .toList();

        if (votiPuri.size() < 3) return 0.0; // Sicurezza extra
        // Calcola la media (voto portiere + 3 migliori difensori) / 4
        double somma = votoPortiere.getVoto();
        for (Double v : votiPuri) {
            somma += v;
        }
        double media = somma / 4.0;
        // Assegna il bonus in base alla media
        if (media >= 7.0) return 6.0;
        if (media >= 6.5) return 3.0;
        if (media >= 6.0) return 1.0;
        return 0.0;
    }
}