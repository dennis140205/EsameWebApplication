package com.example.progettowebapplication.model.request;

import com.example.progettowebapplication.model.ImpostazioniLegaDTO;
import com.example.progettowebapplication.model.LegaDTO;
import lombok.Data;

@Data
public class LegaWithImpostazioniRequest {
    private LegaDTO lega;
    private ImpostazioniLegaDTO impostazioni;
}