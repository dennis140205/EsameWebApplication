package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.LegaDTO;
import com.example.progettowebapplication.model.LegaProxy;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LegaDaoJDBC implements ILegaDAO {
    private Connection connection;

    public LegaDaoJDBC(Connection connection) {
        this.connection = connection;
    }

    @Override
    public LegaDTO createLega(LegaDTO lega) {
        String query = "INSERT INTO Lega (nome_lega, codice_invito, numero_squadre) VALUES ( ?, ?, ?)";
        // RETURN_GENERATED_KEYS per chiedere al DB l'id appena creato
        try (PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            // Imposta i parametri prendendoli dall'oggetto lega passato in input
            ps.setString(1, lega.getNomeLega());
            ps.setString(2, lega.getCodiceInvito());
            ps.setInt(3, lega.getNumeroSquadre());
            // Esegue l'inserimento
            ps.executeUpdate();
            // Recupera l'id generato
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    // Assegna l'id generato all'oggetto lega
                    lega.setIdLega(rs.getInt(1));
                }
            }
            return lega; // Ritorna l'oggetto aggiornato con il nuovo id
        } catch (SQLException e) {
            throw new RuntimeException("Errore durante la creazione della lega", e);
        }
    }

    @Override
    public LegaDTO findByCodiceInvito(String codiceInvito) {
        String query = "SELECT * FROM Lega WHERE codice_invito = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, codiceInvito);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LegaProxy lega = new LegaProxy();
                    lega.setIdLega(rs.getInt("id_lega"));
                    lega.setNomeLega(rs.getString("nome_lega"));
                    lega.setCodiceInvito(rs.getString("codice_invito"));
                    lega.setNumeroSquadre(rs.getInt("numero_squadre"));
                    return lega;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore ricerca lega per codice", e);
        }
        return null; // Se non trova nulla, ritorna null
    }

    @Override
    public List<LegaDTO> getLegheByUtente(Long idUtente) {
        List<LegaDTO> lista = new ArrayList<>();
        // Query che seleziona le leghe a cui l'utente partecipa tramite la sua fantasquadra
        String query = "SELECT l.* FROM Lega l " +
                "JOIN fantasquadra f ON l.id_lega = f.id_lega " +
                "WHERE f.id_utente = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idUtente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LegaProxy lega = new LegaProxy();
                    lega.setIdLega(rs.getInt("id_lega"));
                    lega.setNomeLega(rs.getString("nome_lega"));
                    lega.setCodiceInvito(rs.getString("codice_invito"));
                    lega.setNumeroSquadre(rs.getInt("numero_squadre"));
                    lista.add(lega);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore nel recupero delle leghe dell'utente", e);
        }
        return lista;
    }
    @Override
    public LegaDTO getLegaById(int idLega) {
        String query = "SELECT * FROM Lega WHERE id_lega = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idLega);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Usa il Proxy per gestire il caricamento pigro (lazy loading) delle squadre
                    LegaProxy lega = new LegaProxy();
                    lega.setIdLega(rs.getInt("id_lega"));
                    lega.setNomeLega(rs.getString("nome_lega"));
                    lega.setCodiceInvito(rs.getString("codice_invito"));
                    lega.setNumeroSquadre(rs.getInt("numero_squadre"));
                    return lega;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore durante la ricerca della lega per ID", e);
        }
        return null;
    }
}
