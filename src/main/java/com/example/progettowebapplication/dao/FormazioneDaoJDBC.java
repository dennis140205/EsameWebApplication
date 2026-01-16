package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FormazioneDaoJDBC implements IFormazioneDAO {

    private Connection connection;

    public FormazioneDaoJDBC(Connection connection) {
        this.connection = connection;
    }

    @Override
    public void salvaFormazione(FormazioneDTO f) {
        String deleteOld = "DELETE FROM formazioni WHERE id_fantasquadra = ? AND giornata = ?";
        String insertFormazione = "INSERT INTO formazioni (id_fantasquadra, giornata, modulo) VALUES (?, ?, ?)";
        String insertGiocatore = "INSERT INTO schieramento (id_formazione, id_calciatore, stato, ordine, ruolo_schierato) VALUES (?, ?, ?, ?, ?)";
        try {
            connection.setAutoCommit(false); // Inizio transazione
            // Cancella la vecchia formazione
            try (PreparedStatement psDel = connection.prepareStatement(deleteOld)) {
                psDel.setLong(1, f.getIdFantasquadra());
                psDel.setInt(2, f.getGiornata());
                psDel.executeUpdate();
            }
            // Crea la formazione
            Long idFormazioneGenerato = null;
            try (PreparedStatement psIns = connection.prepareStatement(insertFormazione, Statement.RETURN_GENERATED_KEYS)) {
                psIns.setLong(1, f.getIdFantasquadra());
                psIns.setInt(2, f.getGiornata());
                psIns.setString(3, f.getModulo());
                psIns.executeUpdate();
                try (ResultSet rs = psIns.getGeneratedKeys()) {
                    if (rs.next()) idFormazioneGenerato = rs.getLong(1);
                }
            }
            if (idFormazioneGenerato == null) throw new SQLException("Errore ID formazione.");
            // Inserisce i giocatori
            try (PreparedStatement psPlayers = connection.prepareStatement(insertGiocatore)) {
                for (SchieramentoDTO s : f.getCalciatori()) {
                    psPlayers.setLong(1, idFormazioneGenerato);
                    psPlayers.setLong(2, s.getIdCalciatore());
                    psPlayers.setString(3, s.getStato().name());
                    psPlayers.setInt(4, s.getOrdine());
                    psPlayers.setString(5, s.getRuolo() != null ? s.getRuolo().name() : null);
                    psPlayers.addBatch();
                }
                psPlayers.executeBatch();
            }
            connection.commit(); // Conferma modifiche
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw new RuntimeException("Errore salvataggio formazione", e);
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    @Override
    public FormazioneDTO getFormazione(Long idFantasquadra, int giornata) {
        FormazioneDTO f = null;
        String queryTestata = "SELECT * FROM formazioni WHERE id_fantasquadra = ? AND giornata = ?";
        String queryDettagli = """
            SELECT s.*, c.nome, c.ruolo
            FROM schieramento s
            JOIN calciatori c ON s.id_calciatore = c.id
            WHERE s.id_formazione = ?
            ORDER BY s.stato DESC, s.ordine ASC
        """;
        try (PreparedStatement ps = connection.prepareStatement(queryTestata)) {
            ps.setLong(1, idFantasquadra);
            ps.setInt(2, giornata);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    f = new FormazioneDTO();
                    f.setId(rs.getLong("id"));
                    f.setIdFantasquadra(rs.getLong("id_fantasquadra"));
                    f.setGiornata(rs.getInt("giornata"));
                    f.setModulo(rs.getString("modulo"));
                    f.setDataInserimento(rs.getTimestamp("data_inserimento").toLocalDateTime());
                    f.setCalciatori(new ArrayList<>());
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura formazione", e);
        }
        if (f != null) {
            try (PreparedStatement ps = connection.prepareStatement(queryDettagli)) {
                ps.setLong(1, f.getId());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        SchieramentoDTO s = new SchieramentoDTO();
                        s.setId(rs.getLong("id"));
                        s.setIdFormazione(f.getId());
                        s.setIdCalciatore(rs.getLong("id_calciatore"));
                        s.setNomeCalciatore(rs.getString("nome"));
                        s.setOrdine(rs.getInt("ordine"));
                        double votoLetto = rs.getDouble("fanta_voto");
                        if (!rs.wasNull()) {
                            s.setFantaVoto(votoLetto);
                        }
                        try {
                            s.setStato(StatoSchieramento.valueOf(rs.getString("stato")));
                        } catch (Exception e) {
                            s.setStato(StatoSchieramento.PANCHINA); // Default sicuro
                        }
                        try {
                            s.setRuolo(Ruolo.valueOf(rs.getString("ruolo")));
                        } catch (Exception ex) { s.setRuolo(null); }

                        try {
                            List<StatisticaDTO> storico = DbManager.getInstance().getCalciatoreDao().getStatisticheByCalciatore(s.getIdCalciatore());
                            s.setStatistiche(storico);
                        } catch (Exception e) {
                            s.setStatistiche(new ArrayList<>());
                        }

                        f.getCalciatori().add(s);
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException("Errore lettura dettagli", e);
            }
        }
        return f;
    }

    @Override
    public void aggiornaVotoSchieramento(Long idSchieramento, Double fantaVoto) {
        String query = "UPDATE schieramento SET fanta_voto = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            if (fantaVoto != null) {
                ps.setDouble(1, fantaVoto);
            } else {
                ps.setNull(1, Types.DOUBLE);
            }
            ps.setLong(2, idSchieramento);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore aggiornamento voto schieramento", e);
        }
    }
}