import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CalendarioService {
  private http = inject(HttpClient);
  private API_CALENDARIO = 'http://localhost:8080/calendario';
  private API_PUNTEGGI = 'http://localhost:8080/punteggi';

  private httpOptions = {
    withCredentials: true
  };

  private httpOptionsText = {
    withCredentials: true,
    responseType: 'text' as 'json'
  };
  // Recupera le partite di una specifica giornata
  getPartiteGiornata(idLega: number, giornataReale: number): Observable<any[]> {
    return this.http.get<any[]>(
      `${this.API_CALENDARIO}/lega/${idLega}/giornata/${giornataReale}`,
      { withCredentials: true }
    );
  }

  // Genera il calendario iniziale
  generaCalendario(idLega: number, inizioSerieA: number): Observable<string> {
    return this.http.post<string>(
      `${this.API_CALENDARIO}/genera/${idLega}?giornataIniziale=${inizioSerieA}`,
      {},
      this.httpOptionsText // 🟢 USA QUESTO, non httpOptions!
    );
  }

  // Esegue il calcolo della giornata (Simulato o Reale)
  calcolaGiornata(idLega: number, giornataReale: number): Observable<string> {
    return this.http.post<string>(
      `${this.API_PUNTEGGI}/calcola/lega/${idLega}/giornata/${giornataReale}`,
      {},
      this.httpOptions
    );
  }

  // Elimina il calendario esistente
  eliminaCalendario(idLega: number): Observable<string> {
    return this.http.delete<string>(
      `${this.API_CALENDARIO}/elimina/${idLega}`,
      this.httpOptions
    );
  }
}
