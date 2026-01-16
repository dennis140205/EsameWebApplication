CREATE TABLE public.utenti (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome varchar NOT NULL,
    cognome varchar NOT NULL,
    email varchar NOT NULL UNIQUE,
    password varchar NOT NULL,
    ruolo VARCHAR(20) DEFAULT 'USER',
    squadra_preferita VARCHAR(255)
);
CREATE TABLE calciatori (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR NOT NULL,
    ruolo VARCHAR NOT NULL, -- P,D,C,A
    squadra VARCHAR NOT NULL,
    quotazione INT NOT NULL,
    codice_api INT UNIQUE, -- Il codice di Fantacalcio.it
    stato VARCHAR DEFAULT 'DISPONIBILE', -- DISPONIBILE, INFORTUNATO, SQUALIFICATO
    url_immagine VARCHAR(255)
);

-- Creazione della tabella storico (statistiche)
-- Contiene i voti e i bonus di ogni singola giornata per ogni giocatore
CREATE TABLE statistiche (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_calciatore bigint NOT NULL, -- Collegamento alla tabella calciatori
    giornata INT NOT NULL,         -- Numero della giornata
    voto DECIMAL(4, 2),            -- Voto in pagella. NULL se s.v.
    -- Dati per il calcolo (tutti default a 0)
    gol_fatti INT DEFAULT 0,
    gol_subiti INT DEFAULT 0,
    rigori_parati INT DEFAULT 0,
    rigori_sbagliati INT DEFAULT 0,
    autogol INT DEFAULT 0,
    assist INT DEFAULT 0,
    ammonizione BOOLEAN DEFAULT FALSE,
    espulsione BOOLEAN DEFAULT FALSE,
    -- Se si elimina un calciatore, cancella anche le sue statistiche
    CONSTRAINT fk_calciatore FOREIGN KEY (id_calciatore)
    REFERENCES calciatori(id) ON DELETE CASCADE,
    -- Impedisce di inserire due volte i voti dello stesso giocatore per la stessa giornata
    CONSTRAINT unique_voto_giornata UNIQUE (id_calciatore, giornata)
);
CREATE TABLE public.lega (
    id_lega SERIAL PRIMARY  KEY,
    nome_lega VARCHAR(100) NOT NULL,
    codice_invito VARCHAR(20) UNIQUE,
    numero_squadre INT DEFAULT 8
    );
CREATE TABLE public.impostazioni_lega (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_lega bigint NOT NULL UNIQUE,
    -- Configurazione generale
    budget_iniziale INT DEFAULT 500,
    max_calciatori INT DEFAULT 25,
    mercato_scambi_aperto BOOLEAN DEFAULT TRUE,
    -- Interruttori regole
    modificatore_difesa BOOLEAN DEFAULT FALSE,
    porta_inviolata BOOLEAN DEFAULT FALSE,
    mvp BOOLEAN DEFAULT FALSE,
    gol_vittoria BOOLEAN DEFAULT FALSE,
    -- Punteggi (Bonus/Malus)
    bonus_gol DECIMAL(3,1) DEFAULT 3.0,
    bonus_assist DECIMAL(3,1) DEFAULT 1.0,
    malus_ammonizione DECIMAL(3,1) DEFAULT -0.5,
    malus_espulsione DECIMAL(3,1) DEFAULT -1.0,
    malus_gol_subito DECIMAL(3,1) DEFAULT -1.0,
    malus_autogol DECIMAL(3,1) DEFAULT -2.0,
    bonus_rigore_parato DECIMAL(3,1) DEFAULT 3.0,
    malus_rigore_sbagliato DECIMAL(3,1) DEFAULT -3.0,
    -- Soglie
    soglia_gol INT DEFAULT 66,
    step_fascia INT DEFAULT 6,
    FOREIGN KEY (id_lega) REFERENCES lega(id_lega) ON DELETE CASCADE
);
CREATE TABLE public.fantasquadra (
    id_fantasquadra SERIAL PRIMARY KEY,
    id_utente BIGINT NOT NULL,
    id_lega BIGINT NOT NULL,
    is_admin BOOLEAN DEFAULT FALSE,
    crediti_residui INTEGER DEFAULT 0,
    nome_fantasquadra VARCHAR(255) NOT NULL,
    punteggio_classifica_fantasquadra INTEGER DEFAULT 0,
    giornate_giocate INT DEFAULT 0,
    gol_fatti_totali INT DEFAULT 0,
    gol_subiti_totali INT DEFAULT 0,
    somma_punteggi DOUBLE PRECISION DEFAULT 0,
    CONSTRAINT unq_utente_lega UNIQUE (id_utente, id_lega),
    CONSTRAINT fk_fantasquadra_utente FOREIGN KEY (id_utente) REFERENCES public.utenti(id) ON DELETE CASCADE,
    CONSTRAINT fk_fantasquadra_lega FOREIGN KEY (id_lega) REFERENCES public.lega(id_lega) ON DELETE CASCADE
);
CREATE TABLE public.acquisti (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_fantasquadra bigint NOT NULL,
    id_calciatore bigint NOT NULL,
    prezzo_acquisto INT NOT NULL CHECK (prezzo_acquisto > 0),
    data_acquisto TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Chiave esterna verso la tabella Fantasquadra
    CONSTRAINT fk_acquisti_fantasquadra FOREIGN KEY (id_fantasquadra)
    REFERENCES public.fantasquadra(id_fantasquadra) ON DELETE CASCADE,

    -- Chiave esterna verso la tabella Calciatori
    CONSTRAINT fk_acquisti_calciatore FOREIGN KEY (id_calciatore)
    REFERENCES public.calciatori(id) ON DELETE CASCADE,

    -- Vincolo di unicità: un giocatore non può essere comprato due volte dalla stessa squadra
    CONSTRAINT unique_giocatore_squadra UNIQUE (id_fantasquadra, id_calciatore)
);

