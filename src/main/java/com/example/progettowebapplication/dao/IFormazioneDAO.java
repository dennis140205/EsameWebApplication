package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.FormazioneDTO;

public interface IFormazioneDAO {
    // Salva o sovrascrive la formazione
    void salvaFormazione(FormazioneDTO formazione);
    // Legge la formazione di una squadra per una certa giornata
    FormazioneDTO getFormazione(Long idFantasquadra, int giornata);
    // Aggiorna il voto di un schieramento
    void aggiornaVotoSchieramento(Long idSchieramento, Double fantaVoto);
}