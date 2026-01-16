import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})

export class Stats {

  // L'indirizzo del TUO backend (StatsController)
  private apiUrl = 'http://localhost:8080/api/stats';
  constructor(private http: HttpClient) {}

  // Chiama: GET /api/stats/classifica
  getSerieAStandings(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/classifica`);
  }

  // Chiama: GET /api/stats/marcatori
  getSerieAScorers(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/marcatori`);
  }

  getInfoCompetizione(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/info-competizione`);
  }


  getCalendarioCompleto(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/calendario-completo`);
  }

  getDeadline(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/deadline`, { withCredentials: true });
  }

  getGiornataAttuale(): Observable<number> {
    return this.http.get<number>(`${this.apiUrl}/giornata-attuale`, { withCredentials: true });
  }
}






