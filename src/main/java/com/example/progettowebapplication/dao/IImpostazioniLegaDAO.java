package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.ImpostazioniLegaDTO;

public interface IImpostazioniLegaDAO {
    ImpostazioniLegaDTO insertImpostazioni(ImpostazioniLegaDTO impostazioni);
    ImpostazioniLegaDTO getById(Long id);
    ImpostazioniLegaDTO getByIdLega(Long idLega); // Per caricare le regole di una lega specifica
    ImpostazioniLegaDTO updateImpostazioni(ImpostazioniLegaDTO impostazioni);
    void resetToDefault(Long idLega);
    void setStatoMercato(Long idLega, boolean aperto);
    void deleteImpostazioni(Long id);
}