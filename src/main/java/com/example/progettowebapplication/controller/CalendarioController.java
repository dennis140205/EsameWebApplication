package com.example.progettowebapplication.controller;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.model.FantasquadraDTO;
import com.example.progettowebapplication.model.CalendarioDTO;
import com.example.progettowebapplication.model.LegaDTO;
import com.example.progettowebapplication.model.UtenteDTO;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

@RestController
@RequestMapping("/calendario")
@CrossOrigin(origins = "http://localhost:4200", allowCredentials = "true")
public class CalendarioController {

    // Per recuperare l'utente loggato
    private UtenteDTO getUtenteLoggato() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) return null;
        return DbManager.getInstance().getUtenteDao().getUtenteByEmail(auth.getName());
    }

    // Genera il calendario per una lega
    // Esempio URL: POST http://localhost:8080/calendario/genera/1?giornataIniziale=3
    // giornataIniziale indica a quale giornata reale di Serie A corrisponde la prima giornata del fanta
    @PostMapping("/genera/{idLega}")
    public ResponseEntity<String> generaCalendario(@PathVariable Long idLega, @RequestParam(defaultValue = "1") int giornataIniziale) {
        try {
            // Controllo validità input giornataIniziale
            if (giornataIniziale < 1 || giornataIniziale > 38) {
                return ResponseEntity.badRequest().body("Errore: La giornata iniziale deve essere compresa tra 1 e 38.");
            }

            // Verifica utente loggato
            UtenteDTO utente = getUtenteLoggato();
            FantasquadraDTO adminSquadra = DbManager.getInstance().getFantasquadraDao().getByUtenteAndLega(utente.getId(), idLega);
            if (adminSquadra == null || !adminSquadra.isAdmin()) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Errore: Solo l'admin può generare il calendario.");
            }

            // Recupera i dati della lega per il controllo capienza
            LegaDTO lega = DbManager.getInstance().getLegaDao().getLegaById(idLega.intValue());
            if (lega == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Errore: Lega non trovata.");
            }

            // Controlla se esiste già un calendario
            List<CalendarioDTO> tuttoIlCalendario = DbManager.getInstance().getCalendarioDao().getCalendarioCompleto(idLega);
            if (!tuttoIlCalendario.isEmpty()) {
                return ResponseEntity.badRequest().body("Errore: Esiste già un calendario per questa lega. Devi eliminarlo prima di crearne uno nuovo.");
            }

            // Recupera tutte le squadre della lega
            List<FantasquadraDTO> squadre = DbManager.getInstance().getFantasquadraDao().getByLega(idLega);
            int numSquadre = squadre.size();

            // Controllo numero minimo
            if (numSquadre < 2) {
                return ResponseEntity.badRequest().body("Errore: Servono almeno 2 squadre per generare il calendario (attuali: " + numSquadre + ").");
            }
            if(numSquadre!=lega.getNumeroSquadre()){
                return ResponseEntity.badRequest().body(String.format("Errore:La lega non è ancora completa. Squadre iscritte: %d/%d. Attendi il riempimento di tutti gli slot.", lega.getSquadreIscritte().size(), lega.getNumeroSquadre()));
            }

            // Controllo numero dispari (Berger crasha se dispari)
            if (numSquadre % 2 != 0) {
                return ResponseEntity.badRequest().body("Errore: Il numero di squadre è dispari (" + numSquadre + "). Aggiungi un'altra squadra o una squadra 'Riposo' per pareggiare.");
            }

            // Controllo capienza massima impostata nella creazione lega
            if (numSquadre > lega.getNumeroSquadre()) {
                return ResponseEntity.badRequest().body("Errore: Numero squadre (" + numSquadre + ") superiore al limite impostato per questa lega (" + lega.getNumeroSquadre() + ").");
            }

            // Mischia le squadre casualmente
            Collections.shuffle(squadre);

            // Calcola quante giornate dura un singolo girone
            int giornatePerGirone = numSquadre - 1;

            int partiteGenerate = 0;

            // Ciclo di generazione per 38 giornate totali
            for (int fantaGiornata = 1; fantaGiornata <= 38; fantaGiornata++) {
                int realSerieAGiornata = giornataIniziale + fantaGiornata - 1;
                if (realSerieAGiornata > 38) {
                    break; // Campionato finito
                }
                int numeroCiclo = (fantaGiornata - 1) / giornatePerGirone;
                boolean isRitorno = (numeroCiclo % 2 != 0);
                int bergerIndex = (fantaGiornata - 1) % giornatePerGirone;

                // Algoritmo di Berger per gli accoppiamenti
                for (int j = 0; j < numSquadre / 2; j++) {
                    int casaIndex = (bergerIndex + j) % (numSquadre - 1);
                    int trasfIndex = (numSquadre - 1 - j + bergerIndex) % (numSquadre - 1);
                    if (j == 0) {
                        trasfIndex = numSquadre - 1;
                    }
                    FantasquadraDTO squadraCasa = squadre.get(casaIndex);
                    FantasquadraDTO squadraTrasf = squadre.get(trasfIndex);
                    // Alternanza per bilanciare casa/fuori
                    if (bergerIndex % 2 == 1 && j == 0) {
                        FantasquadraDTO temp = squadraCasa;
                        squadraCasa = squadraTrasf;
                        squadraTrasf = temp;
                    }

                    CalendarioDTO partita = new CalendarioDTO();
                    partita.setIdLega(idLega);
                    partita.setGiornata(realSerieAGiornata);
                    // Gestione girone di ritorno (inversione campi)
                    if (isRitorno) {
                        partita.setIdSquadraCasa(squadraTrasf.getIdFantasquadra());
                        partita.setIdSquadraTrasferta(squadraCasa.getIdFantasquadra());
                    } else {
                        partita.setIdSquadraCasa(squadraCasa.getIdFantasquadra());
                        partita.setIdSquadraTrasferta(squadraTrasf.getIdFantasquadra());
                    }
                    partita.setGolCasa(0);
                    partita.setGolTrasferta(0);
                    partita.setFantaPunteggioCasa(0.0);
                    partita.setFantaPunteggioTrasferta(0.0);
                    partita.setGiocata(false);
                    // Salvataggio nel database tramite DAO
                    DbManager.getInstance().getCalendarioDao().insertPartita(partita);
                    partiteGenerate++;
                }
            }

            return ResponseEntity.ok("Calendario generato con successo! Totale partite: " + partiteGenerate + " su 38 giornate.");

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Errore critico durante la generazione: " + e.getMessage());
        }
    }

    // Per leggere il calendario di una specifica giornata
    // GET http://localhost:8080/calendario/lega/1/giornata/5
    @GetMapping("/lega/{idLega}/giornata/{giornata}")
    public List<CalendarioDTO> getPartite(@PathVariable Long idLega, @PathVariable int giornata) {
        return DbManager.getInstance().getCalendarioDao().getPartiteByLegaAndGiornata(idLega, giornata);
    }

    // Restituisce tutto il calendario della lega
    // GET http://localhost:8080/calendario/lega/1/tutto
    @GetMapping("/lega/{idLega}/tutto")
    public List<CalendarioDTO> getCalendarioCompleto(@PathVariable Long idLega) {
        return DbManager.getInstance().getCalendarioDao().getCalendarioCompleto(idLega);
    }

    // Elimina il calendario esistente per poterlo rigenerare
    // DELETE http://localhost:8080/calendario/elimina/1
    @DeleteMapping("/elimina/{idLega}")
    public ResponseEntity<String> eliminaCalendario(@PathVariable Long idLega) {
        try {
            // Controlla se l'utente è admin
            UtenteDTO utente = getUtenteLoggato();
            FantasquadraDTO adminSquadra = DbManager.getInstance().getFantasquadraDao().getByUtenteAndLega(utente.getId(), idLega);
            if (adminSquadra == null || !adminSquadra.isAdmin()) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Solo l'admin può eliminare il calendario.");
            }

            // Cancellazione
            DbManager.getInstance().getCalendarioDao().deleteCalendario(idLega);
            return ResponseEntity.ok("Calendario eliminato con successo. Ora puoi rigenerarlo.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Errore eliminazione: " + e.getMessage());
        }
    }
}