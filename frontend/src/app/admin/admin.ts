import { Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CalciatoreService } from '../service/calciatore.service';
import {Router, RouterLink} from '@angular/router';
import {HttpClient} from '@angular/common/http';

@Component({
  selector: 'app-admin',
  standalone: true,
  imports: [FormsModule, RouterLink],
  templateUrl: './admin.html',
  styleUrl: './admin.css'
})
export class Admin {
  private calciatoreService = inject(CalciatoreService);
  private router = inject(Router);
  private http = inject(HttpClient);

  isLoading = false;
  messaggioStatus = '';
  giornataSelezionata: number = 1;

  // Variabili per la gestione della conferma pre-upload
  fileSelezionato: File | null = null;
  tipoFileSelezionato: 'voti' | 'stati' | null = null;

  ngOnInit() {
    this.verificaRuoloAdmin();
  }

  verificaRuoloAdmin() {
    const userString = localStorage.getItem('utente');

    if (!userString) {
      this.router.navigate(['/login']);
      return;
    }
    const user = JSON.parse(userString);
    if (user.ruolo !== 'ADMIN' && user.ruolo !== 'ROLE_ADMIN') {
      this.router.navigate(['/']);
    }
  }

  // Metodo per import listone e sync immagini
  eseguiAzione(azione: 'import' | 'sync') {
    this.isLoading = true;
    this.messaggioStatus = 'Operazione in corso...';

    const obs = azione === 'import'
      ? this.calciatoreService.importaListone()
      : this.calciatoreService.sincronizzaFoto();

    obs.subscribe({
      next: (res) => {
        this.messaggioStatus = res;
        this.isLoading = false;
      },
      error: (err) => {
        this.messaggioStatus = "Errore durante l'operazione.";
        this.isLoading = false;
        console.error(err);
      }
    });
  }

  // Fase di selezione(valida il file ma non lo invia ancora al server)
  onFileSelected(event: any, tipo: 'voti' | 'stati') {
    const file: File = event.target.files[0];
    if (!file) {
      this.fileSelezionato = null;
      return;
    }

    if (!file.name.toLowerCase().endsWith('.csv')) {
      this.messaggioStatus = "Errore: Seleziona un file in formato .csv";
      this.fileSelezionato = null;
      event.target.value = ''; // Resetta l'input file
      return;
    }

    this.fileSelezionato = file;
    this.tipoFileSelezionato = tipo;
    this.messaggioStatus = `File pronto per la Giornata ${this.giornataSelezionata}. Clicca su CARICA per confermare.`;
  }

  // Fase in cui invia effettivamente i dati al backend
  eseguiCaricamentoEffettivo() {
    if (!this.fileSelezionato || !this.tipoFileSelezionato) return;

    this.isLoading = true;
    this.messaggioStatus = `Salvataggio voti della giornata ${this.giornataSelezionata}...`;

    const uploadObs = this.tipoFileSelezionato === 'voti'
      ? this.calciatoreService.caricaVoti(this.fileSelezionato, this.giornataSelezionata)
      : this.calciatoreService.caricaStati(this.fileSelezionato);

    uploadObs.subscribe({
      next: (res) => {
        this.messaggioStatus = res;
        this.isLoading = false;
        this.fileSelezionato = null;
        this.tipoFileSelezionato = null;
      },
      error: (err) => {
        this.messaggioStatus = `Errore critico durante l'upload. Controlla la console.`;
        this.isLoading = false;
        this.fileSelezionato = null;
        console.error(err);
      }
    });
  }
}
