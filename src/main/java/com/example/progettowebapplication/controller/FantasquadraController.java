package com.example.progettowebapplication.controller;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.model.CalciatoreDTO;
import com.example.progettowebapplication.model.FantasquadraDTO;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RequestMapping("/fantasquadra")
@RestController
@CrossOrigin(origins = "http://localhost:4200", allowCredentials = "true")

// responseEntity rappresenta l'impacchettamentoo della risposta e serve al frontend per capire se si tratta di un messaggio di errore o di un messaggio di successo
public class FantasquadraController {

    @PostMapping("/creaFantasquadra")
    public ResponseEntity<String> creaFantasquadra(@RequestBody FantasquadraDTO fantasquadra) {
        try {
            DbManager.getInstance().getFantasquadraDao().insertFantasquadrainDB(fantasquadra);
            return ResponseEntity.status(HttpStatus.CREATED).body("Fantasquadra creata con successo");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Errore durante la creazione della fantasquadra" + e.getMessage());
        }
    }

    @GetMapping("/{id}/rosa")
    public ResponseEntity<List<CalciatoreDTO>> getRosa(@PathVariable("id") Long id_Fantasquad) {
        try {
            List<CalciatoreDTO> lista = DbManager.getInstance().getFantasquadraDao().getRosaFantasquadra(id_Fantasquad);
            return ResponseEntity.ok(lista);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

    }

    @PutMapping("/{id}/crediti")
    public ResponseEntity<String> updateCrediti_rosa(@PathVariable("id") Long id_Fantasquad, @RequestParam int crediti) {
        try {
            DbManager.getInstance().getFantasquadraDao().updateCrediti(id_Fantasquad, crediti);
            return ResponseEntity.ok("Crediti aggiornati con successo a " + crediti);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Errore aggiornamento crediti");
        }
    }

    @GetMapping("/{id}/countGiocatori")
    public ResponseEntity<Integer> contaGiocatori(@PathVariable("id") Long id_Fantasquad) {
        try {
            int NumeroCalciatori = DbManager.getInstance().getFantasquadraDao().RosaAlCompleto(id_Fantasquad);
            return ResponseEntity.ok(NumeroCalciatori);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> eliminaFantasquadra(@PathVariable("id") Long id_Fantasquad) {
        try {
            DbManager.getInstance().getFantasquadraDao().deleteFantasquadra(id_Fantasquad);
            return ResponseEntity.ok("Fantasquadra eliminata con successo");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Errore durante l'eliminazione della fantasquadra");
        }
    }

    // Per mostrare il proxy
    // GET http://localhost:8080/fantasquadra/proxy-test/1
    @GetMapping("/proxy-test/{id}")
    public ResponseEntity<?> testProxyPattern(@PathVariable Long id) {
        // Carica la squadra dal DAO, viene restituito il proxy
        FantasquadraDTO squadra = DbManager.getInstance().getFantasquadraDao().getFantasquadraById(id);
        // Qui il proxy vede che è null e fa la query al database
        List<CalciatoreDTO> rosa = squadra.getRosa();
        return ResponseEntity.ok(rosa);
    }

    @GetMapping("/lega/{idLega}")
    public ResponseEntity<List<FantasquadraDTO>> getFantasquadreByLega(@PathVariable Long idLega) {
        try {
            // Chiama il DAO (Assicurati che questo metodo esista nel tuo DAO!)
            List<FantasquadraDTO> squadre = DbManager.getInstance().getFantasquadraDao().getByLega(idLega);
            return ResponseEntity.ok(squadre);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

    }

    @GetMapping("/mia-squadra/{idLega}")
    public ResponseEntity<FantasquadraDTO> getMiaSquadra(@PathVariable Long idLega) {
        try {
            // Recupera l'autenticazione da Spring Security
            org.springframework.security.core.Authentication auth =
                    org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();

            // Verifica che l'utente sia autenticato
            if (auth == null || !auth.isAuthenticated() || auth.getName().equals("anonymousUser")) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }

            // Otteniamo l'oggetto Utente usando l'email (che è il 'name' dell'autenticazione)
            com.example.progettowebapplication.model.UtenteDTO utente =
                    DbManager.getInstance().getUtenteDao().getUtenteByEmail(auth.getName());

            if (utente == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }

            // Cerca la squadra
            FantasquadraDTO squadra = DbManager.getInstance().getFantasquadraDao()
                    .getByUtenteAndLega(utente.getId(), idLega);

            if (squadra != null) {
                return ResponseEntity.ok(squadra);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
