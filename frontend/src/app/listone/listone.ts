import { Component, OnInit, inject } from '@angular/core';
import { CalciatoreService, Statistica } from '../service/calciatore.service';
import { Calciatore } from '../model/calciatore.model';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-listone',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './listone.html',
  styleUrl: './listone.css'
})
export class Listone implements OnInit {
  private calciatoreService = inject(CalciatoreService);

  allCalciatori: Calciatore[] = [];
  calciatoriFiltrati: Calciatore[] = [];

  pagedCalciatori: Calciatore[] = [];


  currentPage = 1;
  pageSize = 20;
  totalPages = 0;

  calciatoreSelezionato: Calciatore | null = null;
  statisticheSelezionate: Statistica[] = [];
  isLoadingStats: boolean = false;

  riepilogo = {
    mediaVoto: 0,
    presenze: 0,
    golFatti: 0,
    golSubiti: 0,
    assist: 0,
    rigoriParati: 0,
    rigoriSbagliati: 0,
    ammonizioni: 0,
    espulsioni: 0,
    autogol: 0
  };

  ngOnInit() {
    this.calciatoreService.getCalciatori().subscribe({
      next: (data) => {
        this.allCalciatori = data;
        this.calciatoriFiltrati = data;
        this.calcolaPaginazione();
      },
      error: (err) => console.error("Errore recupero listone", err)
    });
  }

  calcolaPaginazione() {
    this.totalPages = Math.ceil(this.calciatoriFiltrati.length / this.pageSize);
    const indiceInizio = (this.currentPage - 1) * this.pageSize;
    const indiceFine = indiceInizio + this.pageSize;
    this.pagedCalciatori = this.calciatoriFiltrati.slice(indiceInizio, indiceFine);
    window.scrollTo(0, 0);
  }

  cambiaPagina(nuovaPagina: number) {
    if (nuovaPagina >= 1 && nuovaPagina <= this.totalPages) {
      this.currentPage = nuovaPagina;
      this.calcolaPaginazione();
    }
  }

  onSearch(event: any) {
    const query = event.target.value.toLowerCase();
    this.calciatoriFiltrati = this.allCalciatori.filter(c =>
      c.nome.toLowerCase().includes(query)
    );
    this.currentPage = 1;
    this.calcolaPaginazione();
  }

  filtraRuolo(ruolo: string) {
    this.calciatoriFiltrati = ruolo === ''
      ? this.allCalciatori
      : this.allCalciatori.filter(c => c.ruolo === ruolo);
    this.currentPage = 1;
    this.calcolaPaginazione();
  }


  getListaPagine(): (number | string)[] {
    const pagine: (number | string)[] = [];
    const raggio = 2; // Numero di pagine da mostrare prima e dopo la corrente

    pagine.push(1);
    if (this.totalPages > 1) {
      pagine.push(2);
    }
    if (this.currentPage > raggio + 3) {
      pagine.push('...');
    }


    const inizio = Math.max(3, this.currentPage - raggio);
    const fine = Math.min(this.totalPages, this.currentPage + raggio);

    for (let i = inizio; i <= fine; i++) {
      if (!pagine.includes(i)) {
        pagine.push(i);
      }
    }


    if (this.currentPage < this.totalPages - raggio - 1) {
      if (!pagine.includes('...')) {
        pagine.push('...');
      }
      if (!pagine.includes(this.totalPages)) {
        pagine.push(this.totalPages);
      }
    }

    return pagine;
  }

  vaiAPagina(p: number | string) {
    if (typeof p === 'number') {
      this.cambiaPagina(p);
    }
  }

  // Apre la modale del calciatore selezionato
  apriDettagli(calciatore: Calciatore) {
    this.calciatoreSelezionato = calciatore;
    this.isLoadingStats = true;
    this.statisticheSelezionate = []; // Resetta i dati vecchi
    this.resetRiepilogo();
    this.calciatoreService.getStatisticheCalciatore(calciatore.id).subscribe({
      next: (stats) => {
        this.statisticheSelezionate = stats;
        this.calcolaRiepilogo(stats);
        this.isLoadingStats = false;
      },
      error: (err) => {
        console.error("Errore stats", err);
        this.isLoadingStats = false;
      }
    });
  }

  resetRiepilogo() {
    this.riepilogo = {
      mediaVoto: 0,
      presenze: 0,
      golFatti: 0,
      golSubiti: 0,
      assist: 0,
      rigoriParati: 0,
      rigoriSbagliati: 0,
      ammonizioni: 0,
      espulsioni: 0,
      autogol: 0
    };
  }

  calcolaRiepilogo(stats: Statistica[]) {
    if (!stats || stats.length === 0) return;
    let sommaVoti = 0;
    let contaVoti = 0;
    stats.forEach(s => {
      // Calcolo media voto (solo se ha preso voto)
      if (s.voto !== null) {
        sommaVoti += s.voto;
        contaVoti++;
      }
      // Somme totali
      this.riepilogo.golFatti += s.golFatti;
      this.riepilogo.golSubiti += s.golSubiti;
      this.riepilogo.assist += s.assist;
      this.riepilogo.rigoriParati += s.rigoriParati;
      this.riepilogo.rigoriSbagliati += s.rigoriSbagliati;
      this.riepilogo.autogol += s.autogol;
      if (s.ammonizione) this.riepilogo.ammonizioni++;
      if (s.espulsione) this.riepilogo.espulsioni++;
    });
    this.riepilogo.presenze = contaVoti;
    this.riepilogo.mediaVoto = contaVoti > 0 ? Math.round((sommaVoti / contaVoti) * 100) / 100 : 0;
  }

  // Chiude la modale del calciatore selezionato
  chiudiDettagli() {
    this.calciatoreSelezionato = null;
    this.statisticheSelezionate = [];
  }
}
