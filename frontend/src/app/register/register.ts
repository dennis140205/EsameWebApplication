import {Component, inject} from '@angular/core';
import { Router} from '@angular/router';
import { RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { AuthService} from '../auth/auth.service';
import { UtenteDTO } from '../model/utente';
import { NotificaService } from '../service/notifica.service';
@Component({
  selector: 'app-register',
  standalone:true,
  imports: [RouterModule,FormsModule],
  templateUrl: './register.html',
  styleUrl: './register.css',
})
export class Register {
  private notifica = inject(NotificaService);

  dati={
    nome:'',
    cognome:'',
    email:'',
    password:'',
    confermaPassword:''
  }

  isLoading: boolean = false;

  showPassword: boolean = false;
  showConfirmPassword: boolean = false;

  constructor(private authService: AuthService, private router: Router) {}

  onSubmit(){
    if (!this.dati.nome || !this.dati.cognome || !this.dati.email || !this.dati.password) {
      this.notifica.mostra('Attenzione: compila tutti i campi obbligatori.', 'error');
      return;
    }
    const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/
    if (!passwordPattern.test(this.dati.password)) {
      this.notifica.mostra('La password deve essere di almeno 8 caratteri e contenere una lettera e un numero!', 'error');
      return;
    }

    if (this.dati.password !== this.dati.confermaPassword) {
      this.notifica.mostra('Le due password non coincidono.', 'error');
      return;
    }
    this.isLoading = true;
    const nuovoUtente: UtenteDTO = {
      nome: this.dati.nome,
      cognome: this.dati.cognome,
      email: this.dati.email,
      password: this.dati.password
    };
    this.authService.register(nuovoUtente).subscribe({
      next: (response) => {
        console.log('Registrazione avvenuta con successo:', response);
        this.notifica.mostra('Registrazione completata! Effettua il login.', 'success');
        // Se va tutto bene, mando l'utente al login
        this.router.navigate(['/login']);
      },
      error: (err) => {
        console.error('Errore backend:', err);
        this.isLoading = false;
        if (err.status === 409 || err.status === 500) {
          this.notifica.mostra("Impossibile registrarsi. L'email potrebbe essere già in uso.", 'error');
        } else {
          this.notifica.mostra("Errore di connessione al server. Riprova più tardi.", 'error');
        }
      }
    });
  }

  togglePassword() {
    this.showPassword = !this.showPassword;
  }
  toggleConfirmPassword() {
    this.showConfirmPassword = !this.showConfirmPassword;
  }
}
