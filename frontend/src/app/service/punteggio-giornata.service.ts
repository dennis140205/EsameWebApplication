import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class PunteggioGiornataService {
  private http = inject(HttpClient);
  private API_URL = 'http://localhost:8080/punteggi';

  private httpOptions = {
    withCredentials: true
  };

  private httpOptionsText = {
    withCredentials: true,
    responseType: 'text' as 'json'
  };

  calcolaGiornata(idLega: number, giornata: number): Observable<string> {
    return this.http.post<string>(
      `${this.API_URL}/calcola/lega/${idLega}/giornata/${giornata}`,
      {},
      this.httpOptionsText
    );
  }

  resetGiornata(idLega: number, giornata: number): Observable<string> {
    return this.http.post<string>(
      `${this.API_URL}/reset/lega/${idLega}/giornata/${giornata}`,
      {},
      this.httpOptionsText
    );
  }


  getRisultatiLive(idLega: number, giornata: number): Observable<any[]> {
    return this.http.get<any[]>(
      `${this.API_URL}/live/lega/${idLega}/giornata/${giornata}`,
      { withCredentials: true }
    );
  }
}
