import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, ActivatedRoute } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { UtenteService } from '../service/utente.service';
import { UtenteDTO } from '../model/utente';
import { NotificaService } from '../service/notifica.service';

@Component({
  selector: 'app-profilo',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  templateUrl: './profilo.html',
  styleUrl: './profilo.css',
})
export class Profilo implements OnInit {
  private notifica = inject(NotificaService);

  idLega: number = -1;

  user: UtenteDTO = {
    id: 0,
    nome: '',
    cognome: '',
    email: '',
    squadraPreferita: ''
  };

  nuovaPassword: string = '';
  confermaPassword: string = '';


  tutteLeSquadre: string[] = [
    'Atalanta', 'Bologna', 'Cagliari', 'Como', 'Cremonese',
    'Fiorentina', 'Genoa', 'Inter', 'Juventus', 'Lazio',
    'Lecce', 'Milan', 'Napoli', 'Parma', 'Pisa', 'Roma',
    'Sassuolo', 'Torino', 'Udinese', 'Verona'
  ];

  squadreFiltrate: string[] = [];
  mostraSuggerimenti: boolean = false;

  constructor(
    private utenteService: UtenteService,
    private route: ActivatedRoute
  ) {}

  ngOnInit() {
    const idParam = this.route.snapshot.paramMap.get('idLega');
    if (idParam !== null) {
      this.idLega = Number(idParam);
    } else {
      this.idLega = -1;
    }

    this.caricaDatiUtente();
  }

  filtraSquadre() {
    const ricerca = this.user.squadraPreferita ? this.user.squadraPreferita.toLowerCase() : '';
    if (ricerca.trim() === '') {
      this.squadreFiltrate = [];
      this.mostraSuggerimenti = false;
      return;
    }
    this.squadreFiltrate = this.tutteLeSquadre.filter(s =>
      s.toLowerCase().includes(ricerca)
    );
    this.mostraSuggerimenti = true;
  }

  selezionaSquadra(squadra: string) {
    this.user.squadraPreferita = squadra;
    this.mostraSuggerimenti = false;
  }

  nascondiListaDelay() {
    setTimeout(() => {
      this.mostraSuggerimenti = false;
    }, 200);
  }

  caricaDatiUtente() {
    this.utenteService.getProfile().subscribe({
      next: (dati: UtenteDTO) => {
        this.user = dati;
      },
      error: (err) => {
        this.notifica.mostra("Impossibile caricare i dati utente.", "error");
      }
    });
  }

  salvaModifiche() {
    if (!this.user.nome || this.user.nome.trim() === '') {
      this.notifica.mostra("Attenzione: Il campo Nome non può essere vuoto.", "error");
      return;
    }
    if (!this.user.cognome || this.user.cognome.trim() === '') {
      this.notifica.mostra("Attenzione: Il campo Cognome non può essere vuoto.", "error");
      return;
    }

    if (this.nuovaPassword || this.confermaPassword) {
      if (this.nuovaPassword.length < 8) {
        this.notifica.mostra("La password deve essere di almeno 8 caratteri.", "error");
        return;
      }
      const haLettera = /[a-zA-Z]/.test(this.nuovaPassword);
      const haNumero = /\d/.test(this.nuovaPassword);

      if (!haLettera || !haNumero) {
        this.notifica.mostra("La password deve contenere almeno una lettera e un numero.", "error");
        return;
      }
      if (this.nuovaPassword !== this.confermaPassword) {
        this.notifica.mostra("Le due password non coincidono!", "error");
        return;
      }
      this.user.password = this.nuovaPassword;
    } else {
      delete this.user.password;
    }

    this.notifica.chiediConferma({
      titolo: "Conferma Salvataggio",
      messaggio: "Sei sicuro di voler aggiornare i dati del tuo profilo? L'operazione è immediata.",
      testoConfirm: "SALVA",
      colore: "btn-success",
      azione: () => {
        this.utenteService.updateProfile(this.user).subscribe({
          next: (utenteAggiornato) => {
            this.user = utenteAggiornato;
            this.nuovaPassword = '';
            this.confermaPassword = '';
            this.notifica.mostra("Profilo aggiornato con successo! ✅", "success");
          },
          error: (err) => {
            this.notifica.mostra("Errore durante il salvataggio. Riprova.", "error");
          }
        });
      }
    });
  }
}
