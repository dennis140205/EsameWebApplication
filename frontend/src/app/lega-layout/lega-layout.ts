import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { Stats } from '../service/stats';
import { ScambioService } from '../service/scambio.service';
import { interval, Subscription } from 'rxjs';
import { NotificaService } from '../service/notifica.service';
import {Legaservice} from '../service/lega.service';

@Component({
  selector: 'app-lega-layout',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './lega-layout.html',
  styleUrls: ['./lega-layout.css']
})
export class LegaLayoutComponent implements OnInit, OnDestroy {
  private notifica = inject(NotificaService);

  idLega!: number;
  idMiaSquadra!: number;
  numNotifiche: number = 0;

  nomeLega: string = 'Caricamento...';
  username: string = '';
  nomeSquadra: string = '';
  creditiResidui: number = 0;
  isAdmin: boolean = false;
  isCalendarioGenerato: boolean = false;
  private creditiSub?: Subscription;

  deadline: Date | null = null;
  countdownStr: string = "";
  isUrgent: boolean = false;
  isLive: boolean = false;

  private timerSub?: Subscription;
  private notificheSub?: Subscription;

  constructor(
    private route: ActivatedRoute,
    private http: HttpClient,
    private statsService: Stats,
    private scambioService: ScambioService,
    private legaService: Legaservice
  ) {}

  ngOnInit() {
    this.creditiSub = this.legaService.creditiAttuali$.subscribe(nuoviCrediti => {
      this.creditiResidui = nuoviCrediti;
    });
    this.legaService.creditiAttuali$.subscribe(nuoviCrediti => {
      this.creditiResidui = nuoviCrediti;
    });
    this.route.paramMap.subscribe(params => {
      const id = params.get('idLega');
      if (id) {
        this.idLega = +id;
        this.caricaInfoLega();
        this.recuperaDeadline();
      }
    });
  }

  caricaInfoLega() {
    this.http.get<any>(`http://localhost:8080/lega/pagina-principale-info/${this.idLega}`, { withCredentials: true })
      .subscribe({
        next: (data) => {
          this.nomeLega = data.nomeLega;
          this.username = data.username;
          this.nomeSquadra = data.nomeSquadra;
          this.creditiResidui = data.creditiResidui;
          this.legaService.aggiornaCreditiVisualizzati(data.creditiResidui);
          this.isAdmin = data.isAdmin;
          this.isCalendarioGenerato = data.isCalendarioGenerato ?? false;

          if (data.idFantasquadra) {
            this.idMiaSquadra = data.idFantasquadra;
            this.avviaControlloNotifiche();
          }
        },
        error: () => {
          this.notifica.mostra("Impossibile caricare le informazioni della lega", "error");
        }
      });
  }

  recuperaDeadline() {
    this.statsService.getDeadline().subscribe({
      next: (res) => {
        if (res && res.deadline) {
          this.deadline = new Date(res.deadline);
          this.isLive = res.isLive;
          if (!this.isLive) {
            this.avviaTimer();
          } else {
            this.countdownStr = "LIVE / RISULTATI";
          }
        }
      },
      error: () => {
        this.countdownStr = "Nessun match";
        this.notifica.mostra("Errore nel recupero della scadenza giornata", "error");
      }
    });
  }

  avviaTimer() {
    this.timerSub = interval(1000).subscribe(() => {
      if (!this.deadline) return;
      const ora = new Date().getTime();
      const diff = this.deadline.getTime() - ora;

      if (diff <= 0) {
        this.isLive = true;
        this.countdownStr = "LIVE / RISULTATI";
        this.timerSub?.unsubscribe();
      } else {
        const giorni = Math.floor(diff / (1000 * 60 * 60 * 24));
        const ore = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minuti = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
        const secondi = Math.floor((diff % (1000 * 60)) / 1000);

        if (giorni > 0) {
          this.countdownStr = `${giorni}g ${ore}h ${minuti}m ${secondi}s`;
        } else {
          this.countdownStr = `${ore}h ${minuti}m ${secondi}s`;
        }

        // Urgenza se manca meno di 1 ora
        this.isUrgent = diff < 3600000;
      }
    });
  }

  avviaControlloNotifiche() {
    this.aggiornaNotifiche();
    this.notificheSub = interval(30000).subscribe(() => this.aggiornaNotifiche());
  }

  aggiornaNotifiche() {
    if (this.idMiaSquadra) {
      this.scambioService.getCountNotifiche(this.idMiaSquadra).subscribe({
        next: (count) => this.numNotifiche = count,
        error: () => {
          this.notifica.mostra("Errore nell'aggiornamento notifiche scambi", "error");
        }
      });
    }
  }

  ngOnDestroy() {
    this.timerSub?.unsubscribe();
    this.notificheSub?.unsubscribe();
    this.creditiSub?.unsubscribe();
  }
}
