package com.example.progettowebapplication.model;

public enum StatoScambio {
    IN_ATTESA,  // La proposta è stata fatta ma l'altra squadra non ha ancora risposto
    ACCETTATO,  // Scambio concluso: i giocatori si sono spostati
    RIFIUTATO   // La proposta è stata declinata
}
