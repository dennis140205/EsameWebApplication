package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.UtenteDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtenteDaoJDBC implements IUtenteDAO {

    private Connection connection;

    public UtenteDaoJDBC(Connection connection) {
        this.connection = connection;
    }

    @Override
    public UtenteDTO insertUtente(UtenteDTO utente) {
        String query = "INSERT INTO public.utenti (nome, cognome, email, password, ruolo) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, utente.getNome());
            ps.setString(2, utente.getCognome());
            ps.setString(3, utente.getEmail());
            ps.setString(4, utente.getPassword());
            // Default ruolo: USER
            ps.setString(5, "USER");
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    utente.setId(rs.getLong(1));
                    utente.setRuolo("USER");
                }
            }
            return utente;
        } catch (SQLException e) {
            throw new RuntimeException("Errore inserimento utente", e);
        }
    }

    @Override
    public List<UtenteDTO> getAllUtenti() {
        List<UtenteDTO> utenti = new ArrayList<>();
        String query = "SELECT * FROM public.utenti";
        try (Statement st = connection.createStatement();
             ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) {
                utenti.add(mapRowToDTO(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura utenti", e);
        }
        return utenti;
    }

    @Override
    public UtenteDTO getUtenteById(Long id) {
        String query = "SELECT * FROM public.utenti WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToDTO(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore ricerca utente per id", e);
        }
        return null;
    }

    @Override
    public UtenteDTO getUtenteByEmail(String email) {
        String query = "SELECT * FROM public.utenti WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToDTO(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore ricerca utente per email", e);
        }
        return null;
    }

    @Override
    public UtenteDTO updateUtente(UtenteDTO utente) {
        String query = "UPDATE utenti SET nome=?, cognome=?, email=?, password=?, squadra_preferita=? WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, utente.getNome());
            ps.setString(2, utente.getCognome());
            ps.setString(3, utente.getEmail());
            ps.setString(4, utente.getPassword());
            if (utente.getSquadraPreferita() != null) {
                ps.setString(5, utente.getSquadraPreferita());
            } else {
                ps.setNull(5, Types.VARCHAR);
            }
            ps.setLong(6, utente.getId());
            ps.executeUpdate();
            return utente;
        } catch (SQLException e) {
            throw new RuntimeException("Errore aggiornamento utente", e);
        }
    }

    @Override
    public void deleteUtente(Long id) {
        String query = "DELETE FROM utenti WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore eliminazione utente", e);
        }
    }

    private UtenteDTO mapRowToDTO(ResultSet rs) throws SQLException {
        UtenteDTO u = new UtenteDTO();
        u.setId(rs.getLong("id"));
        u.setNome(rs.getString("nome"));
        u.setCognome(rs.getString("cognome"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        // Gestione ruolo: se nel DB è null mette USER per sicurezza
        String ruoloDB = rs.getString("ruolo");
        u.setRuolo(ruoloDB != null ? ruoloDB : "USER");
        u.setSquadraPreferita(rs.getString("squadra_preferita"));
        return u;
    }
}