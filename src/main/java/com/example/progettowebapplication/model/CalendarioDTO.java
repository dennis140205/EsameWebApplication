package com.example.progettowebapplication.model;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CalendarioDTO {
    private Long id;
    private Long idLega;
    private int giornata;
    // Id delle squadre che si sfidano
    private Long idSquadraCasa;
    private Long idSquadraTrasferta;
    // Risultati fantacalcistici
    private int golCasa;
    private int golTrasferta;
    private Double fantaPunteggioCasa;
    private Double fantaPunteggioTrasferta;
    private boolean giocata; // True se la partita è già stata calcolata
}