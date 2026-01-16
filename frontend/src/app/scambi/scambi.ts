import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ScambioService } from '../service/scambio.service';
import { FantasquadraService } from '../service/fantasquadra.service';
import { ActivatedRoute, Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { NotificaService } from '../service/notifica.service';
import {Legaservice} from '../service/lega.service';
import { ImpostazioniService } from '../service/impostazioni.service';

@Component({
  selector: 'app-scambi',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './scambi.html',
  styleUrls: ['./scambi.css']
})
export class Scambi implements OnInit {
  private notifica = inject(NotificaService);

  scambiProposti: any[] = [];
  scambiRicevuti: any[] = [];
  idLega!: number;
  idMiaSquadra!: number;
  isLoading = true;
  mercatoScambiAperto: boolean = true

  constructor(
    private scambioService: ScambioService,
    private fantasquadraService: FantasquadraService,
    private route: ActivatedRoute,
    private http: HttpClient,
    private router: Router,
    private legaService: Legaservice,
  private impostazioniService: ImpostazioniService
  ) {}

  ngOnInit(): void {
    const idParam = this.route.parent?.snapshot.paramMap.get('idLega');
    this.idLega = Number(idParam);

    if (this.idLega) {
      this.inizializzaDati();
    }
  }

  inizializzaDati() {
    this.isLoading = true;
    this.impostazioniService.getImpostazioni(this.idLega).subscribe({
      next: (settings) => {
        this.mercatoScambiAperto = settings.mercatoScambiAperto;
        this.fantasquadraService.getMiaSquadra(this.idLega).subscribe({
          next: (squadra) => {
            if (squadra && squadra.idFantasquadra) {
              this.idMiaSquadra = squadra.idFantasquadra;
              this.caricaScambi();

              this.legaService.aggiornaCreditiVisualizzati(squadra.creditiResidui);

              this.http.post(`http://localhost:8080/scambi/notifiche/reset/${this.idMiaSquadra}`, {}, { withCredentials: true })
                .subscribe({
                  error: () => {}
                });
            }
          },
          error: () => {
            this.notifica.mostra("Impossibile recuperare i dati della tua squadra", "error");
            this.isLoading = false;
          }
        });
      },
      error: () => {
        this.notifica.mostra("Errore nel caricamento impostazioni lega", "error");
        this.isLoading = false;
      }
    });
  }

  caricaScambi() {
    this.scambioService.getScambiLega(this.idLega).subscribe({
      next: (data) => {
        this.scambiRicevuti = data.filter(s => s.idFantasquadraRicevente === this.idMiaSquadra);
        this.scambiProposti = data.filter(s => s.idFantasquadraProponente === this.idMiaSquadra);
        this.isLoading = false;
      },
      error: (err) => {
        this.isLoading = false;
        if (err.status === 401) {
          this.notifica.mostra("Sessione scaduta. Effettua il login.", "error");
          this.router.navigate(['/login']);
        } else {
          this.notifica.mostra("Errore nel caricamento degli scambi", "error");
        }
      }
    });
  }

  apriNuovoScambio() {
    this.router.navigate(['/lega', this.idLega, 'proponi-scambio']);
  }

  accetta(id: number) {
    this.notifica.chiediConferma({
      titolo: "Conferma scambio",
      messaggio: "Sei sicuro di voler accettare? I giocatori verranno scambiati immediatamente nelle rispettive rose.",
      testoConfirm: "ACCETTA",
      colore: "btn-success",
      azione: () => {
        this.scambioService.accettaScambio(id).subscribe({
          next: () => {
            this.notifica.mostra("Scambio accettato! Rosa aggiornata.", "success");
            this.caricaScambi();

            this.inizializzaDati();
          },
          error: (err) => this.notifica.mostra(err.error || "Errore nell'accettazione", "error")
        });
      }
    });
  }

  rifiuta(id: number) {
    this.notifica.chiediConferma({
      titolo: "Rifiuta scambio",
      messaggio: "Vuoi davvero rifiutare questa proposta di scambio?",
      testoConfirm: "RIFIUTA",
      colore: "btn-danger",
      azione: () => {
        this.scambioService.rifiutaScambio(id).subscribe({
          next: () => {
            this.notifica.mostra("Scambio rifiutato.", "success");
            this.caricaScambi();
          },
          error: () => this.notifica.mostra("Errore nel rifiuto dello scambio", "error")
        });
      }
    });
  }

  annulla(id: number) {
    this.scambioService.annullaScambio(id).subscribe({
      next: () => {
        this.notifica.mostra("Proposta annullata.", "success");
        this.caricaScambi();
      },
      error: () => this.notifica.mostra("Errore nell'annullamento della proposta", "error")
    });
  }
}
