import { Injectable, inject } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import { Observable } from 'rxjs';
import { Lega,LegaWithImpostazioniPayload} from '../model/lega.model';
import {BehaviorSubject} from 'rxjs';

export interface LegaRiepilogo {
  id: number;
  nome: string;
  ruolo: string;
  iscritti: string;
  prossimoTurno: string;  // Es: "In Attesa"
}

@Injectable({
  providedIn: 'root'
})
export class Legaservice {
  private http = inject(HttpClient);
  private API_URL = 'http://localhost:8080/lega';
  private API_SQUADRA = 'http://localhost:8080/fantasquadra';
  private API_ACQUISTI = 'http://localhost:8080/acquisti';
  private creditiSubject = new BehaviorSubject<number>(0);
  creditiAttuali$ = this.creditiSubject.asObservable();
  private httpOptions={
    withCredentials:true
  }
  creaLega(payload: LegaWithImpostazioniPayload): Observable<Lega> {
    return this.http.post<Lega>(
      `${this.API_URL}/crea`,
      payload,
      this.httpOptions
    );
  }

  creaFantasquadra(datiSquadra: any): Observable<string> {
    return this.http.post(
      `${this.API_SQUADRA}/creaFantasquadra`,
      datiSquadra,
      { ...this.httpOptions, responseType: 'text' }
    );
  }
  getGiornataAttiva(idLega: number): Observable<number> {
    return this.http.get<number>(
      `${this.API_URL}/${idLega}/giornata-attiva`,
      this.httpOptions
    );
  }
  getLegaById(idLega: number): Observable<Lega> {

    return this.http.get<Lega>(`${this.API_URL}/${idLega}`, this.httpOptions);
  }
  getMieLeghe(idUtente: number): Observable<Lega[]> {
    return this.http.get<Lega[]>(`${this.API_URL}/mie-leghe/${idUtente}`, {
      withCredentials: true
    });
  }

  joinLega(codiceInvito: string, nomeSquadra: string, idUtente: number): Observable<string> {
    const body = {
      codiceInvito: codiceInvito,
      nomeSquadra: nomeSquadra,
      idUtente: idUtente
    };


    return this.http.post(
      `${this.API_URL}/join`,
      body,
      {
        withCredentials: true,
        responseType: 'text'
      }
    );
  }
  getLegheUtente(idUtente: number): Observable<LegaRiepilogo[]> {
    return this.http.get<LegaRiepilogo[]>(
      `${this.API_URL}/mie-leghe/${idUtente}`,
      this.httpOptions
    );
  }

  getSvincolati(idLega: number): Observable<any[]> {
    return this.http.get<any[]>(`http://localhost:8080/acquisti/svincolati/${idLega}`,
      this.httpOptions);

  }
  getSquadreByLega(idLega:number): Observable<any[]>{
    return this.http.get<any[]>(
      `${this.API_SQUADRA}/lega/${idLega}`,
      this.httpOptions);
  }
  acquistaGiocatore(payload: any): Observable<any>{
      return this.http.post(
        'http://localhost:8080/acquisti',
        payload,
        this.httpOptions);
  }

  getGiocatoriSquadra(idFantaSquadra: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.API_ACQUISTI}/rosa/${idFantaSquadra}`, this.httpOptions);
  }

  annullaAcquistoAdmin(idAcquisto: number,isSvincolo:boolean): Observable<string> {
    return this.http.delete(`${this.API_ACQUISTI}/${idAcquisto}?svincolo=${isSvincolo}`, {
      ...this.httpOptions,
      responseType: 'text'
    });
  }

  getFormazioniSchierate(idLega: number): Observable<any[]> {

    return this.http.get<any[]>(
      `${this.API_URL}/${idLega}/formazioni-schierate`,
      this.httpOptions
    );
  }

  checkAdminStatus(idLega: number): Observable<boolean> {

    return this.http.get<boolean>(`${this.API_URL}/${idLega}/is-admin`, { withCredentials: true });
  }

  getInfoLega(idLega: number): Observable<any> {
    return this.http.get<any>(`${this.API_URL}/pagina-principale-info/${idLega}`, { withCredentials: true });
  }
  aggiornaCreditiVisualizzati(nuoviCrediti: number) {
    this.creditiSubject.next(nuoviCrediti);
  }
}
