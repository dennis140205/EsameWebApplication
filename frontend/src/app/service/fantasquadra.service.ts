import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class FantasquadraService {
  private http = inject(HttpClient);
  private API_URL = 'http://localhost:8080/fantasquadra';

  // Opzioni standard per gestire sessioni e risposte testuali
  private httpOptions = { withCredentials: true };
  private httpOptionsText = { withCredentials: true, responseType: 'text' as 'json' };

  // Recupera la rosa di una specifica fantasquadra
  getRosa(idFantasquadra: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.API_URL}/${idFantasquadra}/rosa`, this.httpOptions);
  }

  // Recupera tutte le fantasquadre di una lega
  getSquadreByLega(idLega: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.API_URL}/lega/${idLega}`, this.httpOptions);
  }

  // Recupera la squadra dell'utente loggato in una specifica lega
  getMiaSquadra(idLega: number): Observable<any> {
    return this.http.get<any>(`${this.API_URL}/mia-squadra/${idLega}`, this.httpOptions);
  }

  // Crea una nuova fantasquadra
  creaFantasquadra(squadra: any): Observable<string> {
    return this.http.post<string>(`${this.API_URL}/creaFantasquadra`, squadra, this.httpOptionsText);
  }

  // Aggiorna i crediti di una squadra
  updateCrediti(idFantasquadra: number, crediti: number): Observable<string> {
    const params = new HttpParams().set('crediti', crediti.toString());
    return this.http.put<string>(`${this.API_URL}/${idFantasquadra}/crediti`, null, {
      ...this.httpOptionsText,
      params
    });
  }

  // Conta i giocatori in rosa
  contaGiocatori(idFantasquadra: number): Observable<number> {
    return this.http.get<number>(`${this.API_URL}/${idFantasquadra}/countGiocatori`, this.httpOptions);
  }

  // Elimina una fantasquadra
  eliminaFantasquadra(idFantasquadra: number): Observable<string> {
    return this.http.delete<string>(`${this.API_URL}/${idFantasquadra}`, this.httpOptionsText);
  }
}
