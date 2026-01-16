export interface Lega {
  idLega?: number;
  nomeLega: string;
  codiceInvito?: string;
  numeroSquadre: number;
}

export interface ImpostazioniLega {
  id?: number;
  idLega?: number;

  budgetIniziale: number;
  maxCalciatori: number;
  mercatoScambiAperto: boolean;

  modificatoreDifesa: boolean;
  portaInviolata: boolean;
  mvp: boolean;
  golVittoria: boolean;

  bonusGol: number;
  bonusAssist: number;
  malusAmmonizione: number;
  malusEspulsione: number;
  malusGolSubito: number;
  malusAutogol: number;
  bonusRigoreParato: number;
  malusRigoreSbagliato: number;

  sogliaGol: number;
  stepFascia: number;
}


export interface LegaWithImpostazioniPayload {
  lega: Lega;
  impostazioni: ImpostazioniLega;
}
