package com.example.progettowebapplication.model;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PunteggioGiornataDTO {
    private Long id;
    private Long idFantasquadra;
    private int giornata;
    private Double punteggioTotale;
    private int golFatti;
    private int golSubiti;
    private int puntiClassifica;
}