package com.example.progettowebapplication.controller;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.model.UtenteDTO;
import com.example.progettowebapplication.dao.IUtenteDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/utente") // URL base: http://localhost:8080/utente
public class UtenteController {

    private final PasswordEncoder passwordEncoder;
    public UtenteController(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }

    // GET ALL - Restituisce tutti gli utenti
    // Chiamata: GET http://localhost:8080/utente
    @GetMapping("")
    public List<UtenteDTO> getAllUtenti() {
        IUtenteDAO utenteDao = DbManager.getInstance().getUtenteDao();
        return utenteDao.getAllUtenti();
    }

    // CREATE - Aggiunge un nuovo utente (Registrazione)
    // Chiamata: POST http://localhost:8080/utente/register
    @PostMapping("/register")
    public UtenteDTO register(@RequestBody UtenteDTO utente) {
        // Controlla se si è già loggati
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        // Se l'auth esiste, è autenticato e non è un utente anonimo
        if (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Sei già loggato! Effettua il logout prima di registrarti con un nuovo account.");
        }

        // Cripta la password
        String passwordCriptata = passwordEncoder.encode(utente.getPassword());
        utente.setPassword(passwordCriptata);

        // Salva nel DB
        IUtenteDAO utenteDao = DbManager.getInstance().getUtenteDao();
        return utenteDao.insertUtente(utente);
    }

    // GET BY ID - Cerca un utente specifico
    // Chiamata: GET http://localhost:8080/utente/1
    @GetMapping("/{id}")
    public UtenteDTO getUtenteById(@PathVariable Long id) {
        IUtenteDAO utenteDao = DbManager.getInstance().getUtenteDao();
        return utenteDao.getUtenteById(id);
    }

    // DELETE - Elimina un utente (PROTETTA: Solo se stesso)
    // Chiamata: DELETE http://localhost:8080/utente/1
    @DeleteMapping("/{id}")
    public void deleteUtente(@PathVariable Long id, HttpServletRequest request) {
        // Recupera chi è loggato
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String emailCorrente = auth.getName();

        IUtenteDAO utenteDao = DbManager.getInstance().getUtenteDao();
        UtenteDTO utenteLoggato = utenteDao.getUtenteByEmail(emailCorrente);
        if (utenteLoggato == null || !utenteLoggato.getId().equals(id)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Non puoi cancellare un account non tuo!");
        }
        utenteDao.deleteUtente(id);
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Elimina il cookie lato server
        }
        // Pulisce anche il contesto di sicurezza immediato
        SecurityContextHolder.clearContext();
    }

    // Per ottenere l'utente loggato
    // Chiamata: GET http://localhost:8080/utente/profile
    @GetMapping("/profile")
    public UtenteDTO getProfile() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) {
            // L'email è nell'auth.getName()
            String email = auth.getName();
            return DbManager.getInstance().getUtenteDao().getUtenteByEmail(email);
        }
        return null;
    }

    // Chiama questo con l'header Basic Auth la prima volta.
    // auth type: Basic Auth
    // Chiamata: GET http://localhost:8080/utente/login
    @GetMapping("/login")
    public UtenteDTO login() {
        // Qui spring security ha già verificato la password e creato la sessione.
        return getProfile();
    }

    // logout
    // Chiamata: POST http://localhost:8080/utente/logout
    @PostMapping("/logout")
    public void logout(HttpServletRequest request) {
        // Invalida la sessione HTTP
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Cancella il contesto di sicurezza di Spring
        SecurityContextHolder.clearContext();
    }

    // UPDATE - Modifica dati utente (Nome, Cognome e Password)
    // Chiamata: PUT http://localhost:8080/utente/1
    @PutMapping("/{id}")
    public UtenteDTO updateUtente(@PathVariable Long id, @RequestBody UtenteDTO utenteModificato) {
        // Controlla chi è l'utente loggato
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        IUtenteDAO utenteDao = DbManager.getInstance().getUtenteDao();
        UtenteDTO utenteLoggato = utenteDao.getUtenteByEmail(auth.getName());
        if (utenteLoggato == null || !utenteLoggato.getId().equals(id)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Non puoi modificare un profilo non tuo!");
        }

        // Aggiorna i campi dell'oggetto DB solo se nel JSON c'è qualcosa di nuovo.
        if (utenteModificato.getNome() != null) {
            utenteLoggato.setNome(utenteModificato.getNome());
        }
        if (utenteModificato.getCognome() != null) {
            utenteLoggato.setCognome(utenteModificato.getCognome());
        }
        if (utenteModificato.getSquadraPreferita() != null) {
            utenteLoggato.setSquadraPreferita(utenteModificato.getSquadraPreferita());
        }

        // Se l'utente manda una nuova password va criptata.
        if (utenteModificato.getPassword() != null && !utenteModificato.getPassword().isBlank()) {
            String nuovaPasswordCriptata = passwordEncoder.encode(utenteModificato.getPassword());
            utenteLoggato.setPassword(nuovaPasswordCriptata);
        }
        return utenteDao.updateUtente(utenteLoggato);
    }
}