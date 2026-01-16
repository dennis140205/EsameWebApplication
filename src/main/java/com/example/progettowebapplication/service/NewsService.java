package com.example.progettowebapplication.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import java.util.Collections;

@Service
public class NewsService {
    private final String API_KEY = "330a9420bb2a4335d458e336604010d0";
    private final String BASE_URL = "https://gnews.io/api/v4/top-headlines?country=it&category=sports&q=calcio+Serie+A&apikey=";

    private String cachedNews = null;
    private long lastFetchNews = 0;
    private final long CACHE_DURATION = 3600000;

    public String getLatestNews() {
        // Verifica se abbiamo dati recenti in memoria
        if (isCacheValid() && cachedNews != null) {
            System.out.println("Restituisco NEWS dalla CACHE (Risparmio chiamate API)");
            return cachedNews;
        }

        // Se la cache è scaduta effettua la chiamata a GNews
        System.out.println("Chiamo GNews API per aggiornare le notizie...");
        String response = callApi(BASE_URL + API_KEY);

        // Salva il risultato per le prossime richieste
        if (response != null) {
            cachedNews = response;
            lastFetchNews = System.currentTimeMillis();
        }
        return cachedNews;
    }
    private boolean isCacheValid() {
        long currentTime = System.currentTimeMillis();
        return (currentTime - lastFetchNews) < CACHE_DURATION;
    }

    private String callApi(String url) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            // GNews restituisce un JSON strutturato con un array di 'articles'
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                return response.getBody();
            } else {
                System.err.println("Errore GNews: " + response.getStatusCode());
                return null;
            }
        } catch (Exception e) {
            System.err.println("Errore durante la chiamata a GNews: " + e.getMessage());
            return null;
        }
    }
}
