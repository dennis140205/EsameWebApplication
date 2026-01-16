package com.example.progettowebapplication.controller;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.dao.FantasquadraDaoJDBC;
import com.example.progettowebapplication.dao.ImpostazioniLegaDaoJDBC;
import com.example.progettowebapplication.dao.LegaDaoJDBC;
import com.example.progettowebapplication.model.*; // Importa tutti i modelli inclusi Stats e CalendarioDTO
import com.example.progettowebapplication.model.request.JoinLegaRequest;
import com.example.progettowebapplication.model.request.LegaWithImpostazioniRequest;
import com.example.progettowebapplication.service.FootballDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

@RestController
@RequestMapping("/lega")
@CrossOrigin(origins = "http://localhost:4200", allowCredentials = "true")
public class LegaController {
    @Autowired
    private FootballDataService footballDataService;

    private static final String ALPHANUMERIC = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    private final SecureRandom random = new SecureRandom();

    // Creazione lega
    @PostMapping("/crea")
    public ResponseEntity<?> createLega(@RequestBody LegaWithImpostazioniRequest request) {
        Connection conn = null;
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            UtenteDTO utenteLoggato = DbManager.getInstance().getUtenteDao().getUtenteByEmail(auth.getName());

            if (utenteLoggato == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Devi essere loggato.");

            LegaDTO legaInput = request.getLega();
            ImpostazioniLegaDTO impostazioniInput = request.getImpostazioni();

            if (legaInput == null || impostazioniInput == null) return ResponseEntity.badRequest().body("Dati mancanti");
            if (legaInput.getNumeroSquadre() % 2 != 0) return ResponseEntity.badRequest().body("Il numero di squadre deve essere pari!");

            conn = DbManager.getInstance().getConnection();
            conn.setAutoCommit(false);

            LegaDaoJDBC legaDao = new LegaDaoJDBC(conn);
            ImpostazioniLegaDaoJDBC impDao = new ImpostazioniLegaDaoJDBC(conn);
            FantasquadraDaoJDBC squadDao = new FantasquadraDaoJDBC(conn);

            String nuovoCodice = generateRandomCode(8);
            legaInput.setCodiceInvito(nuovoCodice);
            LegaDTO legaSalvata = legaDao.createLega(legaInput);

            impostazioniInput.setIdLega((long) legaSalvata.getIdLega());
            impDao.insertImpostazioni(impostazioniInput);

            FantasquadraDTO squadAdmin = new FantasquadraDTO();
            squadAdmin.setIdUtente(utenteLoggato.getId());
            squadAdmin.setIdLega((long) legaSalvata.getIdLega());
            squadAdmin.setNomeFantasquadra(legaInput.getNomeSquadraAdmin());
            squadAdmin.setAdmin(true);
            squadAdmin.setCreditiResidui(impostazioniInput.getBudgetIniziale());
            squadAdmin.setPunteggioClassificaFantasquadra(0);

            squadDao.insertFantasquadrainDB(squadAdmin);
            conn.commit();

            return new ResponseEntity<>(legaSalvata, HttpStatus.CREATED);
        } catch (Exception e) {
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            return new ResponseEntity<>("Errore: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        } finally {
            if (conn != null) { try { conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); } }
        }
    }

