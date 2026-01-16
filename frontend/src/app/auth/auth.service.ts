import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable, of, tap } from 'rxjs';
import { UtenteDTO } from '../model/utente';
import { catchError, map } from 'rxjs/operators';
import { NotificaService } from '../service/notifica.service';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private notifica = inject(NotificaService);
  private baseUrl = 'http://localhost:8080/utente';

  private isLoggedIn: boolean = false;
  private currentUser: UtenteDTO | null = null;

  constructor(private http: HttpClient) {
    const userSalvato = localStorage.getItem('utente');
    if (userSalvato) {
      this.currentUser = JSON.parse(userSalvato);
      this.isLoggedIn = true;
    }
  }

  isLoggedInSnapshot(): boolean {
    return this.isLoggedIn;
  }

  getUserSnapshot(): UtenteDTO | null {
    return this.currentUser;
  }

  login(email: string, pass: string): Observable<boolean> {
    const headers = new HttpHeaders({
      authorization: 'Basic ' + btoa(email + ':' + pass)
    });

    return this.http.get<UtenteDTO>(`${this.baseUrl}/login`, {
      headers: headers,
      withCredentials: true
    }).pipe(
      tap(user => {
        this.isLoggedIn = true;
        this.currentUser = user;
        localStorage.setItem('utente', JSON.stringify(user));


        this.notifica.mostra(`Bentornato, ${user.nome}!`, "success");
      }),
      map(() => true),
      catchError(err => {
        this.notifica.mostra("Email o password errati", "error");
        this.isLoggedIn = false;
        return of(false);
      })
    );
  }

  checkAuthStatus(): Observable<boolean> {
    return this.http.get<UtenteDTO>(`${this.baseUrl}/profile`, {
      withCredentials: true
    }).pipe(
      map(user => {
        if (user) {
          this.isLoggedIn = true;
          this.currentUser = user;
          localStorage.setItem('utente', JSON.stringify(user));
          return true;
        }
        return false;
      }),
      catchError(() => {
        this.isLoggedIn = false;
        this.currentUser = null;
        localStorage.removeItem('utente');
        return of(false);
      })
    );
  }

  register(utente: UtenteDTO): Observable<UtenteDTO> {
    return this.http.post<UtenteDTO>(`${this.baseUrl}/register`, utente).pipe(
      tap(() => this.notifica.mostra("Registrazione completata!", "success")),
      catchError(err => {
        this.notifica.mostra(err.error || "Errore durante la registrazione", "error");
        throw err;
      })
    );
  }

  logout(): Observable<any> {
    return this.http.post(`${this.baseUrl}/logout`, {}, {
      withCredentials: true
    }).pipe(
      tap(() => {
        this.isLoggedIn = false;
        this.currentUser = null;
        localStorage.removeItem('utente');

        this.notifica.mostra("Logout effettuato", "success");
      })
    );
  }

  updateProfile(user: UtenteDTO): Observable<UtenteDTO> {
    return this.http.put<UtenteDTO>(`${this.baseUrl}/${user.id}`, user, {
      withCredentials: true
    }).pipe(
      tap(updatedUser => {
        this.currentUser = updatedUser;
        localStorage.setItem('utente', JSON.stringify(updatedUser));

        this.notifica.mostra("Profilo aggiornato con successo!", "success");
      }),
      catchError(err => {
        this.notifica.mostra("Impossibile aggiornare il profilo", "error");
        throw err;
      })
    );
  }
}
