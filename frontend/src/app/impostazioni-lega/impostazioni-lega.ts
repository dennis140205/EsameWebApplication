import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, ActivatedRoute } from '@angular/router';
import { ImpostazioniService } from '../service/impostazioni.service';
import { Legaservice } from '../service/lega.service';

import { NotificaService } from '../service/notifica.service';
import { AuthService } from '../auth/auth.service';

@Component({
  selector: 'app-impostazioni-lega',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './impostazioni-lega.html',
  styleUrls: ['./impostazioni-lega.css']
})
export class ImpostazioniLega implements OnInit {
  private notifica = inject(NotificaService);
  private authService = inject(AuthService);

  idLega: number = 0;
  codiceLega: string = '';
  loading: boolean = true;
  isAdmin: boolean = false;

  settings: any = {
    id: null,
    idLega: null,
    budgetIniziale: 500,
    maxCalciatori: 25,
    mercatoScambiAperto: true,
    modificatoreDifesa: false,
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
    malusRigoreSbagliato: -3.0,
    sogliaGol: 66,
    stepFascia: 6
  };

  constructor(
    private impostazioniService: ImpostazioniService,
    private legaService: Legaservice,
    private route: ActivatedRoute
  ) {}

  ngOnInit() {
    const idParam = this.route.parent?.snapshot.paramMap.get('idLega');
    this.idLega = idParam ? +idParam : 0;

    if (this.idLega > 0) {
      // Iniziamo il caricamento dei dati
      this.caricaInfoLega();
      this.caricaImpostazioni();
      this.verificaPermessi();
    } else {
      console.error("ID Lega mancante nell'URL!");
      this.loading = false;
    }
  }

  verificaPermessi() {
    this.isAdmin = false;


    this.legaService.getInfoLega(this.idLega).subscribe({
      next: (info: any) => {
        if (info && (info.isAdmin === true || info.isAdmin === 'true')) {
          this.isAdmin = true;
          console.log("Admin confermato da getInfoLega");
        } else {
          this.checkAdminStatusFallback();
        }
      },
      error: () => {
        console.warn("Check info lega fallito");
        this.checkAdminStatusFallback();
      }
    });
  }


  private checkAdminStatusFallback() {
    this.legaService.checkAdminStatus(this.idLega).subscribe({
      next: (status: any) => {
        if (status === true || status?.isAdmin === true || status === 'true') {
          this.isAdmin = true;
          console.log("Admin confermato da checkAdminStatus");
        } else {
          this.checkListaLegheFallback();
        }
      },
      error: () => {
        console.warn("Check is-admin fallito");
        this.checkListaLegheFallback();
      }
    });
  }

  private checkListaLegheFallback() {
    const user = this.authService.getUserSnapshot();
    if (user?.id) {
      this.legaService.getLegheUtente(user.id).subscribe({
        next: (leghe) => {
          const current = leghe.find(l => l.id == this.idLega);
          if (current) {
            const ruolo = current.ruolo ? current.ruolo.toLowerCase() : '';
            if (ruolo === 'presidente' || ruolo === 'admin' || ruolo === 'creatore') {
              this.isAdmin = true;
              console.log("Admin confermato da lista leghe");
            }
          }
        },
        error: (e) => console.warn("Check lista leghe fallito", e)
      });
    }
  }

  caricaInfoLega() {
    this.legaService.getLegaById(this.idLega).subscribe({
      next: (lega: any) => {
        if (lega) {
          this.codiceLega = lega.codiceInvito || lega.codice;
        }
      },
      error: (error) => console.error("Errore recupero codice:", error)
    });
  }

  caricaImpostazioni() {
    this.impostazioniService.getImpostazioni(this.idLega).subscribe({
      next: (data) => {
        if (data) {
          this.settings = data;
        }
        this.loading = false;
      },
      error: (error) => {
        console.error("Errore recupero impostazioni:", error);
        this.notifica.mostra("Impossibile caricare il regolamento", "error");
        this.loading = false;
      }
    });
  }

  copyCode() {
    if (this.codiceLega) {
      navigator.clipboard.writeText(this.codiceLega);
      this.notifica.mostra('Codice copiato negli appunti!', 'success');
    }
  }

  validazioneDati(): boolean {
    if (this.settings.budgetIniziale <= 0) {
      this.notifica.mostra("Il budget iniziale deve essere maggiore di 0.", "error");
      return false;
    }
    if (this.settings.maxCalciatori <= 0) {
      this.notifica.mostra("Il numero massimo di calciatori deve essere maggiore di 0.", "error");
      return false;
    }
    if (this.settings.sogliaGol <= 0) {
      this.notifica.mostra("La soglia gol deve essere maggiore di 0.", "error");
      return false;
    }
    if (this.settings.stepFascia <= 0) {
      this.notifica.mostra("Lo step fascia deve essere maggiore di 0.", "error");
      return false;
    }

    const campiBonus = ['bonusGol', 'bonusAssist', 'bonusRigoreParato'];
    for (const campo of campiBonus) {
      if (this.settings[campo] <= 0) {
        this.notifica.mostra(`Il valore di '${campo}' deve essere positivo!`, "error");
        return false;
      }
    }

    const campiMalus = ['malusAmmonizione', 'malusEspulsione', 'malusGolSubito', 'malusAutogol', 'malusRigoreSbagliato'];
    for (const campo of campiMalus) {
      if (this.settings[campo] >= 0) {
        this.notifica.mostra(`Il valore di '${campo}' deve essere negativo!`, "error");
        return false;
      }
    }
    return true;
  }

  saveSettings() {
    if (!this.isAdmin) return;

    if (!this.validazioneDati()) {
      return;
    }

    this.notifica.chiediConferma({
      titolo: "Salva Impostazioni",
      messaggio: "Sei sicuro di voler aggiornare il regolamento della lega? Le modifiche avranno effetto immediato sui calcoli futuri.",
      testoConfirm: "SALVA",
      colore: "btn-success",
      azione: () => {
        this.impostazioniService.updateImpostazioni(this.settings.id, this.settings).subscribe({
          next: (result) => {
            if (result) {
              this.notifica.mostra('Regolamento salvato con successo!', 'success');
            }
          },
          error: (error) => {
            console.error("Errore salvataggio:", error);
            this.notifica.mostra('Errore durante il salvataggio.', 'error');
          }
        });
      }
    });
  }

  resetToDefault() {
    if (!this.isAdmin) return;

    this.notifica.chiediConferma({
      titolo: "Ripristino Regolamento",
      messaggio: "Sei sicuro di voler ripristinare i valori predefiniti? Tutte le modifiche attuali verranno perse definitivamente.",
      testoConfirm: "RIPRISTINA",
      colore: "btn-danger",
      coloreAnnulla: "btn-secondary",
      azione: () => {
        this.impostazioniService.resetImpostazioni(this.idLega).subscribe({
          next: () => {
            this.caricaImpostazioni();
            this.notifica.mostra('Valori ripristinati correttamente.', 'success');
          },
          error: (error) => {
            console.error("Errore reset:", error);
            this.notifica.mostra('Impossibile ripristinare i valori.', 'error');
          }
        });
      }
    });
  }
}
