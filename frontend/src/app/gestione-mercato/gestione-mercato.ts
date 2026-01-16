import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { Legaservice } from '../service/lega.service';
import { NotificaService } from '../service/notifica.service';

@Component({
  selector: 'app-gestione-mercato',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './gestione-mercato.html',
  styleUrls: ['./gestione-mercato.css']
})
export class GestioneMercato implements OnInit {

  private legaService = inject(Legaservice);
  private route = inject(ActivatedRoute);
  private notifica = inject(NotificaService);

  // Mappa per ordinare i ruoli (P -> D -> C -> A)
  private pesoRuoli: any = { 'P': 1, 'Por': 1, 'D': 2, 'Dif': 2, 'C': 3, 'Cen': 3, 'A': 4, 'Att': 4 };


  listaCalciatoriDisponibili: any[] = [];
  listaFantasquadre: any[] = [];
  searchText: string = '';
  idLega!: number;

  idCalciatoreScelto: number | null = null;
  idSquadraDestinataria: number | null = null;
  costoAcquisto: number = 1;

  rose: { [key: number]: any[] } = {};

  ngOnInit(): void {
    const idParam = this.route.snapshot.paramMap.get('idLega') || this.route.parent?.snapshot.paramMap.get('idLega');

    if (idParam) {
      this.idLega = +idParam;
      this.caricaDati(this.idLega);
    } else {
      this.notifica.mostra("Errore: ID Lega non trovato.", "error");
    }
  }

  caricaDati(id: number) {
    // Carica gli svincolati e li ordina
    this.legaService.getSvincolati(id).subscribe({
      next: (data) => {
        this.listaCalciatoriDisponibili = this.ordinaLista(data);
      },
      error: (e) => console.error("Errore svincolati:", e)
    });

    this.legaService.getSquadreByLega(id).subscribe({
      next: (data) => {
        this.listaFantasquadre = data;

        this.listaFantasquadre.forEach(squadra => {
          this.aggiornaRosa(squadra.idFantasquadra);
        });
      },
      error: (e) => console.error("Errore squadre:", e)
    });
  }

  aggiornaRosa(idSquadra: number) {
    this.legaService.getGiocatoriSquadra(idSquadra).subscribe({
      next: (giocatori) => {
        // Salvo i giocatori nella mappa usando l'ID della squadra come chiave
        this.rose[idSquadra] = this.ordinaLista(giocatori);
      },
      error: (e) => console.error(`Errore caricamento rosa ${idSquadra}`, e)
    });
  }


  ordinaLista(lista: any[]): any[] {
    return lista.sort((a, b) => {
      const pesoA = this.pesoRuoli[a.ruolo] || 99;
      const pesoB = this.pesoRuoli[b.ruolo] || 99;

      if (pesoA !== pesoB) return pesoA - pesoB;

      return a.nome.localeCompare(b.nome);
    });
  }

  // LOGICA ACQUISTO

  get calciatoriFiltrati() {
    if (!this.searchText) return this.listaCalciatoriDisponibili;
    return this.listaCalciatoriDisponibili.filter(c =>
      c.nome.toLowerCase().includes(this.searchText.toLowerCase())
    );
  }

