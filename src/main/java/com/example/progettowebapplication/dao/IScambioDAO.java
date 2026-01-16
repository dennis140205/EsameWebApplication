package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.ScambioDTO;
import com.example.progettowebapplication.model.StatoScambio;
import java.util.List;

public interface IScambioDAO {
    // Crea una nuova proposta di scambio
    void proponiScambio(ScambioDTO scambio);
    // Recupera tutti gli scambi di una lega
    List<ScambioDTO> getScambiByLega(Long idLega);
    // Recupera tutti gli scambi (proposti o ricevuti) di una squadra
    List<ScambioDTO> getScambiBySquadra(Long idFantasquadra);
    // Gestisce la risposta: accetta (con transazione) o rifiuta (solo update stato)
    void gestisciScambio(Long idScambio, StatoScambio nuovoStato);
    // Annulla un scambio (solo update stato)
    void annullaScambio(Long idScambio);
    ScambioDTO getScambioById(Long id);
    int countNotifichePerSquadra(Long idFantasquadra);
    void resetNotifiche(Long idFantasquadra);
}