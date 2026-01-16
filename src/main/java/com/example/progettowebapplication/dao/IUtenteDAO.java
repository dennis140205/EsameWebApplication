package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.UtenteDTO;
import java.util.List;

public interface IUtenteDAO {
    // Create
    UtenteDTO insertUtente(UtenteDTO utente);
    // Read
    List<UtenteDTO> getAllUtenti();
    UtenteDTO getUtenteById(Long id);
    UtenteDTO getUtenteByEmail(String email);
    // Update
    UtenteDTO updateUtente(UtenteDTO utente);
    // Delete
    void deleteUtente(Long id);
}