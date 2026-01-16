package com.example.progettowebapplication.controller;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.model.ScambioDTO;
import com.example.progettowebapplication.model.StatoScambio;
import com.example.progettowebapplication.model.UtenteDTO;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/scambi")
@CrossOrigin(origins = "http://localhost:4200", allowCredentials = "true")
public class ScambioController {
    // Per ottenere l'utente loggato
    private UtenteDTO getUtenteLoggato() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        // Controlla che l'auth esista e non sia l'utente anonimo di Spring
        if (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) {
            return DbManager.getInstance().getUtenteDao().getUtenteByEmail(auth.getName());
        }
        return null;
    }

    // Proporre uno scambio
    // POST http://localhost:8080/scambi/proponi
    @PostMapping("/proponi")
    public ResponseEntity<?> proponiScambio(@RequestBody ScambioDTO scambio) {
        try {
            // Controlli base
            if (!isMercatoAperto(scambio.getIdFantasquadraProponente())) {
                return ResponseEntity.badRequest().body("Il mercato degli scambi è chiuso per questa lega.");
            }
            if (scambio.getIdFantasquadraProponente().equals(scambio.getIdFantasquadraRicevente())) {
                return ResponseEntity.badRequest().body("Non puoi scambiare con te stesso!");
            }

            // Il proponente deve essere il proprietario della squadra
            var squadraProponente = DbManager.getInstance().getFantasquadraDao().getFantasquadraById(scambio.getIdFantasquadraProponente());
            UtenteDTO utente = getUtenteLoggato();
            if (!squadraProponente.getIdUtente().equals(utente.getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Non puoi proporre scambi a nome di un'altra squadra!");
            }

            // Controlla se il proponente possiede davvero il giocatore che vuole cedere
            var acquistoProponente = DbManager.getInstance().getAcquistoDao().getAcquistoByCalciatore(scambio.getIdCalciatoreProposto(), getIdLegaFromSquadra(scambio.getIdFantasquadraProponente()));
            if (acquistoProponente == null || !acquistoProponente.getIdFantasquadra().equals(scambio.getIdFantasquadraProponente())) {
                return ResponseEntity.badRequest().body("Errore: Non possiedi il giocatore che stai offrendo!");
            }

            // Controlla se il ricevente possiede davvero il giocatore richiesto
            var acquistoRicevente = DbManager.getInstance().getAcquistoDao().getAcquistoByCalciatore(scambio.getIdCalciatoreRichiesto(), getIdLegaFromSquadra(scambio.getIdFantasquadraRicevente()));
            if (acquistoRicevente == null || !acquistoRicevente.getIdFantasquadra().equals(scambio.getIdFantasquadraRicevente())) {
                return ResponseEntity.badRequest().body("Errore: La squadra avversaria non possiede il giocatore richiesto!");
            }
            // Controllo crediti negativi
            if (scambio.getCreditiProponente() < 0 || scambio.getCreditiRicevente() < 0) {
                return ResponseEntity.badRequest().body("Non puoi inserire crediti negativi.");
            }
            // Controllo budget proponente
            if (squadraProponente.getCreditiResidui() < scambio.getCreditiProponente()) {
                return ResponseEntity.badRequest().body("Non hai abbastanza crediti per fare questa offerta!");
            }
            // Salvataggio
            DbManager.getInstance().getScambioDao().proponiScambio(scambio);
            return ResponseEntity.ok("Scambio proposto con successo!");
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Errore: " + e.getMessage());
        }
    }

    // Recupera tutti gli scambi di una lega
    // GET http://localhost:8080/scambi/lega/1
    @GetMapping("/lega/{idLega}")
    public ResponseEntity<?> getScambiDiLega(@PathVariable Long idLega) {
        try {
            UtenteDTO utente = getUtenteLoggato();

            // Se l'utente è null, abortiamo qui con un 401
            if (utente == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Sessione non valida.");
            }
            var miaSquadraInLega = DbManager.getInstance().getFantasquadraDao().getByUtenteAndLega(utente.getId(), idLega);
            if (miaSquadraInLega == null) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Non fai parte di questa lega.");
            }

            List<ScambioDTO> lista = DbManager.getInstance().getScambioDao().getScambiByLega(idLega);
            return ResponseEntity.ok(lista);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Errore interno: " + e.getMessage());
        }
    }

    // Vedere gli scambi della propria squadra (sia inviati che ricevuti)
    // GET http://localhost:8080/scambi/squadra/1
    @GetMapping("/squadra/{idFantasquadra}")
    public ResponseEntity<List<ScambioDTO>> getScambiSquadra(@PathVariable Long idFantasquadra) {
        List<ScambioDTO> lista = DbManager.getInstance().getScambioDao().getScambiBySquadra(idFantasquadra);
        return ResponseEntity.ok(lista);
    }

    // Accettare uno scambio
    // PUT http://localhost:8080/scambi/10/accetta
    @PutMapping("/{id}/accetta")
    public ResponseEntity<?> accettaScambio(@PathVariable Long id) {
        try {
            // Recupera lo scambio per vedere di che squadre si tratta
            ScambioDTO scambio = DbManager.getInstance().getScambioDao().getScambioById(id);
            if(scambio == null) return ResponseEntity.notFound().build();

            // Il ricevente deve essere il proprietario della squadra
            // Solo chi ha ricevuto la proposta può accettarla
            var squadraRicevente = DbManager.getInstance().getFantasquadraDao().getFantasquadraById(scambio.getIdFantasquadraRicevente());
            UtenteDTO utente = getUtenteLoggato();
            if (!squadraRicevente.getIdUtente().equals(utente.getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Non puoi accettare scambi destinati ad altri!");
            }

            if (!isMercatoAperto(scambio.getIdFantasquadraRicevente())) {
                return ResponseEntity.badRequest().body("Non puoi accettare: il mercato è CHIUSO.");
            }
            // Controlla budget ricevente
            // Se lo scambio prevede che il ricevente paghi dei crediti, controlla se li ha
            if (scambio.getCreditiRicevente() > 0) {
                if (squadraRicevente.getCreditiResidui() < scambio.getCreditiRicevente()) {
                    return ResponseEntity.badRequest().body("Non hai abbastanza crediti per accettare questo scambio!");
                }
            }
            // Passa l'enum ACCETTATO -> Il DAO farà partire la transazione
            DbManager.getInstance().getScambioDao().gestisciScambio(id, StatoScambio.ACCETTATO);
            return ResponseEntity.ok("Scambio accettato e concluso. I giocatori sono stati trasferiti.");
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Errore nello scambio: " + e.getMessage());
        }
    }

    // Rifiutare uno scambio
    // PUT http://localhost:8080/scambi/10/rifiuta
    @PutMapping("/{id}/rifiuta")
    public ResponseEntity<?> rifiutaScambio(@PathVariable Long id) {
        try {
            ScambioDTO scambio = DbManager.getInstance().getScambioDao().getScambioById(id);
            if(scambio == null) return ResponseEntity.notFound().build();
            // Sicurezza: il ricevente deve essere il proprietario della squadra
            var squadraRicevente = DbManager.getInstance().getFantasquadraDao().getFantasquadraById(scambio.getIdFantasquadraRicevente());
            UtenteDTO utente = getUtenteLoggato();
            if (!squadraRicevente.getIdUtente().equals(utente.getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Non puoi rifiutare scambi destinati ad altri!");
            }
            // Passa l'enum RIFIUTATO -> Il DAO aggiornerà solo lo stato
            DbManager.getInstance().getScambioDao().gestisciScambio(id, StatoScambio.RIFIUTATO);
            return ResponseEntity.ok("Scambio rifiutato.");
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Errore: " + e.getMessage());
        }
    }

    // Cancellare uno scambio
    // DELETE http://localhost:8080/scambi/10
    @DeleteMapping("/{id}")
    public ResponseEntity<?> annullaScambio(@PathVariable Long id) {
        try {
            ScambioDTO scambio = DbManager.getInstance().getScambioDao().getScambioById(id);
            if(scambio == null) return ResponseEntity.notFound().build();
            // Sicurezza: il proponente deve essere il proprietario della squadra
            // Solo chi ha fatto la proposta può annullarla
            var squadraProponente = DbManager.getInstance().getFantasquadraDao().getFantasquadraById(scambio.getIdFantasquadraProponente());
            UtenteDTO utente = getUtenteLoggato();
            if (!squadraProponente.getIdUtente().equals(utente.getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Non puoi annullare scambi altrui!");
            }
            DbManager.getInstance().getScambioDao().annullaScambio(id);
            return ResponseEntity.ok("Proposta di scambio annullata.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Per vedere se il mercato è aperto o no per gli scambi
    private boolean isMercatoAperto(Long idFantasquadra) {
        // Recupera la fantasquadra
        var squadra = DbManager.getInstance().getFantasquadraDao().getFantasquadraById(idFantasquadra);
        if (squadra == null) return false;
        //Recupera le impostazioni della lega
        var impostazioni = DbManager.getInstance().getImpostazioniLegaDao().getByIdLega(squadra.getIdLega());
        // Restituisce true se le impostazioni esistono e il mercato è aperto
        return impostazioni != null && impostazioni.isMercatoScambiAperto();
    }

    // Recupera l'id della lega dalla squadra
    private Long getIdLegaFromSquadra(Long idFantasquadra) {
        var sq = DbManager.getInstance().getFantasquadraDao().getFantasquadraById(idFantasquadra);
        return sq != null ? sq.getIdLega() : null;
    }

    @GetMapping("/notifiche/count/{id}")
    public ResponseEntity<Integer> getNotificheCount(@PathVariable Long id) {
        // Collega il controller al DAO tramite il DbManager
        int count = DbManager.getInstance().getScambioDao().countNotifichePerSquadra(id);
        return ResponseEntity.ok(count);
    }

    @PostMapping("/notifiche/reset/{id}")
    public ResponseEntity<?> resetNotifiche(@PathVariable Long id) {
        DbManager.getInstance().getScambioDao().resetNotifiche(id);
        return ResponseEntity.ok().build();
    }
}