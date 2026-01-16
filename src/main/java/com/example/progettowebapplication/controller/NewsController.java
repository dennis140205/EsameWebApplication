package com.example.progettowebapplication.controller;
import com.example.progettowebapplication.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/news")
@CrossOrigin(origins = "http://localhost:4200")
public class NewsController {
    @Autowired
    private NewsService newsService;

    @GetMapping("/latest") //Endpoint per recuperare le ultime notizie sportive.
    public ResponseEntity<String> getLatestNews() {
        String jsonResponse = newsService.getLatestNews();
        if (jsonResponse != null) {
            // Restituisce 200 OK con il corpo JSON delle notizie
            return ResponseEntity.ok(jsonResponse);
        } else {
            // Restituisce 503 Service Unavailable se l'API esterna fallisce o la cache è vuota
            return ResponseEntity.status(503).body("{\"error\": \"Impossibile recuperare le news da GNews al momento.\"}");
        }
    }

}
