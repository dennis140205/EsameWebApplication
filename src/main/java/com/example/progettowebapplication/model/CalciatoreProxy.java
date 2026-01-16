package com.example.progettowebapplication.model;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.dao.ICalciatoreDAO;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.List;

public class CalciatoreProxy extends CalciatoreDTO {

    @JsonIgnore
    private ICalciatoreDAO calciatoreDAO;

    public CalciatoreProxy() {
        super();
        this.calciatoreDAO = DbManager.getInstance().getCalciatoreDao();
    }

    @Override
    public List<StatisticaDTO> getStatistiche() {
        // Lazy loading
        if (super.getStatistiche() == null) {
            List<StatisticaDTO> stats = calciatoreDAO.getStatisticheByCalciatore(this.getId());
            super.setStatistiche(stats);
        }
        return super.getStatistiche();
    }
}