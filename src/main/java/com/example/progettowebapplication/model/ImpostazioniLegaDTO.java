package com.example.progettowebapplication.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ImpostazioniLegaDTO {
    private Long id;
    private Long idLega;
    // Configurazione generale
    private int budgetIniziale=500;
    private int maxCalciatori=25;
    private boolean mercatoScambiAperto=true;
    // Regole speciali
    private boolean modificatoreDifesa=false;
    private boolean portaInviolata=false;
    private boolean mvp=false;
    private boolean golVittoria=false;
    // Bonus e malus
    private double bonusGol=3;
    private double bonusAssist=1;
    private double malusAmmonizione=-0.5;
    private double malusEspulsione=-1;
    private double malusGolSubito=-1;
    private double malusAutogol=-2;
    private double bonusRigoreParato=3;
    private double malusRigoreSbagliato=-2;
    // Fasce gol
    private int sogliaGol=66;
    private int stepFascia=6;
}