package com.example.progettowebapplication.controller;
import com.example.progettowebapplication.service.FootballDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.OffsetDateTime;
import java.util.Map;


@RestController
@RequestMapping("/api/stats")
@CrossOrigin(origins = "http://localhost:4200")
public class StatsController {
    @Autowired
    private FootballDataService footballDataService;

    @GetMapping("/classifica")
    public ResponseEntity<String> getClassifica() {
        String jsonResponse = footballDataService.getClassifica();
        if (jsonResponse != null) {
            // Restituisce 200 OK con il corpo JSON
            return ResponseEntity.ok(jsonResponse);
        } else {
            // Restituisce 503 Service Unavailable se qualcosa va storto
            return ResponseEntity.status(503).body("{\"error\": \"Impossibile recuperare la classifica al momento.\"}");
        }
    }

    @GetMapping("/marcatori")
    public ResponseEntity<String> getMarcatori() {
        String jsonResponse = footballDataService.getMarcatori();
        if (jsonResponse != null) {
            return ResponseEntity.ok(jsonResponse);
        } else {
            return ResponseEntity.status(503).body("{\"error\": \"Impossibile recuperare i marcatori al momento.\"}");
        }
    }

    @GetMapping("/info-competizione")
    public ResponseEntity<String> getInfo() {
        String jsonResponse = footballDataService.getInformazioniCompetizione();
        if (jsonResponse != null) {
            return ResponseEntity.ok(jsonResponse);
        } else {
            return ResponseEntity.status(503).body("{\"error\": \"Errore info competizione\"}");
        }
    }

    @GetMapping("/calendario-completo")
    public ResponseEntity<String> getCalendarioCompleto() {
        String jsonResponse = footballDataService.getCalendario();
        if (jsonResponse != null) {
            return ResponseEntity.ok(jsonResponse);
        } else {
            return ResponseEntity.status(503).body("{\"error\": \"Impossibile recuperare il calendario completo.\"}");
        }
    }

    @GetMapping("/deadline")
    public ResponseEntity<?> getDeadline() {
        String deadlineStr = footballDataService.getDeadlineProssimaGiornata();
        if (deadlineStr != null) {
            OffsetDateTime deadline = OffsetDateTime.parse(deadlineStr);
            boolean isLive = OffsetDateTime.now().isAfter(deadline);
            // Restituisce un oggetto JSON con tutte le info per il frontend
            return ResponseEntity.ok(Map.of(
                    "deadline", deadlineStr,
                    "isLive", isLive,
                    "messaggio", isLive ? "SERIE A LIVE" : "TEMPO RIMANENTE"
            ));
        } else {
            return ResponseEntity.status(503).body(Map.of("error", "Dati deadline non disponibili"));
        }
    }

    @GetMapping("/giornata-attuale")
    public ResponseEntity<Integer> getGiornataAttuale() {
        int giornata = footballDataService.getCurrentMatchday();
        return ResponseEntity.ok(giornata);
    }
}