CREATE TABLE scambi (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Chi propone
    id_fantasquadra_proponente bigint NOT NULL,
    id_calciatore_proposto bigint NOT NULL, -- Il giocatore che il proponente cede
    crediti_proponente int DEFAULT 0 CHECK (crediti_proponente >= 0), -- Soldi offerti (extra)
    -- Chi riceve
    id_fantasquadra_ricevente bigint NOT NULL,
    id_calciatore_richiesto bigint NOT NULL, -- Il giocatore che il proponente vuole
    crediti_ricevente int DEFAULT 0 CHECK (crediti_ricevente >= 0), -- Soldi richiesti (extra)

    stato VARCHAR(20) DEFAULT 'IN_ATTESA', -- Valori: 'IN_ATTESA', 'ACCETTATO', 'RIFIUTATO'
    data_proposta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    visto_ricevente BOOLEAN DEFAULT FALSE, -- FALSE = Nuovo scambio in arrivo (Mostra !)
    visto_proponente BOOLEAN DEFAULT TRUE,  -- TRUE = Ho appena inviato (Nascondi !)

    -- Foreign keys
    -- Collega alle fantasquadre
    CONSTRAINT fk_scambi_prop FOREIGN KEY (id_fantasquadra_proponente)
        REFERENCES fantasquadra(id_fantasquadra) ON DELETE CASCADE,
    CONSTRAINT fk_scambi_ric FOREIGN KEY (id_fantasquadra_ricevente)
        REFERENCES fantasquadra(id_fantasquadra) ON DELETE CASCADE,

    -- Collega ai calciatori
    CONSTRAINT fk_scambi_calc_prop FOREIGN KEY (id_calciatore_proposto)
        REFERENCES calciatori(id) ON DELETE CASCADE,
    CONSTRAINT fk_scambi_calc_ric FOREIGN KEY (id_calciatore_richiesto)
        REFERENCES calciatori(id) ON DELETE CASCADE,

    -- Vincoli logici
    -- Una squadra non può scambiare con se stessa
    CONSTRAINT check_squadre_diverse CHECK (id_fantasquadra_proponente <> id_fantasquadra_ricevente)
);

-- Memorizza le partite di ogni giornata
CREATE TABLE calendario (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_lega BIGINT NOT NULL,
    giornata INT NOT NULL,
    id_squadra_casa BIGINT NOT NULL,
    id_squadra_trasferta BIGINT NOT NULL,
    -- Risultati (saranno 0 all'inizio, poi aggiornati dopo il calcolo)
    gol_casa INT DEFAULT 0,
    gol_trasferta INT DEFAULT 0,
    fanta_punteggio_casa DOUBLE PRECISION DEFAULT 0,      -- Es. 72.5
    fanta_punteggio_trasferta DOUBLE PRECISION DEFAULT 0, -- Es. 66.0
    giocata BOOLEAN DEFAULT FALSE, -- Diventa TRUE quando si calcola la giornata
    FOREIGN KEY (id_squadra_casa) REFERENCES fantasquadra(id_fantasquadra),
    FOREIGN KEY (id_squadra_trasferta) REFERENCES fantasquadra(id_fantasquadra)
);

-- Lo storico dettagliato per ogni squadra
CREATE TABLE punteggi_giornata (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_fantasquadra BIGINT NOT NULL,
    giornata INT NOT NULL,
    punteggio_totale DOUBLE PRECISION, -- Il fantavoto (es. 72.5)
    gol_fatti INT,                     -- I gol "virtuali" calcolati con le fasce (es. 2)
    gol_subiti INT,                    -- I gol presi dall'avversario (es. 1)
    punti_classifica INT,              -- 3 (Vittoria), 1 (Pareggio), 0 (Sconfitta)
    FOREIGN KEY (id_fantasquadra) REFERENCES fantasquadra(id_fantasquadra)
);

-- Contiene i dati generali della giornata
CREATE TABLE formazioni (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_fantasquadra BIGINT NOT NULL,
    giornata INT NOT NULL,
    modulo VARCHAR(10) NOT NULL, -- Es. "3-4-3", "4-4-2"
    data_inserimento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Collegamento alla fantasquadra
    FOREIGN KEY (id_fantasquadra) REFERENCES fantasquadra(id_fantasquadra) ON DELETE CASCADE,
    -- Una squadra può inserire una sola formazione per giornata
    CONSTRAINT unique_formazione_giornata UNIQUE (id_fantasquadra, giornata)
);

-- I singoli giocatori inseriti nella formazione
CREATE TABLE schieramento (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_formazione BIGINT NOT NULL,
    id_calciatore BIGINT NOT NULL,
    stato VARCHAR(20) NOT NULL, -- 'TITOLARE' o 'PANCHINA'
    ordine INT NOT NULL,        -- 0 per titolari, 1-12 per panchinari (ordine di ingresso)
    ruolo_schierato VARCHAR(5), -- P, D, C, A (utile per controlli rapidi senza join)
    fanta_voto DECIMAL(4,2),
    -- Collegamenti
    FOREIGN KEY (id_formazione) REFERENCES formazioni(id) ON DELETE CASCADE,
    FOREIGN KEY (id_calciatore) REFERENCES calciatori(id) ON DELETE CASCADE
);