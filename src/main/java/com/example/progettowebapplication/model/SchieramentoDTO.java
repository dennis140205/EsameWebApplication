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
public class SchieramentoDTO {
    private Long id;
    private Long idFormazione;    // Id della formazione padre
    private Long idCalciatore;    // Id del giocatore
    private String nomeCalciatore;// Nome per visualizzazione frontend
    private Ruolo ruolo;          // Ruolo (P, D, C, A)
    private StatoSchieramento stato; // Enum: TITOLARE o PANCHINA
    private int ordine;           // Ordine di ingresso
    private Double fantaVoto; // Voto del giocatore nella fantasquadra
    private List<StatisticaDTO> statistiche;
}