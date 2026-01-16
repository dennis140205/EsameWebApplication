export interface CalciatoreDTO {
  id: number;
  nome: string;
  ruolo: 'P' | 'D' | 'C' | 'A';
  squadra: string;
  quotazione: number;
  codiceApi?: number;
  stato: string; // DISPONIBILE, INFORTUNATO, SQUALIFICATO
  urlImmagine?: string;
}

export interface SchieramentoDTO {
  id?: number;
  idFormazione?: number;
  idCalciatore: number;
  nomeCalciatore: string;
  ruolo: 'P' | 'D' | 'C' | 'A';
  stato: 'TITOLARE' | 'PANCHINA';
  ordine: number;
  fantaVoto?: number;
}

export interface FormazioneDTO {
  id?: number;
  idFantasquadra: number;
  giornata: number;
  modulo: string;
  dataInserimento?: string;
  calciatori: SchieramentoDTO[];
}
