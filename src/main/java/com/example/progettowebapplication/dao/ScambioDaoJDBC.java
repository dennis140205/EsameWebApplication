package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.ScambioDTO;
import com.example.progettowebapplication.model.StatoScambio;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScambioDaoJDBC implements IScambioDAO {

    private Connection connection;

    public ScambioDaoJDBC(Connection connection) {
        this.connection = connection;
    }

    @Override
    public void proponiScambio(ScambioDTO s) {
        String query = """
        INSERT INTO scambi (id_fantasquadra_proponente, id_calciatore_proposto, crediti_proponente, 
                           id_fantasquadra_ricevente, id_calciatore_richiesto, crediti_ricevente, 
                           stato, data_proposta, visto_ricevente, visto_proponente) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, s.getIdFantasquadraProponente());
            ps.setLong(2, s.getIdCalciatoreProposto());
            ps.setInt(3, s.getCreditiProponente());
            ps.setLong(4, s.getIdFantasquadraRicevente());
            ps.setLong(5, s.getIdCalciatoreRichiesto());
            ps.setInt(6, s.getCreditiRicevente());
            ps.setString(7, StatoScambio.IN_ATTESA.name());
            ps.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            ps.setBoolean(9, false); // visto_ricevente: l'avversario deve ancora vederlo
            ps.setBoolean(10, true);  // visto_proponente: appena inviato, quindi è stato visto dal proponente
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore inserimento proposta scambio", e);
        }
    }

    @Override
    public List<ScambioDTO> getScambiByLega(Long idLega) {
        List<ScambioDTO> lista = new ArrayList<>();
        String query = """
        SELECT s.*, 
               f1.nome_fantasquadra AS nome_prop, 
               f2.nome_fantasquadra AS nome_ricev, 
               c1.nome AS nome_calc_offerto, 
               c2.nome AS nome_calc_richiesto
        FROM scambi s
        JOIN fantasquadra f1 ON s.id_fantasquadra_proponente = f1.id_fantasquadra
        JOIN fantasquadra f2 ON s.id_fantasquadra_ricevente = f2.id_fantasquadra
        JOIN calciatori c1 ON s.id_calciatore_proposto = c1.id
        JOIN calciatori c2 ON s.id_calciatore_richiesto = c2.id
        WHERE f1.id_lega = ?
        ORDER BY s.data_proposta DESC
    """;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idLega);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapRowToDTO(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura scambi della lega " + idLega, e);
        }
        return lista;
    }

    @Override
    public List<ScambioDTO> getScambiBySquadra(Long idFantasquadra) {
        List<ScambioDTO> lista = new ArrayList<>();
        // Seleziona sia quelli dove la squadra è proponente, sia quelli dove è ricevente
        String query = "SELECT * FROM scambi WHERE id_fantasquadra_proponente = ? OR id_fantasquadra_ricevente = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idFantasquadra);
            ps.setLong(2, idFantasquadra);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapRowToDTO(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura scambi squadra", e);
        }
        return lista;
    }

    @Override
    public void gestisciScambio(Long idScambio, StatoScambio nuovoStato) {
        // Se RIFIUTATO basta aggiornare lo stato nel database
        if (nuovoStato == StatoScambio.RIFIUTATO) {
            updateStatoScambio(idScambio, StatoScambio.RIFIUTATO);
            return;
        }
        // Se ACCETTATO bisogna spostare i giocatori tra le squadre
        // Questo richiede una transazione (tutto o niente)
        if (nuovoStato == StatoScambio.ACCETTATO) {
            eseguiTransazioneScambio(idScambio);
        }
    }

    @Override
    public void annullaScambio(Long idScambio) {
        // Cancella lo scambio solo se è ancora IN_ATTESA
        String query = "DELETE FROM scambi WHERE id = ? AND stato = 'IN_ATTESA'";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idScambio);
            int rows = ps.executeUpdate();
            if (rows == 0) {
                throw new RuntimeException("Impossibile annullare: scambio non trovato o già gestito.");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore annullamento scambio", e);
        }
    }

    @Override
    public ScambioDTO getScambioById(Long id) {
        String query = """
        SELECT s.*, 
               f1.nome_fantasquadra AS nome_prop, 
               f2.nome_fantasquadra AS nome_ricev, 
               c1.nome AS nome_calc_offerto, 
               c2.nome AS nome_calc_richiesto
        FROM scambi s
        JOIN fantasquadra f1 ON s.id_fantasquadra_proponente = f1.id_fantasquadra
        JOIN fantasquadra f2 ON s.id_fantasquadra_ricevente = f2.id_fantasquadra
        JOIN calciatori c1 ON s.id_calciatore_proposto = c1.id
        JOIN calciatori c2 ON s.id_calciatore_richiesto = c2.id
        WHERE s.id = ?
    """;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToDTO(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura scambio ID " + id, e);
        }
        return null;
    }

    // Esegue lo scambio effettivo (spostamento dei giocatori tra le squadre)
    private void eseguiTransazioneScambio(Long idScambio) {
        String updateProprietario = "UPDATE acquisti SET id_fantasquadra = ? WHERE id_calciatore = ? AND id_fantasquadra = ?";
        String updateBudget = "UPDATE fantasquadra SET crediti_residui = crediti_residui - ? + ? WHERE id_fantasquadra = ?";
        String closeScambio = "UPDATE scambi SET stato = ?, visto_ricevente = true, visto_proponente = false WHERE id = ?";
        try {
            connection.setAutoCommit(false);
            ScambioDTO s = getScambioById(idScambio);
            if(s == null) throw new SQLException("Scambio non trovato id: " + idScambio);
            if(s.getStato() != StatoScambio.IN_ATTESA) throw new SQLException("Lo scambio non è in attesa!");
            // Sposta il giocatore proposto (dal proponente al ricevente)
            try(PreparedStatement ps1 = connection.prepareStatement(updateProprietario)) {
                ps1.setLong(1, s.getIdFantasquadraRicevente());
                ps1.setLong(2, s.getIdCalciatoreProposto());
                ps1.setLong(3, s.getIdFantasquadraProponente());
                int righe = ps1.executeUpdate();
                if(righe == 0) throw new SQLException("Errore: Il proponente non possiede più il giocatore!");
            }
            // Sposta il giocatore richiesto (dal ricevente al proponente)
            try(PreparedStatement ps2 = connection.prepareStatement(updateProprietario)) {
                ps2.setLong(1, s.getIdFantasquadraProponente());
                ps2.setLong(2, s.getIdCalciatoreRichiesto());
                ps2.setLong(3, s.getIdFantasquadraRicevente());
                int righe = ps2.executeUpdate();
                if(righe == 0) throw new SQLException("Errore: Il ricevente non possiede più il giocatore!");
            }
            // Aggiorna budget proponente
            try(PreparedStatement psBud1 = connection.prepareStatement(updateBudget)) {
                psBud1.setInt(1, s.getCreditiProponente());
                psBud1.setInt(2, s.getCreditiRicevente());
                psBud1.setLong(3, s.getIdFantasquadraProponente());
                psBud1.executeUpdate();
            }
            // Aggiorna budget ricevente
            try(PreparedStatement psBud2 = connection.prepareStatement(updateBudget)) {
                psBud2.setInt(1, s.getCreditiRicevente());
                psBud2.setInt(2, s.getCreditiProponente());
                psBud2.setLong(3, s.getIdFantasquadraRicevente());
                psBud2.executeUpdate();
            }
            // Chiude lo scambio
            try(PreparedStatement ps3 = connection.prepareStatement(closeScambio)) {
                ps3.setString(1, StatoScambio.ACCETTATO.name());
                ps3.setLong(2, idScambio);
                ps3.executeUpdate();
            }
            connection.commit();
            System.out.println("Scambio completato con successo!");

        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw new RuntimeException("Transazione fallita: " + e.getMessage());
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) {}
        }
    }

    // Per aggiornare solo lo stato
    private void updateStatoScambio(Long id, StatoScambio stato) {
        String sql = "UPDATE scambi SET stato = ?, visto_ricevente = true, visto_proponente = false WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, stato.name());
            ps.setLong(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore update stato scambio", e);
        }
    }

    private ScambioDTO mapRowToDTO(ResultSet rs) throws SQLException {
        ScambioDTO s = new ScambioDTO();
        s.setId(rs.getLong("id"));
        s.setIdFantasquadraProponente(rs.getLong("id_fantasquadra_proponente"));
        s.setIdCalciatoreProposto(rs.getLong("id_calciatore_proposto"));
        s.setCreditiProponente(rs.getInt("crediti_proponente"));
        s.setIdFantasquadraRicevente(rs.getLong("id_fantasquadra_ricevente"));
        s.setIdCalciatoreRichiesto(rs.getLong("id_calciatore_richiesto"));
        s.setCreditiRicevente(rs.getInt("crediti_ricevente"));
        s.setDataProposta(rs.getTimestamp("data_proposta").toLocalDateTime());
        s.setNomeSquadraProponente(rs.getString("nome_prop"));
        s.setNomeSquadraRicevente(rs.getString("nome_ricev"));
        s.setNomeCalciatoreProposto(rs.getString("nome_calc_offerto"));
        s.setNomeCalciatoreRichiesto(rs.getString("nome_calc_richiesto"));
        // Conversione da stringa a enum
        try {
            String statoStr = rs.getString("stato");
            if (statoStr != null) {
                s.setStato(StatoScambio.valueOf(statoStr));
            }
        } catch (IllegalArgumentException e) {
            s.setStato(StatoScambio.IN_ATTESA);
        }
        return s;
    }

    @Override
    public int countNotifichePerSquadra(Long idFantasquadra) {
        String sql = """
        SELECT COUNT(*) FROM scambi 
        WHERE (id_fantasquadra_ricevente = ? AND visto_ricevente = false AND stato = 'IN_ATTESA')
           OR (id_fantasquadra_proponente = ? AND visto_proponente = false AND stato != 'IN_ATTESA')
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, idFantasquadra);
            ps.setLong(2, idFantasquadra);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public void resetNotifiche(Long idFantasquadra) {
        String sqlRicevente = "UPDATE scambi SET visto_ricevente = true WHERE id_fantasquadra_ricevente = ?";
        String sqlProponente = "UPDATE scambi SET visto_proponente = true WHERE id_fantasquadra_proponente = ?";

        try {
            // Reset per quando sei tu a ricevere
            try (PreparedStatement ps1 = connection.prepareStatement(sqlRicevente)) {
                ps1.setLong(1, idFantasquadra);
                ps1.executeUpdate();
            }
            // Reset per quando ricevi una risposta a una tua proposta
            try (PreparedStatement ps2 = connection.prepareStatement(sqlProponente)) {
                ps2.setLong(1, idFantasquadra);
                ps2.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore reset notifiche", e);
        }
    }
}