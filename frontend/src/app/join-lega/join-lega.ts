import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { Legaservice } from '../service/lega.service';
import { FormsModule } from '@angular/forms';
import { NotificaService } from '../service/notifica.service';

@Component({
  selector: 'app-join-lega',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './join-lega.html',
  styleUrl: './join-lega.css'
})
export class JoinLega {
  private notifica = inject(NotificaService);

  codiceInserito: string = '';
  nomeSquadraInserito: string = '';



  constructor(private legaService: Legaservice, private router: Router) {}

  unisciti() {

    if (!this.codiceInserito || !this.nomeSquadraInserito) {
      this.notifica.mostra("Inserisci sia il codice che il nome della squadra.", 'error');
      return;
    }

    const utenteString = localStorage.getItem('utente');
    let idUtente = 0;

    if (utenteString) {
      const utenteObj = JSON.parse(utenteString);
      idUtente = utenteObj.id;
    } else {
      this.notifica.mostra("Devi essere loggato per unirti a una lega.", 'error');
      return;
    }

    this.notifica.chiediConferma({
      titolo: "Conferma Adesione",
      messaggio: `Stai per unirti alla lega con il nome squadra "${this.nomeSquadraInserito}". Vuoi procedere?`,
      testoConfirm: "ENTRA",
      colore: "btn-success",
      azione: () => {

        this.legaService.joinLega(this.codiceInserito, this.nomeSquadraInserito, idUtente)
          .subscribe({
            next: (response) => {
              this.notifica.mostra("Ti sei unito alla lega con successo! ⚽", 'success');
              this.router.navigate(['/']);
            },
            error: (error) => {
              this.notifica.mostra(error.error || "Errore durante l'adesione alla lega", 'error');
            }
          });
      }
    });
  }
}
