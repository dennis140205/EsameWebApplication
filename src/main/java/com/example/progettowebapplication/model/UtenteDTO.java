package com.example.progettowebapplication.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UtenteDTO {

    private Long id;
    private String nome;
    private String cognome;
    private String email;
    private String squadraPreferita;

    // WRITE_ONLY: il server legge la password quando arriva dal frontend (es. registrazione) ma non la scrive mai quando invia i dati indietro.
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;
    private String ruolo; //USER o ADMIN

}