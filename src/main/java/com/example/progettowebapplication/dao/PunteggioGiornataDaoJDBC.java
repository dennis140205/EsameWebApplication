package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.PunteggioGiornataDTO;
import java.sql.*;

public class PunteggioGiornataDaoJDBC implements IPunteggioGiornataDAO {
    private Connection connection;

    public PunteggioGiornataDaoJDBC(Connection connection) {
        this.connection = connection;
    }

    @Override
    public void salvaPunteggio(PunteggioGiornataDTO s) {
        String query = "INSERT INTO punteggi_giornata (id_fantasquadra, giornata, punteggio_totale, gol_fatti, gol_subiti, punti_classifica) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, s.getIdFantasquadra());
            ps.setInt(2, s.getGiornata());
            ps.setDouble(3, s.getPunteggioTotale());
            ps.setInt(4, s.getGolFatti());
            ps.setInt(5, s.getGolSubiti());
            ps.setInt(6, s.getPuntiClassifica());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore salvataggio storico giornata", e);
        }
    }

    @Override
    public PunteggioGiornataDTO getPunteggioBySquadraAndGiornata(Long idFantasquadra, int giornata) {
        String query = "SELECT * FROM punteggi_giornata WHERE id_fantasquadra = ? AND giornata = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idFantasquadra);
            ps.setInt(2, giornata);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new PunteggioGiornataDTO(
                            rs.getLong("id"),
                            rs.getLong("id_fantasquadra"),
                            rs.getInt("giornata"),
                            rs.getDouble("punteggio_totale"),
                            rs.getInt("gol_fatti"),
                            rs.getInt("gol_subiti"),
                            rs.getInt("punti_classifica")
                    );
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura storico", e);
        }
        return null;
    }

    @Override
    public void deletePunteggio(Long idFantasquadra, int giornata) {
        String query = "DELETE FROM punteggi_giornata WHERE id_fantasquadra = ? AND giornata = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idFantasquadra);
            ps.setInt(2, giornata);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore eliminazione storico", e);
        }
    }
}