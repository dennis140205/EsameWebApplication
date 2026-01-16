package com.example.progettowebapplication.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import java.util.Collections;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.time.OffsetDateTime;
// api esterna football-data per statistiche
@Service
public class FootballDataService {
    private final String API_KEY = "089fb6aa02e340f2b8b4f573b89bb16d";
    private final String BASE_URL = "https://api.football-data.org/v4/competitions/SA";

    // Salva i dati in memoria per non consumare tutte le chiamate API (limite 10/minuto)
    private String cachedClassifica = null;
    private String cachedMarcatori = null;
    private String cachedCompetizione = null;
    private String cachedCalendario = null;

    private long lastFetchClassifica = 0;
    private long lastFetchMarcatori = 0;
    private long lastFetchCompetizione = 0;
    private long lastFetchCalendario = 0;

    // Durata della cache: 1 ora (3600000 millisecondi)
    private final long CACHE_DURATION = 3600000;

    public String getInformazioniCompetizione() {
        if (isCacheValid(lastFetchCompetizione) && cachedCompetizione != null) {
            return cachedCompetizione;
        }
        String response = callApi(BASE_URL);
        if (response != null) {
            cachedCompetizione = response;
            lastFetchCompetizione = System.currentTimeMillis();
        }
        return cachedCompetizione;
    }


    public String getCalendario() {
        if (isCacheValid(lastFetchCalendario) && cachedCalendario != null) {
            return cachedCalendario;
        }

        String url = BASE_URL + "/matches";


        String response = callApi(url);
        if (response != null) {
            cachedCalendario = response;
            lastFetchCalendario = System.currentTimeMillis();
        }
        return cachedCalendario;
    }


    public String getClassifica() {
        // "Ho dei dati salvati?" (cachedClassifica != null)
        // E ANCHE "Sono passati meno di 60 minuti?" (isCacheValid)
        if (isCacheValid(lastFetchClassifica) && cachedClassifica != null) {
            System.out.println("Restituisco Classifica dalla CACHE locale");
            return cachedClassifica;
        }

        // Se la cache è vecchia o vuota, chiama l'API esterna
        System.out.println("Chiamo API Esterna per la Classifica...");
        String url = BASE_URL + "/standings";
        String response = callApi(url);

        // Se la chiamata ha successo, aggiorna la cache
        if (response != null) {
            cachedClassifica = response;
            lastFetchClassifica = System.currentTimeMillis();
        }
        return cachedClassifica;
    }

    public String getMarcatori() {
        if (isCacheValid(lastFetchMarcatori) && cachedMarcatori != null) {
            System.out.println("Restituisco Marcatori dalla CACHE locale");
            return cachedMarcatori;
        }

        System.out.println("Chiamo API Esterna per i Marcatori...");
        String url = BASE_URL + "/scorers?limit=10"; // Prendiamo i primi 10
        String response = callApi(url);

        if (response != null) {
            cachedMarcatori = response;
            lastFetchMarcatori = System.currentTimeMillis();
        }
        return cachedMarcatori;
    }
    // Controlla se è passata meno di un'ora dall'ultimo aggiornamento
    private boolean isCacheValid(long lastFetchTime) {
        long currentTime = System.currentTimeMillis();
        return (currentTime - lastFetchTime) < CACHE_DURATION;
    }



    public int getCurrentMatchday() {
        try {
            String infoJson = getInformazioniCompetizione();
            if (infoJson == null) return 1; // Fallback alla prima giornata

            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(infoJson);

            // Estrae currentMatchday dal percorso: currentSeason -> currentMatchday
            return root.get("currentSeason").get("currentMatchday").asInt();
        } catch (Exception e) {
            System.err.println("Errore nel recupero matchday: " + e.getMessage());
            return 1;
        }
    }

    //Metodo per calcolare la data di inizio della prossima giornata di partita e mettere un timer nel front-end
    public String getDeadlineProssimaGiornata() {
        try {
            String calendarioJson = getCalendario();
            if (calendarioJson == null) return null;

            ObjectMapper mapper = new ObjectMapper();
            JsonNode matches = mapper.readTree(calendarioJson).get("matches");

            OffsetDateTime now = OffsetDateTime.now();
            OffsetDateTime nextDeadline = null;

            for (JsonNode match : matches) {
                OffsetDateTime matchTime = OffsetDateTime.parse(match.get("utcDate").asText());

                // Cerca la prima partita che avverrà nel futuro rispetto ad adesso
                if (matchTime.isAfter(now)) {
                    if (nextDeadline == null || matchTime.isBefore(nextDeadline)) {
                        nextDeadline = matchTime;
                    }
                }
            }
            return nextDeadline != null ? nextDeadline.toString() : null;
        } catch (Exception e) {
            return null;
        }
    }
    // Metodo generico per fare la chiamata HTTP con l'Header corretto
    private String callApi(String url) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();

            // Imposta il Token nell'header
            headers.set("X-Auth-Token", API_KEY);
            headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

            HttpEntity<String> entity = new HttpEntity<>(headers);

            // Esegue la chiamata GET
            ResponseEntity<String> response = restTemplate.exchange(
                    url, HttpMethod.GET, entity, String.class
            );

            if (response.getStatusCode() == HttpStatus.OK) {
                return response.getBody(); // Ritorna il JSON grezzo
            } else {
                System.err.println("Errore API: " + response.getStatusCode());
                return null;
            }

        } catch (Exception e) {
            System.err.println("Eccezione durante chiamata API: " + e.getMessage());
            return null;
        }
    }
}
