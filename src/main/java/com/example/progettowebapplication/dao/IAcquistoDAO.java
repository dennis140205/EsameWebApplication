package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.AcquistoDTO;
import com.example.progettowebapplication.model.CalciatoreDTO;
import com.example.progettowebapplication.model.GiocatoreRosaDTO;

import java.util.List;

public interface IAcquistoDAO {
    // Inserisce l'acquisto
    AcquistoDTO insertAcquisto(AcquistoDTO acquisto);
    // Restituisce la rosa di una squadra
    List<GiocatoreRosaDTO> getRosaByFantaSquadra(Long idFantaSquadra);
    // Controlla se un calciatore è già di qualcuno in quella lega
    boolean isCalciatoreGiaAcquistatoInLega(Long idCalciatore, Long idLega);
    // Svincolo
    void deleteAcquisto(Long id);
    AcquistoDTO getAcquistoById(Long id);
    // Restituisce tutti i calciatori svincolati in una lega
    List<CalciatoreDTO> getCalciatoriSvincolati(Long idLega);
    // Restituisce l'acquisto di un determinato calciatore in una determinata lega
    AcquistoDTO getAcquistoByCalciatore(Long idCalciatore, Long idLega);
}
