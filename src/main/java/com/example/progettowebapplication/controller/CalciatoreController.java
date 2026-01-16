package com.example.progettowebapplication.controller;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.model.CalciatoreDTO;
import com.example.progettowebapplication.model.StatisticaDTO;
import com.example.progettowebapplication.service.CalciatoreExternalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/calciatori")
@CrossOrigin(origins = "http://localhost:4200")
public class CalciatoreController {

    // Collega il Service per gestire la logica complessa (importazione, calcoli, API esterne)
    @Autowired
    private CalciatoreExternalService externalService;

    // URL: GET http://localhost:8080/calciatori
    // Restituisce la lista completa di tutti i calciatori nel DB
    @GetMapping("")
    public List<CalciatoreDTO> getAll() {
        return DbManager.getInstance().getCalciatoreDao().getAllCalciatori();
    }

    // URL: GET http://localhost:8080/calciatori/ruolo/A
    // Restituisce solo i giocatori di un certo ruolo (P, D, C, A)
    @GetMapping("/ruolo/{ruolo}")
    public List<CalciatoreDTO> getByRuolo(@PathVariable String ruolo) {
        return DbManager.getInstance().getCalciatoreDao().getCalciatoriByRuolo(ruolo);
    }

    // URL: GET http://localhost:8080/calciatori/1
    // Restituisce i dettagli di un singolo giocatore tramite il suo ID
    @GetMapping("/{id}")
    public CalciatoreDTO getById(@PathVariable Long id) {
        return DbManager.getInstance().getCalciatoreDao().getCalciatoreById(id);
    }

    // Popolamento iniziale
    // URL: POST http://localhost:8080/calciatori/import
    // Legge il file CSV interno al progetto (listone) e riempie il database
    @PostMapping("/import")
    public ResponseEntity<String> importListone() {
        String risultato = externalService.importListoneCsv();
        return ResponseEntity.ok(risultato);
    }

    // Gestione stati
    // URL: POST http://localhost:8080/calciatori/upload-stati
    // L'admin carica un file CSV. Il sistema resetta tutti a DISPONIBILE e segna gli stati dei calciatori del file
    @PostMapping("/upload-stati")
    public ResponseEntity<String> uploadStati(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) return ResponseEntity.badRequest().body("File vuoto!");
        String risultato = externalService.aggiornaStatiDaCsv(file);
        return ResponseEntity.ok(risultato);
    }

    // Gestione voti
    // URL: POST http://localhost:8080/calciatori/upload-voti
    // L'admin carica il CSV voti. Il sistema salva i voti grezzi e le statistiche (gol, assist, ecc.) per i calcoli futuri
    @PostMapping("/upload-voti")
    public ResponseEntity<String> uploadVoti(@RequestParam("file") MultipartFile file,@RequestParam("giornata") int giornata) {
        if (file.isEmpty()) return ResponseEntity.badRequest().body("File vuoto!");
        if (giornata < 1 || giornata > 38) return ResponseEntity.badRequest().body("Giornata non valida!");
        String risultato = externalService.caricaVotiDaCsv(file,giornata);
        return ResponseEntity.ok(risultato);
    }

    // Download foto calciatori (link delle immagini)
    // URL: POST http://localhost:8080/calciatori/sync-images
    // Si collega all'API esterna, scarica le foto dei giocatori e salva l'URL nel DB
    @PostMapping("/sync-images")
    public ResponseEntity<String> syncImages() {
        String risultato = externalService.syncImmagini();
        return ResponseEntity.ok(risultato);
    }

    // URL: GET http://localhost:8080/calciatori/10/statistiche
    // Restituisce tutti i voti presi dal giocatore con ID 10 (l'ultimo della lista è il più recente)
    @GetMapping("/{id}/statistiche")
    public List<StatisticaDTO> getStatisticheCalciatore(@PathVariable Long id) {
        return DbManager.getInstance().getCalciatoreDao().getStatisticheByCalciatore(id);
    }

    // URL: GET http://localhost:8080/calciatori/giornata/3/voti
    // Restituisce tutti i voti della 3ª giornata (utile per calcoli di lega)
    @GetMapping("/giornata/{giornata}/voti")
    public List<StatisticaDTO> getVotiGiornata(@PathVariable int giornata) {
        return DbManager.getInstance().getCalciatoreDao().getStatisticheByGiornata(giornata);
    }

    // Esempio utilizzo del proxy
    // GET http://localhost:8080/calciatori/proxy-test/10
    @GetMapping("/proxy-test/{id}")
    public ResponseEntity<?> testCalciatoreProxy(@PathVariable Long id) {
        // Carica il calciatore (proxy)
        CalciatoreDTO c = DbManager.getInstance().getCalciatoreDao().getCalciatoreById(id);
        if (c == null) return ResponseEntity.notFound().build();
        List<StatisticaDTO> stats = c.getStatistiche();
        return ResponseEntity.ok(stats);
    }
}