import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { Legaservice } from '../service/lega.service';
import { Lega, ImpostazioniLega, LegaWithImpostazioniPayload } from '../model/lega.model';
import { NotificaService } from '../service/notifica.service';

@Component({
  selector: 'app-crea-lega',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './crea-lega.html',
  styleUrl: './crea-lega.css'
})
export class CreaLega {
  private notifica = inject(NotificaService);

  stepCorrente: number = 1;
  tabRegole: string = 'bonus';

  codiceInvitoGenerato: string | undefined = '';
  codiceCopiato: boolean = false;

  datiLega = {
    nome: '',
    squadraAdmin: '',
    numeroSquadre: 10,
    regole: {
      budgetIniziale: 500,
      maxCalciatori: 25,
      sogliaGol: 66,
      stepFascia: 6,
      mercatoScambiAperto: true,
      modificatoreDifesa: true,
      portaInviolata: false,
      mvp: false,
      golVittoria: false,
      bonusGol: 3.0,
      bonusAssist: 1.0,
      malusAmmonizione: -0.5,
      malusEspulsione: -1.0,
      malusGolSubito: -1.0,
      malusAutogol: -2.0,
      bonusRigoreParato: 3.0,
      malusRigoreSbagliato: -3.0
    }
  };

  constructor(private router: Router, private legaService: Legaservice) {}

  vaiAlleRegole() {
    if (!this.datiLega.nome || this.datiLega.nome.trim() === '') {
      this.notifica.mostra("Ehi Presidente, manca il nome della Lega!", 'error');
      return;
    }
    if (!this.datiLega.squadraAdmin || this.datiLega.squadraAdmin.trim() === '') {
      this.notifica.mostra("Ehi Presidente, manca il nome della tua Squadra!", 'error');
      return;
    }
    this.stepCorrente = 2;
  }

  tornaIndietro() {
    this.stepCorrente = 1;
  }

  cambiaTabRegole(tab: string) {
    this.tabRegole = tab;
  }

  aggiornaBonus(chiave: string, valore: number) {
    const key = chiave as keyof typeof this.datiLega.regole;
    const valoreAttuale = this.datiLega.regole[key];
    // Controlla che sia effettivamente un numero
    if (typeof valoreAttuale === 'number') {
      let nuovoValore = valoreAttuale + valore;
      nuovoValore = Math.round(nuovoValore * 10) / 10;
      // Controlli logici
      if (key.includes('bonus') && nuovoValore <= 0) return;
      if (key.includes('malus') && nuovoValore >= 0) return;
      (this.datiLega.regole[key] as number) = nuovoValore;
    }
  }


  aggiornaIntero(chiave: string, valore: number) {
    const key = chiave as keyof typeof this.datiLega.regole;
    const valoreAttuale = this.datiLega.regole[key];
    if (typeof valoreAttuale === 'number') {
      let nuovoValore = valoreAttuale + valore;
      if (nuovoValore < 0) return;
      (this.datiLega.regole[key] as number) = Math.floor(nuovoValore);
    }
  }

  creaLegaFinale() {
    const utenteString = localStorage.getItem('utente');
    if (!utenteString) {
      this.notifica.mostra("Sessione scaduta. Effettua nuovamente il login.", 'error');
      setTimeout(() => this.router.navigate(['/login']), 2000);
      return;
    }

    this.notifica.chiediConferma({
      titolo: "Conferma Creazione Lega",
      messaggio: `Presidente, sei sicuro di voler creare la lega "${this.datiLega.nome}"? Una volta creata potrai invitare i tuoi amici con il codice dedicato.`,
      testoConfirm: "CREA ORA",
      colore: "btn-success",
      azione: () => {


        const oggettoLega: any = {
          nomeLega: this.datiLega.nome,
          numeroSquadre: this.datiLega.numeroSquadre,
          nomeSquadraAdmin: this.datiLega.squadraAdmin
        };

        const oggettoImpostazioni: ImpostazioniLega = { ...this.datiLega.regole };

        const payloadWrapper: LegaWithImpostazioniPayload = {
          lega: oggettoLega,
          impostazioni: oggettoImpostazioni
        };

        this.legaService.creaLega(payloadWrapper).subscribe({
          next: (legaCreata: Lega) => {
            this.codiceInvitoGenerato = legaCreata.codiceInvito || '';
            // Notifica successo
            this.notifica.mostra("Lega creata con successo! 🏆", 'success');
            this.stepCorrente = 3;
          },
          error: (err) => {
            this.notifica.mostra("Errore: " + (err.error || "Impossibile creare la lega"), 'error');
          }
        });
      }
    });
  }

  copiaCodice() {
    if (this.codiceInvitoGenerato) {
      navigator.clipboard.writeText(this.codiceInvitoGenerato).then(() => {
        this.codiceCopiato = true;
        this.notifica.mostra("Codice copiato negli appunti!", 'success');
        setTimeout(() => this.codiceCopiato = false, 2000);
      });
    }
  }
}
