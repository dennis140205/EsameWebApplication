package com.example.progettowebapplication.model;

import lombok.*;
import java.time.LocalDateTime;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class ScambioDTO {
    private Long id;
    // Chi propone lo scambio
    private Long idFantasquadraProponente;
    private String nomeSquadraProponente;
    private Long idCalciatoreProposto; // Il giocatore che il proponente vuole dare
    private String nomeCalciatoreProposto;
    private int creditiProponente; // Crediti che il proponente offre
    // Chi riceve la proposta
    private Long idFantasquadraRicevente;
    private String nomeSquadraRicevente;
    private Long idCalciatoreRichiesto; // Il giocatore che il proponente vuole ricevere
    private String nomeCalciatoreRichiesto;
    private int creditiRicevente; // Crediti che il proponente chiede
    private StatoScambio stato;
    private LocalDateTime dataProposta;
    private boolean vistoRicevente;
    private boolean vistoProponente;
}