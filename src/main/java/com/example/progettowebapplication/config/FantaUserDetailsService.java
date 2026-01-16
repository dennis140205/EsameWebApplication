package com.example.progettowebapplication.config;

import com.example.progettowebapplication.dao.DbManager;
import com.example.progettowebapplication.dao.IUtenteDAO;
import com.example.progettowebapplication.model.UtenteDTO;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

// Chiamata automaticamente durante il login
// Prende i dati dal DB e li converte in un oggetto comprensibile a Spring Security.
@Service
public class FantaUserDetailsService implements UserDetailsService {
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        IUtenteDAO utenteDao = DbManager.getInstance().getUtenteDao();
        UtenteDTO utente = utenteDao.getUtenteByEmail(email);
        if (utente == null) {
            throw new UsernameNotFoundException("Utente non trovato con email: " + email);
        }
        return User.builder().username(utente.getEmail()).password(utente.getPassword()).roles(utente.getRuolo()).build();
    }
}