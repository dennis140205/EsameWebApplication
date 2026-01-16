export interface RigaClassifica {
  pos: number;
  squadra: string;
  pt: number;
  logo: string;
  pg: number; // Partite Giocate
  gf: number; // Gol Fatti
  gs: number; // Gol Subiti
  dr: number; // Differenza reti
}

export interface Marcatore {
  nome: string;
  squadra: string;
  gol: number;
  logo: string;
}
