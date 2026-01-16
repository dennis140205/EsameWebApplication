import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { Stats } from '../service/stats';
import { LegaLayoutComponent } from '../lega-layout/lega-layout';
import { CalendarioService } from '../service/calendario.service';
import { PunteggioGiornataService } from '../service/punteggio-giornata.service';
import { NotificaService } from '../service/notifica.service';
import { Legaservice } from '../service/lega.service';

@Component({
  selector: 'app-pagina-principale',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  templateUrl: './pagina-principale.html',
  styleUrls: ['./pagina-principale.css']
})
export class PaginaPrincipale implements OnInit {
  private notifica = inject(NotificaService);
  private route = inject(ActivatedRoute);
  private http = inject(HttpClient);
  private statsService = inject(Stats);
  private calendarioService = inject(CalendarioService);
  private punteggioService = inject(PunteggioGiornataService);
  private legaService = inject(Legaservice);
  public layoutPadre = inject(LegaLayoutComponent);

  idLega!: number;
  isAdmin: boolean = false;
  isLoading: boolean = false;
  isCalendarioGenerato: boolean = false;
  classifica: any[] = [];
  prossimaGiornata: any[] = [];
  giornataCorrente: number = 1;
  giornataVisualizzata: number = 1;
  giornataInizialeLega: number = 1;
  inputGiornata: number = 1;

  ngOnInit() {
    this.route.parent?.paramMap.subscribe(params => {
      const id = params.get('idLega');
      if (id) {
        this.idLega = +id;
        this.statsService.getGiornataAttuale().subscribe({
          next: (g) => {
            this.giornataCorrente = g;
            this.caricaInfoBaseLega();
          }
        });
      }
    });
  }

  caricaInfoBaseLega() {
    this.http.get<any>(`http://localhost:8080/lega/pagina-principale-info/${this.idLega}`, { withCredentials: true })
      .subscribe({
        next: (data) => {
          this.isAdmin = data.isAdmin;
          this.giornataInizialeLega = data.giornataInizialeLega || 1;
          this.isCalendarioGenerato = data.isCalendarioGenerato;
          this.layoutPadre.isCalendarioGenerato = data.isCalendarioGenerato;

          this.caricaClassifica();

          // Imposta la giornata visualizzata iniziale basandosi sullo stato reale della lega
          this.legaService.getGiornataAttiva(this.idLega).subscribe(gAttiva => {
            const fantaG = Math.max(1, gAttiva - this.giornataInizialeLega + 1);
            this.caricaGiornata(fantaG);
          });
        }
      });
  }

  caricaClassifica() {
    this.http.get<any[]>(`http://localhost:8080/lega/${this.idLega}/classifica`, { withCredentials: true })
      .subscribe({ next: (data) => this.classifica = data });
  }

  caricaGiornata(fantaG: number) {
    const giornataReale = fantaG + (this.giornataInizialeLega - 1);
    this.calendarioService.getPartiteGiornata(this.idLega, giornataReale).subscribe({
      next: (data) => {
        this.prossimaGiornata = data;
        this.giornataVisualizzata = fantaG;
        this.inputGiornata = fantaG;
      }
    });
  }

  eseguiCalcolo() {
    this.isLoading = true;
    const giornataReale = this.giornataVisualizzata + (this.giornataInizialeLega - 1);

    this.punteggioService.calcolaGiornata(this.idLega, giornataReale).subscribe({
      next: (res) => {
        this.isLoading = false;
        this.notifica.mostra(res, 'success');
        this.caricaClassifica();
        this.caricaGiornata(this.giornataVisualizzata);

        setTimeout(() => {
          this.legaService.getGiornataAttiva(this.idLega).subscribe(gAttiva => {
            const fantaAttiva = gAttiva - this.giornataInizialeLega + 1;
            if (fantaAttiva > this.giornataVisualizzata) this.cambiaGiornata(1);
          });
        }, 1500);
      },
      error: (err) => {
        this.isLoading = false;
        this.notifica.mostra("Errore: " + err.error, 'error');
      }
    });
  }

  get testoBottoneCalcolo(): string {
    if (this.prossimaGiornata.length > 0 && this.prossimaGiornata[0].giocata) {
      return `Ricalcola giornata ${this.giornataVisualizzata}`;
    }
    return 'Calcola giornata';
  }

  get isCalcoloAbilitato(): boolean {
    const fantaCorrente = this.giornataCorrente - this.giornataInizialeLega + 1;
    return this.giornataVisualizzata < fantaCorrente;
  }

  cambiaGiornata(delta: number) {
    const nuova = this.giornataVisualizzata + delta;
    if (nuova >= 1 && nuova <= this.giornateTotaliLega) this.caricaGiornata(nuova);
  }

  vaiAGiornata() {
    if (this.inputGiornata >= 1 && this.inputGiornata <= this.giornateTotaliLega) this.caricaGiornata(this.inputGiornata);
    else this.inputGiornata = this.giornataVisualizzata;
  }

  get giornateTotaliLega(): number { return 38 - (this.giornataInizialeLega - 1); }
  getNomeSquadra(id: number): string {
    const squadra = this.classifica.find(s => s.idFantasquadra === id);
    return squadra ? squadra.nomeFantasquadra : 'Squadra ' + id;
  }

  generaCalendario() {
    this.isLoading = true;
    // Scarica tutto il calendario della Serie A
    this.statsService.getCalendarioCompleto().subscribe({
      next: (response) => {
        const tutteLePartite = response.matches || response;
        if (!tutteLePartite || tutteLePartite.length === 0) {
          this.notifica.mostra("Errore: Impossibile recuperare il calendario Serie A.", 'error');
          this.isLoading = false;
          return;
        }

        const partiteGiornata = tutteLePartite.filter((p: any) => p.matchday === this.giornataCorrente);
        if (partiteGiornata.length === 0) {
          console.warn("Nessuna partita trovata per la giornata " + this.giornataCorrente);
          this.eseguiGenerazione(this.giornataCorrente); // Fallback
          return;
        }

        // Cerca la partita con data minore
        const partiteOrdinate = partiteGiornata.sort((a: any, b: any) =>
          new Date(a.utcDate).getTime() - new Date(b.utcDate).getTime()
        );
        const dataPrimaPartita = new Date(partiteOrdinate[0].utcDate);
        const adesso = new Date();
        console.log(`ORARIO PRIMA PARTITA (G${this.giornataCorrente}): ${dataPrimaPartita.toLocaleString()}`);
        let giornataStart = this.giornataCorrente;

        if (adesso >= dataPrimaPartita) {
          giornataStart = this.giornataCorrente + 1;
          console.log("Giornata iniziata -> Start calendario: G" + giornataStart);
        } else {
          console.log("Giornata NON iniziata -> Start calendario: G" + giornataStart);
        }
        this.eseguiGenerazione(giornataStart);
      },
      error: (err) => {
        this.isLoading = false;
        this.notifica.mostra("Errore API Serie A: " + err.message, 'error');
      }
    });
  }

  private eseguiGenerazione(giornataIniziale: number) {
    this.calendarioService.generaCalendario(this.idLega, giornataIniziale).subscribe({
      next: () => {
        this.isLoading = false;
        this.notifica.mostra(`Calendario generato con successo! (Start: G${giornataIniziale})`, 'success');
        this.caricaInfoBaseLega();
      },
      error: (err) => {
        this.isLoading = false;
        this.notifica.mostra(err.error, 'error');
      }
    });
  }
}
