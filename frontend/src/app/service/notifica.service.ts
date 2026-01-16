import { Injectable, signal } from '@angular/core';

export interface Notifica {
  testo: string;
  tipo: 'success' | 'error';
}

@Injectable({ providedIn: 'root' })
export class NotificaService {
  msg = signal<Notifica | null>(null);

  // --- STATO MODALE GLOBALE ---
  mostraModale = signal<boolean>(false);
  titoloModale = signal<string>('');
  messaggioModale = signal<string>('');
  testoBottoneConferma = signal<string>('Conferma');
  coloreBottone = signal<'btn-danger' | 'btn-success' | 'btn-primary'>('btn-primary');
  callbackConferma: () => void = () => {};
  coloreBottoneAnnulla = signal<string>('btn-light');
  mostra(testo: string, tipo: 'success' | 'error') {
    this.msg.set({ testo, tipo });
    setTimeout(() => this.msg.set(null), 6000);
  }

  // FUNZIONE UNIVERSALE PER OGNI SITUAZIONE
  chiediConferma(opts: {
    titolo: string,
    messaggio: string,
    testoConfirm?: string,
    colore?: 'btn-danger' | 'btn-success' | 'btn-primary',
    coloreAnnulla?: string,
    azione: () => void
  }) {
    this.titoloModale.set(opts.titolo);
    this.messaggioModale.set(opts.messaggio);
    this.testoBottoneConferma.set(opts.testoConfirm || 'Sì, procedi');
    this.coloreBottone.set(opts.colore || 'btn-primary');
    // 🟢 Se passi un colore lo imposta, altrimenti usa btn-light (il tuo rosso di base)
    this.coloreBottoneAnnulla.set(opts.coloreAnnulla || 'btn-light');
    this.callbackConferma = opts.azione;
    this.mostraModale.set(true);
  }

  conferma() {
    this.callbackConferma();
    this.mostraModale.set(false);
  }

  annulla() {
    this.mostraModale.set(false);
  }
}
