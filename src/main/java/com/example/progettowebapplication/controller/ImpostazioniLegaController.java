package com.example.progettowebapplication.controller;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.dao.IImpostazioniLegaDAO;
import com.example.progettowebapplication.model.FantasquadraDTO;
import com.example.progettowebapplication.model.ImpostazioniLegaDTO;
import com.example.progettowebapplication.model.UtenteDTO;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/impostazioni")
@CrossOrigin(origins = "http://localhost:4200", allowCredentials = "true")
public class ImpostazioniLegaController {

    private IImpostazioniLegaDAO getDao() {
        return DbManager.getInstance().getImpostazioniLegaDao();
    }

    //Recupera l'utente loggato
    private UtenteDTO getUtenteLoggato() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getName())) {
            return null;
        }
        return DbManager.getInstance().getUtenteDao().getUtenteByEmail(auth.getName());
    }

    // Verifica se l'utente loggato è l'ADMIN della lega
    // Controlla la tabella Fantasquadra per vedere se questo utente ha isAdmin=true in quella lega
    private boolean isUserAdminDiLega(Long idLega, UtenteDTO utenteLoggato) {
        // Cerca la squadra di questo utente in questa lega
        FantasquadraDTO squadra = DbManager.getInstance().getFantasquadraDao().getByUtenteAndLega(utenteLoggato.getId(), idLega);
        // Se non ha una squadra, o se ha una squadra ma non è admin -> false
        if (squadra == null) return false;
        return squadra.isAdmin();
    }

    // Salva nuove impostazioni (chiamato subito dopo la creazione lega)
    // POST http://localhost:8080/impostazioni
    @PostMapping("")
    public ResponseEntity<?> createImpostazioni(@RequestBody ImpostazioniLegaDTO imp) {
        // Sicurezza
        UtenteDTO utente = getUtenteLoggato();
        if (utente == null || !isUserAdminDiLega(imp.getIdLega(), utente)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Solo l'Admin della lega può creare le impostazioni.");
        }
        // Verifica se le impostazioni esistono già per questa lega
        if (getDao().getByIdLega(imp.getIdLega()) != null) {
            return ResponseEntity.badRequest().body("Le impostazioni per questa lega esistono già. Usa la modifica.");
        }

        // Controlla i dati prima di inserire
        String erroreValidazione = validaParametri(imp);
        if (erroreValidazione != null) {
            return ResponseEntity.badRequest().body(erroreValidazione);
        }
        ImpostazioniLegaDTO create = getDao().insertImpostazioni(imp);
        return ResponseEntity.ok(create);
    }

    // Legge le impostazioni di una determinata lega (in questo caso la lega con id = 5)
    // GET http://localhost:8080/impostazioni/lega/5
    @GetMapping("/lega/{idLega}")
    public ResponseEntity<ImpostazioniLegaDTO> getByIdLega(@PathVariable Long idLega) {
        ImpostazioniLegaDTO imp = getDao().getByIdLega(idLega);
        if (imp == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(imp);
    }

    // Aggiorna le impostazioni di una determinata lega in questo caso la lega con id = 1)
    // PUT http://localhost:8080/impostazioni/1
    @PutMapping("/{id}")
    public ResponseEntity<?> updateImpostazioni(@PathVariable Long id, @RequestBody ImpostazioniLegaDTO imp) {
        // Verifica se esistono le impostazioni
        ImpostazioniLegaDTO esistente = getDao().getById(id);
        if (esistente == null) return ResponseEntity.notFound().build();

        // Sicurezza
        UtenteDTO utente = getUtenteLoggato();
        // Controlla se l'utente è admin della lega associata a queste impostazioni
        if (utente == null || !isUserAdminDiLega(esistente.getIdLega(), utente)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Non sei l'admin di questa lega!");
        }

        // Controlla i dati prima di aggiornare
        String erroreValidazione = validaParametri(imp);
        if (erroreValidazione != null) {
            return ResponseEntity.badRequest().body(erroreValidazione);
        }

        // Assicura che l'id e l'id lega siano corretti
        imp.setId(id);
        imp.setIdLega(esistente.getIdLega());
        ImpostazioniLegaDTO aggiornato = getDao().updateImpostazioni(imp);
        return ResponseEntity.ok(aggiornato);
    }

    // Per settare velocemente l'apertura / chiusura del mercato
    // PATCH http://localhost:8080/impostazioni/mercato/5?aperto=false
    @PatchMapping("/mercato/{idLega}")
    public ResponseEntity<String> cambioStatoMercato(@PathVariable Long idLega, @RequestParam boolean aperto) {
        // Sicurezza
        UtenteDTO utente = getUtenteLoggato();
        if (utente == null || !isUserAdminDiLega(idLega, utente)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Solo l'admin può aprire/chiudere il mercato.");
        }

        // Verifica veloce se la lega esiste
        if (getDao().getByIdLega(idLega) == null) {
            return ResponseEntity.notFound().build();
        }
        getDao().setStatoMercato(idLega, aperto);
        String stato = aperto ? "APERTO" : "CHIUSO";
        return ResponseEntity.ok("Il mercato della lega " + idLega + " è ora " + stato);
    }

    // Per resettare le impostazioni della lega (in questo caso con id = 5) --> valori di default
    // POST http://localhost:8080/impostazioni/reset/5
    @PostMapping("/reset/{idLega}")
    public ResponseEntity<String> resetSettings(@PathVariable Long idLega) {
        // Sicurezza
        UtenteDTO utente = getUtenteLoggato();
        if (utente == null || !isUserAdminDiLega(idLega, utente)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Solo l'admin può resettare le impostazioni.");
        }
        getDao().resetToDefault(idLega);
        return ResponseEntity.ok("Impostazioni ripristinate ai valori ufficiali.");
    }

    private String validaParametri(ImpostazioniLegaDTO imp) {
        // Controlli generali
        if (imp.getBudgetIniziale() <= 0) {
            return "Errore: Il budget iniziale deve essere maggiore di 0.";
        }
        if (imp.getMaxCalciatori() <= 0) {
            return "Errore: Il numero massimo di calciatori deve essere maggiore di 0.";
        }
        // Controllo fasce gol
        if (imp.getStepFascia() <= 0) {
            return "Errore: Lo step fascia deve essere maggiore di 0.";
        }
        if (imp.getSogliaGol() < 0) {
            return "Errore: La soglia gol deve essere un valore maggiore o uguale a 0.";
        }
        // Controllo bonus (devono essere > 0)
        if (imp.getBonusGol() <= 0 || imp.getBonusAssist() <= 0 || imp.getBonusRigoreParato() <= 0) {
            return "Errore: I bonus (Gol, Assist, Rigore Parato) devono essere valori positivi.";
        }
        // Controllo malus (devono essere < 0)
        if (imp.getMalusAmmonizione() >= 0 || imp.getMalusEspulsione() >= 0 ||
                imp.getMalusGolSubito() >= 0 || imp.getMalusAutogol() >= 0 ||
                imp.getMalusRigoreSbagliato() >= 0) {
            return "Errore: I malus (Ammonizione, Espulsione, ecc.) devono essere valori negativi.";
        }
        return null;
    }
}