import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { Legaservice, LegaRiepilogo } from '../service/lega.service';
import { NotificaService } from '../service/notifica.service';

@Component({
  selector: 'app-le-mie-leghe',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './le-mie-leghe.html',
  styleUrls: ['./le-mie-leghe.css']
})
export class LeMieLeghe implements OnInit {
  private notifica = inject(NotificaService);

  elencoLeghe: LegaRiepilogo[] = [];

  constructor(
    private router: Router,
    private legaService: Legaservice
  ) {}

  ngOnInit() {
    const datiUtenteSalvato = localStorage.getItem('utente');

    if (datiUtenteSalvato) {
      const utenteCorrente = JSON.parse(datiUtenteSalvato);
      const idReale = utenteCorrente.id;

      this.legaService.getLegheUtente(idReale).subscribe({
        next: (datiRicevuti) => {
          this.elencoLeghe = datiRicevuti;
        },
        error: (errore) => {
          this.notifica.mostra("Errore nel recupero delle tue leghe. Riprova più tardi.", "error");
        }
      });

    } else {
      this.notifica.mostra("Sessione scaduta o utente non trovato. Effettua il login.", "error");
      this.router.navigate(['/login']);
    }
  }

  apriLega(id: number) {
    this.router.navigate(['/lega', id]);
  }
}
