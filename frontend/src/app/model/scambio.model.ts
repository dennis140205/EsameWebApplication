export enum StatoScambio {
  IN_ATTESA = 'IN_ATTESA',
  ACCETTATO = 'ACCETTATO',
  RIFIUTATO = 'RIFIUTATO'
}

export interface ScambioDTO {
  id: number;
  nomeSquadraProponente: string;
  nomeCalciatoreProposto: string;
  creditiProponente: number;
  nomeSquadraRicevente: string;
  nomeCalciatoreRichiesto: string;
  creditiRicevente: number;
  stato: StatoScambio;
  dataProposta: string;
  idFantasquadraProponente: number;
  idFantasquadraRicevente: number;
}
