package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.CalendarioDTO;
import java.util.List;

public interface ICalendarioDAO {
    // Recupera tutte le partite di una specifica giornata in una lega
    List<CalendarioDTO> getPartiteByLegaAndGiornata(Long idLega, int giornata);
    //Recupera tutte le partite della lega
    List<CalendarioDTO> getCalendarioCompleto(Long idLega);
    // Aggiorna il risultato di una partita dopo il calcolo
    void updateRisultatoPartita(CalendarioDTO partita);
    // Inserisce una nuova partita
    void insertPartita(CalendarioDTO partita);
    // Elimina il calendario di una lega
    void deleteCalendario(Long idLega);
    // Resetta tutte le partite di una giornata
    void resetPartiteGiornata(Long idLega, int giornata);
}