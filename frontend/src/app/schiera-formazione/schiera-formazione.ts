import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { AcquistoService } from '../service/acquisto.service';
import { FormazioneService } from '../service/formazione.service';
import { Legaservice } from '../service/lega.service';
import { SchieramentoDTO, FormazioneDTO } from '../model/formazione.model';
import { NotificaService } from '../service/notifica.service';

interface PostiModulo {
  [key: string]: number;
  P: number; D: number; C: number; A: number;
}

@Component({
  selector: 'app-schiera-formazione',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  templateUrl: './schiera-formazione.html',
  styleUrl: './schiera-formazione.css',
})
export class SchieraFormazione implements OnInit {
  private http = inject(HttpClient);
  private route = inject(ActivatedRoute);
  private acquistoService = inject(AcquistoService);
  private formazioneService = inject(FormazioneService);
  private legaService = inject(Legaservice);
  private notifica = inject(NotificaService);

  idLega!: number;
  idFantasquadra!: number;
  rosa: any[] = [];
  titolari: SchieramentoDTO[] = [];
  panchina: SchieramentoDTO[] = [];
  moduloScelto: string = '4-4-2';
  moduliDisponibili = ['3-4-3', '4-3-3', '4-4-2', '3-5-2', '5-3-2', '5-4-1', '4-5-1'];
  giornataCorrente: number = 1;

  isModalOpen: boolean = false;
  ruoloSelezionatoModale: string = '';
  giocatoriFiltratiModale: any[] = [];
  isLoadingSalvataggio: boolean = false;

  private pesoRuoli: any = { 'P': 1, 'Por': 1, 'D': 2, 'Dif': 2, 'C': 3, 'Cen': 3, 'A': 4, 'Att': 4 };

  ngOnInit(): void {
    this.route.parent?.paramMap.subscribe(params => {
      const id = params.get('idLega');
      if (id) {
        this.idLega = +id;
        // Recupera la giornata attiva
        this.legaService.getGiornataAttiva(this.idLega).subscribe({
          next: (g) => {
            this.giornataCorrente = g;
            this.caricaInfoLega(this.idLega);
          },
          error: () => this.caricaInfoLega(this.idLega)
        });
      }
    });
  }

  caricaInfoLega(idLega: number) {
    this.http.get<any>(`http://localhost:8080/lega/pagina-principale-info/${idLega}`, { withCredentials: true })
      .subscribe({
        next: (data) => {
          this.idFantasquadra = data.idFantasquadra;
          if (this.idFantasquadra) {
            this.caricaRosa();
            this.caricaFormazioneEsistente();
          }
        },
        error: () => this.notifica.mostra("Errore nel caricamento informazioni squadra", "error")
      });
  }

  get postiModulo(): PostiModulo {
    const p = this.moduloScelto.split('-');
    return { P: 1, D: parseInt(p[0]), C: parseInt(p[1]), A: parseInt(p[2]) };
  }

  caricaRosa() {
    this.acquistoService.getRosa(this.idFantasquadra).subscribe(data => this.rosa = data);
  }

  caricaFormazioneEsistente() {
    this.formazioneService.getFormazione(this.idFantasquadra, this.giornataCorrente).subscribe(form => {
      if (form) {
        this.moduloScelto = form.modulo;
        this.titolari = form.calciatori.filter((c: any) => c.stato === 'TITOLARE');
        this.panchina = form.calciatori.filter((c: any) => c.stato === 'PANCHINA');
      } else {
        this.titolari = [];
        this.panchina = [];
      }
    });
  }

  salva() {
    if (this.titolari.length !== 11) {
      this.notifica.mostra("Devi schierare esattamente 11 titolari.", "error");
      return;
    }
    this.isLoadingSalvataggio = true;
    const formazioneInviata: FormazioneDTO = {
      idFantasquadra: this.idFantasquadra,
      giornata: this.giornataCorrente,
      modulo: this.moduloScelto,
      calciatori: [...this.titolari, ...this.panchina]
    };

    this.formazioneService.salvaFormazione(formazioneInviata).subscribe({
      next: (resp) => {
        this.isLoadingSalvataggio = false;
        this.notifica.mostra(resp || "Formazione salvata con successo!", "success");
      },
      error: (err) => {
        this.isLoadingSalvataggio = false;
        this.notifica.mostra(err.error || "Impossibile salvare la formazione.", "error");
      }
    });
  }

  apriModale(ruolo: string) {
    if (ruolo === 'ANY' && this.panchina.length >= 12) {
      this.notifica.mostra("Hai raggiunto il limite massimo di 12 panchinari!", "error");
      return;
    }

    this.ruoloSelezionatoModale = ruolo;
    let filtrati = this.rosa.filter(g =>
      (ruolo === 'ANY' || g.ruolo === ruolo) &&
      ![...this.titolari, ...this.panchina].some(s => s.idCalciatore === g.idCalciatore)
    );

    filtrati.sort((a, b) => {
      const pesoA = this.pesoRuoli[a.ruolo] || 99;
      const pesoB = this.pesoRuoli[b.ruolo] || 99;

      if (pesoA !== pesoB) {
        return pesoA - pesoB;
      }
      return a.nome.localeCompare(b.nome);
    });
    this.giocatoriFiltratiModale = filtrati;
    this.isModalOpen = true;
  }

  selezionaGiocatore(calc: any) {
    const stato = this.ruoloSelezionatoModale === 'ANY' ? 'PANCHINA' : 'TITOLARE';
    const nuovo: SchieramentoDTO = {
      idCalciatore: calc.idCalciatore,
      nomeCalciatore: calc.nome,
      ruolo: calc.ruolo,
      stato: stato,
      ordine: stato === 'PANCHINA' ? this.panchina.length + 1 : 0
    };
    if (stato === 'TITOLARE') this.titolari.push(nuovo);
    else this.panchina.push(nuovo);
    this.isModalOpen = false;
  }

  rimuovi(s: any) {
    this.titolari = this.titolari.filter(x => x.idCalciatore !== s.idCalciatore);
    this.panchina = this.panchina.filter(x => x.idCalciatore !== s.idCalciatore);
  }

  getArrayVuoto(n: number): any[] { return n > 0 ? Array(n).fill(0) : []; }
  getTitolariPerRuolo(ruolo: string) { return this.titolari.filter(t => t.ruolo === ruolo); }
}
