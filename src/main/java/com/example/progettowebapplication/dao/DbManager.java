package com.example.progettowebapplication.dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties; // Import fondamentale

public final class DbManager {

    private static DbManager instance = null;

    private DbManager() {}

    public static DbManager getInstance() {
        if (instance == null) {
            instance = new DbManager();
        }
        return instance;
    }

    private Connection con = null;
    private IUtenteDAO utenteDao = null;
    private ICalciatoreDAO calciatoreDao = null;
    private IImpostazioniLegaDAO impostazioniLegaDao = null;
    private IFantasquadraDAO fantasquadraDao = null;
    private IAcquistoDAO acquistoDao = null;
    private ILegaDAO legaDao = null;
    private IScambioDAO scambioDao = null;
    private IFormazioneDAO formazioneDao = null;
    private ICalendarioDAO calendarioDao = null;
    private IPunteggioGiornataDAO punteggioGiornataDao = null;

    public Connection getConnection() {
        if (con == null) {
            try {
                // Carica il file application.properties
                Properties prop = new Properties();
                try (InputStream input = getClass().getClassLoader().getResourceAsStream("application.properties")) {
                    if (input == null) {
                        throw new RuntimeException("Impossibile trovare application.properties");
                    }
                    prop.load(input);
                }
                String dbUrl = prop.getProperty("spring.datasource.url");
                String dbUser = prop.getProperty("spring.datasource.username");
                String dbPass = prop.getProperty("spring.datasource.password");
                con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            } catch (SQLException | IOException e) {
                throw new RuntimeException("Errore di connessione al DB", e);
            }
        }
        return con;
    }

    public IUtenteDAO getUtenteDao() {
        if (utenteDao == null) {
            utenteDao = new UtenteDaoJDBC(getConnection());
        }
        return utenteDao;
    }

    public ICalciatoreDAO getCalciatoreDao() {
        if (calciatoreDao == null) {
            calciatoreDao = new CalciatoreDaoJDBC(getConnection());
        }
        return calciatoreDao;
    }

    public IImpostazioniLegaDAO getImpostazioniLegaDao() {
        if (impostazioniLegaDao == null) {
            impostazioniLegaDao = new ImpostazioniLegaDaoJDBC(getConnection());
        }
        return impostazioniLegaDao;
    }

    public IFantasquadraDAO getFantasquadraDao() {
        if (fantasquadraDao == null) {
            fantasquadraDao = new FantasquadraDaoJDBC(getConnection());
        }
        return fantasquadraDao;
    }

    public IAcquistoDAO getAcquistoDao() {
        if (acquistoDao == null) {
            acquistoDao = new AcquistoDaoJDBC(getConnection());
        }
        return acquistoDao;
    }

    public ILegaDAO getLegaDao() {
        if (legaDao == null) {
            legaDao = new LegaDaoJDBC(getConnection());
        }
        return legaDao;
    }

    public IScambioDAO getScambioDao() {
        if (scambioDao == null) {
            scambioDao = new ScambioDaoJDBC(getConnection());
        }
        return scambioDao;
    }

    public IFormazioneDAO getFormazioneDao() {
        if (formazioneDao == null) {
            formazioneDao = new FormazioneDaoJDBC(getConnection());
        }
        return formazioneDao;
    }

    public ICalendarioDAO getCalendarioDao() {
        if (calendarioDao == null) {
            calendarioDao = new CalendarioDaoJDBC(getConnection());
        }
        return calendarioDao;
    }

    public IPunteggioGiornataDAO getPunteggioGiornataDao() {
        if (punteggioGiornataDao == null) {
            punteggioGiornataDao = new PunteggioGiornataDaoJDBC(getConnection());
        }
        return punteggioGiornataDao;
    }
}