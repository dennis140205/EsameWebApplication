package com.example.progettowebapplication.model;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.dao.IFantasquadraDAO;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.List;

public class FantasquadraProxy extends FantasquadraDTO {
    // Riferimento al DAO per poter caricare i dati quando servono
    // @JsonIgnore serve per non mandare il DAO al frontend quando si converte in JSON
    @JsonIgnore
    private IFantasquadraDAO dao;

    public FantasquadraProxy() {
        this.dao = DbManager.getInstance().getFantasquadraDao();
    }

    //Lazy loading
    @Override
    public List<CalciatoreDTO> getRosa() {
        List<CalciatoreDTO> rosaAttuale = super.getRosa();
        if (rosaAttuale == null) {
            // Carica dal database usando il DAO recuperato nel costruttore
            List<CalciatoreDTO> rosaCaricata = dao.getRosaFantasquadra(this.getIdFantasquadra());
            super.setRosa(rosaCaricata);
        }
        return super.getRosa();
    }
}