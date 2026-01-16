import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class FormazioneService {
  private http = inject(HttpClient);
  private baseUrl = 'http://localhost:8080/formazione';

  // 🔴 AGGIUNTO { withCredentials: true } in tutte le chiamate
  getFormazione(idFantasquadra: number, giornata: number): Observable<any> {
    return this.http.get(`${this.baseUrl}/${idFantasquadra}/${giornata}`, {
      withCredentials: true
    });
  }

  salvaFormazione(formazione: any): Observable<any> {
    return this.http.post(this.baseUrl, formazione, {
      responseType: 'text',
      withCredentials: true
    });
  }

  getRosa(idFantasquadra: number): Observable<any[]> {
    return this.http.get<any[]>(`http://localhost:8080/squadra/${idFantasquadra}/rosa`, {
      withCredentials: true
    });
  }
}
