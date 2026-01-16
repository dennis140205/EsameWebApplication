package com.example.progettowebapplication.dao;

import com.example.progettowebapplication.model.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FantasquadraDaoJDBC implements IFantasquadraDAO{
    private Connection connection;

    public FantasquadraDaoJDBC(Connection connection) {
        this.connection = connection;
    }
    public void insertFantasquadrainDB(FantasquadraDTO fantasquadra){
        String query="INSERT INTO public.fantasquadra(id_utente,id_lega,nome_fantasquadra,is_admin,crediti_residui,punteggio_classifica_fantasquadra) VALUES (?,?,?,?,?,?)";
        try(PreparedStatement ps=connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)){
            ps.setLong(1,fantasquadra.getIdUtente());
            ps.setLong(2,fantasquadra.getIdLega());
            ps.setString(3,fantasquadra.getNomeFantasquadra());
            ps.setBoolean(4,fantasquadra.isAdmin());
            ps.setInt(5,fantasquadra.getCreditiResidui());
            ps.setInt(6,fantasquadra.getPunteggioClassificaFantasquadra());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore inserimento fantasquadra"+ e.getMessage(), e);
        }

    }


    public List<CalciatoreDTO> getRosaFantasquadra(Long id_fantasquadra){
        List<CalciatoreDTO> lista=new ArrayList<>();
        String query="SELECT c.* FROM calciatori c " +
                "JOIN acquisti a ON c.id = a.id_calciatore " +
                "WHERE a.id_fantasquadra = ?";
        try(PreparedStatement ps=connection.prepareStatement(query)){
            ps.setLong(1,id_fantasquadra);
            try(ResultSet rs=ps.executeQuery()){
                while(rs.next()){
                    CalciatoreDTO c=new CalciatoreDTO();
                    c.setId(rs.getLong("id"));
                    c.setNome(rs.getString("nome"));
                    String ruoloString = rs.getString("ruolo");
                    if (ruoloString != null) {
                        c.setRuolo(Ruolo.valueOf(ruoloString));
                    }
                    c.setSquadra(rs.getString("squadra"));
                    c.setQuotazione(rs.getInt("quotazione"));
                    c.setCodiceApi(rs.getInt("codice_api"));
                    String statoCalc=rs.getString("stato");
                    if(statoCalc!=null){
                        c.setStato(StatoCalciatore.valueOf(statoCalc));
                    }
                    c.setUrlImmagine(rs.getString("url_immagine"));
                    lista.add(c);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return lista;
    }

    public void updateCrediti(Long id_fantasquad,int nuoviCrediti){
        String query="UPDATE public.fantasquadra SET crediti_residui=? WHERE id_fantasquadra=?";
        try(PreparedStatement ps=connection.prepareStatement(query)){
            ps.setInt(1,nuoviCrediti);
            ps.setLong(2,id_fantasquad);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore aggiornamento crediti",e);
        }
    }
    public int RosaAlCompleto(Long id_fantasquad){
        String query="Select count(*) from acquisti where id_fantasquadra=?";
        try(PreparedStatement ps=connection.prepareStatement(query)){
            ps.setLong(1,id_fantasquad);
            try(ResultSet rs=ps.executeQuery()){
                if(rs.next()){
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Errore conteggio rosa",e);
        }
        return 0;
    }
    public void deleteFantasquadra(Long idFantasquadra) {
        // Controllo preventivo: la squadra è un admin?
        String sqlCheckAdmin = "SELECT is_admin FROM fantasquadra WHERE id_fantasquadra = ?";
        try {
            // Verifica il ruolo prima di iniziare la transazione
            try (PreparedStatement psCheck = connection.prepareStatement(sqlCheckAdmin)) {
                psCheck.setLong(1, idFantasquadra);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        boolean isAdmin = rs.getBoolean("is_admin");
                        if (isAdmin) {
                            // Impedisce l'eliminazione se è l'amministratore
                            throw new SQLException("Un amministratore non può abbandonare la lega. Deve prima nominare un altro admin o chiudere la lega.");
                        }
                    }
                }
            }

            connection.setAutoCommit(false);
            // Elimina gli acquisti (svincola i giocatori)
            String sqlAcquisti = "DELETE FROM acquisti WHERE id_fantasquadra = ?";
            try (PreparedStatement ps1 = connection.prepareStatement(sqlAcquisti)) {
                ps1.setLong(1, idFantasquadra);
                ps1.executeUpdate();
            }
            // Elimina gli scambi (sia come proponente che come ricevente)
            String sqlScambi = "DELETE FROM scambi WHERE id_fantasquadra_proponente = ? OR id_fantasquadra_ricevente = ?";
            try (PreparedStatement psScambi = connection.prepareStatement(sqlScambi)) {
                psScambi.setLong(1, idFantasquadra);
                psScambi.setLong(2, idFantasquadra);
                psScambi.executeUpdate();
            }
            // Elimina partite dal calendario
            String sqlCalendario = "DELETE FROM calendario WHERE id_squadra_casa = ? OR id_squadra_trasferta = ?";
            try (PreparedStatement psCal = connection.prepareStatement(sqlCalendario)) {
                psCal.setLong(1, idFantasquadra);
                psCal.setLong(2, idFantasquadra);
                psCal.executeUpdate();
            }
            // Elimina storico punteggi
            String sqlPunteggi = "DELETE FROM punteggi_giornata WHERE id_fantasquadra = ?";
            try (PreparedStatement psPun = connection.prepareStatement(sqlPunteggi)) {
                psPun.setLong(1, idFantasquadra);
                psPun.executeUpdate();
            }
            // Infine, elimina la squadra effettiva
            String sqlSquadra = "DELETE FROM fantasquadra WHERE id_fantasquadra = ?";
            try (PreparedStatement ps2 = connection.prepareStatement(sqlSquadra)) {
                ps2.setLong(1, idFantasquadra);
                ps2.executeUpdate();
            }
            connection.commit();
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            throw new RuntimeException("Errore durante l'abbandono della lega: " + e.getMessage(), e);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Restituisce tutte le squadre di una determinata lega
    @Override
    public List<FantasquadraDTO> getByLega(Long id_lega) {
        List<FantasquadraDTO> lista = new ArrayList<>();
        String query = "SELECT * FROM fantasquadra WHERE id_lega = ?";
        try(PreparedStatement ps = connection.prepareStatement(query)){
            ps.setLong(1, id_lega);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FantasquadraProxy f = new FantasquadraProxy();
                    f.setIdFantasquadra(rs.getLong("id_fantasquadra"));
                    f.setIdUtente(rs.getLong("id_utente"));
                    f.setIdLega(rs.getLong("id_lega"));
                    f.setAdmin(rs.getBoolean("is_admin"));
                    f.setCreditiResidui(rs.getInt("crediti_residui"));
                    f.setNomeFantasquadra(rs.getString("nome_fantasquadra"));
                    f.setPunteggioClassificaFantasquadra(rs.getInt("punteggio_classifica_fantasquadra"));
                    lista.add(f);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return lista;
    }

    @Override
    public FantasquadraDTO getFantasquadraById(Long id) {
        String query = "SELECT * FROM fantasquadra WHERE id_fantasquadra = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    FantasquadraProxy f = new FantasquadraProxy();
                    f.setIdFantasquadra(rs.getLong("id_fantasquadra"));
                    f.setIdUtente(rs.getLong("id_utente"));
                    f.setIdLega(rs.getLong("id_lega"));
                    f.setAdmin(rs.getBoolean("is_admin"));
                    f.setCreditiResidui(rs.getInt("crediti_residui"));
                    f.setNomeFantasquadra(rs.getString("nome_fantasquadra"));
                    f.setPunteggioClassificaFantasquadra(rs.getInt("punteggio_classifica_fantasquadra"));
                    return f;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura fantasquadra per id", e);
        }
        return null;
    }

    @Override
    public FantasquadraDTO getByUtenteAndLega(Long idUtente, Long idLega) {
        String query = "SELECT * FROM fantasquadra WHERE id_utente = ? AND id_lega = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idUtente);
            ps.setLong(2, idLega);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    FantasquadraProxy f = new FantasquadraProxy();
                    f.setIdFantasquadra(rs.getLong("id_fantasquadra"));
                    f.setIdUtente(rs.getLong("id_utente"));
                    f.setIdLega(rs.getLong("id_lega"));
                    f.setAdmin(rs.getBoolean("is_admin"));
                    f.setCreditiResidui(rs.getInt("crediti_residui"));
                    f.setNomeFantasquadra(rs.getString("nome_fantasquadra"));
                    f.setPunteggioClassificaFantasquadra(rs.getInt("punteggio_classifica_fantasquadra"));
                    return f;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore ricerca squadra utente/lega", e);
        }
        return null;
    }

    // Aggiorna la classifica di una determinata fantasquadra
    @Override
    public void aggiornaClassifica(Long idFantasquadra, int puntiFatti, int golFatti, int golSubiti, double fantaPuntiGiornata, int incrementoGiornata) {
        // Somma i nuovi valori a quelli esistenti
        String query = """
        UPDATE fantasquadra SET 
            punteggio_classifica_fantasquadra = punteggio_classifica_fantasquadra + ?,
            gol_fatti_totali = gol_fatti_totali + ?,
            gol_subiti_totali = gol_subiti_totali + ?,
            somma_punteggi = somma_punteggi + ?,
            giornate_giocate = giornate_giocate + ?
        WHERE id_fantasquadra = ?
    """;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, puntiFatti);
            ps.setInt(2, golFatti);
            ps.setInt(3, golSubiti);
            ps.setDouble(4, fantaPuntiGiornata);
            ps.setInt(5, incrementoGiornata); // +1 o -1
            ps.setLong(6, idFantasquadra);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore aggiornamento classifica fantasquadra", e);
        }
    }

    // Restituisce la classifica di una determinata lega
    @Override
    public List<FantasquadraDTO> getClassifica(Long idLega) {
        List<FantasquadraDTO> lista = new ArrayList<>();
        // Ordina per punti classifica, poi per somma voti, poi per gol fatti
        String query = """
        SELECT * FROM fantasquadra
        WHERE id_lega = ?
        ORDER BY punteggio_classifica_fantasquadra DESC, somma_punteggi DESC, gol_fatti_totali DESC
    """;
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setLong(1, idLega);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FantasquadraProxy f = new FantasquadraProxy();
                    f.setIdFantasquadra(rs.getLong("id_fantasquadra"));
                    f.setIdUtente(rs.getLong("id_utente"));
                    f.setIdLega(rs.getLong("id_lega"));
                    f.setCreditiResidui(rs.getInt("crediti_residui"));
                    f.setNomeFantasquadra(rs.getString("nome_fantasquadra"));
                    f.setPunteggioClassificaFantasquadra(rs.getInt("punteggio_classifica_fantasquadra"));
                    f.setGolFattiTotali(rs.getInt("gol_fatti_totali"));
                    f.setGolSubitiTotali(rs.getInt("gol_subiti_totali"));
                    f.setSommaPunteggi(rs.getDouble("somma_punteggi"));
                    f.setGiornateGiocate(rs.getInt("giornate_giocate"));
                    f.setAdmin(rs.getBoolean("is_admin"));
                    lista.add(f);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura classifica", e);
        }
        return lista;
    }

    // Recupera tutte le fantasquadre del sistema
    public List<FantasquadraDTO> getAllFantasquadre() {
        List<FantasquadraDTO> lista = new ArrayList<>();
        String query = "SELECT * FROM fantasquadra";
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                FantasquadraProxy f = new FantasquadraProxy();
                f.setIdFantasquadra(rs.getLong("id_fantasquadra"));
                f.setIdUtente(rs.getLong("id_utente"));
                f.setIdLega(rs.getLong("id_lega"));
                f.setAdmin(rs.getBoolean("is_admin"));
                f.setCreditiResidui(rs.getInt("crediti_residui"));
                f.setNomeFantasquadra(rs.getString("nome_fantasquadra"));
                f.setPunteggioClassificaFantasquadra(rs.getInt("punteggio_classifica_fantasquadra"));
                lista.add(f);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore lettura tutte squadre", e);
        }
        return lista;
    }

}
