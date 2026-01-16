package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.LegaDTO;

import java.util.List;

public interface ILegaDAO {
    LegaDTO createLega(LegaDTO lega);
    LegaDTO findByCodiceInvito(String codiceInvito);
    List<LegaDTO> getLegheByUtente(Long idUtente);
    LegaDTO getLegaById(int idLega);

}
