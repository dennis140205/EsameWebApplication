package com.example.progettowebapplication.controller;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.model.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/formazione")
@CrossOrigin(origins = "http://localhost:4200")
public class FormazioneController {

    // Limiti massimi per ruolo (titolari + panchinari)
    private static final int MAX_PORTIERI = 3;
    private static final int MAX_DIFENSORI = 6;
    private static final int MAX_CENTROCAMPISTI = 7;
    private static final int MAX_ATTACCANTI = 6;

    // Per ottenere l'utente loggato
    private UtenteDTO getUtenteLoggato() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) return null;
        return DbManager.getInstance().getUtenteDao().getUtenteByEmail(auth.getName());
    }

    // Controlla che il modulo sia coerente con quello scelto dall'utente
    private String controllaCoerenzaModulo(FormazioneDTO f) {
        // Parsa la stringa del modulo (es. "3-4-3")
        String[] parti = f.getModulo().split("-");
        if (parti.length != 3) return "Modulo non valido (formato atteso D-C-A, es. 3-4-3)";

        int difensoriAttesi = Integer.parseInt(parti[0]);
        int centrocampistiAttesi = Integer.parseInt(parti[1]);
        int attaccantiAttesi = Integer.parseInt(parti[2]);

        // Conta i ruoli TITOLARI
        long difensoriReali = f.getCalciatori().stream().filter(c -> c.getStato() == StatoSchieramento.TITOLARE && c.getRuolo() == Ruolo.D).count();
        long centrocampistiReali = f.getCalciatori().stream().filter(c -> c.getStato() == StatoSchieramento.TITOLARE && c.getRuolo() == Ruolo.C).count();
        long attaccantiReali = f.getCalciatori().stream().filter(c -> c.getStato() == StatoSchieramento.TITOLARE && c.getRuolo() == Ruolo.A).count();

        // Verifica
        if (difensoriReali != difensoriAttesi)
            return "Il modulo dice " + difensoriAttesi + " difensori, ma ne hai schierati " + difensoriReali;
        if (centrocampistiReali != centrocampistiAttesi)
            return "Il modulo dice " + centrocampistiAttesi + " centrocampisti, ma ne hai schierati " + centrocampistiReali;
        if (attaccantiReali != attaccantiAttesi)
            return "Il modulo dice " + attaccantiAttesi + " attaccanti, ma ne hai schierati " + attaccantiReali;
        return null;
    }

    // Legge la formazione
    // GET http://localhost:8080/formazione/{idFantasquadra}/{giornata}
    @GetMapping("/{idFantasquadra}/{giornata}")
    public ResponseEntity<?> getFormazione(@PathVariable Long idFantasquadra, @PathVariable int giornata) {
        FormazioneDTO f = DbManager.getInstance().getFormazioneDao().getFormazione(idFantasquadra, giornata);
        if (f == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(f);
    }

    // Salva la formazione
    // POST http://localhost:8080/formazione
    @PostMapping("")
    public ResponseEntity<?> salvaFormazione(@RequestBody FormazioneDTO formazione) {
        try {
            // Controlla il proprietario
            FantasquadraDTO squadra = DbManager.getInstance().getFantasquadraDao().getFantasquadraById(formazione.getIdFantasquadra());
            UtenteDTO utente = getUtenteLoggato();
            if (squadra == null) return ResponseEntity.badRequest().body("Squadra non trovata");
            if (utente == null || !squadra.getIdUtente().equals(utente.getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Non puoi inserire la formazione per una squadra non tua!");
            }

            // Recupera la rosa
            List<CalciatoreDTO> rosaRealeList = DbManager.getInstance().getFantasquadraDao().getRosaFantasquadra(formazione.getIdFantasquadra());
            // Crea una mappa (id -> calciatore) per fare controlli veloci
            Map<Long, CalciatoreDTO> rosaMap = rosaRealeList.stream().collect(Collectors.toMap(CalciatoreDTO::getId, Function.identity()));
            // Contatori per verificare i limiti numerici
            int countP = 0, countD = 0, countC = 0, countA = 0;

            // Validazione
            for (SchieramentoDTO schieramento : formazione.getCalciatori()) {
                // Controlla se il giocatore è davvero della squadra
                CalciatoreDTO giocatoreReale = rosaMap.get(schieramento.getIdCalciatore());
                if (giocatoreReale == null) {
                    return ResponseEntity.badRequest().body("Errore: Il giocatore con ID " + schieramento.getIdCalciatore() + " non appartiene alla tua rosa!");
                }
                // Controlla se il ruolo dichiarato corrisponde a quello reale nel database
                if (giocatoreReale.getRuolo() != schieramento.getRuolo()) {
                    return ResponseEntity.badRequest().body("Errore: " + giocatoreReale.getNome() + " è un " + giocatoreReale.getRuolo() + ", non puoi schierarlo come " + schieramento.getRuolo());
                }
                // Incremento contatori ruoli reali
                switch (giocatoreReale.getRuolo()) {
                    case P -> countP++;
                    case D -> countD++;
                    case C -> countC++;
                    case A -> countA++;
                }
            }

            // Controlla limiti numerici per ruolo (titolari + panchina)
            if (countP > MAX_PORTIERI) return ResponseEntity.badRequest().body("Troppi Portieri! Max: " + MAX_PORTIERI);
            if (countD > MAX_DIFENSORI) return ResponseEntity.badRequest().body("Troppi Difensori! Max: " + MAX_DIFENSORI);
            if (countC > MAX_CENTROCAMPISTI) return ResponseEntity.badRequest().body("Troppi Centrocampisti! Max: " + MAX_CENTROCAMPISTI);
            if (countA > MAX_ATTACCANTI) return ResponseEntity.badRequest().body("Troppi Attaccanti! Max: " + MAX_ATTACCANTI);

            // Controlla se esistono 11 titolari
            long numeroTitolari = formazione.getCalciatori().stream().filter(c -> c.getStato() == StatoSchieramento.TITOLARE).count();
            if (numeroTitolari != 11) {
                return ResponseEntity.badRequest().body("Devi schierare esattamente 11 titolari.");
            }

            // Controlla il portiere
            long numeroPortieri = formazione.getCalciatori().stream().filter(c -> c.getStato() == StatoSchieramento.TITOLARE && c.getRuolo() == Ruolo.P).count();
            if (numeroPortieri != 1) {
                return ResponseEntity.badRequest().body("Devi schierare esattamente 1 portiere titolare.");
            }

            // Controlla il modulo
            String erroreModulo = controllaCoerenzaModulo(formazione);
            if (erroreModulo != null) {
                return ResponseEntity.badRequest().body(erroreModulo);
            }

            // Controlla che non ci siano giocatori duplicati
            long numeroGiocatoriUnici = formazione.getCalciatori().stream().map(SchieramentoDTO::getIdCalciatore).distinct().count();
            if (numeroGiocatoriUnici != formazione.getCalciatori().size()) {
                return ResponseEntity.badRequest().body("Errore: Hai inserito lo stesso giocatore più volte!");
            }

            // Verifica se la giornata è già stata calcolata (controllando il calendario)
            List<CalendarioDTO> partite = DbManager.getInstance().getCalendarioDao().getPartiteByLegaAndGiornata(squadra.getIdLega(), formazione.getGiornata());
            boolean giornataGiaCalcolata = partite.stream().anyMatch(CalendarioDTO::isGiocata);
            if (giornataGiaCalcolata) {
                return ResponseEntity.badRequest().body("Non puoi modificare la formazione: la giornata è già stata calcolata!");
            }

            DbManager.getInstance().getFormazioneDao().salvaFormazione(formazione);
            return ResponseEntity.ok("Formazione salvata con successo!");

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Errore salvataggio: " + e.getMessage());
        }
    }
}