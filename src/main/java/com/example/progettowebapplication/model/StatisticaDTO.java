package com.example.progettowebapplication.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
//Strettamente legata ai calciatori
public class StatisticaDTO {
    private Long id;
    private Long idCalciatore; // Collegamento al calciatore
    private int giornata;
    private Double voto; // Voto puro (null se s.v.)
    // Dati grezzi per il calcolo
    private int golFatti;
    private int golSubiti;
    private int rigoriParati;
    private int rigoriSbagliati;
    private int autogol;
    private int assist;
    private boolean ammonizione;
    private boolean espulsione;
}