import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { StatoCalciatore, Ruolo,Calciatore} from '../model/calciatore.model';

export interface Statistica {
  id: number;
  giornata: number;
  voto: number | null;
  golFatti: number;
  golSubiti: number;
  rigoriParati: number;
  rigoriSbagliati: number;
  assist: number;
  ammonizione: boolean;
  espulsione: boolean;
  autogol: number;
}

@Injectable({
  providedIn: 'root'
})
export class CalciatoreService {
  // Iniettiamo HttpClient (metodo moderno Angular 15+)
  private http = inject(HttpClient);

  // URL base del backend
  private API_URL = 'http://localhost:8080/calciatori';

  // Opzioni per gestire la sessione (necessarie per Spring Security)
  private httpOptions = {
    withCredentials: true // Permette l'invio dei cookie di sessione/login
  };

  /** * METODI PER GLI UTENTI
   **/

  // Recupera tutto il listone
  getCalciatori(): Observable<Calciatore[]> {
    return this.http.get<Calciatore[]>(this.API_URL, this.httpOptions);
  }

  // Filtra per ruolo (P, D, C, A)
  getCalciatoriByRuolo(ruolo: Ruolo): Observable<Calciatore[]> {
    return this.http.get<Calciatore[]>(`${this.API_URL}/ruolo/${ruolo}`, this.httpOptions);
  }

  // Dettaglio singolo giocatore
  getCalciatoreById(id: number): Observable<Calciatore> {
    return this.http.get<Calciatore>(`${this.API_URL}/${id}`, this.httpOptions);
  }

  /** * METODI PER L'ADMIN
   * Nota: usiamo { responseType: 'text' } perché il tuo controller Java
   * restituisce ResponseEntity<String> e non un JSON.
   **/

  importaListone(): Observable<string> {
    return this.http.post(`${this.API_URL}/import`, {}, { ...this.httpOptions, responseType: 'text' });
  }

  sincronizzaFoto(): Observable<string> {
    return this.http.post(`${this.API_URL}/sync-images`, {}, { ...this.httpOptions, responseType: 'text' });
  }

  caricaVoti(file: File, giornata: number): Observable<string> {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('giornata', giornata.toString()); // Parametro richiesto dal backend

    return this.http.post(`${this.API_URL}/upload-voti`, formData, {
      ...this.httpOptions,
      responseType: 'text'
    });
  }

  caricaStati(file: File): Observable<string> {
    const formData = new FormData();
    formData.append('file', file);
    return this.http.post(`${this.API_URL}/upload-stati`, formData, { ...this.httpOptions, responseType: 'text' });
  }

  // Recupera lo storico voti di un calciatore
  getStatisticheCalciatore(id: number): Observable<Statistica[]> {
    return this.http.get<Statistica[]>(`${this.API_URL}/${id}/statistiche`, this.httpOptions);
  }
}