  get maxCreditiSquadra(): number {
    if (!this.idSquadraDestinataria) return 0;
    const squadra = this.listaFantasquadre.find(s => s.idFantasquadra === this.idSquadraDestinataria);
    return squadra ? squadra.creditiResidui : 0;
  }
  eseguiAssegnazione() {
    if (!this.idCalciatoreScelto || !this.idSquadraDestinataria || this.costoAcquisto <= 0) {
      this.notifica.mostra("Dati incompleti: controlla tutti i campi.", "error");
      return;
    }

    if (this.costoAcquisto > this.maxCreditiSquadra) {
      this.notifica.mostra(`Crediti insufficienti! La squadra ha solo ${this.maxCreditiSquadra} cr.`, "error");
      return;
    }


    const playerToBuy = this.listaCalciatoriDisponibili.find(c => c.id == this.idCalciatoreScelto);

    if (!playerToBuy) {
      this.notifica.mostra("Errore: Impossibile recuperare i dati del calciatore.", "error");
      return;
    }

    const rosaAttuale = this.rose[this.idSquadraDestinataria] || [];

    const ruolo = playerToBuy.ruolo ? playerToBuy.ruolo.toString().toUpperCase() : '';
    const inizialeRuolo = ruolo.charAt(0); // P, D, C, A

    const countRuolo = rosaAttuale.filter(g => g.ruolo && g.ruolo.toString().toUpperCase().startsWith(inizialeRuolo)).length;

    let limite = 0;
    let nomeRuolo = "";

    if (inizialeRuolo === 'P') { limite = 3; nomeRuolo = "portieri"; }
    else if (inizialeRuolo === 'D') { limite = 8; nomeRuolo = "difensori"; }
    else if (inizialeRuolo === 'C') { limite = 8; nomeRuolo = "centrocampisti"; }
    else if (inizialeRuolo === 'A') { limite = 6; nomeRuolo = "attaccanti"; }

    if (limite > 0 && countRuolo >= limite) {
      this.notifica.mostra(`Reparto completo! Hai già ${countRuolo}/${limite} ${nomeRuolo}.`, "error");
      return;
    }



    const acquistoDTO = {
      idLega: this.idLega,
      idFantasquadra: this.idSquadraDestinataria,
      idCalciatore: this.idCalciatoreScelto,
      prezzoAcquisto: this.costoAcquisto
    };

    this.legaService.acquistaGiocatore(acquistoDTO).subscribe({
      next: () => {
        this.notifica.mostra('Acquisto registrato con successo! 🤝', 'success');

        // Aggiorna i crediti visivi subito
        const sq = this.listaFantasquadre.find(s => s.idFantasquadra === this.idSquadraDestinataria);
        if (sq) sq.creditiResidui -= this.costoAcquisto;

        this.caricaDati(this.idLega);

        this.idCalciatoreScelto = null;
        this.searchText = '';
        this.costoAcquisto = 1;
      },
      error: (err) => this.notifica.mostra(err.error || "Errore durante l'acquisto", 'error')
    });
  }

  annullaOperazione(idAcquisto: number, idSquadra: number, prezzo: number, isSvincolo: boolean) {

    const rimborsoPrevisto = isSvincolo ? Math.floor(prezzo / 2) : prezzo;

    let titoloModale = "";
    let corpoMessaggio = "";

    if (isSvincolo) {
      titoloModale = "Conferma Svincolo";
      corpoMessaggio = `Sei sicuro di voler svincolare questo giocatore?\n\n` +
        `La squadra recupererà il 50% della spesa (${rimborsoPrevisto} crediti).`;
    } else {
      titoloModale = "Annulla Acquisto ";
      corpoMessaggio = `Attenzione: stai per annullare un acquisto fatto per errore.\n\n` +
        `La squadra recupererà l'intera somma (${rimborsoPrevisto} crediti).`;
    }

    this.notifica.chiediConferma({
      titolo: titoloModale,
      messaggio: corpoMessaggio,
      testoConfirm: isSvincolo ? "Sì, Svincola" : "Sì",
      colore: "btn-success",
      azione: () => {
        this.legaService.annullaAcquistoAdmin(idAcquisto, isSvincolo).subscribe({
          next: (res) => {
            this.notifica.mostra(isSvincolo ? "Giocatore svincolato con successo." : "Acquisto annullato.", "success");
            const sq = this.listaFantasquadre.find(s => s.idFantasquadra === idSquadra);
            if (sq) {
              sq.creditiResidui += rimborsoPrevisto;
            }
            this.caricaDati(this.idLega);
          },
          error: (err) => this.notifica.mostra("Errore durante l'operazione", "error")
        });
      }
    });
  }

  getClassRuolo(ruolo: string): string {
    const r = ruolo ? ruolo.toUpperCase() : '';
    if (r === 'P' || r === 'POR') return 'ruolo-portiere';
    if (r === 'D' || r === 'DIF') return 'ruolo-difensore';
    if (r === 'C' || r === 'CEN') return 'ruolo-centrocampista';
    if (r === 'A' || r === 'ATT') return 'ruolo-attaccante';
    return '';
  }
}
