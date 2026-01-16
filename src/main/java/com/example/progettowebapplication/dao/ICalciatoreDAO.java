package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.CalciatoreDTO;
import com.example.progettowebapplication.model.StatisticaDTO;

import java.util.List;

public interface ICalciatoreDAO {
    // Restituisce l'elenco completo di tutti i calciatori nel DB
    List<CalciatoreDTO> getAllCalciatori();
    // Cerca per ID interno del database (generato automaticamente)
    CalciatoreDTO getCalciatoreById(Long id);
    // Filtra i giocatori in base al ruolo (P, D, C, A)
    List<CalciatoreDTO> getCalciatoriByRuolo(String ruolo);
    // Cerca per ID ufficiale di Fantacalcio (quello del file CSV).
    CalciatoreDTO getCalciatoreByCodiceApi(Integer codiceApi);
    // Cerca un giocatore per nome
    CalciatoreDTO getCalciatoreByNome(String nome);
    // Inserisce un nuovo calciatore (usato all'avvio per caricare il listone).
    void insertCalciatore(CalciatoreDTO calciatore);
    // Aggiorna le info di un giocatore esistente (squadra, foto, stato, ecc.)
    void updateCalciatore(CalciatoreDTO calciatore);
    // Inserisce il voto e i bonus della giornata nella tabella statistiche
    void inserisciStatistica(StatisticaDTO statistica);
    // Imposta tutti a DISPONIBILE, da fare prima di caricare la lista degli indisponibili
    void resetTuttiDisponibili();
    // Elimina un calciatore dal database (per ora non usato)
    void deleteCalciatore(Long id);
    // Cancella le statistiche della giornata indicata
    void deleteStatisticheByGiornata(int giornata);
    // Vedere l'andamento di un singolo giocatore (es. utile per grafico voti)
    List<StatisticaDTO> getStatisticheByCalciatore(Long idCalciatore);
    // Calcolare i punteggi di una giornata specifica (es. Giornata 3)
    List<StatisticaDTO> getStatisticheByGiornata(int giornata);
}