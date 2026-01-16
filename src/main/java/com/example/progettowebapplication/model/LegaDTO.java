package com.example.progettowebapplication.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LegaDTO {
    private int idLega;
    private String nomeLega;
    private String codiceInvito;
    private int numeroSquadre;
    private String nomeSquadraAdmin;

    @JsonIgnore
    protected List<FantasquadraDTO> squadreIscritte=null;
}
