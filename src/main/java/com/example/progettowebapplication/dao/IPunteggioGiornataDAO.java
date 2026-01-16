package com.example.progettowebapplication.dao;
import com.example.progettowebapplication.model.PunteggioGiornataDTO;

public interface IPunteggioGiornataDAO {
    void salvaPunteggio(PunteggioGiornataDTO storico);
    PunteggioGiornataDTO getPunteggioBySquadraAndGiornata(Long idFantasquadra, int giornata);
    void deletePunteggio(Long idFantasquadra, int giornata);
}