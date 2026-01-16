import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ScambioDTO } from '../model/scambio.model';

@Injectable({
  providedIn: 'root'
})
export class ScambioService {
  private http = inject(HttpClient);
  private API_URL = 'http://localhost:8080/scambi';

  private httpOptions = {
    withCredentials: true
  };

  private httpOptionsText = {
    withCredentials: true,
    responseType: 'text' as 'json'
  };

  getScambiLega(idLega: number): Observable<ScambioDTO[]> {
    return this.http.get<ScambioDTO[]>(
      `${this.API_URL}/lega/${idLega}`,
      this.httpOptions
    );
  }

  proponiScambio(scambio: any): Observable<string> {
    return this.http.post<string>(
      `${this.API_URL}/proponi`,
      scambio,
      this.httpOptionsText
    );
  }

  accettaScambio(id: number): Observable<string> {
    return this.http.put<string>(
      `${this.API_URL}/${id}/accetta`,
      {},
      this.httpOptionsText
    );
  }

  rifiutaScambio(id: number): Observable<string> {
    return this.http.put<string>(
      `${this.API_URL}/${id}/rifiuta`,
      {},
      this.httpOptionsText
    );
  }

  annullaScambio(id: number): Observable<string> {
    return this.http.delete<string>(
      `${this.API_URL}/${id}`,
      this.httpOptionsText
    );
  }
  getCountNotifiche(idFantasquadra: number): Observable<number> {
    return this.http.get<number>(`${this.API_URL}/notifiche/count/${idFantasquadra}`, { withCredentials: true });
  }

  resetNotifiche(idFantasquadra: number): Observable<any> {
    return this.http.post(`${this.API_URL}/notifiche/reset/${idFantasquadra}`, {}, { withCredentials: true });
  }
}
