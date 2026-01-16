package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.CalendarioDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CalendarioDaoJDBC implements ICalendarioDAO {
    private Connection connection;

    public CalendarioDaoJDBC(Connection connection) {
        this.connection = connection;
    }

    @Override
    public List<CalendarioDTO> getPartiteByLegaAndGiornata(Long idLega, int giornata) {
        List<CalendarioDTO> lista = new ArrayList<>();
        String query = "SELECT * FROM calendario WHERE id_lega = ? AND giornata = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idLega);
            ps.setInt(2, giornata);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CalendarioDTO c = new CalendarioDTO();
                    c.setId(rs.getLong("id"));
                    c.setIdLega(rs.getLong("id_lega"));
                    c.setGiornata(rs.getInt("giornata"));
                    c.setIdSquadraCasa(rs.getLong("id_squadra_casa"));
                    c.setIdSquadraTrasferta(rs.getLong("id_squadra_trasferta"));
                    c.setGolCasa(rs.getInt("gol_casa"));
                    c.setGolTrasferta(rs.getInt("gol_trasferta"));
                    c.setFantaPunteggioCasa(rs.getDouble("fanta_punteggio_casa"));
                    c.setFantaPunteggioTrasferta(rs.getDouble("fanta_punteggio_trasferta"));
                    c.setGiocata(rs.getBoolean("giocata"));
                    lista.add(c);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura calendario", e);
        }
        return lista;
    }

    @Override
    public List<CalendarioDTO> getCalendarioCompleto(Long idLega) {
        List<CalendarioDTO> lista = new ArrayList<>();
        // Seleziona tutte le partite della lega ordinandole per giornata
        String query = "SELECT * FROM calendario WHERE id_lega = ? ORDER BY giornata ASC";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idLega);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CalendarioDTO c = new CalendarioDTO();
                    c.setId(rs.getLong("id"));
                    c.setIdLega(rs.getLong("id_lega"));
                    c.setGiornata(rs.getInt("giornata"));
                    c.setIdSquadraCasa(rs.getLong("id_squadra_casa"));
                    c.setIdSquadraTrasferta(rs.getLong("id_squadra_trasferta"));
                    c.setGolCasa(rs.getInt("gol_casa"));
                    c.setGolTrasferta(rs.getInt("gol_trasferta"));
                    c.setFantaPunteggioCasa(rs.getDouble("fanta_punteggio_casa"));
                    c.setFantaPunteggioTrasferta(rs.getDouble("fanta_punteggio_trasferta"));
                    c.setGiocata(rs.getBoolean("giocata"));
                    lista.add(c);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura calendario completo", e);
        }
        return lista;
    }

    @Override
    public void updateRisultatoPartita(CalendarioDTO c) {
        String query = "UPDATE calendario SET gol_casa=?, gol_trasferta=?, fanta_punteggio_casa=?, fanta_punteggio_trasferta=?, giocata=? WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, c.getGolCasa());
            ps.setInt(2, c.getGolTrasferta());
            ps.setDouble(3, c.getFantaPunteggioCasa());
            ps.setDouble(4, c.getFantaPunteggioTrasferta());
            ps.setBoolean(5, true); // Ora la partita risulta giocata
            ps.setLong(6, c.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore aggiornamento partita", e);
        }
    }

    @Override
    public void insertPartita(CalendarioDTO c) {
        String query = "INSERT INTO calendario (id_lega, giornata, id_squadra_casa, id_squadra_trasferta, giocata) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, c.getIdLega());
            ps.setInt(2, c.getGiornata());
            ps.setLong(3, c.getIdSquadraCasa());
            ps.setLong(4, c.getIdSquadraTrasferta());
            ps.setBoolean(5, false); // Appena creata non è ancora giocata
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore inserimento partita", e);
        }
    }

    @Override
    public void deleteCalendario(Long idLega) {
        String query = "DELETE FROM calendario WHERE id_lega = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idLega);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore eliminazione calendario", e);
        }
    }

    @Override
    public void resetPartiteGiornata(Long idLega, int giornata) {
        String query = """
            UPDATE calendario 
            SET gol_casa = 0, gol_trasferta = 0, fanta_punteggio_casa = 0, fanta_punteggio_trasferta = 0, giocata = FALSE 
            WHERE id_lega = ? AND giornata = ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idLega);
            ps.setInt(2, giornata);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore reset calendario", e);
        }
    }
}