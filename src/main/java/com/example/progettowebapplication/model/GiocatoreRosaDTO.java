package com.example.progettowebapplication.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GiocatoreRosaDTO {
    private Long idCalciatore; // Id del calciatore
    private Long idAcquisto;   // Id della transazione
    private String nome;
    private String ruolo;      // P, D, C, A
    private String squadraReale;
    private int quotazione;    // Valore attuale
    private int prezzoAcquisto; // Quanto è stato pagato nella lega
}