package com.example.progettowebapplication.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FantasquadraDTO {
    private Long idFantasquadra;
    private Long idUtente;
    private Long idLega;
    private boolean isAdmin;
    private int creditiResidui;
    private String nomeFantasquadra;
    private int punteggioClassificaFantasquadra;
    private int golFattiTotali;
    private int golSubitiTotali;
    private Double sommaPunteggi;
    private int giornateGiocate;
    private double fantamedia;
    // Non inizializzata subito, ci penserà il proxy o il setter
    @JsonIgnore
    protected List<CalciatoreDTO> rosa = null;
    // Campo calcolato virtuale, non esiste nel database
    public Double getFantamedia() {
        if (giornateGiocate == 0 || sommaPunteggi == null) return 0.0;
        // Arrotonda a 2 decimali
        double media = sommaPunteggi / giornateGiocate;
        return Math.round(media * 100.0) / 100.0;
    }
}
