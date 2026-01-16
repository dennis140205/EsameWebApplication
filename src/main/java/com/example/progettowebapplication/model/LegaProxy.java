package com.example.progettowebapplication.model;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.dao.IFantasquadraDAO;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.List;

public class LegaProxy extends LegaDTO {

    @JsonIgnore
    private IFantasquadraDAO fantasquadraDAO;

    public LegaProxy() {
        super();
        this.fantasquadraDAO = DbManager.getInstance().getFantasquadraDao();
    }

    @Override
    public List<FantasquadraDTO> getSquadreIscritte() {
        // Lazy loading
        if (super.getSquadreIscritte() == null) {
            List<FantasquadraDTO> squadre = fantasquadraDAO.getByLega((long) this.getIdLega());
            super.setSquadreIscritte(squadre);
        }
        return super.getSquadreIscritte();
    }
}