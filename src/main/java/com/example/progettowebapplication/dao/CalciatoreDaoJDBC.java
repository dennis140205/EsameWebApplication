package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CalciatoreDaoJDBC implements ICalciatoreDAO {

    private Connection connection;

    public CalciatoreDaoJDBC(Connection connection) {
        this.connection = connection;
    }

    @Override
    public void insertCalciatore(CalciatoreDTO c) {
        String query = "INSERT INTO calciatori (nome, ruolo, squadra, quotazione, codice_api, stato, url_immagine) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getNome());
            ps.setString(2, c.getRuolo().name()); // Salvo l'Enum come stringa
            ps.setString(3, c.getSquadra());
            ps.setInt(4, c.getQuotazione());
            if (c.getCodiceApi() != null) ps.setInt(5, c.getCodiceApi()); else ps.setNull(5, Types.INTEGER);
            // Se lo stato è null, mette DISPONIBILE di default
            ps.setString(6, c.getStato() != null ? c.getStato().name() : StatoCalciatore.DISPONIBILE.name());
            ps.setString(7, c.getUrlImmagine());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) c.setId(rs.getLong(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore inserimento calciatore", e);
        }
    }

    @Override
    public List<CalciatoreDTO> getAllCalciatori() {
        List<CalciatoreDTO> lista = new ArrayList<>();
        String query = "SELECT * FROM calciatori";
        try (Statement st = connection.createStatement();
             ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) {
                lista.add(mapRowToDTO(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura calciatori", e);
        }
        return lista;
    }

    @Override
    public CalciatoreDTO getCalciatoreById(Long id) {
        String query = "SELECT * FROM calciatori WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToDTO(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore by ID", e);
        }
        return null; // Nessun calciatore trovato
    }

    @Override
    public List<CalciatoreDTO> getCalciatoriByRuolo(String ruolo) {
        List<CalciatoreDTO> lista = new ArrayList<>();
        String query = "SELECT * FROM calciatori WHERE ruolo = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, ruolo);
            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) lista.add(mapRowToDTO(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore by Ruolo", e);
        }
        return lista;
    }

    @Override
    public CalciatoreDTO getCalciatoreByCodiceApi(Integer codiceApi) {
        // Cerca usando il codice del file csv
        String query = "SELECT * FROM calciatori WHERE codice_api = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, codiceApi);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToDTO(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore ricerca by codiceApi", e);
        }
        return null;
    }

    @Override
    public CalciatoreDTO getCalciatoreByNome(String nome) {
        // Usa LOWER per ignorare maiuscole/minuscole nella ricerca
        String query = "SELECT * FROM calciatori WHERE LOWER(nome) = LOWER(?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, nome);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToDTO(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore ricerca per nome", e);
        }
        return null;
    }

    @Override
    public void updateCalciatore(CalciatoreDTO c) {
        // Aggiorna l'anagrafica
        String query = "UPDATE calciatori SET nome=?, ruolo=?, squadra=?, quotazione=?, codice_api=?, stato=?, url_immagine=? WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, c.getNome());
            ps.setString(2, c.getRuolo().name());
            ps.setString(3, c.getSquadra());
            ps.setInt(4, c.getQuotazione());
            if (c.getCodiceApi() != null){
                ps.setInt(5, c.getCodiceApi());
            }
            else{
                ps.setNull(5, Types.INTEGER);
            }
            ps.setString(6, c.getStato().name());
            ps.setString(7, c.getUrlImmagine());
            ps.setLong(8, c.getId());

            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore update calciatore", e);
        }
    }

    @Override
    public void inserisciStatistica(StatisticaDTO s) {
        String query = "INSERT INTO statistiche (id_calciatore, giornata, voto, gol_fatti, gol_subiti, rigori_parati, rigori_sbagliati, autogol, assist, ammonizione, espulsione) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, s.getIdCalciatore());
            ps.setInt(2, s.getGiornata());
            if (s.getVoto() != null) ps.setDouble(3, s.getVoto());
            else ps.setNull(3, Types.DOUBLE);
            ps.setInt(4, s.getGolFatti());
            ps.setInt(5, s.getGolSubiti());
            ps.setInt(6, s.getRigoriParati());
            ps.setInt(7, s.getRigoriSbagliati());
            ps.setInt(8, s.getAutogol());
            ps.setInt(9, s.getAssist());
            ps.setBoolean(10, s.isAmmonizione());
            ps.setBoolean(11, s.isEspulsione());
            ps.executeUpdate();
        } catch (SQLException e) {
            // Gestione chiavi duplicate se si prova a caricare due volte la stessa giornata
            throw new RuntimeException("Errore inserimento statistica: " + e.getMessage(), e);
        }
    }

    @Override
    public void resetTuttiDisponibili() {
        String query = "UPDATE calciatori SET stato = 'DISPONIBILE'";
        try (Statement st = connection.createStatement()) {
            st.executeUpdate(query);
        } catch (SQLException e) {
            throw new RuntimeException("Errore reset stati", e);
        }
    }

    @Override
    public void deleteCalciatore(Long id) {
        String query = "DELETE FROM calciatori WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore delete calciatore", e);
        }
    }

    @Override
    public void deleteStatisticheByGiornata(int giornata) {
        String query = "DELETE FROM statistiche WHERE giornata = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, giornata);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore pulizia statistiche giornata " + giornata, e);
        }
    }

    @Override
    public List<StatisticaDTO> getStatisticheByCalciatore(Long idCalciatore) {
        List<StatisticaDTO> lista = new ArrayList<>();
        // Ordina per giornata crescente per avere lo storico ordinato
        String query = "SELECT * FROM statistiche WHERE id_calciatore = ? ORDER BY giornata ASC";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idCalciatore);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapRowToStatisticaDTO(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura statistiche calciatore", e);
        }
        return lista;
    }

    @Override
    public List<StatisticaDTO> getStatisticheByGiornata(int giornata) {
        List<StatisticaDTO> lista = new ArrayList<>();
        String query = "SELECT * FROM statistiche WHERE giornata = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, giornata);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapRowToStatisticaDTO(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura statistiche giornata", e);
        }
        return lista;
    }

    // Metodo per la tabella statistiche
    private StatisticaDTO mapRowToStatisticaDTO(ResultSet rs) throws SQLException {
        StatisticaDTO s = new StatisticaDTO();
        s.setId(rs.getLong("id"));
        s.setIdCalciatore(rs.getLong("id_calciatore"));
        s.setGiornata(rs.getInt("giornata"));
        double voto = rs.getDouble("voto");
        s.setVoto(rs.wasNull() ? null : voto);
        s.setGolFatti(rs.getInt("gol_fatti"));
        s.setGolSubiti(rs.getInt("gol_subiti"));
        s.setRigoriParati(rs.getInt("rigori_parati"));
        s.setRigoriSbagliati(rs.getInt("rigori_sbagliati"));
        s.setAutogol(rs.getInt("autogol"));
        s.setAssist(rs.getInt("assist"));
        s.setAmmonizione(rs.getBoolean("ammonizione"));
        s.setEspulsione(rs.getBoolean("espulsione"));
        return s;
    }

    // Metodo per convertire una riga del DB in oggetto java
    private CalciatoreDTO mapRowToDTO(ResultSet rs) throws SQLException {
        CalciatoreProxy c = new CalciatoreProxy();
        c.setId(rs.getLong("id"));
        c.setNome(rs.getString("nome"));
        c.setSquadra(rs.getString("squadra"));
        c.setQuotazione(rs.getInt("quotazione"));
        c.setCodiceApi(rs.getObject("codice_api") != null ? rs.getInt("codice_api") : null);
        c.setUrlImmagine(rs.getString("url_immagine"));
        // Conversione da stringa a Enum (se fallisce, usa valori di default)
        try { c.setRuolo(Ruolo.valueOf(rs.getString("ruolo"))); } catch (Exception e) { c.setRuolo(null); }
        try { c.setStato(StatoCalciatore.valueOf(rs.getString("stato"))); } catch (Exception e) { c.setStato(StatoCalciatore.DISPONIBILE); }
        return c;
    }
}