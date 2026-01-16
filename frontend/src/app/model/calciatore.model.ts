export enum Ruolo {
  P = 'P',
  D = 'D',
  C = 'C',
  A = 'A'
}


export enum StatoCalciatore {
  DISPONIBILE = 'DISPONIBILE',
  INFORTUNATO = 'INFORTUNATO',
  SQUALIFICATO = 'SQUALIFICATO'
}

export interface Calciatore {
  id: number;
  nome: string;
  ruolo: Ruolo;
  squadra: string;
  quotazione: number;
  codiceApi?: number;
  stato: StatoCalciatore;
  urlImmagine?: string;
  ultimoFantaVoto?: number;
}
