import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { FormazioneService } from '../service/formazione.service';
import { FantasquadraService } from '../service/fantasquadra.service';
import { CalciatoreService } from '../service/calciatore.service';
import { Legaservice } from '../service/lega.service';
import { Stats } from '../service/stats';
import {PunteggioGiornataService} from '../service/punteggio-giornata.service';

const ordineRuoli: any = { 'P': 1, 'D': 2, 'C': 3, 'A': 4 };

@Component({
  selector: 'app-risultati',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './risultati.html',
  styleUrls: ['./risultati.css']
})
export class RisultatiLega implements OnInit {
  private route = inject(ActivatedRoute);
  private http = inject(HttpClient);
  private formazioneService = inject(FormazioneService);
  private punteggioService = inject(PunteggioGiornataService);
  private fantasquadraService = inject(FantasquadraService);
  private calciatoreService = inject(CalciatoreService);
  private legaService = inject(Legaservice);
  private statsService = inject(Stats);

  idLega: number = 0;
  giornataCorrenteReale: number = 1;
  giornataInizialeLega: number = 1;
  giornataVisualizzata: number = 1;
  partite: any[] = [];
  elencoSquadre: any[] = [];
  listoneCalciatori: any[] = [];
  indexAttivo: number = 0;
  totaleCasa: number = 0;
  totaleTrasferta: number = 0;
  formazioneCasa: any = null;
  formazioneTrasferta: any = null;

  ngOnInit() {
    const idParam = this.route.parent?.snapshot.paramMap.get('idLega');
    this.idLega = idParam ? +idParam : 0;

    this.statsService.getGiornataAttuale().subscribe(gSerieA => {
      this.giornataCorrenteReale = gSerieA;

      this.legaService.getGiornataAttiva(this.idLega).subscribe(gLega => {
        this.calciatoreService.getCalciatori().subscribe(calciatori => {
          this.listoneCalciatori = calciatori;
          this.http.get<any>(`http://localhost:8080/lega/pagina-principale-info/${this.idLega}`, { withCredentials: true })
            .subscribe(data => {
              this.giornataInizialeLega = data.giornataInizialeLega || 1;

              this.giornataVisualizzata = Math.max(1, gLega - this.giornataInizialeLega + 1);

              this.caricaSquadreEPartite();
            });
        });
      });
    });
  }

  cambiaGiornata(delta: number) {
    const nuova = this.giornataVisualizzata + delta;
    if (nuova >= 1 && nuova <= this.giornateTotaliLega) {
      this.giornataVisualizzata = nuova;
      this.caricaDatiCalendario();
    }
  }

  get giornateTotaliLega(): number {
    return 38 - (this.giornataInizialeLega - 1);
  }

  caricaSquadreEPartite() {
    this.fantasquadraService.getSquadreByLega(this.idLega).subscribe(squadre => {
      this.elencoSquadre = squadre;
      this.caricaDatiCalendario();
    });
  }

  caricaDatiCalendario() {
    const giornataReale = this.giornataVisualizzata + (this.giornataInizialeLega - 1);
    this.punteggioService.getRisultatiLive(this.idLega, giornataReale).subscribe({
      next: (res) => {
        this.partite = res;
        if (this.partite && this.partite.length > 0) {
          if (this.indexAttivo >= this.partite.length) {
            this.indexAttivo = 0;
          }
          this.selezionaSfida(this.indexAttivo);
        } else {
          this.formazioneCasa = null;
          this.formazioneTrasferta = null;
          this.totaleCasa = 0;
          this.totaleTrasferta = 0;
        }
      },
      error: (err) => console.error('Errore caricamento risultati live:', err)
    });
  }

  selezionaSfida(index: number) {
    this.indexAttivo = index;
    const match = this.partite[index];
    const giornataRealeMatch = this.giornataVisualizzata + (this.giornataInizialeLega - 1);

    this.totaleCasa = match.fantaPunteggioCasa ?? 0;
    this.totaleTrasferta = match.fantaPunteggioTrasferta ?? 0;

    this.formazioneCasa = null;
    this.formazioneTrasferta = null;

    this.formazioneService.getFormazione(match.idSquadraCasa, giornataRealeMatch).subscribe({
      next: f => {
        this.formazioneCasa = f;
        this.ordinaCalciatori(this.formazioneCasa);
        if (match.giocata === true) {
          this.calcolaSostituzioniVisive(this.formazioneCasa.calciatori);
        }
      },
      error: () => { this.formazioneCasa = null; }
    });

    this.formazioneService.getFormazione(match.idSquadraTrasferta, giornataRealeMatch).subscribe({
      next: f => {
        this.formazioneTrasferta = f;
        this.ordinaCalciatori(this.formazioneTrasferta);
        if (match.giocata === true) {
          this.calcolaSostituzioniVisive(this.formazioneTrasferta.calciatori);
        }
      },
      error: () => { this.totaleTrasferta = 0; this.formazioneTrasferta = null; }
    });
  }

  private calcolaSostituzioniVisive(calciatori: any[]) {
    if (!calciatori) return;
    const titolari = calciatori.filter(g => g.stato === 'TITOLARE');
    const panchina = calciatori.filter(g => g.stato === 'PANCHINA').sort((a, b) => a.ordine - b.ordine);

    const idPanchinaUsati = new Set<number>();

    let sostituzioniEffettuate = 0;
    const maxSostituzioni = 3;

    titolari.forEach(t => {
      // Se il titolare non ha voto (e siamo in una giornata calcolata), cerca sostituto
      if (t.fantaVoto === null || t.fantaVoto === undefined) {

        if (sostituzioniEffettuate < maxSostituzioni) {
          const sub = panchina.find(p => p.ruolo === t.ruolo && p.fantaVoto !== null && !idPanchinaUsati.has(p.idCalciatore));

          if (sub) {
            idPanchinaUsati.add(sub.idCalciatore);
            sub.subentrato = true;
            sostituzioniEffettuate++;
          }
        }
      }
    });
  }

  private ordinaCalciatori(formazione: any) {
    if (formazione && formazione.calciatori) {
      formazione.calciatori.sort((a: any, b: any) => {
        if (a.stato !== b.stato) return a.stato === 'TITOLARE' ? -1 : 1;
        return ordineRuoli[a.ruolo] - ordineRuoli[b.ruolo];
      });
    }
  }

  getNomeSquadra(id: number): string {
    const s = this.elencoSquadre.find(sq => sq.idFantasquadra === id);
    return s ? s.nomeFantasquadra : 'Squadra ' + id;
  }

  // Metodo per estrarre la statistica della giornata corrente
  getStatisticheGiornata(calciatore: any): any {
    if (!calciatore || !calciatore.statistiche) return null;
    const giornataReale = this.giornataVisualizzata + (this.giornataInizialeLega - 1);
    return calciatore.statistiche.find((s: any) => s.giornata === giornataReale);
  }
}
