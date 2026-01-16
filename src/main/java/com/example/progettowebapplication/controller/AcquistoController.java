package com.example.progettowebapplication.controller;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.dao.IFantasquadraDAO;
import com.example.progettowebapplication.model.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/acquisti")
public class AcquistoController {

    // Registra un acquisto
    // POST http://localhost:8080/acquisti
    // Body: { "idFantasquadra": 1, "idCalciatore": 100, "prezzoAcquisto": 10, "idLega": 5 }
    @PostMapping("")
    public ResponseEntity<?> acquistaGiocatore(@RequestBody AcquistoDTO acquisto) {
        // Validazione dati in ingresso
        if (acquisto.getIdFantasquadra() == null || acquisto.getIdCalciatore() == null) {
            return ResponseEntity.badRequest().body("Errore: ID Fantasquadra e ID Calciatore sono obbligatori.");
        }
        if (acquisto.getPrezzoAcquisto() <= 0) {
            return ResponseEntity.badRequest().body("Errore: Il prezzo deve essere maggiore di 0.");
        }
        // Recupero dati squadra (per controllo budget e lega se mancante)
        IFantasquadraDAO fantaDao = DbManager.getInstance().getFantasquadraDao();
        FantasquadraDTO squadraDestinazione = fantaDao.getFantasquadraById(acquisto.getIdFantasquadra());
        if (squadraDestinazione == null) {
            return ResponseEntity.badRequest().body("Errore: Fantasquadra di destinazione non trovata.");
        }
        // Recupero utente loggato
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || auth.getName().equals("anonymousUser")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Devi essere loggato per effettuare acquisti.");
        }
        UtenteDTO utenteLoggato = DbManager.getInstance().getUtenteDao().getUtenteByEmail(auth.getName());
        // Cerca quale squadra possiede l'utente loggato nella lega della squadra di destinazione
        FantasquadraDTO squadraUtenteLoggato = fantaDao.getByUtenteAndLega(utenteLoggato.getId(), squadraDestinazione.getIdLega());
        // Se l'utente non partecipa a questa lega o la sua squadra non è admin
        if (squadraUtenteLoggato == null || !squadraUtenteLoggato.isAdmin()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Errore: Solo l'Admin della lega può registrare acquisti.");
        }
        // Controlla se il mercato è aperto per quella lega
        var impostazioni = DbManager.getInstance().getImpostazioniLegaDao().getByIdLega(squadraDestinazione.getIdLega());
        if (impostazioni != null && !impostazioni.isMercatoScambiAperto()) {
            return ResponseEntity.badRequest().body("Il mercato per questa lega è CHIUSO.");
        }
        // Controllo disponibilità giocatore
        boolean occupato = DbManager.getInstance().getAcquistoDao()
                .isCalciatoreGiaAcquistatoInLega(acquisto.getIdCalciatore(), squadraDestinazione.getIdLega());
        if (occupato) {
            return ResponseEntity.badRequest().body("Errore: Giocatore già acquistato in questa lega!");
        }
        // Controllo budget (della squadra che compra)
        if (squadraDestinazione.getCreditiResidui() < acquisto.getPrezzoAcquisto()) {
            return ResponseEntity.badRequest().body("Errore: Crediti insufficienti! La squadra ha " + squadraDestinazione.getCreditiResidui() + " crediti, ma ne servono " + acquisto.getPrezzoAcquisto());
        }
        // Controllo spazio rosa (max 25 giocatori)
        int numeroGiocatori = fantaDao.RosaAlCompleto(squadraDestinazione.getIdFantasquadra());
        if (numeroGiocatori >= 25) {
            return ResponseEntity.badRequest().body("Errore: Rosa completa (max 25 giocatori).");
        }
        // Esecuzione acquisto sul database
        try {
            // Imposta la data attuale
            acquisto.setDataAcquisto(LocalDateTime.now());
            // Forza l'id lega corretto nel DTO
            acquisto.setIdLega(squadraDestinazione.getIdLega());
            // Inserimento acquisto
            AcquistoDTO creato = DbManager.getInstance().getAcquistoDao().insertAcquisto(acquisto);
            // Scala i crediti alla squadra destinataria
            int nuoviCrediti = squadraDestinazione.getCreditiResidui() - acquisto.getPrezzoAcquisto();
            fantaDao.updateCrediti(squadraDestinazione.getIdFantasquadra(), nuoviCrediti);
            return ResponseEntity.ok(creato);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Errore durante l'acquisto: " + e.getMessage());
        }
    }

    // Legge la rosa di una squadra
    // GET http://localhost:8080/acquisti/rosa/1
    @GetMapping("/rosa/{idFantaSquadra}")
    public List<GiocatoreRosaDTO> getRosa(@PathVariable Long idFantaSquadra) {
        return DbManager.getInstance().getAcquistoDao().getRosaByFantaSquadra(idFantaSquadra);
    }
    // Annullamento/svincolo giocatore
    // DELETE http://localhost:8080/acquisti/10?svincolo=true
    @DeleteMapping("/{id}")
    public ResponseEntity<String> svincolaGiocatore(
            @PathVariable Long id,
            @RequestParam(defaultValue = "false") boolean svincolo) {

        //  Recupera l'acquisto
        AcquistoDTO acquisto = DbManager.getInstance().getAcquistoDao().getAcquistoById(id);
        if (acquisto == null) {
            return ResponseEntity.notFound().build();
        }
        // Recupera la squadra proprietaria
        IFantasquadraDAO fantaDao = DbManager.getInstance().getFantasquadraDao();
        FantasquadraDTO squadraProprietaria = fantaDao.getFantasquadraById(acquisto.getIdFantasquadra()); //
        if (squadraProprietaria == null) {
            return ResponseEntity.badRequest().body("Squadra non trovata");
        }
        // Recupera chi fa la richiesta (Admin o Proprietario)
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String emailLoggato = auth.getName(); //
        UtenteDTO utenteLoggato = DbManager.getInstance().getUtenteDao().getUtenteByEmail(emailLoggato);
        // Recupera la squadra dell'utente loggato in questa lega (per verificare se è Admin)
        FantasquadraDTO squadraUtenteLoggato = fantaDao.getByUtenteAndLega(utenteLoggato.getId(), squadraProprietaria.getIdLega()); //
        // Controllo permessi
        boolean isProprietario = squadraProprietaria.getIdUtente().equals(utenteLoggato.getId());
        boolean isAdmin = (squadraUtenteLoggato != null && squadraUtenteLoggato.isAdmin()); //
        // Se non sei né il proprietario né l'admin, blocco.
        if (!isProprietario && !isAdmin) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Non hai i permessi per svincolare questo giocatore!");
        }

        // Calcolo rimborso
        int rimborso;
        String messaggioOperazione;

        if (svincolo) {
            // Caso svincolo volontario: rimborso 50%
            rimborso = acquisto.getPrezzoAcquisto() / 2;
            messaggioOperazione = "Svincolo (50%)";
        } else {
            // Caso annullamento errore: rimborso 100%
            rimborso = acquisto.getPrezzoAcquisto();
            messaggioOperazione = "Annullamento (100%)";
        }

        // Aggiorna i crediti della squadra
        int creditiAggiornati = squadraProprietaria.getCreditiResidui() + rimborso;
        fantaDao.updateCrediti(squadraProprietaria.getIdFantasquadra(), creditiAggiornati); //

        // Cancella l'acquisto dal DB
        DbManager.getInstance().getAcquistoDao().deleteAcquisto(id); //

        return ResponseEntity.ok(messaggioOperazione + " effettuato con successo. Rimborsati " + rimborso + " crediti.");
    }
    @GetMapping("/svincolati/{idLega}")
    public List<CalciatoreDTO> getSvincolati(@PathVariable Long idLega) {
        return DbManager.getInstance().getAcquistoDao().getCalciatoriSvincolati(idLega);
    }

    // Restituisce l'acquisto (e quindi la squadra proprietaria) di un giocatore in una specifica lega
    // GET http://localhost:8080/acquisti/proprietario/calciatore/100/lega/5
    @GetMapping("/proprietario/calciatore/{idCalciatore}/lega/{idLega}")
    public ResponseEntity<?> getAcquistoByCalciatore( @PathVariable Long idCalciatore, @PathVariable Long idLega) {
        AcquistoDTO acquisto = DbManager.getInstance().getAcquistoDao().getAcquistoByCalciatore(idCalciatore, idLega);
        if (acquisto == null) {
            // Se nessuno lo ha comprato
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(acquisto);
    }
}