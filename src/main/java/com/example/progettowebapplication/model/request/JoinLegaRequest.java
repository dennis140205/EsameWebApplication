package com.example.progettowebapplication.model.request;

import lombok.Data;

@Data
public class JoinLegaRequest {
    private String codiceInvito;
    private String nomeSquadra;
    private Long idUtente;
}