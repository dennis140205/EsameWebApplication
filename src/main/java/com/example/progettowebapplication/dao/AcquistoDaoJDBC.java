package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AcquistoDaoJDBC implements IAcquistoDAO {

    private Connection connection;

    public AcquistoDaoJDBC(Connection connection) {
        this.connection = connection;
    }

    @Override
    public AcquistoDTO insertAcquisto(AcquistoDTO a) {
        String query = "INSERT INTO acquisti (id_fantasquadra, id_calciatore, prezzo_acquisto, data_acquisto) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, a.getIdFantasquadra());
            ps.setLong(2, a.getIdCalciatore());
            ps.setInt(3, a.getPrezzoAcquisto());
            // Se la data è null, usa quella corrente
            if (a.getDataAcquisto() != null) {
                ps.setTimestamp(4, Timestamp.valueOf(a.getDataAcquisto()));
            } else {
                ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            }
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    a.setId(rs.getLong(1));
                }
            }
            return a;
        } catch (SQLException e) {
            throw new RuntimeException("Errore inserimento acquisto", e);
        }
    }

    // Restituisce la lista di calciatori appartenenti alla fantasquadra indicata
    @Override
    public List<GiocatoreRosaDTO> getRosaByFantaSquadra(Long idFantaSquadra) {
        List<GiocatoreRosaDTO> rosa = new ArrayList<>();
        String query = """
        SELECT a.id AS id_acquisto, a.prezzo_acquisto, 
               c.id AS id_calciatore, c.nome, c.ruolo, c.squadra, c.quotazione
        FROM acquisti a
        JOIN calciatori c ON a.id_calciatore = c.id
        WHERE a.id_fantasquadra = ?
    """;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idFantaSquadra);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GiocatoreRosaDTO g = new GiocatoreRosaDTO();
                    g.setIdAcquisto(rs.getLong("id_acquisto"));
                    g.setIdCalciatore(rs.getLong("id_calciatore"));
                    g.setNome(rs.getString("nome"));
                    g.setRuolo(rs.getString("ruolo"));
                    g.setSquadraReale(rs.getString("squadra"));
                    g.setQuotazione(rs.getInt("quotazione"));
                    g.setPrezzoAcquisto(rs.getInt("prezzo_acquisto"));
                    rosa.add(g);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura rosa completa", e);
        }
        return rosa;
    }

    @Override
    public boolean isCalciatoreGiaAcquistatoInLega(Long idCalciatore, Long idLega) {
        // Query per verificare se il calciatore è in una squadra di quella lega
        String query = """
            SELECT COUNT(*) FROM acquisti a 
            JOIN fantasquadra f ON a.id_fantasquadra = f.id_fantasquadra 
            WHERE a.id_calciatore = ? AND f.id_lega = ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idCalciatore);
            ps.setLong(2, idLega);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore verifica disponibilità calciatore", e);
        }
        return false;
    }

    @Override
    public void deleteAcquisto(Long id) {
        String query = "DELETE FROM acquisti WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore cancellazione acquisto", e);
        }
    }

    @Override
    public AcquistoDTO getAcquistoById(Long id) {
        String query = "SELECT * FROM acquisti WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToDTO(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura acquisto", e);
        }
        return null;
    }

    @Override
    public List<CalciatoreDTO> getCalciatoriSvincolati(Long idLega) {
        List<CalciatoreDTO> lista = new ArrayList<>();
        // Seleziona tutti i calciatori il cui id non è presente nella tabella acquisti filtrata per le squadre di quella lega
        String query = """
            SELECT c.* FROM calciatori c
            WHERE c.id NOT IN (
                SELECT a.id_calciatore 
                FROM acquisti a
                JOIN fantasquadra f ON a.id_fantasquadra = f.id_fantasquadra
                WHERE f.id_lega = ?
            )
        """;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idLega);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CalciatoreDTO c = new CalciatoreDTO();
                    c.setId(rs.getLong("id"));
                    c.setNome(rs.getString("nome"));
                    c.setSquadra(rs.getString("squadra"));
                    c.setQuotazione(rs.getInt("quotazione"));
                    c.setCodiceApi(rs.getObject("codice_api") != null ? rs.getInt("codice_api") : null);
                    c.setUrlImmagine(rs.getString("url_immagine"));
                    // Conversione da stringa a enum (se fallisce usa valori di default)
                    try { c.setRuolo(Ruolo.valueOf(rs.getString("ruolo"))); } catch (Exception e) { c.setRuolo(null); }
                    try { c.setStato(StatoCalciatore.valueOf(rs.getString("stato"))); } catch (Exception e) { c.setStato(StatoCalciatore.DISPONIBILE); }
                    lista.add(c);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura svincolati", e);
        }
        return lista;
    }

    @Override
    public AcquistoDTO getAcquistoByCalciatore(Long idCalciatore, Long idLega) {
        // Join per filtrare per lega (un giocatore può essere comprato in leghe diverse)
        String query = """
        SELECT a.* FROM acquisti a
        JOIN fantasquadra f ON a.id_fantasquadra = f.id_fantasquadra
        WHERE a.id_calciatore = ? AND f.id_lega = ?
    """;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idCalciatore);
            ps.setLong(2, idLega);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToDTO(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore ricerca proprietario calciatore", e);
        }
        return null; // Il giocatore è svincolato in quella lega
    }

    private AcquistoDTO mapRowToDTO(ResultSet rs) throws SQLException {
        AcquistoDTO a = new AcquistoDTO();
        a.setId(rs.getLong("id"));
        a.setIdFantasquadra(rs.getLong("id_fantasquadra"));
        a.setIdCalciatore(rs.getLong("id_calciatore"));
        a.setPrezzoAcquisto(rs.getInt("prezzo_acquisto"));
        Timestamp ts = rs.getTimestamp("data_acquisto");
        if (ts != null) a.setDataAcquisto(ts.toLocalDateTime());
        return a;
    }
}