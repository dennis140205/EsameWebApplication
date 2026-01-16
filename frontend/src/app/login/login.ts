import { Component, inject } from '@angular/core';
import { AuthService } from '../auth/auth.service';
import { Router } from '@angular/router';
import {FormsModule} from '@angular/forms';
import {RouterModule} from '@angular/router';
import { NotificaService } from '../service/notifica.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [
    FormsModule,RouterModule
  ],
  templateUrl: './login.html',
  styleUrl: './login.css',
})
export class Login {
  private notifica = inject(NotificaService);
  dati={email:'', password:''};


  isPasswordVisible: boolean = false;

  constructor(private authService: AuthService, private router: Router) {}

  onLogin() {
    this.authService.login(this.dati.email, this.dati.password)
      .subscribe(success => {
        if (success) {
          this.router.navigate(['/']);
        }
      });
  }

  togglePasswordVisibility() {
    this.isPasswordVisible = !this.isPasswordVisible;
  }
}