    // Ricerca lega
    @GetMapping("/trovaLega")
    public ResponseEntity<?> findByCodiceInvito(@RequestParam String codiceInvito) {
        try {
            LegaDTO legaTrovata = DbManager.getInstance().getLegaDao().findByCodiceInvito(codiceInvito);
            if (legaTrovata == null) return new ResponseEntity<>("La lega non esiste", HttpStatus.NOT_FOUND);
            return ResponseEntity.ok(legaTrovata);
        } catch (Exception e) {
            return new ResponseEntity<>("Errore: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Entrata nella lega (join)
    @PostMapping("/join")
    public ResponseEntity<String> joinLega(@RequestBody JoinLegaRequest request) {
        try {
            LegaDTO lega = DbManager.getInstance().getLegaDao().findByCodiceInvito(request.getCodiceInvito());
            if (lega == null) return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Codice non valido.");

            if (lega.getSquadreIscritte().size() >= lega.getNumeroSquadre()) return ResponseEntity.badRequest().body("Lega piena!");

            FantasquadraDTO esistente = DbManager.getInstance().getFantasquadraDao().getByUtenteAndLega(request.getIdUtente(), (long) lega.getIdLega());
            if (esistente != null) return ResponseEntity.badRequest().body("Hai già una squadra qui!");

            ImpostazioniLegaDTO impostazioni = DbManager.getInstance().getImpostazioniLegaDao().getByIdLega((long) lega.getIdLega());
            int budget = (impostazioni != null) ? impostazioni.getBudgetIniziale() : 500;

            FantasquadraDTO nuovaSquadra = new FantasquadraDTO();
            nuovaSquadra.setNomeFantasquadra(request.getNomeSquadra());
            nuovaSquadra.setIdUtente(request.getIdUtente());
            nuovaSquadra.setIdLega((long) lega.getIdLega());
            nuovaSquadra.setCreditiResidui(budget);
            nuovaSquadra.setAdmin(false);
            nuovaSquadra.setPunteggioClassificaFantasquadra(0);

            DbManager.getInstance().getFantasquadraDao().insertFantasquadrainDB(nuovaSquadra);
            return ResponseEntity.ok("Ti sei unito con successo!");
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Errore: " + e.getMessage());
        }
    }

    // Classifica
    @GetMapping("/{idLega}/classifica")
    public ResponseEntity<List<FantasquadraDTO>> getClassifica(@PathVariable Long idLega) {
        try {
            List<FantasquadraDTO> classifica = DbManager.getInstance().getFantasquadraDao().getClassifica(idLega);
            return classifica.isEmpty() ? ResponseEntity.noContent().build() : ResponseEntity.ok(classifica);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // Lista mie leghe
    @GetMapping("/mie-leghe/{idUtente}")
    public ResponseEntity<List<LegaRiepilogo>> getMieLeghe(@PathVariable Long idUtente) {
        try {
            List<LegaDTO> mieLegheRaw = DbManager.getInstance().getLegaDao().getLegheByUtente(idUtente);
            if (mieLegheRaw.isEmpty()) return ResponseEntity.noContent().build();

            List<LegaRiepilogo> risposta = new ArrayList<>();
            for (LegaDTO lega : mieLegheRaw) {
                List<FantasquadraDTO> squadre = lega.getSquadreIscritte();
                int numIscritti = (squadre != null) ? squadre.size() : 0;
                String iscrittiFormat = numIscritti + "/" + lega.getNumeroSquadre();

                String ruolo = "Partecipante";
                if (squadre != null) {
                    for (FantasquadraDTO sq : squadre) {
                        if (sq.getIdUtente().equals(idUtente) && sq.isAdmin()) { ruolo = "Presidente"; break; }
                    }
                }

                risposta.add(new LegaRiepilogo(lega.getIdLega(), lega.getNomeLega(), ruolo, iscrittiFormat, "In Attesa"));
            }
            return ResponseEntity.ok(risposta);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Dashboard info
    @GetMapping("/pagina-principale-info/{idLega}")
    public ResponseEntity<?> getDashboardInfo(@PathVariable Long idLega) {
        try {
            String email = SecurityContextHolder.getContext().getAuthentication().getName();
            UtenteDTO utente = DbManager.getInstance().getUtenteDao().getUtenteByEmail(email);
            LegaDTO lega = DbManager.getInstance().getLegaDao().getLegaById(idLega.intValue());
            FantasquadraDTO squadra = DbManager.getInstance().getFantasquadraDao().getByUtenteAndLega(utente.getId(), idLega);

            if (squadra == null) return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Squadra non trovata");

            List<CalendarioDTO> calendario = DbManager.getInstance().getCalendarioDao().getCalendarioCompleto(idLega);
            int gIniziale = calendario.isEmpty() ? 1 : calendario.get(0).getGiornata();

            Map<String, Object> response = new HashMap<>();
            response.put("username", utente.getNome() + " " + (utente.getCognome() != null ? utente.getCognome() : ""));
            response.put("nomeLega", lega.getNomeLega());
            response.put("idFantasquadra", squadra.getIdFantasquadra());
            response.put("nomeSquadra", squadra.getNomeFantasquadra());
            response.put("creditiResidui", squadra.getCreditiResidui());
            response.put("isAdmin", squadra.isAdmin());
            response.put("isCalendarioGenerato", !calendario.isEmpty());
            response.put("giornataInizialeLega", gIniziale);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Errore: " + e.getMessage());
        }
    }

    // Per ottenere la gioranta attiva
    @GetMapping("/{idLega}/giornata-attiva")
    public ResponseEntity<Integer> getGiornataAttiva(@PathVariable Long idLega) {
        try {
            // Chiede al servizio esterno qual è la giornata reale attuale
            int giornataRealeSerieA = footballDataService.getCurrentMatchday();
            // Recupera la prima giornata della nostra lega dal calendario
            List<CalendarioDTO> calendarioCompleto = DbManager.getInstance().getCalendarioDao().getCalendarioCompleto(idLega);
            // Se il calendario non esiste ancora, ci si fida della Serie A
            if (calendarioCompleto.isEmpty()) {
                return ResponseEntity.ok(giornataRealeSerieA);
            }
            int giornataInizialeLega = calendarioCompleto.get(0).getGiornata();

            // Se la giornata reale è precedente all'inizio della lega,
            // forza il sistema a restituire la prima giornata della lega.
            if (giornataRealeSerieA < giornataInizialeLega) {
                return ResponseEntity.ok(giornataInizialeLega);
            }
            // Controlla se la giornata corrente della lega è conclusa
            List<CalendarioDTO> partiteGiornataCorrente = DbManager.getInstance().getCalendarioDao()
                    .getPartiteByLegaAndGiornata(idLega, giornataRealeSerieA);
            if (partiteGiornataCorrente.isEmpty()) {
                // Giornata reale >= giornata iniziale, ma non ci sono partite per questa specifica giornata
                // Restituisce la reale
                return ResponseEntity.ok(giornataRealeSerieA);
            }
            boolean giornataLegaConclusa = partiteGiornataCorrente.stream().allMatch(CalendarioDTO::isGiocata);
            if (giornataLegaConclusa) {
                return ResponseEntity.ok(giornataRealeSerieA + 1);
            }
            return ResponseEntity.ok(giornataRealeSerieA);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(null);
        }
    }


    @GetMapping("/{id}")
    public ResponseEntity<LegaDTO> getLegaById(@PathVariable Long id) {
        LegaDTO lega = DbManager.getInstance().getLegaDao().getLegaById(id.intValue());
        return (lega == null) ? ResponseEntity.notFound().build() : ResponseEntity.ok(lega);
    }

    private String generateRandomCode(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) sb.append(ALPHANUMERIC.charAt(random.nextInt(ALPHANUMERIC.length())));
        return sb.toString();
    }
}