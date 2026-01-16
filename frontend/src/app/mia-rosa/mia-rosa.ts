import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, ActivatedRoute } from '@angular/router';
import { AcquistoService, GiocatoreRosa } from '../service/acquisto.service';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { NotificaService } from '../service/notifica.service';

@Component({
  selector: 'app-mia-rosa',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  templateUrl: './mia-rosa.html',
  styleUrl: './mia-rosa.css',
})
export class MiaRosa implements OnInit {
  private notifica = inject(NotificaService);

  calciatori: GiocatoreRosa[] = [];
  idLega!: number;
  squadreLega: any[] = [];
  idSquadraSelezionata!: number;
  idMiaSquadra!: number;

  constructor(
    private acquistoService: AcquistoService,
    private http: HttpClient,
    private route: ActivatedRoute
  ) {}

  ngOnInit(): void {
    this.route.parent?.paramMap.subscribe(params => {
      const id = params.get('idLega');
      if (id) {
        this.idLega = +id;
        this.inizializzaDati();
      }
    });
  }

  inizializzaDati() {
    this.http.get<any>(`http://localhost:8080/lega/pagina-principale-info/${this.idLega}`, { withCredentials: true })
      .subscribe({
        next: (data) => {
          this.idMiaSquadra = data.idFantasquadra;
          this.idSquadraSelezionata = data.idFantasquadra;
          this.caricaRosa(this.idSquadraSelezionata);
          this.caricaTutteLeSquadre();
        },
        error: () => {
          this.notifica.mostra("Errore nel recupero delle informazioni della tua squadra", "error");
        }
      });
  }

  caricaTutteLeSquadre() {
    this.http.get<any[]>(`http://localhost:8080/lega/${this.idLega}/classifica`, { withCredentials: true })
      .subscribe({
        next: (data) => {
          this.squadreLega = data;
        },
        error: () => {
          this.notifica.mostra("Impossibile caricare l'elenco delle squadre della lega", "error");
        }
      });
  }

  onCambioSquadra() {
    this.caricaRosa(this.idSquadraSelezionata);
  }

  caricaRosa(idFantasquadra: number) {
    this.acquistoService.getRosa(idFantasquadra).subscribe({
      next: (data) => {
        this.calciatori = data;
        const ordineRuoli: any = { 'P': 1, 'D': 2, 'C': 3, 'A': 4 };
        this.calciatori.sort((a, b) => ordineRuoli[a.ruolo] - ordineRuoli[b.ruolo]);
      },
      error: () => {
        this.notifica.mostra("Errore nel caricamento della rosa selezionata", "error");
      }
    });
  }

  get creditiSelezionati(): number {
    const squadra = this.squadreLega.find(s => s.idFantasquadra === +this.idSquadraSelezionata);
    return squadra ? squadra.creditiResidui : 0;
  }
}
