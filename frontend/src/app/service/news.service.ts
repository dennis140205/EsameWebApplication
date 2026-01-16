import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { GNewsResponse } from '../model/news.model';

@Injectable({
  providedIn: 'root'
})
export class NewsService {
  private apiUrl = 'http://localhost:8080/api/news/latest';

  constructor(private http: HttpClient) {
  }

  getLatestNews(): Observable<GNewsResponse> {
    return this.http.get<GNewsResponse>(this.apiUrl);
  }
}
