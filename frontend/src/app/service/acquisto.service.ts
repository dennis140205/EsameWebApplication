import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface GiocatoreRosa {
  idCalciatore: number;
  idAcquisto: number;
  nome: string;
  ruolo: string;
  squadraReale: string;
  quotazione: number;
  prezzoAcquisto: number;
}

@Injectable({
  providedIn: 'root'
})
export class AcquistoService {
  private apiUrl = 'http://localhost:8080/acquisti';

  constructor(private http: HttpClient) {}

  getRosa(idFantasquadra: number): Observable<GiocatoreRosa[]> {
    return this.http.get<GiocatoreRosa[]>(`${this.apiUrl}/rosa/${idFantasquadra}`, {
      withCredentials: true
    });
  }
}
