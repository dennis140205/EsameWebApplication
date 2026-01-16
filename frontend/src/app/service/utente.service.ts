import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { UtenteDTO } from '../model/utente';

@Injectable({
  providedIn: 'root'
})
export class UtenteService {
  private http = inject(HttpClient);
  private API_URL = 'http://localhost:8080/utente';

  // Opzioni per includere i cookie
  private httpOptions = {
    withCredentials: true
  };

  // Recupera il profilo dell'utente loggato
  getProfile(): Observable<UtenteDTO> {
    return this.http.get<UtenteDTO>(`${this.API_URL}/profile`, this.httpOptions);
  }

  // Aggiorna i dati
  updateProfile(utente: UtenteDTO): Observable<UtenteDTO> {
    return this.http.put<UtenteDTO>(
      `${this.API_URL}/${utente.id}`,
      utente,
      this.httpOptions
    );
  }
}
