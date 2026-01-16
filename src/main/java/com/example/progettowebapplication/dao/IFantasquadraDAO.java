package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.CalciatoreDTO;
import com.example.progettowebapplication.model.FantasquadraDTO;

import java.util.List;

public interface IFantasquadraDAO {
    void insertFantasquadrainDB(FantasquadraDTO fantasquadra);
    List<CalciatoreDTO> getRosaFantasquadra(Long id_fantasquadra);
    void updateCrediti(Long id_fantasquadra,int crediti);
    int RosaAlCompleto(Long id_fantasquadra);
    void deleteFantasquadra(Long id_fantasquadra);
    List<FantasquadraDTO> getByLega(Long id_lega);
    FantasquadraDTO getFantasquadraById(Long id);
    // Cerca la squadra di un utente specifico in una lega specifica
    FantasquadraDTO getByUtenteAndLega(Long idUtente, Long idLega);
    void aggiornaClassifica(Long idFantasquadra, int puntiFatti, int golFatti, int golSubiti, double fantaPuntiGiornata, int incrementoGiornata);
    List<FantasquadraDTO> getClassifica(Long idLega);
    List<FantasquadraDTO> getAllFantasquadre();
}
