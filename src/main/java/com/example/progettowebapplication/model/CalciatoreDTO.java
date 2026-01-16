package com.example.progettowebapplication.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CalciatoreDTO {
    private Long id;
    private String nome;
    private Ruolo ruolo;  // Enum: P, D, C, A
    private String squadra;
    private int quotazione;
    private Integer codiceApi;  // Id per collegare i voti
    private StatoCalciatore stato;  // Enum: DISPONIBILE, INFORTUNATO, SQUALIFICATO
    private String urlImmagine;  // Link immagine calciatore

    protected List<StatisticaDTO> statistiche=null;
}