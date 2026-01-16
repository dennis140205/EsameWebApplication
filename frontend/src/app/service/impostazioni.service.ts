import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ImpostazioniService {
  private apiUrl = 'http://localhost:8080/impostazioni';

  constructor(private http: HttpClient) {}

  // Restituisce un Observable invece di una Promise
  getImpostazioni(idLega: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/lega/${idLega}`, { withCredentials: true });
  }

  updateImpostazioni(idLega: number, impostazioni: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/${idLega}`, impostazioni, { withCredentials: true });
  }

  resetImpostazioni(idLega: number): Observable<any> {
    return this.http.post(`${this.apiUrl}/reset/${idLega}`, {}, { withCredentials: true, responseType: 'text' });
  }
}
