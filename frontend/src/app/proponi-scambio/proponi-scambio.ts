import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ScambioService } from '../service/scambio.service';
import { FantasquadraService } from '../service/fantasquadra.service';
import { NotificaService } from '../service/notifica.service';

@Component({
  selector: 'app-proponi-scambio',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './proponi-scambio.html',
  styleUrls: ['./proponi-scambio.css']
})
export class ProponiScambio implements OnInit {
  private notifica = inject(NotificaService);

  idLega!: number;
  isLoading = true;

  squadreAvversarie: any[] = [];
  rosaMia: any[] = [];
  rosaAvversaria: any[] = [];

  private pesoRuoli: any = { 'P': 1, 'D': 2, 'C': 3, 'A': 4 };

  proposta = {
    idFantasquadraProponente: 0,
    idFantasquadraRicevente: 0,
    idCalciatoreProposto: null,
    idCalciatoreRichiesto: null,
    creditiProponente: 0,
    creditiRicevente: 0,
    stato: 'IN_ATTESA'
  };

  constructor(
    private http: HttpClient,
    private route: ActivatedRoute,
    private router: Router,
    private scambioService: ScambioService,
    private fantasquadraService: FantasquadraService
  ) {}

  ngOnInit() {
    const idParam = this.route.parent?.snapshot.paramMap.get('idLega');
    this.idLega = Number(idParam);

    if (this.idLega) {
      this.caricaDatiIniziali();
    }
  }

  caricaDatiIniziali() {
    this.http.get<any>(`http://localhost:8080/lega/pagina-principale-info/${this.idLega}`, { withCredentials: true })
      .subscribe({
        next: (info) => {
          if (info && info.idFantasquadra) {
            this.proposta.idFantasquadraProponente = info.idFantasquadra;

            this.fantasquadraService.getRosa(info.idFantasquadra).subscribe({
              next: (res) => this.rosaMia = this.ordinaGiocatori(res),
              error: (err) => this.notifica.mostra("Errore recupero rosa propria", "error")
            });

            this.fantasquadraService.getSquadreByLega(this.idLega).subscribe({
              next: (squadre) => {
                this.squadreAvversarie = squadre.filter(s =>
                  (s.idFantasquadra || s.id) !== this.proposta.idFantasquadraProponente
                );
                this.isLoading = false;
              },
              error: (err) => {
                this.notifica.mostra("Errore caricamento squadre", "error");
                this.isLoading = false;
              }
            });
          }
        },
        error: (err) => {
          this.notifica.mostra("Errore recupero info iniziali", "error");
          this.isLoading = false;
        }
      });
  }

  onAvversarioSelezionato() {
    const idRicevente = this.proposta.idFantasquadraRicevente;
    if (idRicevente && idRicevente != 0) {
      this.fantasquadraService.getRosa(idRicevente).subscribe({
        next: (res) => this.rosaAvversaria = this.ordinaGiocatori(res),
        error: (err) => this.notifica.mostra("Errore recupero rosa avversaria", "error")
      });
    } else {
      this.rosaAvversaria = [];
    }
  }

  inviaProposta() {
    if (!this.proposta.idFantasquadraRicevente || (!this.proposta.idCalciatoreProposto && !this.proposta.idCalciatoreRichiesto)) {
      this.notifica.mostra("Seleziona un destinatario e almeno un calciatore!", "error");
      return;
    }

    if (!this.proposta.idCalciatoreProposto) {
      this.notifica.mostra("Attenzione: Non hai selezionato il giocatore da offrire (La tua offerta).", "error");
      return;
    }

    if (!this.proposta.idCalciatoreRichiesto) {
      this.notifica.mostra("Attenzione: Non hai selezionato il giocatore da richiedere (La tua richiesta).", "error");
      return;
    }

    this.notifica.chiediConferma({
      titolo: "Conferma Scambio",
      messaggio: "Sei sicuro di voler inviare questa proposta? Una volta inviata, dovrai attendere la risposta dell'altro fantallenatore.",
      testoConfirm: "INVIA PROPOSTA",
      colore: "btn-success",
      azione: () => {

        this.scambioService.proponiScambio(this.proposta).subscribe({
          next: () => {
            this.notifica.mostra("Proposta di scambio inviata con successo! 🤝", "success");
            this.router.navigate(['/lega', this.idLega, 'scambi']);
          },
          error: (err) => {
            const msg = err.error || "Impossibile inviare la proposta di scambio.";
            this.notifica.mostra("Errore: " + msg, "error");
          }
        });
      }
    });
  }

  // Metodo che ordina i giocatori in base al ruolo e al nome
  private ordinaGiocatori(lista: any[]): any[] {
    if (!lista) return [];
    return lista.sort((a, b) => {
      // Ordina per ruolo (P < D < C < A)
      const pesoA = this.pesoRuoli[a.ruolo] || 99;
      const pesoB = this.pesoRuoli[b.ruolo] || 99;

      if (pesoA !== pesoB) {
        return pesoA - pesoB;
      }
      return a.nome.localeCompare(b.nome);
    });
  }
}
