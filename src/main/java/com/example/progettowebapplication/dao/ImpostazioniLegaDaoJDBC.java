package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.ImpostazioniLegaDTO;
import java.sql.*;

public class ImpostazioniLegaDaoJDBC implements IImpostazioniLegaDAO {

    private Connection connection;

    public ImpostazioniLegaDaoJDBC(Connection connection) {
        this.connection = connection;
    }

    @Override
    public ImpostazioniLegaDTO insertImpostazioni(ImpostazioniLegaDTO imp) {
        String query = """
            INSERT INTO impostazioni_lega (
                id_lega, budget_iniziale, max_calciatori, mercato_scambi_aperto,
                modificatore_difesa, porta_inviolata, mvp, gol_vittoria,
                bonus_gol, bonus_assist, malus_ammonizione, malus_espulsione,
                malus_gol_subito, malus_autogol, bonus_rigore_parato, malus_rigore_sbagliato,
                soglia_gol, step_fascia
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, imp.getIdLega());
            ps.setInt(2, imp.getBudgetIniziale());
            ps.setInt(3, imp.getMaxCalciatori());
            ps.setBoolean(4, imp.isMercatoScambiAperto());
            ps.setBoolean(5, imp.isModificatoreDifesa());
            ps.setBoolean(6, imp.isPortaInviolata());
            ps.setBoolean(7, imp.isMvp());
            ps.setBoolean(8, imp.isGolVittoria());
            ps.setDouble(9, imp.getBonusGol());
            ps.setDouble(10, imp.getBonusAssist());
            ps.setDouble(11, imp.getMalusAmmonizione());
            ps.setDouble(12, imp.getMalusEspulsione());
            ps.setDouble(13, imp.getMalusGolSubito());
            ps.setDouble(14, imp.getMalusAutogol());
            ps.setDouble(15, imp.getBonusRigoreParato());
            ps.setDouble(16, imp.getMalusRigoreSbagliato());
            ps.setInt(17, imp.getSogliaGol());
            ps.setInt(18, imp.getStepFascia());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    imp.setId(rs.getLong(1));
                }
            }
            return imp;
        } catch (SQLException e) {
            throw new RuntimeException("Errore inserimento impostazioni lega", e);
        }
    }

    @Override
    public ImpostazioniLegaDTO getById(Long id) {
        String query = "SELECT * FROM impostazioni_lega WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToDTO(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura impostazioni per id", e);
        }
        return null;
    }

    @Override
    public ImpostazioniLegaDTO getByIdLega(Long idLega) {
        String query = "SELECT * FROM impostazioni_lega WHERE id_lega = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idLega);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToDTO(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura impostazioni per id_lega", e);
        }
        return null;
    }

    @Override
    public ImpostazioniLegaDTO updateImpostazioni(ImpostazioniLegaDTO imp) {
        String query = """
            UPDATE impostazioni_lega SET
                budget_iniziale=?, max_calciatori=?, mercato_scambi_aperto=?,
                modificatore_difesa=?, porta_inviolata=?, mvp=?, gol_vittoria=?,
                bonus_gol=?, bonus_assist=?, malus_ammonizione=?, malus_espulsione=?,
                malus_gol_subito=?, malus_autogol=?, bonus_rigore_parato=?, malus_rigore_sbagliato=?,
                soglia_gol=?, step_fascia=?
            WHERE id=?
        """;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, imp.getBudgetIniziale());
            ps.setInt(2, imp.getMaxCalciatori());
            ps.setBoolean(3, imp.isMercatoScambiAperto());
            ps.setBoolean(4, imp.isModificatoreDifesa());
            ps.setBoolean(5, imp.isPortaInviolata());
            ps.setBoolean(6, imp.isMvp());
            ps.setBoolean(7, imp.isGolVittoria());
            ps.setDouble(8, imp.getBonusGol());
            ps.setDouble(9, imp.getBonusAssist());
            ps.setDouble(10, imp.getMalusAmmonizione());
            ps.setDouble(11, imp.getMalusEspulsione());
            ps.setDouble(12, imp.getMalusGolSubito());
            ps.setDouble(13, imp.getMalusAutogol());
            ps.setDouble(14, imp.getBonusRigoreParato());
            ps.setDouble(15, imp.getMalusRigoreSbagliato());
            ps.setInt(16, imp.getSogliaGol());
            ps.setInt(17, imp.getStepFascia());
            ps.setLong(18, imp.getId()); // WHERE id = ?
            ps.executeUpdate();
            return imp;
        } catch (SQLException e) {
            throw new RuntimeException("Errore aggiornamento impostazioni", e);
        }
    }

    @Override
    public void resetToDefault(Long idLega) {
        String query = """
        UPDATE impostazioni_lega SET 
            budget_iniziale=500, max_calciatori=25, mercato_scambi_aperto=true,
            modificatore_difesa=false, porta_inviolata=false, mvp=false, gol_vittoria=false,
            bonus_gol=3.0, bonus_assist=1.0, malus_ammonizione=-0.5, malus_espulsione=-1.0,
            malus_gol_subito=-1.0, malus_autogol=-2.0, bonus_rigore_parato=3.0, malus_rigore_sbagliato=-3.0,
            soglia_gol=66, step_fascia=6
        WHERE id_lega=?
    """;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idLega);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore reset impostazioni", e);
        }
    }

    @Override
    public void setStatoMercato(Long idLega, boolean aperto) {
        String query = "UPDATE impostazioni_lega SET mercato_scambi_aperto = ? WHERE id_lega = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setBoolean(1, aperto);
            ps.setLong(2, idLega);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore aggiornamento stato mercato", e);
        }
    }

    @Override
    public void deleteImpostazioni(Long id) {
        String query = "DELETE FROM impostazioni_lega WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore eliminazione impostazioni", e);
        }
    }

    private ImpostazioniLegaDTO mapRowToDTO(ResultSet rs) throws SQLException {
        ImpostazioniLegaDTO imp = new ImpostazioniLegaDTO();
        imp.setId(rs.getLong("id"));
        imp.setIdLega(rs.getLong("id_lega"));
        imp.setBudgetIniziale(rs.getInt("budget_iniziale"));
        imp.setMaxCalciatori(rs.getInt("max_calciatori"));
        imp.setMercatoScambiAperto(rs.getBoolean("mercato_scambi_aperto"));
        imp.setModificatoreDifesa(rs.getBoolean("modificatore_difesa"));
        imp.setPortaInviolata(rs.getBoolean("porta_inviolata"));
        imp.setMvp(rs.getBoolean("mvp"));
        imp.setGolVittoria(rs.getBoolean("gol_vittoria"));
        imp.setBonusGol(rs.getDouble("bonus_gol"));
        imp.setBonusAssist(rs.getDouble("bonus_assist"));
        imp.setMalusAmmonizione(rs.getDouble("malus_ammonizione"));
        imp.setMalusEspulsione(rs.getDouble("malus_espulsione"));
        imp.setMalusGolSubito(rs.getDouble("malus_gol_subito"));
        imp.setMalusAutogol(rs.getDouble("malus_autogol"));
        imp.setBonusRigoreParato(rs.getDouble("bonus_rigore_parato"));
        imp.setMalusRigoreSbagliato(rs.getDouble("malus_rigore_sbagliato"));
        imp.setSogliaGol(rs.getInt("soglia_gol"));
        imp.setStepFascia(rs.getInt("step_fascia"));
        return imp;
    }
}