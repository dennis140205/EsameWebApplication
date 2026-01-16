--
-- PostgreSQL database dump
--

\restrict mgOJYc1KZMnF3bWLgyt008xsI2svOmUXZg87zApc4qcp80chuGXTZJao0GTOUhe

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-01-16 18:35:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 232 (class 1259 OID 16520)
-- Name: acquisti; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acquisti (
    id bigint NOT NULL,
    id_fantasquadra bigint NOT NULL,
    id_calciatore bigint NOT NULL,
    prezzo_acquisto integer NOT NULL,
    data_acquisto timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT acquisti_prezzo_acquisto_check CHECK ((prezzo_acquisto > 0))
);


ALTER TABLE public.acquisti OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16519)
-- Name: acquisti_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.acquisti ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.acquisti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 16406)
-- Name: calciatori; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.calciatori (
    id bigint NOT NULL,
    nome character varying NOT NULL,
    ruolo character varying NOT NULL,
    squadra character varying NOT NULL,
    quotazione integer NOT NULL,
    codice_api integer,
    stato character varying DEFAULT 'DISPONIBILE'::character varying,
    url_immagine character varying(255)
);


ALTER TABLE public.calciatori OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16405)
-- Name: calciatori_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.calciatori ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.calciatori_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 16584)
-- Name: calendario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.calendario (
    id bigint NOT NULL,
    id_lega bigint NOT NULL,
    giornata integer NOT NULL,
    id_squadra_casa bigint NOT NULL,
    id_squadra_trasferta bigint NOT NULL,
    gol_casa integer DEFAULT 0,
    gol_trasferta integer DEFAULT 0,
    fanta_punteggio_casa double precision DEFAULT 0,
    fanta_punteggio_trasferta double precision DEFAULT 0,
    giocata boolean DEFAULT false
);


ALTER TABLE public.calendario OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16583)
-- Name: calendario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.calendario ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.calendario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 16490)
-- Name: fantasquadra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fantasquadra (
    id_fantasquadra integer NOT NULL,
    id_utente bigint NOT NULL,
    id_lega bigint NOT NULL,
    is_admin boolean DEFAULT false,
    crediti_residui integer DEFAULT 0,
    nome_fantasquadra character varying(255) NOT NULL,
    punteggio_classifica_fantasquadra integer DEFAULT 0,
    giornate_giocate integer DEFAULT 0,
    gol_fatti_totali integer DEFAULT 0,
    gol_subiti_totali integer DEFAULT 0,
    somma_punteggi double precision DEFAULT 0
);


ALTER TABLE public.fantasquadra OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16489)
-- Name: fantasquadra_id_fantasquadra_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fantasquadra_id_fantasquadra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fantasquadra_id_fantasquadra_seq OWNER TO postgres;

--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 229
-- Name: fantasquadra_id_fantasquadra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fantasquadra_id_fantasquadra_seq OWNED BY public.fantasquadra.id_fantasquadra;


--
-- TOC entry 240 (class 1259 OID 16624)
-- Name: formazioni; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formazioni (
    id bigint NOT NULL,
    id_fantasquadra bigint NOT NULL,
    giornata integer NOT NULL,
    modulo character varying(10) NOT NULL,
    data_inserimento timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.formazioni OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16623)
-- Name: formazioni_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.formazioni ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.formazioni_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 16458)
-- Name: impostazioni_lega; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.impostazioni_lega (
    id bigint NOT NULL,
    id_lega bigint NOT NULL,
    budget_iniziale integer DEFAULT 500,
    max_calciatori integer DEFAULT 25,
    mercato_scambi_aperto boolean DEFAULT true,
    modificatore_difesa boolean DEFAULT false,
    porta_inviolata boolean DEFAULT false,
    mvp boolean DEFAULT false,
    gol_vittoria boolean DEFAULT false,
    bonus_gol numeric(3,1) DEFAULT 3.0,
    bonus_assist numeric(3,1) DEFAULT 1.0,
    malus_ammonizione numeric(3,1) DEFAULT '-0.5'::numeric,
    malus_espulsione numeric(3,1) DEFAULT '-1.0'::numeric,
    malus_gol_subito numeric(3,1) DEFAULT '-1.0'::numeric,
    malus_autogol numeric(3,1) DEFAULT '-2.0'::numeric,
    bonus_rigore_parato numeric(3,1) DEFAULT 3.0,
    malus_rigore_sbagliato numeric(3,1) DEFAULT '-3.0'::numeric,
    soglia_gol integer DEFAULT 66,
    step_fascia integer DEFAULT 6
);


ALTER TABLE public.impostazioni_lega OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16457)
-- Name: impostazioni_lega_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.impostazioni_lega ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.impostazioni_lega_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 16446)
-- Name: lega; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lega (
    id_lega integer NOT NULL,
    nome_lega character varying(100) NOT NULL,
    codice_invito character varying(20),
    numero_squadre integer DEFAULT 8
);


ALTER TABLE public.lega OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16445)
-- Name: lega_id_lega_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lega_id_lega_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lega_id_lega_seq OWNER TO postgres;

--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 225
-- Name: lega_id_lega_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lega_id_lega_seq OWNED BY public.lega.id_lega;


--
-- TOC entry 238 (class 1259 OID 16610)
-- Name: punteggi_giornata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.punteggi_giornata (
    id bigint NOT NULL,
    id_fantasquadra bigint NOT NULL,
    giornata integer NOT NULL,
    punteggio_totale double precision,
    gol_fatti integer,
    gol_subiti integer,
    punti_classifica integer
);


ALTER TABLE public.punteggi_giornata OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16609)
-- Name: punteggi_giornata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.punteggi_giornata ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.punteggi_giornata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 16544)
-- Name: scambi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scambi (
    id bigint NOT NULL,
    id_fantasquadra_proponente bigint NOT NULL,
    id_calciatore_proposto bigint NOT NULL,
    crediti_proponente integer DEFAULT 0,
    id_fantasquadra_ricevente bigint NOT NULL,
    id_calciatore_richiesto bigint NOT NULL,
    crediti_ricevente integer DEFAULT 0,
    stato character varying(20) DEFAULT 'IN_ATTESA'::character varying,
    data_proposta timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    visto_ricevente boolean DEFAULT false,
    visto_proponente boolean DEFAULT true,
    CONSTRAINT check_squadre_diverse CHECK ((id_fantasquadra_proponente <> id_fantasquadra_ricevente)),
    CONSTRAINT scambi_crediti_proponente_check CHECK ((crediti_proponente >= 0)),
    CONSTRAINT scambi_crediti_ricevente_check CHECK ((crediti_ricevente >= 0))
);


ALTER TABLE public.scambi OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16543)
-- Name: scambi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.scambi ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.scambi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 242 (class 1259 OID 16642)
-- Name: schieramento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schieramento (
    id bigint NOT NULL,
    id_formazione bigint NOT NULL,
    id_calciatore bigint NOT NULL,
    stato character varying(20) NOT NULL,
    ordine integer NOT NULL,
    ruolo_schierato character varying(5),
    fanta_voto numeric(4,2)
);


ALTER TABLE public.schieramento OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16641)
-- Name: schieramento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.schieramento ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.schieramento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 16422)
-- Name: statistiche; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statistiche (
    id bigint NOT NULL,
    id_calciatore bigint NOT NULL,
    giornata integer NOT NULL,
    voto numeric(4,2),
    gol_fatti integer DEFAULT 0,
    gol_subiti integer DEFAULT 0,
    rigori_parati integer DEFAULT 0,
    rigori_sbagliati integer DEFAULT 0,
    autogol integer DEFAULT 0,
    assist integer DEFAULT 0,
    ammonizione boolean DEFAULT false,
    espulsione boolean DEFAULT false
);


ALTER TABLE public.statistiche OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16421)
-- Name: statistiche_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.statistiche ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.statistiche_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 16390)
-- Name: utenti; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utenti (
    id bigint NOT NULL,
    nome character varying NOT NULL,
    cognome character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    ruolo character varying(20) DEFAULT 'USER'::character varying,
    squadra_preferita character varying(255)
);


ALTER TABLE public.utenti OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: utenti_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.utenti ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.utenti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4839 (class 2604 OID 16493)
-- Name: fantasquadra id_fantasquadra; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fantasquadra ALTER COLUMN id_fantasquadra SET DEFAULT nextval('public.fantasquadra_id_fantasquadra_seq'::regclass);


--
-- TOC entry 4820 (class 2604 OID 16449)
-- Name: lega id_lega; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lega ALTER COLUMN id_lega SET DEFAULT nextval('public.lega_id_lega_seq'::regclass);


--
-- TOC entry 5080 (class 0 OID 16520)
-- Dependencies: 232
-- Data for Name: acquisti; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.acquisti (id, id_fantasquadra, id_calciatore, prezzo_acquisto, data_acquisto) FROM stdin;
\.


--
-- TOC entry 5070 (class 0 OID 16406)
-- Dependencies: 222
-- Data for Name: calciatori; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.calciatori (id, nome, ruolo, squadra, quotazione, codice_api, stato, url_immagine) FROM stdin;
8	Falcone	P	Lecce	15	2134	DISPONIBILE	https://media.api-sports.io/football/players/56459.png
46	Samooja	P	Lecce	1	6523	DISPONIBILE	https://media.api-sports.io/football/players/156619.png
35	Radunovic	P	Cagliari	1	3	DISPONIBILE	https://media.api-sports.io/football/players/31601.png
11	Audero	P	Cremonese	13	761	DISPONIBILE	https://media.api-sports.io/football/players/30441.png
37	Nava	P	Cremonese	1	6505	DISPONIBILE	https://media.api-sports.io/football/players/342995.png
75	Terracciano F.	D	Cremonese	13	5812	DISPONIBILE	https://media.api-sports.io/football/players/264472.png
24	Guaita	P	Parma	4	5135	DISPONIBILE	https://media.api-sports.io/football/players/18835.png
29	Pessina Mas.	P	Bologna	2	7172	DISPONIBILE	\N
16	Suzuki	P	Parma	11	6641	DISPONIBILE	https://media.api-sports.io/football/players/199578.png
51	Nicolas	P	Pisa	1	2271	DISPONIBILE	https://media.api-sports.io/football/players/30792.png
14	Semper	P	Pisa	12	2861	DISPONIBILE	https://media.api-sports.io/football/players/30733.png
6	Butez	P	Como	15	6966	DISPONIBILE	https://media.api-sports.io/football/players/8574.png
36	Vigorito	P	Como	1	2809	DISPONIBILE	https://media.api-sports.io/football/players/31719.png
80	Kempf	D	Como	12	6893	DISPONIBILE	https://media.api-sports.io/football/players/26301.png
105	Valle	D	Como	9	6867	DISPONIBILE	https://media.api-sports.io/football/players/336560.png
92	Ostigard	D	Genoa	11	5750	DISPONIBILE	\N
3	Provedel	P	Lazio	17	2814	DISPONIBILE	https://media.api-sports.io/football/players/31037.png
54	Satalino	P	Sassuolo	1	2127	DISPONIBILE	https://media.api-sports.io/football/players/30518.png
1	Maignan	P	Milan	20	4312	DISPONIBILE	https://media.api-sports.io/football/players/22221.png
47	Terracciano	P	Milan	1	2815	DISPONIBILE	https://media.api-sports.io/football/players/30394.png
90	Bartesaghi	D	Milan	11	6496	DISPONIBILE	https://media.api-sports.io/football/players/374359.png
10	Caprile	P	Cagliari	13	4360	DISPONIBILE	https://media.api-sports.io/football/players/30731.png
96	Luperto	D	Cagliari	10	393	DISPONIBILE	https://media.api-sports.io/football/players/319.png
69	Palestra	D	Cagliari	16	6832	DISPONIBILE	https://media.api-sports.io/football/players/383018.png
21	Meret	P	Napoli	8	572	DISPONIBILE	https://media.api-sports.io/football/players/312.png
83	Buongiorno	D	Napoli	12	2724	DISPONIBILE	https://media.api-sports.io/football/players/31226.png
71	Spinazzola	D	Napoli	15	1852	DISPONIBILE	https://media.api-sports.io/football/players/862.png
19	Okoye	P	Udinese	10	6462	DISPONIBILE	https://media.api-sports.io/football/players/143648.png
27	Sava	P	Udinese	3	6842	DISPONIBILE	https://media.api-sports.io/football/players/197830.png
101	Solet	D	Udinese	10	6956	DISPONIBILE	https://media.api-sports.io/football/players/656.png
18	Leali	P	Genoa	10	188	DISPONIBILE	https://media.api-sports.io/football/players/31631.png
40	Sommariva	P	Genoa	1	219	DISPONIBILE	https://media.api-sports.io/football/players/31445.png
74	Martin	D	Genoa	13	2593	DISPONIBILE	https://media.api-sports.io/football/players/25914.png
7	Di Gregorio	P	Juventus	15	5876	DISPONIBILE	https://media.api-sports.io/football/players/30670.png
42	Pinsoglio	P	Juventus	1	1930	DISPONIBILE	https://media.api-sports.io/football/players/850.png
99	Cambiaso	D	Juventus	10	5520	DISPONIBILE	https://media.api-sports.io/football/players/127011.png
88	Kalulu	D	Juventus	11	4976	DISPONIBILE	https://media.api-sports.io/football/players/162188.png
2	Svilar	P	Roma	20	5841	DISPONIBILE	https://media.api-sports.io/football/players/556.png
52	Zelezny	P	Roma	1	7169	DISPONIBILE	https://media.api-sports.io/football/players/452423.png
100	Mancini	D	Roma	10	2296	DISPONIBILE	https://media.api-sports.io/football/players/30425.png
5	Carnesecchi	P	Atalanta	15	4431	DISPONIBILE	https://media.api-sports.io/football/players/30417.png
33	Sportiello	P	Atalanta	1	4	DISPONIBILE	https://media.api-sports.io/football/players/31069.png
93	Kossounou	D	Atalanta	10	5578	DISPONIBILE	https://media.api-sports.io/football/players/48119.png
20	Ravaglia F.	P	Bologna	9	2722	DISPONIBILE	https://media.api-sports.io/football/players/31098.png
28	Silvestri	P	Cremonese	3	2211	DISPONIBILE	https://media.api-sports.io/football/players/30498.png
85	Miranda J.	D	Bologna	11	4734	DISPONIBILE	https://media.api-sports.io/football/players/134.png
61	Lezzerini	P	Fiorentina	1	158	DISPONIBILE	https://media.api-sports.io/football/players/31352.png
17	De Gea	P	Fiorentina	10	2521	DISPONIBILE	https://media.api-sports.io/football/players/882.png
26	Israel	P	Torino	3	7179	DISPONIBILE	https://media.api-sports.io/football/players/56266.png
56	Popa	P	Torino	1	6210	DISPONIBILE	https://media.api-sports.io/football/players/42796.png
91	Maripan	D	Torino	11	4665	DISPONIBILE	https://media.api-sports.io/football/players/2553.png
58	Perilli	P	Verona	1	511	DISPONIBILE	https://media.api-sports.io/football/players/31383.png
62	Toniolo	P	Verona	1	7236	DISPONIBILE	https://media.api-sports.io/football/players/350539.png
65	Calligaris	P	Inter	1	7042	DISPONIBILE	https://media.api-sports.io/football/players/336707.png
30	Martinez Jo.	P	Inter	2	5116	DISPONIBILE	https://media.api-sports.io/football/players/46988.png
104	Akanji	D	Inter	10	4159	DISPONIBILE	https://media.api-sports.io/football/players/5.png
66	Dimarco	D	Inter	26	254	DISPONIBILE	https://media.api-sports.io/football/players/31010.png
81	Carlos Augusto	D	Inter	12	5877	DISPONIBILE	https://media.api-sports.io/football/players/10238.png
45	Fruchtl	P	Lecce	1	2401	DISPONIBILE	https://media.api-sports.io/football/players/495.png
146	Veiga D.	D	Lecce	6	6990	DISPONIBILE	https://media.api-sports.io/football/players/161702.png
115	Delprato	D	Parma	9	6664	DISPONIBILE	\N
147	Valenti	D	Parma	6	5307	DISPONIBILE	https://media.api-sports.io/football/players/520533.png
106	Barbieri	D	Cremonese	9	6013	DISPONIBILE	https://media.api-sports.io/football/players/126980.png
205	Faye	D	Cremonese	3	6870	DISPONIBILE	https://media.api-sports.io/football/players/237249.png
172	Folino	D	Cremonese	4	7130	DISPONIBILE	https://media.api-sports.io/football/players/385788.png
143	Britschgi	D	Parma	7	7255	DISPONIBILE	https://media.api-sports.io/football/players/499380.png
130	N'Dicka	D	Roma	8	4317	DISPONIBILE	\N
116	Valeri	D	Parma	9	5862	DISPONIBILE	https://media.api-sports.io/football/players/91358.png
129	Angori	D	Pisa	8	7143	DISPONIBILE	https://media.api-sports.io/football/players/302069.png
186	Bonfanti	D	Pisa	3	6444	DISPONIBILE	https://media.api-sports.io/football/players/341838.png
165	Canestrelli	D	Pisa	5	7139	DISPONIBILE	https://media.api-sports.io/football/players/91503.png
119	Diego Carlos	D	Como	9	4137	DISPONIBILE	https://media.api-sports.io/football/players/21090.png
189	Smolcic I.	D	Como	3	7014	DISPONIBILE	https://media.api-sports.io/football/players/14266.png
171	Moreno Alb.	D	Como	4	5435	DISPONIBILE	\N
173	Pezzella Giu.	D	Cremonese	4	770	DISPONIBILE	\N
144	Pellegrini Lu.	D	Lazio	6	2728	DISPONIBILE	https://media.api-sports.io/football/players/30554.png
176	Provstgaard	D	Lazio	4	7012	DISPONIBILE	https://media.api-sports.io/football/players/350857.png
145	Tavares N.	D	Lazio	6	5620	DISPONIBILE	https://media.api-sports.io/football/players/41577.png
199	Candè	D	Sassuolo	3	6985	DISPONIBILE	https://media.api-sports.io/football/players/41371.png
150	Doig	D	Sassuolo	6	5851	DISPONIBILE	https://media.api-sports.io/football/players/135526.png
149	Muharemovic	D	Sassuolo	6	7155	DISPONIBILE	https://media.api-sports.io/football/players/271350.png
184	Athekame	D	Milan	4	7211	DISPONIBILE	https://media.api-sports.io/football/players/396380.png
193	De Winter	D	Milan	3	5739	DISPONIBILE	https://media.api-sports.io/football/players/162141.png
111	Gabbia	D	Milan	9	4401	DISPONIBILE	https://media.api-sports.io/football/players/56473.png
122	Idrissi R.	D	Cagliari	8	7125	DISPONIBILE	https://media.api-sports.io/football/players/383026.png
204	Rodriguez Ju.	D	Cagliari	3	7268	DISPONIBILE	https://media.api-sports.io/football/players/415155.png
112	Beukema	D	Napoli	9	6202	DISPONIBILE	https://media.api-sports.io/football/players/37604.png
113	Di Lorenzo	D	Napoli	9	2816	DISPONIBILE	https://media.api-sports.io/football/players/31042.png
196	Juan Jesus	D	Napoli	3	256	DISPONIBILE	https://media.api-sports.io/football/players/774.png
140	Rrahmani	D	Napoli	7	4409	DISPONIBILE	https://media.api-sports.io/football/players/1314.png
180	Ehizibue	D	Udinese	4	6047	DISPONIBILE	https://media.api-sports.io/football/players/36916.png
154	Kamara H.	D	Udinese	6	5555	DISPONIBILE	https://media.api-sports.io/football/players/22007.png
128	Zanoli	D	Udinese	8	5527	DISPONIBILE	https://media.api-sports.io/football/players/162907.png
197	Zemura	D	Udinese	3	6211	DISPONIBILE	https://media.api-sports.io/football/players/19824.png
135	Norton-Cuffy	D	Genoa	7	6814	DISPONIBILE	https://media.api-sports.io/football/players/284570.png
138	Gatti	D	Juventus	7	5831	DISPONIBILE	https://media.api-sports.io/football/players/268341.png
108	Kelly L.	D	Juventus	9	6766	DISPONIBILE	https://media.api-sports.io/football/players/19263.png
141	Angelino	D	Roma	7	4772	DISPONIBILE	https://media.api-sports.io/football/players/227.png
202	Tsimikas	D	Roma	3	5168	DISPONIBILE	https://media.api-sports.io/football/players/1600.png
156	Djimsiti	D	Atalanta	5	787	DISPONIBILE	https://media.api-sports.io/football/players/30421.png
207	Kolasinac	D	Atalanta	2	2640	DISPONIBILE	https://media.api-sports.io/football/players/1442.png
120	Zappacosta	D	Atalanta	8	554	DISPONIBILE	https://media.api-sports.io/football/players/2286.png
208	Casale	D	Bologna	2	5498	DISPONIBILE	https://media.api-sports.io/football/players/31099.png
121	Lucumì	D	Bologna	8	6042	DISPONIBILE	https://media.api-sports.io/football/players/1929.png
187	Vitik	D	Bologna	3	7068	DISPONIBILE	https://media.api-sports.io/football/players/287564.png
174	Comuzzo	D	Fiorentina	4	6495	DISPONIBILE	https://media.api-sports.io/football/players/396637.png
162	Fortini	D	Fiorentina	5	7069	DISPONIBILE	https://media.api-sports.io/football/players/437093.png
191	Parisi	D	Fiorentina	3	5449	DISPONIBILE	https://media.api-sports.io/football/players/136087.png
175	Pongracic	D	Fiorentina	4	5603	DISPONIBILE	https://media.api-sports.io/football/players/1084.png
107	Gosens	D	Fiorentina	9	2160	DISPONIBILE	https://media.api-sports.io/football/players/30422.png
151	Ismajli	D	Torino	6	5010	DISPONIBILE	https://media.api-sports.io/football/players/14329.png
168	Pedersen	D	Torino	5	6426	DISPONIBILE	https://media.api-sports.io/football/players/39362.png
170	Bella-Kotchap	D	Verona	5	7253	DISPONIBILE	https://media.api-sports.io/football/players/25061.png
155	Bradaric	D	Verona	6	5532	DISPONIBILE	https://media.api-sports.io/football/players/14327.png
169	Nelsson	D	Verona	5	7018	DISPONIBILE	https://media.api-sports.io/football/players/15912.png
182	Valentini N.	D	Verona	4	6957	DISPONIBILE	https://media.api-sports.io/football/players/311071.png
137	Bisseck	D	Inter	7	6217	DISPONIBILE	https://media.api-sports.io/football/players/24953.png
127	Gallo	D	Lecce	8	4502	DISPONIBILE	https://media.api-sports.io/football/players/31543.png
218	Kouassi	D	Lecce	2	7136	DISPONIBILE	https://media.api-sports.io/football/players/482309.png
220	Lovik	D	Parma	2	6965	DISPONIBILE	\N
224	Ndiaye	D	Parma	2	7202	DISPONIBILE	\N
227	Ziolkowski	D	Roma	2	7260	DISPONIBILE	\N
238	Perez M.	D	Lecce	1	7164	DISPONIBILE	https://media.api-sports.io/football/players/458543.png
286	Berisha M.	C	Lecce	15	6015	DISPONIBILE	https://media.api-sports.io/football/players/335071.png
235	Gigot	D	Lazio	1	5899	DISPONIBILE	\N
310	Sottil	C	Lecce	12	2839	DISPONIBILE	https://media.api-sports.io/football/players/31507.png
232	Sernicola	D	Cremonese	1	2847	DISPONIBILE	https://media.api-sports.io/football/players/30530.png
283	Vandeputte	C	Cremonese	15	7133	DISPONIBILE	https://media.api-sports.io/football/players/31211.png
226	Troilo	D	Parma	2	7235	DISPONIBILE	https://media.api-sports.io/football/players/428237.png
248	Schuurs	D	Torino	1	6041	DISPONIBILE	\N
241	Coppola F.	D	Pisa	1	7140	DISPONIBILE	https://media.api-sports.io/football/players/419603.png
255	Denoon	D	Pisa	1	7196	DISPONIBILE	https://media.api-sports.io/football/players/485960.png
221	Mateus Lusuardi	D	Pisa	2	6411	DISPONIBILE	https://media.api-sports.io/football/players/435548.png
230	Dossena	D	Como	1	6230	DISPONIBILE	https://media.api-sports.io/football/players/32034.png
211	Van Der Brempt	D	Como	2	6896	DISPONIBILE	https://media.api-sports.io/football/players/129119.png
261	Paz N.	C	Como	30	6875	DISPONIBILE	https://media.api-sports.io/football/players/350037.png
297	Gudmundsson A.	C	Fiorentina	13	5800	DISPONIBILE	\N
284	Basic	C	Lazio	15	5674	DISPONIBILE	https://media.api-sports.io/football/players/1266.png
292	Guendouzi	C	Lazio	14	4186	DISPONIBILE	https://media.api-sports.io/football/players/1454.png
285	Isaksen	C	Lazio	15	6398	DISPONIBILE	https://media.api-sports.io/football/players/135519.png
244	Odenthal	D	Sassuolo	1	7154	DISPONIBILE	https://media.api-sports.io/football/players/127802.png
245	Romagna	D	Sassuolo	1	2279	DISPONIBILE	https://media.api-sports.io/football/players/30556.png
281	Konè M.	C	Roma	16	5589	DISPONIBILE	https://media.api-sports.io/football/players/328046.png
314	Thorstvedt	C	Sassuolo	11	5844	DISPONIBILE	https://media.api-sports.io/football/players/39143.png
308	Fadera	C	Sassuolo	12	6815	DISPONIBILE	https://media.api-sports.io/football/players/263699.png
313	Fofana Y.	C	Milan	11	4686	DISPONIBILE	https://media.api-sports.io/football/players/22254.png
268	Modric	C	Milan	20	2606	DISPONIBILE	https://media.api-sports.io/football/players/754.png
273	Rabiot	C	Milan	18	2379	DISPONIBILE	https://media.api-sports.io/football/players/272.png
271	Saelemaekers	C	Milan	19	4892	DISPONIBILE	https://media.api-sports.io/football/players/1417.png
210	Di Pardo	D	Cagliari	2	5406	DISPONIBILE	https://media.api-sports.io/football/players/56287.png
304	Gaetano	C	Cagliari	12	4364	DISPONIBILE	https://media.api-sports.io/football/players/325.png
240	Mazzocchi	D	Napoli	1	5481	DISPONIBILE	https://media.api-sports.io/football/players/31390.png
264	De Bruyne	C	Napoli	24	2517	DISPONIBILE	https://media.api-sports.io/football/players/629.png
265	McTominay	C	Napoli	23	4777	DISPONIBILE	https://media.api-sports.io/football/players/903.png
250	Palma	D	Udinese	1	6925	DISPONIBILE	https://media.api-sports.io/football/players/422156.png
223	Rui Modesto	D	Udinese	2	6900	DISPONIBILE	https://media.api-sports.io/football/players/142442.png
214	Otoa	D	Genoa	2	6977	DISPONIBILE	https://media.api-sports.io/football/players/387128.png
215	Sabelli	D	Genoa	2	791	DISPONIBILE	https://media.api-sports.io/football/players/31137.png
298	Thorsby	C	Genoa	13	4404	DISPONIBILE	https://media.api-sports.io/football/players/36980.png
216	Rugani	D	Juventus	2	294	DISPONIBILE	https://media.api-sports.io/football/players/861.png
307	Locatelli	C	Juventus	12	827	DISPONIBILE	https://media.api-sports.io/football/players/30533.png
278	Conceicao	C	Juventus	16	6884	DISPONIBILE	https://media.api-sports.io/football/players/161585.png
295	Cristante	C	Roma	14	779	DISPONIBILE	https://media.api-sports.io/football/players/778.png
287	Konè I.	C	Sassuolo	15	6717	DISPONIBILE	https://media.api-sports.io/football/players/22147.png
296	Pasalic	C	Atalanta	13	2077	DISPONIBILE	https://media.api-sports.io/football/players/2763.png
312	Zalewski	C	Atalanta	11	5422	DISPONIBILE	https://media.api-sports.io/football/players/203474.png
269	Odgaard	C	Bologna	19	2765	DISPONIBILE	https://media.api-sports.io/football/players/30542.png
263	Orsolini	C	Bologna	27	2167	DISPONIBILE	https://media.api-sports.io/football/players/30488.png
228	Lamptey	D	Fiorentina	2	6351	DISPONIBILE	https://media.api-sports.io/football/players/138815.png
274	Mandragora	C	Fiorentina	17	1933	DISPONIBILE	https://media.api-sports.io/football/players/30810.png
222	Masina	D	Torino	2	49	DISPONIBILE	https://media.api-sports.io/football/players/18799.png
253	Ebosse	D	Verona	1	5994	DISPONIBILE	https://media.api-sports.io/football/players/20656.png
254	Oyegoke	D	Verona	1	6992	DISPONIBILE	https://media.api-sports.io/football/players/153408.png
225	Cham	D	Verona	2	7222	DISPONIBILE	https://media.api-sports.io/football/players/527889.png
233	Darmian	D	Inter	1	2525	DISPONIBILE	https://media.api-sports.io/football/players/887.png
270	Barella	C	Inter	19	1870	DISPONIBILE	https://media.api-sports.io/football/players/30558.png
299	Sucic P.	C	Inter	13	7070	DISPONIBILE	https://media.api-sports.io/football/players/348205.png
164	Gaspar K.	D	Lecce	5	6632	DISPONIBILE	https://media.api-sports.io/football/players/291589.png
402	Maleh	C	Lecce	3	5457	DISPONIBILE	https://media.api-sports.io/football/players/56560.png
418	Pierret	C	Lecce	2	6633	DISPONIBILE	https://media.api-sports.io/football/players/190958.png
333	Pierotti	C	Lecce	8	6549	DISPONIBILE	https://media.api-sports.io/football/players/6662.png
355	Bondo	C	Cremonese	6	5992	DISPONIBILE	https://media.api-sports.io/football/players/266813.png
375	Grassi	C	Cremonese	4	27	DISPONIBILE	https://media.api-sports.io/football/players/31021.png
325	Payero	C	Cremonese	9	6481	DISPONIBILE	https://media.api-sports.io/football/players/6383.png
343	Zerbin	C	Cremonese	7	5998	DISPONIBILE	https://media.api-sports.io/football/players/31219.png
405	Hernani	C	Parma	3	4423	DISPONIBILE	https://media.api-sports.io/football/players/1208.png
367	Ondrejka	C	Parma	5	6984	DISPONIBILE	https://media.api-sports.io/football/players/191979.png
404	Ordonez C.	C	Parma	3	7138	DISPONIBILE	https://media.api-sports.io/football/players/362752.png
373	Aebischer	C	Pisa	4	5784	DISPONIBILE	https://media.api-sports.io/football/players/951.png
337	Lorran	C	Pisa	8	7254	DISPONIBILE	https://media.api-sports.io/football/players/403300.png
390	Stengs	C	Pisa	4	5561	DISPONIBILE	https://media.api-sports.io/football/players/36910.png
320	Tourè I.	C	Pisa	10	7146	DISPONIBILE	https://media.api-sports.io/football/players/56293.png
406	Vural	C	Pisa	3	7150	DISPONIBILE	https://media.api-sports.io/football/players/364600.png
359	Sorensen O.	C	Parma	6	7209	DISPONIBILE	\N
382	Piccinini G.	C	Pisa	4	7145	DISPONIBILE	https://media.api-sports.io/football/players/325387.png
316	Caqueret	C	Como	10	5036	DISPONIBILE	https://media.api-sports.io/football/players/659.png
414	Sergi Roberto	C	Como	2	4284	DISPONIBILE	https://media.api-sports.io/football/players/137.png
378	Gronbaek	C	Genoa	4	6722	DISPONIBILE	\N
392	Nicolussi Caviglia	C	Fiorentina	4	4349	DISPONIBILE	\N
380	Rovella	C	Lazio	4	4459	DISPONIBILE	https://media.api-sports.io/football/players/30784.png
385	Iannoni	C	Sassuolo	4	7157	DISPONIBILE	https://media.api-sports.io/football/players/281291.png
315	Matic	C	Sassuolo	11	2528	DISPONIBILE	https://media.api-sports.io/football/players/902.png
323	Moro N.	C	Bologna	9	6054	DISPONIBILE	https://media.api-sports.io/football/players/31440.png
412	Sala A.	C	Lecce	3	7246	DISPONIBILE	https://media.api-sports.io/football/players/554588.png
347	Deiola	C	Cagliari	6	1871	DISPONIBILE	https://media.api-sports.io/football/players/30561.png
348	Prati	C	Cagliari	6	6424	DISPONIBILE	https://media.api-sports.io/football/players/309388.png
360	Elmas	C	Napoli	6	4479	DISPONIBILE	https://media.api-sports.io/football/players/1358.png
356	Lobotka	C	Napoli	6	4287	DISPONIBILE	https://media.api-sports.io/football/players/47439.png
326	Ekkelenkamp	C	Udinese	9	6684	DISPONIBILE	https://media.api-sports.io/football/players/541.png
371	Lovric	C	Udinese	5	5850	DISPONIBILE	https://media.api-sports.io/football/players/7591.png
379	Carboni V.	C	Genoa	4	6106	DISPONIBILE	https://media.api-sports.io/football/players/341646.png
318	Ellertsson	C	Genoa	10	6020	DISPONIBILE	https://media.api-sports.io/football/players/89520.png
349	Masini	C	Genoa	6	6917	DISPONIBILE	https://media.api-sports.io/football/players/281096.png
397	Messias	C	Genoa	3	4970	DISPONIBILE	https://media.api-sports.io/football/players/56396.png
353	Koopmeiners	C	Juventus	6	5685	DISPONIBILE	https://media.api-sports.io/football/players/36899.png
400	Miretti	C	Juventus	3	5813	DISPONIBILE	https://media.api-sports.io/football/players/181808.png
384	Baldanzi	C	Roma	4	5823	DISPONIBILE	https://media.api-sports.io/football/players/288769.png
357	El Aynaoui	C	Roma	6	6271	DISPONIBILE	https://media.api-sports.io/football/players/277003.png
369	El Shaarawy	C	Roma	5	795	DISPONIBILE	https://media.api-sports.io/football/players/791.png
339	Brescianini	C	Atalanta	7	4947	DISPONIBILE	https://media.api-sports.io/football/players/1639.png
394	Maldini	C	Atalanta	3	4896	DISPONIBILE	https://media.api-sports.io/football/players/134926.png
338	De Roon	C	Atalanta	7	22	DISPONIBILE	https://media.api-sports.io/football/players/30432.png
340	Freuler	C	Bologna	7	788	DISPONIBILE	https://media.api-sports.io/football/players/2807.png
341	Bernardeschi	C	Bologna	7	184	DISPONIBILE	https://media.api-sports.io/football/players/873.png
376	Fagioli	C	Fiorentina	4	4465	DISPONIBILE	https://media.api-sports.io/football/players/876.png
396	Ndour	C	Fiorentina	3	6294	DISPONIBILE	https://media.api-sports.io/football/players/311083.png
416	Sabiri	C	Fiorentina	2	5788	DISPONIBILE	https://media.api-sports.io/football/players/19053.png
366	Sohm	C	Fiorentina	5	5319	DISPONIBILE	https://media.api-sports.io/football/players/1014.png
399	Asllani	C	Torino	3	5719	DISPONIBILE	https://media.api-sports.io/football/players/275776.png
386	Gineitis	C	Torino	4	6170	DISPONIBILE	https://media.api-sports.io/football/players/343189.png
370	Tameze	C	Torino	5	4890	DISPONIBILE	https://media.api-sports.io/football/players/22174.png
391	Al-Musrati	C	Verona	4	7010	DISPONIBILE	https://media.api-sports.io/football/players/42006.png
345	Gagliardini	C	Verona	7	801	DISPONIBILE	https://media.api-sports.io/football/players/203.png
409	Harroui	C	Verona	3	5688	DISPONIBILE	https://media.api-sports.io/football/players/37437.png
411	Diouf	C	Inter	3	6274	DISPONIBILE	https://media.api-sports.io/football/players/270509.png
351	Mkhitaryan	C	Inter	6	2529	DISPONIBILE	https://media.api-sports.io/football/players/1457.png
237	Jean	D	Lecce	1	6883	DISPONIBILE	https://media.api-sports.io/football/players/23253.png
431	Rafia	C	Lecce	1	6222	DISPONIBILE	https://media.api-sports.io/football/players/136016.png
509	Camarda	A	Lecce	7	6519	DISPONIBILE	https://media.api-sports.io/football/players/436260.png
429	Valoti	C	Cremonese	1	2274	DISPONIBILE	https://media.api-sports.io/football/players/30875.png
433	Hojholt	C	Pisa	1	7147	DISPONIBILE	\N
522	De Luca	A	Cremonese	4	5512	DISPONIBILE	https://media.api-sports.io/football/players/31853.png
457	Vardy	A	Cremonese	20	2499	DISPONIBILE	https://media.api-sports.io/football/players/18788.png
523	Almqvist	A	Parma	4	6207	DISPONIBILE	https://media.api-sports.io/football/players/48193.png
502	Benedyczak	A	Parma	9	6667	DISPONIBILE	https://media.api-sports.io/football/players/40592.png
456	Pellegrino M.	A	Parma	20	7023	DISPONIBILE	https://media.api-sports.io/football/players/292172.png
446	Yildiz	A	Juventus	29	6434	DISPONIBILE	\N
517	Meister	A	Pisa	6	6836	DISPONIBILE	https://media.api-sports.io/football/players/331678.png
472	Nzola	A	Pisa	16	5336	DISPONIBILE	https://media.api-sports.io/football/players/31318.png
450	Hojlund	A	Napoli	24	6052	DISPONIBILE	\N
479	Addai	A	Como	14	7127	DISPONIBILE	https://media.api-sports.io/football/players/354533.png
463	Douvikas	A	Como	17	7017	DISPONIBILE	https://media.api-sports.io/football/players/26845.png
455	Castellanos	A	Lazio	20	6226	DISPONIBILE	\N
514	Kuhn	A	Como	6	7128	DISPONIBILE	https://media.api-sports.io/football/players/38753.png
495	N'Dri	A	Lecce	10	7001	DISPONIBILE	\N
492	Noslin	A	Lazio	11	6556	DISPONIBILE	https://media.api-sports.io/football/players/133729.png
453	Laurientè	A	Sassuolo	21	6060	DISPONIBILE	https://media.api-sports.io/football/players/2215.png
449	Berardi	A	Sassuolo	24	531	DISPONIBILE	https://media.api-sports.io/football/players/30537.png
467	Pinamonti	A	Sassuolo	17	2038	DISPONIBILE	https://media.api-sports.io/football/players/31094.png
486	Gimenez	A	Milan	12	7008	DISPONIBILE	https://media.api-sports.io/football/players/94562.png
485	Nkunku	A	Milan	13	4728	DISPONIBILE	https://media.api-sports.io/football/players/269.png
428	Liteta	C	Cagliari	1	7165	DISPONIBILE	https://media.api-sports.io/football/players/551413.png
438	Rog	C	Cagliari	1	2076	DISPONIBILE	https://media.api-sports.io/football/players/2055.png
478	Borrelli	A	Cagliari	14	6243	DISPONIBILE	https://media.api-sports.io/football/players/31499.png
520	Luvumbo	A	Cagliari	5	5297	DISPONIBILE	https://media.api-sports.io/football/players/140831.png
441	Vergara	C	Napoli	1	7223	DISPONIBILE	https://media.api-sports.io/football/players/347395.png
510	Lucca	A	Napoli	7	6215	DISPONIBILE	https://media.api-sports.io/football/players/199089.png
437	Miller L.	C	Udinese	1	7208	DISPONIBILE	https://media.api-sports.io/football/players/343558.png
525	Bayo V.	A	Udinese	4	7161	DISPONIBILE	https://media.api-sports.io/football/players/1134.png
497	Buksa	A	Udinese	10	7249	DISPONIBILE	https://media.api-sports.io/football/players/40594.png
452	Davis K.	A	Udinese	22	5637	DISPONIBILE	https://media.api-sports.io/football/players/19185.png
425	Onana J.	C	Genoa	2	6538	DISPONIBILE	https://media.api-sports.io/football/players/41748.png
426	Cornet	C	Genoa	2	4677	DISPONIBILE	https://media.api-sports.io/football/players/665.png
500	Ekuban	A	Genoa	9	5506	DISPONIBILE	https://media.api-sports.io/football/players/3430.png
430	Venturino	C	Genoa	1	6980	DISPONIBILE	https://media.api-sports.io/football/players/452033.png
480	David	A	Juventus	14	5544	DISPONIBILE	https://media.api-sports.io/football/players/8489.png
477	Openda	A	Juventus	15	6314	DISPONIBILE	https://media.api-sports.io/football/players/86.png
420	Pisilli	C	Roma	2	6190	DISPONIBILE	https://media.api-sports.io/football/players/356888.png
481	Dybala	A	Roma	14	309	DISPONIBILE	https://media.api-sports.io/football/players/875.png
459	De Ketelaere	A	Atalanta	18	5995	DISPONIBILE	https://media.api-sports.io/football/players/147859.png
462	Lookman	A	Atalanta	17	4730	DISPONIBILE	https://media.api-sports.io/football/players/18767.png
427	Sulemana I.	C	Bologna	1	6024	DISPONIBILE	https://media.api-sports.io/football/players/199837.png
484	Ferguson E.	A	Roma	13	6365	DISPONIBILE	https://media.api-sports.io/football/players/44814.png
458	Cambiaghi	A	Bologna	19	4436	DISPONIBILE	https://media.api-sports.io/football/players/30438.png
489	Dallinga	A	Bologna	11	6643	DISPONIBILE	https://media.api-sports.io/football/players/93016.png
504	Immobile	A	Bologna	8	785	DISPONIBILE	https://media.api-sports.io/football/players/1863.png
515	Dzeko	A	Fiorentina	6	647	DISPONIBILE	https://media.api-sports.io/football/players/790.png
505	Piccoli	A	Fiorentina	8	4359	DISPONIBILE	https://media.api-sports.io/football/players/30440.png
468	Adams C.	A	Torino	17	6646	DISPONIBILE	https://media.api-sports.io/football/players/19524.png
466	Simeone	A	Torino	17	2061	DISPONIBILE	https://media.api-sports.io/football/players/30414.png
434	Santiago	C	Verona	1	7177	DISPONIBILE	https://media.api-sports.io/football/players/364415.png
469	Giovane	A	Verona	17	7162	DISPONIBILE	https://media.api-sports.io/football/players/312615.png
435	Kastanos	C	Verona	1	2117	DISPONIBILE	https://media.api-sports.io/football/players/867.png
473	Orban G.	A	Verona	16	6552	DISPONIBILE	https://media.api-sports.io/football/players/368260.png
474	Bonny	A	Inter	15	6669	DISPONIBILE	https://media.api-sports.io/football/players/275651.png
444	Martinez L.	A	Inter	32	2764	DISPONIBILE	https://media.api-sports.io/football/players/217.png
529	Kilicsoy	A	Cagliari	3	7199	DISPONIBILE	\N
531	Djuric	A	Parma	2	5471	DISPONIBILE	\N
219	Ndaba	D	Lecce	2	7182	DISPONIBILE	https://media.api-sports.io/football/players/19738.png
530	Okereke	A	Cremonese	2	5515	DISPONIBILE	https://media.api-sports.io/football/players/30848.png
540	Frigan	A	Parma	1	7213	DISPONIBILE	https://media.api-sports.io/football/players/292543.png
541	Balentien	A	Milan	1	7262	DISPONIBILE	\N
43	Furlanetto	P	Lazio	1	6417	DISPONIBILE	https://media.api-sports.io/football/players/63934.png
44	Mandas	P	Lazio	1	6482	DISPONIBILE	https://media.api-sports.io/football/players/26644.png
125	Gila	D	Lazio	8	5833	DISPONIBILE	https://media.api-sports.io/football/players/162952.png
236	Hysaj	D	Lazio	1	140	DISPONIBILE	https://media.api-sports.io/football/players/317.png
110	Marusic	D	Lazio	9	2188	DISPONIBILE	https://media.api-sports.io/football/players/1844.png
217	Patric	D	Lazio	2	327	DISPONIBILE	https://media.api-sports.io/football/players/1841.png
126	Romagnoli	D	Lazio	8	460	DISPONIBILE	https://media.api-sports.io/football/players/1632.png
417	Belahyane	C	Lazio	2	6191	DISPONIBILE	https://media.api-sports.io/football/players/333116.png
301	Cataldi	C	Lazio	13	333	DISPONIBILE	https://media.api-sports.io/football/players/1852.png
363	Dele-Bashiru	C	Lazio	5	6629	DISPONIBILE	https://media.api-sports.io/football/players/144740.png
195	Lazzari	D	Lazio	3	2263	DISPONIBILE	https://media.api-sports.io/football/players/30866.png
362	Vecino	C	Lazio	5	181	DISPONIBILE	https://media.api-sports.io/football/players/211.png
267	Zaccagni	C	Lazio	20	632	DISPONIBILE	https://media.api-sports.io/football/players/30937.png
491	Cancellieri	A	Lazio	11	5500	DISPONIBILE	https://media.api-sports.io/football/players/286474.png
494	Dia	A	Lazio	10	5672	DISPONIBILE	https://media.api-sports.io/football/players/22015.png
229	Zè Pedro	D	Cagliari	2	7274	DISPONIBILE	https://media.api-sports.io/football/players/2299.png
15	Muric	P	Sassuolo	12	4236	DISPONIBILE	https://media.api-sports.io/football/players/616.png
55	Turati	P	Sassuolo	1	4867	DISPONIBILE	https://media.api-sports.io/football/players/30519.png
206	Coulibaly W.	D	Sassuolo	3	6665	DISPONIBILE	https://media.api-sports.io/football/players/128338.png
118	Idzes	D	Sassuolo	9	6672	DISPONIBILE	https://media.api-sports.io/football/players/37651.png
247	Pieragnolo	D	Sassuolo	1	7156	DISPONIBILE	https://media.api-sports.io/football/players/342055.png
142	Walukiewicz	D	Sassuolo	7	4374	DISPONIBILE	https://media.api-sports.io/football/players/40582.png
421	Boloca	C	Sassuolo	2	6219	DISPONIBILE	https://media.api-sports.io/football/players/291780.png
422	Lipani	C	Sassuolo	2	6246	DISPONIBILE	https://media.api-sports.io/football/players/343562.png
246	Paz Y.	D	Sassuolo	1	6431	DISPONIBILE	https://media.api-sports.io/football/players/59513.png
303	Volpato	C	Sassuolo	13	5735	DISPONIBILE	https://media.api-sports.io/football/players/342035.png
389	Vranckx	C	Sassuolo	4	5610	DISPONIBILE	https://media.api-sports.io/football/players/127413.png
518	Cheddira	A	Sassuolo	6	6439	DISPONIBILE	https://media.api-sports.io/football/players/128478.png
527	Pierini	A	Sassuolo	3	1842	DISPONIBILE	https://media.api-sports.io/football/players/30849.png
538	Skjellerup	A	Sassuolo	1	7159	DISPONIBILE	https://media.api-sports.io/football/players/264739.png
48	Torriani	P	Milan	1	6813	DISPONIBILE	https://media.api-sports.io/football/players/386298.png
177	Estupinan	D	Milan	4	5273	DISPONIBILE	https://media.api-sports.io/football/players/46731.png
258	Odogu	D	Milan	1	7271	DISPONIBILE	https://media.api-sports.io/football/players/394740.png
68	Pavlovic	D	Milan	17	5022	DISPONIBILE	https://media.api-sports.io/football/players/45826.png
139	Tomori	D	Milan	7	4751	DISPONIBILE	https://media.api-sports.io/football/players/19209.png
388	Jashari	C	Milan	4	7203	DISPONIBILE	https://media.api-sports.io/football/players/264705.png
302	Loftus-Cheek	C	Milan	13	4199	DISPONIBILE	https://media.api-sports.io/football/players/2292.png
294	Ricci S.	C	Milan	14	5453	DISPONIBILE	https://media.api-sports.io/football/players/31056.png
447	Leao	A	Milan	27	4510	DISPONIBILE	https://media.api-sports.io/football/players/22236.png
260	Pulisic	C	Milan	32	2423	DISPONIBILE	https://media.api-sports.io/football/players/17.png
34	Ciocci	P	Cagliari	1	4929	DISPONIBILE	https://media.api-sports.io/football/players/135863.png
97	Mina	D	Cagliari	10	4210	DISPONIBILE	https://media.api-sports.io/football/players/2484.png
159	Obert	D	Cagliari	5	5701	DISPONIBILE	https://media.api-sports.io/football/players/321744.png
516	Pedro	A	Lazio	6	2489	DISPONIBILE	https://media.api-sports.io/football/players/41964.png
133	Zappa	D	Cagliari	7	4461	DISPONIBILE	https://media.api-sports.io/football/players/200.png
361	Adopo	C	Cagliari	5	4870	DISPONIBILE	https://media.api-sports.io/football/players/30505.png
289	Felici	C	Cagliari	14	6640	DISPONIBILE	https://media.api-sports.io/football/players/31734.png
330	Folorunsho	C	Cagliari	8	6252	DISPONIBILE	https://media.api-sports.io/football/players/56851.png
436	Mazzitelli	C	Cagliari	1	1976	DISPONIBILE	https://media.api-sports.io/football/players/30780.png
498	Belotti	A	Cagliari	10	441	DISPONIBILE	https://media.api-sports.io/football/players/30509.png
534	Pavoletti	A	Cagliari	1	247	DISPONIBILE	https://media.api-sports.io/football/players/30573.png
532	Ambrosino	A	Napoli	2	7264	DISPONIBILE	https://media.api-sports.io/football/players/341912.png
542	Gueye	A	Udinese	1	7272	DISPONIBILE	https://media.api-sports.io/football/players/434410.png
543	Arena A.	A	Roma	1	7277	DISPONIBILE	https://media.api-sports.io/football/players/484027.png
528	Aboukhlal	A	Torino	3	7183	DISPONIBILE	https://media.api-sports.io/football/players/243.png
470	Esposito Se.	A	Cagliari	16	4463	DISPONIBILE	https://media.api-sports.io/football/players/215.png
49	Contini	P	Napoli	1	2845	DISPONIBILE	https://media.api-sports.io/football/players/32172.png
4	Milinkovic-Savic V.	P	Napoli	16	2170	DISPONIBILE	https://media.api-sports.io/football/players/31156.png
201	Gutierrez	D	Napoli	3	5427	DISPONIBILE	https://media.api-sports.io/football/players/162032.png
239	Marianucci	D	Napoli	1	6809	DISPONIBILE	https://media.api-sports.io/football/players/388547.png
178	Olivera	D	Napoli	4	5840	DISPONIBILE	https://media.api-sports.io/football/players/47254.png
266	Zambo Anguissa	C	Napoli	22	4220	DISPONIBILE	https://media.api-sports.io/football/players/3406.png
334	Gilmour	C	Napoli	8	5131	DISPONIBILE	https://media.api-sports.io/football/players/130423.png
279	Neres	C	Napoli	16	6831	DISPONIBILE	https://media.api-sports.io/football/players/552.png
483	Lang	A	Napoli	13	7120	DISPONIBILE	https://media.api-sports.io/football/players/544.png
476	Lukaku	A	Napoli	15	2531	DISPONIBILE	https://media.api-sports.io/football/players/907.png
319	Politano	C	Napoli	10	536	DISPONIBILE	https://media.api-sports.io/football/players/219.png
60	Nunziante	P	Udinese	1	7185	DISPONIBILE	https://media.api-sports.io/football/players/418940.png
57	Padelli	P	Udinese	1	543	DISPONIBILE	https://media.api-sports.io/football/players/189.png
153	Bertola	D	Udinese	6	5820	DISPONIBILE	https://media.api-sports.io/football/players/315249.png
198	Goglichidze	D	Udinese	3	6537	DISPONIBILE	https://media.api-sports.io/football/players/318053.png
78	Kabasele	D	Udinese	13	4263	DISPONIBILE	https://media.api-sports.io/football/players/18797.png
131	Kristensen T.	D	Udinese	8	6485	DISPONIBILE	https://media.api-sports.io/football/players/281495.png
282	Atta	C	Udinese	16	6908	DISPONIBILE	https://media.api-sports.io/football/players/347644.png
321	Karlstrom	C	Udinese	10	6680	DISPONIBILE	https://media.api-sports.io/football/players/48047.png
328	Piotrowski	C	Udinese	9	7198	DISPONIBILE	https://media.api-sports.io/football/players/1939.png
272	Zaniolo	C	Udinese	19	2766	DISPONIBILE	https://media.api-sports.io/football/players/786.png
423	Zarraga	C	Udinese	2	6212	DISPONIBILE	https://media.api-sports.io/football/players/182560.png
524	Bravo	A	Udinese	4	6653	DISPONIBILE	https://media.api-sports.io/football/players/330599.png
39	Siegrist	P	Genoa	1	6991	DISPONIBILE	https://media.api-sports.io/football/players/45083.png
76	Celik	D	Roma	13	4657	DISPONIBILE	https://media.api-sports.io/football/players/570213.png
192	Marcandalli	D	Genoa	3	6660	DISPONIBILE	https://media.api-sports.io/football/players/281826.png
59	Vasquez D.	P	Roma	1	6125	DISPONIBILE	https://media.api-sports.io/football/players/35544.png
440	Cuenca H.	C	Genoa	1	7025	DISPONIBILE	https://media.api-sports.io/football/players/382947.png
342	Frendrup	C	Genoa	7	5791	DISPONIBILE	https://media.api-sports.io/football/players/15881.png
305	Malinovskyi	C	Genoa	12	4427	DISPONIBILE	https://media.api-sports.io/football/players/1938.png
398	Stanciu	C	Genoa	3	7135	DISPONIBILE	https://media.api-sports.io/football/players/44439.png
508	Colombo	A	Genoa	8	4923	DISPONIBILE	https://media.api-sports.io/football/players/263481.png
507	Ekhator	A	Genoa	8	6822	DISPONIBILE	https://media.api-sports.io/football/players/451504.png
442	Fini	C	Genoa	1	6506	DISPONIBILE	https://media.api-sports.io/football/players/348533.png
490	Vitinha O.	A	Genoa	11	6164	DISPONIBILE	https://media.api-sports.io/football/players/281408.png
25	Perin	P	Juventus	3	218	DISPONIBILE	https://media.api-sports.io/football/players/849.png
87	Bremer	D	Juventus	11	2788	DISPONIBILE	https://media.api-sports.io/football/players/30497.png
109	Cabal	D	Juventus	9	6039	DISPONIBILE	https://media.api-sports.io/football/players/125674.png
194	Joao Mario	D	Juventus	3	7175	DISPONIBILE	https://media.api-sports.io/football/players/41734.png
234	Rouhi	D	Juventus	1	6803	DISPONIBILE	https://media.api-sports.io/football/players/335101.png
410	Adzic	C	Juventus	3	6677	DISPONIBILE	https://media.api-sports.io/football/players/339872.png
306	Kostic	C	Juventus	12	4711	DISPONIBILE	https://media.api-sports.io/football/players/1821.png
332	McKennie	C	Juventus	8	4973	DISPONIBILE	https://media.api-sports.io/football/players/415.png
291	Thuram K.	C	Juventus	14	5562	DISPONIBILE	https://media.api-sports.io/football/players/116.png
535	Milik	A	Juventus	1	2012	DISPONIBILE	https://media.api-sports.io/football/players/333.png
461	Vlahovic	A	Juventus	18	2841	DISPONIBILE	https://media.api-sports.io/football/players/30415.png
322	Zhegrova	C	Juventus	10	5761	DISPONIBILE	https://media.api-sports.io/football/players/48392.png
53	Gollini	P	Roma	1	610	DISPONIBILE	https://media.api-sports.io/football/players/30418.png
98	Vasquez	D	Genoa	10	5514	DISPONIBILE	https://media.api-sports.io/football/players/81012.png
251	Ghilardi	D	Roma	1	6631	DISPONIBILE	https://media.api-sports.io/football/players/342019.png
84	Hermoso	D	Roma	12	4807	DISPONIBILE	https://media.api-sports.io/football/players/2669.png
167	Rensch	D	Roma	5	6986	DISPONIBILE	https://media.api-sports.io/football/players/162452.png
72	Wesley	D	Roma	15	7181	DISPONIBILE	https://media.api-sports.io/football/players/349001.png
275	Pellegrini Lo.	C	Roma	17	530	DISPONIBILE	https://media.api-sports.io/football/players/782.png
335	Bailey	C	Roma	8	2670	DISPONIBILE	https://media.api-sports.io/football/players/983.png
471	Dovbyk	A	Roma	16	6675	DISPONIBILE	https://media.api-sports.io/football/players/15811.png
346	Ferguson	C	Bologna	6	5858	DISPONIBILE	https://media.api-sports.io/football/players/129643.png
448	Soulè	A	Roma	26	5734	DISPONIBILE	https://media.api-sports.io/football/players/323936.png
32	Rossi F.	P	Atalanta	1	2297	DISPONIBILE	https://media.api-sports.io/football/players/30419.png
158	Ahanor	D	Atalanta	5	6916	DISPONIBILE	https://media.api-sports.io/football/players/453906.png
157	Hien	D	Atalanta	5	6046	DISPONIBILE	https://media.api-sports.io/football/players/137976.png
132	Scalvini	D	Atalanta	7	5526	DISPONIBILE	https://media.api-sports.io/football/players/289761.png
94	Bellanova	D	Atalanta	10	4887	DISPONIBILE	https://media.api-sports.io/football/players/91422.png
200	Bernasconi	D	Atalanta	3	7219	DISPONIBILE	https://media.api-sports.io/football/players/264857.png
329	Ederson D.S.	C	Atalanta	8	5792	DISPONIBILE	https://media.api-sports.io/football/players/10097.png
364	Musah	C	Atalanta	5	5295	DISPONIBILE	https://media.api-sports.io/football/players/162106.png
276	Samardzic	C	Atalanta	16	5119	DISPONIBILE	https://media.api-sports.io/football/players/178749.png
465	Krstovic	A	Atalanta	17	6435	DISPONIBILE	https://media.api-sports.io/football/players/66817.png
454	Scamacca	A	Atalanta	20	2137	DISPONIBILE	https://media.api-sports.io/football/players/30544.png
9	Skorupski	P	Bologna	13	133	DISPONIBILE	https://media.api-sports.io/football/players/2998.png
209	Lykogiannis	D	Bologna	2	2653	DISPONIBILE	https://media.api-sports.io/football/players/30553.png
103	Heggem	D	Bologna	10	7212	DISPONIBILE	https://media.api-sports.io/football/players/39254.png
374	Fabbian	C	Bologna	4	6206	DISPONIBILE	https://media.api-sports.io/football/players/322630.png
73	Holm	D	Bologna	14	5678	DISPONIBILE	https://media.api-sports.io/football/players/47985.png
537	Moro L.	A	Sassuolo	1	7158	DISPONIBILE	https://media.api-sports.io/football/players/1322.png
311	Pobega	C	Bologna	11	5298	DISPONIBILE	https://media.api-sports.io/football/players/31273.png
482	Sulemana K.	A	Atalanta	13	5918	DISPONIBILE	https://media.api-sports.io/football/players/353609.png
123	Zortea	D	Bologna	8	4433	DISPONIBILE	https://media.api-sports.io/football/players/128461.png
451	Castro S.	A	Bologna	23	6572	DISPONIBILE	https://media.api-sports.io/football/players/311067.png
519	Dominguez B.	A	Bologna	5	6895	DISPONIBILE	https://media.api-sports.io/football/players/347265.png
336	Rowe	C	Bologna	8	6844	DISPONIBILE	https://media.api-sports.io/football/players/278095.png
38	Martinelli T.	P	Fiorentina	1	6184	DISPONIBILE	https://media.api-sports.io/football/players/383267.png
161	Dodò	D	Fiorentina	5	5885	DISPONIBILE	https://media.api-sports.io/football/players/41144.png
256	Kouadio	D	Fiorentina	1	7238	DISPONIBILE	https://media.api-sports.io/football/players/448977.png
190	Marì	D	Fiorentina	3	4904	DISPONIBILE	https://media.api-sports.io/football/players/46792.png
124	Ranieri L.	D	Fiorentina	8	4378	DISPONIBILE	https://media.api-sports.io/football/players/31642.png
213	Viti	D	Fiorentina	2	5718	DISPONIBILE	https://media.api-sports.io/football/players/180510.png
377	Fazzini	C	Fiorentina	4	6010	DISPONIBILE	https://media.api-sports.io/football/players/340700.png
415	Richardson	C	Fiorentina	2	6804	DISPONIBILE	https://media.api-sports.io/football/players/314231.png
460	Kean	A	Fiorentina	18	2097	DISPONIBILE	https://media.api-sports.io/football/players/877.png
22	Paleari	P	Torino	8	5320	DISPONIBILE	https://media.api-sports.io/football/players/30642.png
179	Biraghi	D	Torino	4	252	DISPONIBILE	https://media.api-sports.io/football/players/30396.png
77	Coco	D	Torino	13	6642	DISPONIBILE	https://media.api-sports.io/football/players/122468.png
249	Dembelè A.	D	Torino	1	6826	DISPONIBILE	https://media.api-sports.io/football/players/349232.png
203	Nkounkou	D	Torino	3	5156	DISPONIBILE	https://media.api-sports.io/football/players/156490.png
407	Anjorin	C	Torino	3	6889	DISPONIBILE	https://media.api-sports.io/football/players/138777.png
358	Casadei	C	Torino	6	5888	DISPONIBILE	https://media.api-sports.io/football/players/270507.png
387	Ilic	C	Torino	4	5007	DISPONIBILE	https://media.api-sports.io/football/players/46170.png
439	Ilkhan	C	Torino	1	6005	DISPONIBILE	https://media.api-sports.io/football/players/336573.png
152	Lazaro	D	Torino	6	4385	DISPONIBILE	https://media.api-sports.io/football/players/25353.png
288	Vlasic	C	Torino	15	5687	DISPONIBILE	https://media.api-sports.io/football/players/842.png
488	Ngonge	A	Torino	12	6145	DISPONIBILE	https://media.api-sports.io/football/players/85.png
539	Njie	A	Torino	1	6827	DISPONIBILE	https://media.api-sports.io/football/players/383006.png
496	Zapata D.	A	Torino	10	608	DISPONIBILE	https://media.api-sports.io/football/players/2495.png
12	Montipò	P	Verona	13	4957	DISPONIBILE	https://media.api-sports.io/football/players/30611.png
79	Belghali	D	Verona	13	7220	DISPONIBILE	https://media.api-sports.io/football/players/303362.png
183	Frese	D	Verona	4	6639	DISPONIBILE	https://media.api-sports.io/football/players/15909.png
181	Unai Nunez	D	Verona	4	6894	DISPONIBILE	https://media.api-sports.io/football/players/47277.png
252	Slotsager	D	Verona	1	7011	DISPONIBILE	https://media.api-sports.io/football/players/368129.png
413	Akpa Akpro	C	Verona	3	5286	DISPONIBILE	https://media.api-sports.io/football/players/31678.png
327	Bernede	C	Verona	9	7028	DISPONIBILE	https://media.api-sports.io/football/players/1090.png
408	Niasse	C	Verona	3	5540	DISPONIBILE	https://media.api-sports.io/football/players/22239.png
309	Serdar	C	Verona	12	6458	DISPONIBILE	https://media.api-sports.io/football/players/418.png
424	Suslov	C	Verona	2	6486	DISPONIBILE	https://media.api-sports.io/football/players/194837.png
503	Mosquera	A	Verona	9	6630	DISPONIBILE	https://media.api-sports.io/football/players/59421.png
521	Sarr A.	A	Verona	5	6159	DISPONIBILE	https://media.api-sports.io/football/players/236955.png
41	Di Gennaro	P	Inter	1	1926	DISPONIBILE	https://media.api-sports.io/football/players/91488.png
13	Sommer	P	Inter	12	2428	DISPONIBILE	https://media.api-sports.io/football/players/2802.png
136	Acerbi	D	Inter	7	513	DISPONIBILE	https://media.api-sports.io/football/players/1836.png
67	Bastoni	D	Inter	20	2120	DISPONIBILE	https://media.api-sports.io/football/players/31009.png
82	Dumfries	D	Inter	12	5513	DISPONIBILE	https://media.api-sports.io/football/players/226.png
259	Palacios T.	D	Inter	1	6874	DISPONIBILE	https://media.api-sports.io/football/players/311360.png
163	De Vrij	D	Inter	5	322	DISPONIBILE	https://media.api-sports.io/football/players/194.png
262	Calhanoglu	C	Inter	29	2194	DISPONIBILE	https://media.api-sports.io/football/players/1640.png
352	Frattesi	C	Inter	6	2848	DISPONIBILE	https://media.api-sports.io/football/players/31173.png
300	Zielinski	C	Inter	13	152	DISPONIBILE	https://media.api-sports.io/football/players/329.png
475	Esposito F.P.	A	Inter	15	7071	DISPONIBILE	https://media.api-sports.io/football/players/345808.png
350	Luis Henrique	C	Inter	6	5301	DISPONIBILE	https://media.api-sports.io/football/players/10077.png
445	Thuram	A	Inter	29	4871	DISPONIBILE	https://media.api-sports.io/football/players/21509.png
257	Siebert	D	Lecce	1	7240	DISPONIBILE	https://media.api-sports.io/football/players/203219.png
89	Tiago Gabriel	D	Lecce	11	6989	DISPONIBILE	https://media.api-sports.io/football/players/455316.png
293	Coulibaly L.	C	Lecce	14	5504	DISPONIBILE	https://media.api-sports.io/football/players/1748.png
419	Helgason	C	Lecce	2	5872	DISPONIBILE	https://media.api-sports.io/football/players/28744.png
401	Kaba	C	Lecce	3	6410	DISPONIBILE	https://media.api-sports.io/football/players/197779.png
432	Marchwinski	C	Lecce	1	6645	DISPONIBILE	https://media.api-sports.io/football/players/40563.png
354	Ramadani	C	Lecce	6	6394	DISPONIBILE	https://media.api-sports.io/football/players/15673.png
501	Banda	A	Lecce	9	6001	DISPONIBILE	https://media.api-sports.io/football/players/118956.png
513	Stulic	A	Lecce	7	7252	DISPONIBILE	https://media.api-sports.io/football/players/264122.png
381	Tete Morente	C	Lecce	4	6634	DISPONIBILE	https://media.api-sports.io/football/players/47182.png
64	Ferrante	P	Napoli	1	7285	DISPONIBILE	https://media.api-sports.io/football/players/56774.png
188	De Silvestri	D	Bologna	3	487	DISPONIBILE	https://media.api-sports.io/football/players/30915.png
70	Baschirotto	D	Cremonese	15	5835	DISPONIBILE	https://media.api-sports.io/football/players/127035.png
134	Bianchetti	D	Cremonese	7	612	DISPONIBILE	https://media.api-sports.io/football/players/30919.png
212	Ceccherini	D	Cremonese	2	1891	DISPONIBILE	https://media.api-sports.io/football/players/30397.png
160	Floriani Mussolini	D	Cremonese	5	7131	DISPONIBILE	https://media.api-sports.io/football/players/342651.png
395	Collocolo	C	Cremonese	3	7132	DISPONIBILE	https://media.api-sports.io/football/players/126889.png
277	Vazquez	C	Cremonese	16	449	DISPONIBILE	https://media.api-sports.io/football/players/2057.png
464	Bonazzoli	A	Cremonese	17	505	DISPONIBILE	https://media.api-sports.io/football/players/31436.png
526	Johnsen	A	Cremonese	3	5496	DISPONIBILE	https://media.api-sports.io/football/players/36986.png
533	Moumbagna	A	Cremonese	2	6555	DISPONIBILE	https://media.api-sports.io/football/players/102447.png
511	Sanabria	A	Cremonese	7	479	DISPONIBILE	https://media.api-sports.io/football/players/2522.png
393	Sarmiento J.	C	Cremonese	4	6528	DISPONIBILE	https://media.api-sports.io/football/players/202086.png
23	Corvi	P	Parma	6	6662	DISPONIBILE	https://media.api-sports.io/football/players/180762.png
50	Rinaldi	P	Parma	1	5338	DISPONIBILE	https://media.api-sports.io/football/players/237268.png
114	Circati	D	Parma	9	6663	DISPONIBILE	https://media.api-sports.io/football/players/348568.png
280	Bernabè	C	Parma	16	6666	DISPONIBILE	https://media.api-sports.io/football/players/628.png
443	Cremaschi	C	Parma	1	7276	DISPONIBILE	https://media.api-sports.io/football/players/362061.png
403	Estevez	C	Parma	3	5290	DISPONIBILE	https://media.api-sports.io/football/players/6409.png
365	Keita M.	C	Parma	5	6898	DISPONIBILE	https://media.api-sports.io/football/players/308836.png
372	Oristanio	C	Parma	5	6218	DISPONIBILE	https://media.api-sports.io/football/players/161859.png
493	Cutrone	A	Parma	10	2155	DISPONIBILE	https://media.api-sports.io/football/players/1649.png
31	Scuffet	P	Pisa	2	574	DISPONIBILE	https://media.api-sports.io/football/players/50054.png
185	Albiol	D	Pisa	4	388	DISPONIBILE	https://media.api-sports.io/football/players/314.png
166	Calabresi	D	Pisa	5	2745	DISPONIBILE	https://media.api-sports.io/football/players/30469.png
148	Caracciolo A.	D	Pisa	6	2273	DISPONIBILE	https://media.api-sports.io/football/players/31604.png
243	Esteves T.	D	Pisa	1	7142	DISPONIBILE	https://media.api-sports.io/football/players/129790.png
242	Mbambi	D	Pisa	1	7170	DISPONIBILE	https://media.api-sports.io/football/players/526688.png
324	Akinsanmiro	C	Pisa	9	6593	DISPONIBILE	https://media.api-sports.io/football/players/408635.png
102	Cuadrado	D	Pisa	10	697	DISPONIBILE	https://media.api-sports.io/football/players/866.png
383	Marin M.	C	Pisa	4	7149	DISPONIBILE	https://media.api-sports.io/football/players/30723.png
368	Tramoni M.	C	Pisa	5	5318	DISPONIBILE	https://media.api-sports.io/football/players/20959.png
536	Buffon L.	A	Pisa	1	7171	DISPONIBILE	https://media.api-sports.io/football/players/510473.png
344	Leris	C	Pisa	7	2334	DISPONIBILE	https://media.api-sports.io/football/players/30753.png
487	Moreo	A	Pisa	12	5455	DISPONIBILE	https://media.api-sports.io/football/players/31560.png
63	Cavlina	P	Como	1	7261	DISPONIBILE	https://media.api-sports.io/football/players/207804.png
231	Goldaniga	D	Como	1	418	DISPONIBILE	https://media.api-sports.io/football/players/31073.png
95	Posch	D	Como	10	6066	DISPONIBILE	https://media.api-sports.io/football/players/711.png
117	Ramon	D	Como	9	6869	DISPONIBILE	https://media.api-sports.io/football/players/386305.png
86	Vojvoda	D	Como	11	4994	DISPONIBILE	https://media.api-sports.io/football/players/8586.png
331	Baturina	C	Como	8	7126	DISPONIBILE	https://media.api-sports.io/football/players/295026.png
317	Da Cunha	C	Como	10	5559	DISPONIBILE	https://media.api-sports.io/football/players/162266.png
290	Perrone	C	Como	14	6151	DISPONIBILE	https://media.api-sports.io/football/players/288699.png
499	Rodriguez Je.	A	Como	9	7129	DISPONIBILE	https://media.api-sports.io/football/players/443162.png
506	Diao	A	Como	8	6967	DISPONIBILE	https://media.api-sports.io/football/players/400948.png
512	Morata	A	Como	7	313	DISPONIBILE	https://media.api-sports.io/football/players/59.png
\.


--
-- TOC entry 5084 (class 0 OID 16584)
-- Dependencies: 236
-- Data for Name: calendario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.calendario (id, id_lega, giornata, id_squadra_casa, id_squadra_trasferta, gol_casa, gol_trasferta, fanta_punteggio_casa, fanta_punteggio_trasferta, giocata) FROM stdin;
\.


--
-- TOC entry 5078 (class 0 OID 16490)
-- Dependencies: 230
-- Data for Name: fantasquadra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fantasquadra (id_fantasquadra, id_utente, id_lega, is_admin, crediti_residui, nome_fantasquadra, punteggio_classifica_fantasquadra, giornate_giocate, gol_fatti_totali, gol_subiti_totali, somma_punteggi) FROM stdin;
\.


--
-- TOC entry 5088 (class 0 OID 16624)
-- Dependencies: 240
-- Data for Name: formazioni; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.formazioni (id, id_fantasquadra, giornata, modulo, data_inserimento) FROM stdin;
\.


--
-- TOC entry 5076 (class 0 OID 16458)
-- Dependencies: 228
-- Data for Name: impostazioni_lega; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.impostazioni_lega (id, id_lega, budget_iniziale, max_calciatori, mercato_scambi_aperto, modificatore_difesa, porta_inviolata, mvp, gol_vittoria, bonus_gol, bonus_assist, malus_ammonizione, malus_espulsione, malus_gol_subito, malus_autogol, bonus_rigore_parato, malus_rigore_sbagliato, soglia_gol, step_fascia) FROM stdin;
\.


--
-- TOC entry 5074 (class 0 OID 16446)
-- Dependencies: 226
-- Data for Name: lega; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lega (id_lega, nome_lega, codice_invito, numero_squadre) FROM stdin;
\.


--
-- TOC entry 5086 (class 0 OID 16610)
-- Dependencies: 238
-- Data for Name: punteggi_giornata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.punteggi_giornata (id, id_fantasquadra, giornata, punteggio_totale, gol_fatti, gol_subiti, punti_classifica) FROM stdin;
\.


--
-- TOC entry 5082 (class 0 OID 16544)
-- Dependencies: 234
-- Data for Name: scambi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scambi (id, id_fantasquadra_proponente, id_calciatore_proposto, crediti_proponente, id_fantasquadra_ricevente, id_calciatore_richiesto, crediti_ricevente, stato, data_proposta, visto_ricevente, visto_proponente) FROM stdin;
\.


--
-- TOC entry 5090 (class 0 OID 16642)
-- Dependencies: 242
-- Data for Name: schieramento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schieramento (id, id_formazione, id_calciatore, stato, ordine, ruolo_schierato, fanta_voto) FROM stdin;
\.


--
-- TOC entry 5072 (class 0 OID 16422)
-- Dependencies: 224
-- Data for Name: statistiche; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statistiche (id, id_calciatore, giornata, voto, gol_fatti, gol_subiti, rigori_parati, rigori_sbagliati, autogol, assist, ammonizione, espulsione) FROM stdin;
3259	5	6	6.50	0	1	0	0	0	0	f	f
3260	120	6	6.00	0	0	0	0	0	0	f	f
544	5	1	6.50	0	1	0	0	0	0	f	f
545	156	1	5.00	0	0	0	0	0	0	f	f
546	94	1	5.50	0	0	0	0	0	0	f	f
547	132	1	5.50	0	0	0	0	0	0	f	f
548	93	1	6.00	0	0	0	0	0	0	f	f
549	157	1	5.00	0	0	0	0	1	0	f	f
550	338	1	5.50	0	0	0	0	0	0	f	f
551	296	1	6.00	0	0	0	0	0	1	f	f
552	394	1	5.50	0	0	0	0	0	0	t	f
553	276	1	6.00	0	0	0	0	0	0	f	f
554	312	1	6.50	0	0	0	0	0	0	f	f
555	329	1	5.50	0	0	0	0	0	0	f	f
556	454	1	7.00	1	0	0	0	0	0	f	f
557	482	1	6.00	0	0	0	0	0	0	t	f
558	459	1	5.50	0	0	0	0	0	0	f	f
559	465	1	5.50	0	0	0	0	0	0	f	f
560	9	1	6.00	0	1	0	0	0	0	f	f
561	188	1	6.00	0	0	0	0	0	0	f	f
562	209	1	5.00	0	0	0	0	0	0	f	f
563	123	1	5.50	0	0	0	0	0	0	f	f
564	208	1	5.50	0	0	0	0	0	0	f	f
565	121	1	5.00	0	0	0	0	0	0	f	f
566	187	1	6.00	0	0	0	0	0	0	f	f
567	341	1	6.00	0	0	0	0	0	0	f	f
568	340	1	6.00	0	0	0	0	0	0	t	f
569	263	1	6.00	0	0	0	0	0	0	f	f
570	269	1	5.00	0	0	0	0	0	0	f	f
571	311	1	5.00	0	0	0	0	0	0	f	f
572	374	1	6.00	0	0	0	0	0	0	f	f
573	504	1	6.00	0	0	0	0	0	0	f	f
574	458	1	5.00	0	0	0	0	0	0	f	f
575	451	1	6.50	0	0	0	0	0	0	f	f
576	10	1	6.00	0	1	0	0	0	0	f	f
577	96	1	7.00	1	0	0	0	0	0	f	f
578	97	1	5.50	0	0	0	0	0	0	f	f
579	133	1	6.00	0	0	0	0	0	0	f	f
3261	156	6	6.00	0	0	0	0	0	0	t	f
580	159	1	6.00	0	0	0	0	0	0	t	f
581	122	1	6.00	0	0	0	0	0	0	f	f
582	347	1	6.00	0	0	0	0	0	0	f	f
583	436	1	6.00	0	0	0	0	0	0	t	f
584	304	1	6.50	0	0	0	0	0	1	f	f
585	361	1	6.00	0	0	0	0	0	0	f	f
586	330	1	6.00	0	0	0	0	0	0	f	f
587	348	1	6.00	0	0	0	0	0	0	f	f
588	470	1	6.00	0	0	0	0	0	0	f	f
589	520	1	6.00	0	0	0	0	0	0	f	f
590	478	1	5.50	0	0	0	0	0	0	t	f
591	529	1	6.00	0	0	0	0	0	0	t	f
592	6	1	6.00	0	0	0	0	0	0	f	f
593	86	1	7.00	0	0	0	0	0	0	f	f
594	105	1	6.50	0	0	0	0	0	0	f	f
595	117	1	7.00	0	0	0	0	0	0	f	f
596	80	1	6.00	0	0	0	0	0	0	f	f
597	211	1	6.00	0	0	0	0	0	0	t	f
598	189	1	6.00	0	0	0	0	0	0	f	f
599	414	1	6.00	0	0	0	0	0	0	f	f
600	316	1	6.00	0	0	0	0	0	0	f	f
601	317	1	6.50	0	0	0	0	0	0	f	f
602	290	1	6.50	0	0	0	0	0	0	f	f
603	261	1	7.50	1	0	0	0	0	1	t	f
604	512	1	6.00	0	0	0	0	0	0	f	f
605	463	1	7.00	1	0	0	0	0	0	f	f
606	514	1	6.00	0	0	0	0	0	0	f	f
607	499	1	6.50	0	0	0	0	0	0	f	f
608	11	1	6.50	0	1	0	0	0	0	f	f
609	134	1	6.50	0	0	0	0	0	0	f	f
610	173	1	6.50	0	0	0	0	0	1	f	f
611	212	1	6.00	0	0	0	0	0	0	f	f
612	75	1	6.50	0	0	0	0	0	0	t	f
613	70	1	8.00	1	0	0	0	0	0	f	f
614	375	1	5.50	0	0	0	0	0	0	t	f
615	355	1	6.00	0	0	0	0	0	0	t	f
616	343	1	7.00	0	0	0	0	0	1	f	f
617	325	1	6.00	0	0	0	0	0	0	t	f
618	395	1	6.50	0	0	0	0	0	0	f	f
619	283	1	6.00	0	0	0	0	0	0	f	f
620	511	1	6.00	0	0	0	0	0	0	f	f
621	464	1	7.50	1	0	0	0	0	0	f	f
622	522	1	6.00	0	0	0	0	0	0	f	f
623	530	1	6.00	0	0	0	0	0	0	f	f
624	17	1	5.50	0	1	0	0	0	0	f	f
625	107	1	6.50	0	0	0	0	0	0	f	f
626	124	1	6.00	0	0	0	0	0	0	f	f
627	190	1	5.00	0	0	0	0	0	0	t	f
628	191	1	5.50	0	0	0	0	0	0	f	f
629	175	1	6.00	0	0	0	0	0	0	t	f
630	213	1	6.00	0	0	0	0	0	0	f	f
631	161	1	6.00	0	0	0	0	0	0	f	f
632	174	1	6.00	0	0	0	0	0	0	f	f
633	274	1	7.00	1	0	0	0	0	0	f	f
634	376	1	6.00	0	0	0	0	0	0	f	f
635	366	1	5.50	0	0	0	0	0	0	f	f
636	297	1	6.50	0	0	0	0	0	1	f	f
637	377	1	6.00	0	0	0	0	0	0	f	f
638	396	1	5.50	0	0	0	0	0	0	f	f
639	460	1	5.00	0	0	0	0	0	0	f	f
640	18	1	6.00	0	0	0	0	0	0	f	f
641	74	1	6.00	0	0	0	0	0	0	t	f
642	98	1	6.50	0	0	0	0	0	0	f	f
643	192	1	6.50	0	0	0	0	0	0	f	f
644	135	1	5.00	0	0	0	0	0	0	f	f
645	298	1	6.00	0	0	0	0	0	0	f	f
646	397	1	5.50	0	0	0	0	0	0	f	f
647	342	1	6.00	0	0	0	0	0	0	f	f
648	318	1	6.00	0	0	0	0	0	0	f	f
649	379	1	6.00	0	0	0	0	0	0	f	f
650	378	1	5.50	0	0	0	0	0	0	f	f
651	349	1	6.00	0	0	0	0	0	0	f	f
652	398	1	6.00	0	0	0	0	0	0	f	f
653	508	1	5.00	0	0	0	0	0	0	f	f
654	490	1	6.00	0	0	0	0	0	0	f	f
655	507	1	5.50	0	0	0	0	0	0	t	f
656	13	1	6.00	0	0	0	0	0	0	f	f
657	66	1	6.50	0	0	0	0	0	0	f	f
658	136	1	6.50	0	0	0	0	0	0	f	f
659	67	1	7.50	1	0	0	0	0	1	f	f
660	82	1	6.50	0	0	0	0	0	0	f	f
661	81	1	6.00	0	0	0	0	0	0	f	f
662	300	1	6.00	0	0	0	0	0	0	f	f
663	270	1	6.50	0	0	0	0	0	1	f	f
664	351	1	6.50	0	0	0	0	0	0	f	f
665	350	1	6.00	0	0	0	0	0	0	f	f
666	411	1	6.00	0	0	0	0	0	0	f	f
667	299	1	7.00	0	0	0	0	0	1	f	f
668	444	1	7.50	1	0	0	0	0	1	f	f
669	445	1	7.50	2	0	0	0	0	0	f	f
670	474	1	7.00	1	0	0	0	0	0	f	f
671	7	1	6.00	0	0	0	0	0	0	f	f
672	87	1	6.50	0	0	0	0	0	0	f	f
673	88	1	6.00	0	0	0	0	0	0	f	f
674	99	1	4.50	0	0	0	0	0	0	f	t
675	138	1	6.00	0	0	0	0	0	0	t	f
676	108	1	6.00	0	0	0	0	0	0	f	f
677	194	1	6.00	0	0	0	0	0	0	f	f
678	307	1	6.50	0	0	0	0	0	0	f	f
679	332	1	6.00	0	0	0	0	0	0	f	f
680	291	1	6.50	0	0	0	0	0	0	f	f
681	353	1	6.00	0	0	0	0	0	0	f	f
682	278	1	6.50	0	0	0	0	0	0	f	f
683	461	1	7.00	1	0	0	0	0	0	f	f
684	480	1	7.00	1	0	0	0	0	0	f	f
685	446	1	7.50	0	0	0	0	0	2	f	f
686	3	1	6.00	0	2	0	0	0	0	f	f
687	110	1	5.50	0	0	0	0	0	0	f	f
688	195	1	5.00	0	0	0	0	0	0	f	f
689	144	1	5.50	0	0	0	0	0	0	f	f
690	145	1	5.00	0	0	0	0	0	0	f	f
691	125	1	5.50	0	0	0	0	0	0	f	f
692	176	1	5.50	0	0	0	0	0	0	f	f
693	301	1	5.00	0	0	0	0	0	0	f	f
694	267	1	5.00	0	0	0	0	0	0	t	f
695	292	1	5.50	0	0	0	0	0	0	t	f
696	380	1	5.50	0	0	0	0	0	0	f	f
697	363	1	5.00	0	0	0	0	0	0	f	f
698	516	1	5.50	0	0	0	0	0	0	f	f
699	491	1	5.50	0	0	0	0	0	0	f	f
700	494	1	5.50	0	0	0	0	0	0	f	f
701	455	1	5.50	0	0	0	0	0	0	t	f
702	8	1	7.00	0	0	0	0	0	0	f	f
703	127	1	6.50	0	0	0	0	0	0	f	f
704	164	1	6.50	0	0	0	0	0	0	f	f
705	89	1	6.50	0	0	0	0	0	0	f	f
706	146	1	6.00	0	0	0	0	0	0	t	f
707	218	1	6.00	0	0	0	0	0	0	f	f
708	310	1	5.50	0	0	0	0	0	0	f	f
709	293	1	6.50	0	0	0	0	0	0	f	f
710	286	1	5.50	0	0	0	0	0	0	f	f
711	354	1	6.00	0	0	0	0	0	0	f	f
712	401	1	6.00	0	0	0	0	0	0	f	f
713	418	1	6.00	0	0	0	0	0	0	f	f
714	381	1	5.50	0	0	0	0	0	0	t	f
715	501	1	5.50	0	0	0	0	0	0	t	f
716	509	1	5.00	0	0	0	0	0	0	f	f
717	495	1	6.00	0	0	0	0	0	0	f	f
718	1	1	6.00	0	2	0	0	0	0	f	f
719	111	1	6.00	0	0	0	0	0	0	f	f
720	139	1	6.00	0	0	0	0	0	0	f	f
721	68	1	6.50	1	0	0	0	0	0	f	f
722	177	1	6.00	0	0	0	0	0	1	f	f
723	260	1	6.00	0	0	0	0	0	0	f	f
724	268	1	6.50	0	0	0	0	0	0	f	f
725	302	1	5.50	0	0	0	0	0	0	f	f
726	313	1	5.00	0	0	0	0	0	0	f	f
727	271	1	6.00	0	0	0	0	0	0	f	f
728	388	1	5.50	0	0	0	0	0	0	f	f
729	486	1	5.00	0	0	0	0	0	0	f	f
730	21	1	6.00	0	0	0	0	0	0	f	f
731	196	1	6.50	0	0	0	0	0	0	f	f
732	71	1	6.00	0	0	0	0	0	0	f	f
733	113	1	6.00	0	0	0	0	0	0	f	f
734	140	1	6.50	0	0	0	0	0	0	f	f
735	178	1	6.00	0	0	0	0	0	0	f	f
736	319	1	7.00	0	0	0	0	0	1	f	f
737	264	1	7.00	1	0	0	0	0	0	f	f
738	266	1	7.00	0	0	0	0	0	0	f	f
739	356	1	6.00	0	0	0	0	0	0	f	f
740	265	1	7.50	1	0	0	0	0	0	f	f
741	334	1	6.00	0	0	0	0	0	0	f	f
742	279	1	6.00	0	0	0	0	0	0	f	f
743	441	1	6.00	0	0	0	0	0	0	f	f
744	510	1	5.50	0	0	0	0	0	0	t	f
745	483	1	6.00	0	0	0	0	0	0	f	f
746	16	1	6.50	0	2	0	0	0	0	t	f
747	147	1	6.00	0	0	0	0	0	0	f	f
748	116	1	5.50	0	0	0	0	0	0	f	f
749	114	1	5.00	0	0	0	0	0	0	f	f
750	115	1	6.00	0	0	0	0	0	0	f	f
751	220	1	6.00	0	0	0	0	0	0	f	f
752	280	1	6.00	0	0	0	0	0	0	f	f
753	365	1	5.50	0	0	0	0	0	0	f	f
754	404	1	5.50	0	0	0	0	0	0	f	f
755	359	1	6.00	0	0	0	0	0	0	t	f
756	531	1	6.00	0	0	0	0	0	0	f	f
757	523	1	6.00	0	0	0	0	0	0	f	f
758	502	1	6.00	0	0	0	0	0	0	f	f
759	456	1	6.00	0	0	0	0	0	0	f	f
760	14	1	6.50	0	1	0	0	0	0	f	f
761	102	1	6.00	0	0	0	0	0	0	f	f
762	148	1	6.50	0	0	0	0	0	0	f	f
763	166	1	6.00	0	0	0	0	0	0	f	f
764	165	1	6.50	0	0	0	0	0	0	f	f
765	129	1	7.00	0	0	0	0	0	0	f	f
766	255	1	5.50	0	0	0	0	0	0	f	f
767	368	1	6.00	0	0	0	0	0	0	f	f
768	373	1	5.50	0	0	0	0	0	0	f	f
769	324	1	6.00	0	0	0	0	0	0	f	f
770	382	1	6.00	0	0	0	0	0	0	f	f
771	320	1	7.00	0	0	0	0	0	0	f	f
772	383	1	6.00	0	0	0	0	0	0	f	f
773	472	1	6.00	0	0	0	0	0	0	f	f
774	487	1	6.50	0	0	0	0	0	0	f	f
775	517	1	6.00	0	0	0	0	0	0	f	f
776	2	1	6.00	0	0	0	0	0	0	f	f
777	100	1	6.50	0	0	0	0	0	0	t	f
778	130	1	6.50	0	0	0	0	0	0	f	f
779	141	1	6.00	0	0	0	0	0	0	f	f
780	84	1	6.50	0	0	0	0	0	0	f	f
781	167	1	6.00	0	0	0	0	0	0	f	f
782	72	1	7.00	1	0	0	0	0	0	f	f
783	295	1	6.50	0	0	0	0	0	0	f	f
784	369	1	6.00	0	0	0	0	0	0	f	f
785	281	1	6.50	0	0	0	0	0	0	f	f
786	357	1	6.00	0	0	0	0	0	0	f	f
787	481	1	6.50	0	0	0	0	0	0	f	f
788	448	1	5.00	0	0	0	0	0	0	f	f
789	484	1	6.50	0	0	0	0	0	0	f	f
790	471	1	5.50	0	0	0	0	0	0	f	f
791	55	1	5.50	0	2	0	0	0	0	f	f
792	245	1	5.00	0	0	0	0	0	0	f	f
793	142	1	5.50	0	0	0	0	0	0	f	f
794	150	1	6.00	0	0	0	0	0	0	f	f
795	199	1	6.00	0	0	0	0	0	0	f	f
796	149	1	5.50	0	0	0	0	0	0	f	f
797	421	1	6.00	0	0	0	0	0	0	f	f
798	422	1	5.50	0	0	0	0	0	0	f	f
799	287	1	4.50	0	0	0	0	0	0	f	t
800	308	1	6.00	0	0	0	0	0	0	f	f
801	449	1	6.00	0	0	0	0	0	0	t	f
802	527	1	6.00	0	0	0	0	0	0	f	f
803	467	1	5.00	0	0	0	0	0	0	f	f
804	453	1	5.50	0	0	0	0	0	0	f	f
805	537	1	6.00	0	0	0	0	0	0	f	f
806	26	1	5.00	0	5	0	0	0	0	f	f
807	222	1	4.50	0	0	0	0	0	0	f	f
808	179	1	4.50	0	0	0	0	0	0	f	f
809	152	1	5.00	0	0	0	0	0	0	f	f
810	168	1	6.00	0	0	0	0	0	0	f	f
811	77	1	4.50	0	0	0	0	0	0	f	f
812	370	1	5.00	0	0	0	0	0	0	f	f
813	288	1	5.50	0	0	0	0	0	0	f	f
814	358	1	5.50	0	0	0	0	0	0	f	f
815	439	1	5.00	0	0	0	0	0	0	f	f
816	386	1	4.00	0	0	0	0	0	0	f	f
817	407	1	6.00	0	0	0	0	0	0	f	f
818	466	1	5.00	0	0	0	0	0	0	f	f
819	488	1	5.00	0	0	0	0	0	0	f	f
820	468	1	5.50	0	0	0	0	0	0	f	f
821	528	1	5.50	0	0	0	0	0	0	f	f
822	27	1	6.00	0	1	0	0	0	0	f	f
823	154	1	6.00	0	0	0	0	0	0	f	f
824	153	1	6.00	0	0	0	0	0	0	t	f
825	180	1	5.50	0	0	0	0	0	0	f	f
826	197	1	5.50	0	0	0	0	0	0	f	f
827	131	1	7.00	1	0	0	0	0	0	f	f
828	101	1	5.50	0	0	0	0	0	0	f	f
829	371	1	6.50	0	0	0	0	0	1	f	f
830	423	1	6.00	0	0	0	0	0	0	f	f
831	321	1	6.00	0	0	0	0	0	0	f	f
832	282	1	6.50	0	0	0	0	0	0	f	f
833	328	1	5.50	0	0	0	0	0	0	f	f
834	452	1	5.50	0	0	0	0	0	0	t	f
835	524	1	6.00	0	0	0	0	0	0	t	f
836	525	1	5.50	0	0	0	0	0	0	f	f
837	12	1	6.00	0	1	0	0	0	0	f	f
838	155	1	6.00	0	0	0	0	0	0	f	f
839	253	1	6.00	0	0	0	0	0	0	t	f
840	183	1	5.00	0	0	0	0	0	0	f	f
841	181	1	5.50	0	0	0	0	0	0	f	f
842	254	1	6.00	0	0	0	0	0	0	f	f
843	169	1	5.50	0	0	0	0	0	0	f	f
844	79	1	6.00	0	0	0	0	0	0	t	f
845	225	1	6.00	0	0	0	0	0	0	f	f
846	408	1	5.50	0	0	0	0	0	0	f	f
847	409	1	6.00	0	0	0	0	0	0	f	f
848	309	1	7.00	1	0	0	0	0	0	f	f
849	327	1	5.50	0	0	0	0	0	0	f	f
850	521	1	5.50	0	0	0	0	0	0	f	f
851	503	1	6.00	0	0	0	0	0	0	f	f
852	469	1	7.00	0	0	0	0	0	1	f	f
853	46	1	\N	0	0	0	0	0	0	f	f
854	35	1	\N	0	0	0	0	0	0	f	f
855	37	1	\N	0	0	0	0	0	0	f	f
856	24	1	\N	0	0	0	0	0	0	f	f
857	29	1	\N	0	0	0	0	0	0	f	f
858	51	1	\N	0	0	0	0	0	0	f	f
859	36	1	\N	0	0	0	0	0	0	f	f
860	92	1	\N	0	0	0	0	0	0	f	f
861	54	1	\N	0	0	0	0	0	0	f	f
862	47	1	\N	0	0	0	0	0	0	f	f
863	90	1	\N	0	0	0	0	0	0	f	f
864	69	1	\N	0	0	0	0	0	0	f	f
865	83	1	\N	0	0	0	0	0	0	f	f
866	19	1	\N	0	0	0	0	0	0	f	f
867	40	1	\N	0	0	0	0	0	0	f	f
868	42	1	\N	0	0	0	0	0	0	f	f
869	52	1	\N	0	0	0	0	0	0	f	f
870	33	1	\N	0	0	0	0	0	0	f	f
871	20	1	\N	0	0	0	0	0	0	f	f
872	28	1	\N	0	0	0	0	0	0	f	f
873	85	1	\N	0	0	0	0	0	0	f	f
874	61	1	\N	0	0	0	0	0	0	f	f
875	56	1	\N	0	0	0	0	0	0	f	f
876	91	1	\N	0	0	0	0	0	0	f	f
877	58	1	\N	0	0	0	0	0	0	f	f
878	62	1	\N	0	0	0	0	0	0	f	f
879	65	1	\N	0	0	0	0	0	0	f	f
880	30	1	\N	0	0	0	0	0	0	f	f
881	104	1	\N	0	0	0	0	0	0	f	f
882	45	1	\N	0	0	0	0	0	0	f	f
883	106	1	\N	0	0	0	0	0	0	f	f
884	205	1	\N	0	0	0	0	0	0	f	f
885	172	1	\N	0	0	0	0	0	0	f	f
886	143	1	\N	0	0	0	0	0	0	f	f
887	186	1	\N	0	0	0	0	0	0	f	f
888	119	1	\N	0	0	0	0	0	0	f	f
889	171	1	\N	0	0	0	0	0	0	f	f
890	184	1	\N	0	0	0	0	0	0	f	f
891	193	1	\N	0	0	0	0	0	0	f	f
892	204	1	\N	0	0	0	0	0	0	f	f
893	112	1	\N	0	0	0	0	0	0	f	f
894	128	1	\N	0	0	0	0	0	0	f	f
895	202	1	\N	0	0	0	0	0	0	f	f
896	207	1	\N	0	0	0	0	0	0	f	f
897	120	1	\N	0	0	0	0	0	0	f	f
898	162	1	\N	0	0	0	0	0	0	f	f
899	151	1	\N	0	0	0	0	0	0	f	f
900	170	1	\N	0	0	0	0	0	0	f	f
901	182	1	\N	0	0	0	0	0	0	f	f
902	137	1	\N	0	0	0	0	0	0	f	f
903	224	1	\N	0	0	0	0	0	0	f	f
904	227	1	\N	0	0	0	0	0	0	f	f
905	238	1	\N	0	0	0	0	0	0	f	f
906	235	1	\N	0	0	0	0	0	0	f	f
907	232	1	\N	0	0	0	0	0	0	f	f
908	226	1	\N	0	0	0	0	0	0	f	f
909	248	1	\N	0	0	0	0	0	0	f	f
910	241	1	\N	0	0	0	0	0	0	f	f
911	221	1	\N	0	0	0	0	0	0	f	f
912	230	1	\N	0	0	0	0	0	0	f	f
913	284	1	\N	0	0	0	0	0	0	f	f
914	285	1	\N	0	0	0	0	0	0	f	f
915	244	1	\N	0	0	0	0	0	0	f	f
916	314	1	\N	0	0	0	0	0	0	f	f
917	273	1	\N	0	0	0	0	0	0	f	f
918	210	1	\N	0	0	0	0	0	0	f	f
919	240	1	\N	0	0	0	0	0	0	f	f
920	250	1	\N	0	0	0	0	0	0	f	f
921	223	1	\N	0	0	0	0	0	0	f	f
922	214	1	\N	0	0	0	0	0	0	f	f
923	215	1	\N	0	0	0	0	0	0	f	f
924	216	1	\N	0	0	0	0	0	0	f	f
925	228	1	\N	0	0	0	0	0	0	f	f
926	233	1	\N	0	0	0	0	0	0	f	f
927	402	1	\N	0	0	0	0	0	0	f	f
928	333	1	\N	0	0	0	0	0	0	f	f
929	405	1	\N	0	0	0	0	0	0	f	f
930	367	1	\N	0	0	0	0	0	0	f	f
931	337	1	\N	0	0	0	0	0	0	f	f
932	390	1	\N	0	0	0	0	0	0	f	f
933	406	1	\N	0	0	0	0	0	0	f	f
934	392	1	\N	0	0	0	0	0	0	f	f
935	385	1	\N	0	0	0	0	0	0	f	f
936	315	1	\N	0	0	0	0	0	0	f	f
937	323	1	\N	0	0	0	0	0	0	f	f
938	412	1	\N	0	0	0	0	0	0	f	f
939	360	1	\N	0	0	0	0	0	0	f	f
940	326	1	\N	0	0	0	0	0	0	f	f
941	400	1	\N	0	0	0	0	0	0	f	f
942	384	1	\N	0	0	0	0	0	0	f	f
943	339	1	\N	0	0	0	0	0	0	f	f
944	416	1	\N	0	0	0	0	0	0	f	f
945	399	1	\N	0	0	0	0	0	0	f	f
946	391	1	\N	0	0	0	0	0	0	f	f
947	345	1	\N	0	0	0	0	0	0	f	f
948	237	1	\N	0	0	0	0	0	0	f	f
949	431	1	\N	0	0	0	0	0	0	f	f
950	429	1	\N	0	0	0	0	0	0	f	f
951	433	1	\N	0	0	0	0	0	0	f	f
952	457	1	\N	0	0	0	0	0	0	f	f
953	450	1	\N	0	0	0	0	0	0	f	f
954	479	1	\N	0	0	0	0	0	0	f	f
955	492	1	\N	0	0	0	0	0	0	f	f
956	485	1	\N	0	0	0	0	0	0	f	f
957	428	1	\N	0	0	0	0	0	0	f	f
958	438	1	\N	0	0	0	0	0	0	f	f
959	437	1	\N	0	0	0	0	0	0	f	f
960	497	1	\N	0	0	0	0	0	0	f	f
961	425	1	\N	0	0	0	0	0	0	f	f
962	426	1	\N	0	0	0	0	0	0	f	f
963	500	1	\N	0	0	0	0	0	0	f	f
964	430	1	\N	0	0	0	0	0	0	f	f
965	477	1	\N	0	0	0	0	0	0	f	f
966	420	1	\N	0	0	0	0	0	0	f	f
967	462	1	\N	0	0	0	0	0	0	f	f
968	427	1	\N	0	0	0	0	0	0	f	f
969	489	1	\N	0	0	0	0	0	0	f	f
970	515	1	\N	0	0	0	0	0	0	f	f
971	505	1	\N	0	0	0	0	0	0	f	f
972	434	1	\N	0	0	0	0	0	0	f	f
973	435	1	\N	0	0	0	0	0	0	f	f
974	473	1	\N	0	0	0	0	0	0	f	f
975	219	1	\N	0	0	0	0	0	0	f	f
976	540	1	\N	0	0	0	0	0	0	f	f
977	541	1	\N	0	0	0	0	0	0	f	f
978	43	1	\N	0	0	0	0	0	0	f	f
979	44	1	\N	0	0	0	0	0	0	f	f
980	236	1	\N	0	0	0	0	0	0	f	f
981	217	1	\N	0	0	0	0	0	0	f	f
982	126	1	\N	0	0	0	0	0	0	f	f
983	417	1	\N	0	0	0	0	0	0	f	f
984	362	1	\N	0	0	0	0	0	0	f	f
985	229	1	\N	0	0	0	0	0	0	f	f
986	15	1	\N	0	0	0	0	0	0	f	f
987	206	1	\N	0	0	0	0	0	0	f	f
988	118	1	\N	0	0	0	0	0	0	f	f
989	247	1	\N	0	0	0	0	0	0	f	f
990	246	1	\N	0	0	0	0	0	0	f	f
991	303	1	\N	0	0	0	0	0	0	f	f
992	389	1	\N	0	0	0	0	0	0	f	f
993	518	1	\N	0	0	0	0	0	0	f	f
994	538	1	\N	0	0	0	0	0	0	f	f
995	48	1	\N	0	0	0	0	0	0	f	f
996	258	1	\N	0	0	0	0	0	0	f	f
997	294	1	\N	0	0	0	0	0	0	f	f
998	447	1	\N	0	0	0	0	0	0	f	f
999	34	1	\N	0	0	0	0	0	0	f	f
1000	289	1	\N	0	0	0	0	0	0	f	f
1001	498	1	\N	0	0	0	0	0	0	f	f
1002	534	1	\N	0	0	0	0	0	0	f	f
1003	532	1	\N	0	0	0	0	0	0	f	f
1004	542	1	\N	0	0	0	0	0	0	f	f
1005	543	1	\N	0	0	0	0	0	0	f	f
1006	49	1	\N	0	0	0	0	0	0	f	f
1007	4	1	\N	0	0	0	0	0	0	f	f
1008	201	1	\N	0	0	0	0	0	0	f	f
1009	239	1	\N	0	0	0	0	0	0	f	f
1010	476	1	\N	0	0	0	0	0	0	f	f
1011	60	1	\N	0	0	0	0	0	0	f	f
1012	57	1	\N	0	0	0	0	0	0	f	f
1013	198	1	\N	0	0	0	0	0	0	f	f
1014	78	1	\N	0	0	0	0	0	0	f	f
1015	272	1	\N	0	0	0	0	0	0	f	f
1016	39	1	\N	0	0	0	0	0	0	f	f
1017	76	1	\N	0	0	0	0	0	0	f	f
1018	59	1	\N	0	0	0	0	0	0	f	f
1019	440	1	\N	0	0	0	0	0	0	f	f
1020	305	1	\N	0	0	0	0	0	0	f	f
1021	442	1	\N	0	0	0	0	0	0	f	f
1022	25	1	\N	0	0	0	0	0	0	f	f
1023	109	1	\N	0	0	0	0	0	0	f	f
1024	234	1	\N	0	0	0	0	0	0	f	f
1025	410	1	\N	0	0	0	0	0	0	f	f
1026	306	1	\N	0	0	0	0	0	0	f	f
1027	535	1	\N	0	0	0	0	0	0	f	f
1028	322	1	\N	0	0	0	0	0	0	f	f
1029	53	1	\N	0	0	0	0	0	0	f	f
1030	251	1	\N	0	0	0	0	0	0	f	f
1031	275	1	\N	0	0	0	0	0	0	f	f
1032	335	1	\N	0	0	0	0	0	0	f	f
1033	346	1	\N	0	0	0	0	0	0	f	f
1034	32	1	\N	0	0	0	0	0	0	f	f
1035	158	1	\N	0	0	0	0	0	0	f	f
1036	200	1	\N	0	0	0	0	0	0	f	f
1037	364	1	\N	0	0	0	0	0	0	f	f
1038	103	1	\N	0	0	0	0	0	0	f	f
1039	73	1	\N	0	0	0	0	0	0	f	f
1040	519	1	\N	0	0	0	0	0	0	f	f
1041	336	1	\N	0	0	0	0	0	0	f	f
1042	38	1	\N	0	0	0	0	0	0	f	f
1043	256	1	\N	0	0	0	0	0	0	f	f
1044	415	1	\N	0	0	0	0	0	0	f	f
1045	22	1	\N	0	0	0	0	0	0	f	f
1046	249	1	\N	0	0	0	0	0	0	f	f
1047	203	1	\N	0	0	0	0	0	0	f	f
1048	387	1	\N	0	0	0	0	0	0	f	f
1049	539	1	\N	0	0	0	0	0	0	f	f
1050	496	1	\N	0	0	0	0	0	0	f	f
1051	252	1	\N	0	0	0	0	0	0	f	f
1052	413	1	\N	0	0	0	0	0	0	f	f
1053	424	1	\N	0	0	0	0	0	0	f	f
1054	41	1	\N	0	0	0	0	0	0	f	f
1055	259	1	\N	0	0	0	0	0	0	f	f
1056	163	1	\N	0	0	0	0	0	0	f	f
1057	262	1	\N	0	0	0	0	0	0	f	f
1058	352	1	\N	0	0	0	0	0	0	f	f
1059	475	1	\N	0	0	0	0	0	0	f	f
1060	257	1	\N	0	0	0	0	0	0	f	f
1061	419	1	\N	0	0	0	0	0	0	f	f
1062	432	1	\N	0	0	0	0	0	0	f	f
1063	513	1	\N	0	0	0	0	0	0	f	f
1064	64	1	\N	0	0	0	0	0	0	f	f
1065	160	1	\N	0	0	0	0	0	0	f	f
1066	277	1	\N	0	0	0	0	0	0	f	f
1067	526	1	\N	0	0	0	0	0	0	f	f
1068	533	1	\N	0	0	0	0	0	0	f	f
1069	393	1	\N	0	0	0	0	0	0	f	f
1070	23	1	\N	0	0	0	0	0	0	f	f
1071	50	1	\N	0	0	0	0	0	0	f	f
1072	443	1	\N	0	0	0	0	0	0	f	f
1073	403	1	\N	0	0	0	0	0	0	f	f
1074	372	1	\N	0	0	0	0	0	0	f	f
1075	493	1	\N	0	0	0	0	0	0	f	f
1076	31	1	\N	0	0	0	0	0	0	f	f
1077	185	1	\N	0	0	0	0	0	0	f	f
1078	243	1	\N	0	0	0	0	0	0	f	f
1079	242	1	\N	0	0	0	0	0	0	f	f
1080	536	1	\N	0	0	0	0	0	0	f	f
1081	344	1	\N	0	0	0	0	0	0	f	f
1082	63	1	\N	0	0	0	0	0	0	f	f
1083	231	1	\N	0	0	0	0	0	0	f	f
1084	95	1	\N	0	0	0	0	0	0	f	f
1085	331	1	\N	0	0	0	0	0	0	f	f
1086	506	1	\N	0	0	0	0	0	0	f	f
1087	5	2	6.00	0	1	0	0	0	0	f	f
1088	120	2	6.00	0	0	0	0	0	0	f	f
1089	156	2	6.00	0	0	0	0	0	0	f	f
1090	94	2	6.00	0	0	0	0	0	0	f	f
1091	132	2	5.50	0	0	0	0	0	0	f	f
1092	157	2	5.50	0	0	0	0	0	0	t	f
1093	338	2	6.50	0	0	0	0	0	0	t	f
1094	296	2	7.00	1	0	0	0	0	0	f	f
1095	394	2	5.50	0	0	0	0	0	0	f	f
1096	339	2	6.00	0	0	0	0	0	0	f	f
1097	312	2	6.00	0	0	0	0	0	0	f	f
1098	454	2	6.00	0	0	0	0	0	0	f	f
1099	482	2	5.50	0	0	0	0	0	0	f	f
1100	459	2	6.00	0	0	0	0	0	0	f	f
1101	465	2	6.50	0	0	0	0	0	1	f	f
1102	9	2	6.00	0	0	0	0	0	0	f	f
1103	209	2	5.50	0	0	0	0	0	0	f	f
1104	123	2	6.00	0	0	0	0	0	0	f	f
1105	85	2	6.00	0	0	0	0	0	0	f	f
1106	121	2	6.50	0	0	0	0	0	0	t	f
1107	187	2	6.00	0	0	0	0	0	0	t	f
1108	103	2	7.00	0	0	0	0	0	0	f	f
1109	340	2	6.50	0	0	0	0	0	0	f	f
1110	263	2	7.00	1	0	0	0	0	0	f	f
1111	269	2	6.00	0	0	0	0	0	0	f	f
1112	311	2	6.00	0	0	0	0	0	0	t	f
1113	323	2	5.50	0	0	0	0	0	0	f	f
1114	374	2	6.00	0	0	0	0	0	0	f	f
1115	458	2	6.50	0	0	0	0	0	0	t	f
1116	451	2	6.50	0	0	0	0	0	1	f	f
1117	489	2	6.00	0	0	0	0	0	0	f	f
1118	10	2	6.50	0	1	0	0	0	0	f	f
1119	96	2	6.50	0	0	0	0	0	0	f	f
1120	97	2	6.00	0	0	0	0	0	0	f	f
1121	133	2	6.00	0	0	0	0	0	0	t	f
1122	210	2	6.00	0	0	0	0	0	0	f	f
1123	159	2	5.50	0	0	0	0	0	0	f	f
1124	69	2	6.50	0	0	0	0	0	0	f	f
1125	122	2	6.00	0	0	0	0	0	0	f	f
1126	347	2	6.00	0	0	0	0	0	0	f	f
1127	304	2	5.50	0	0	0	0	0	0	f	f
1128	361	2	6.00	0	0	0	0	0	0	f	f
1129	330	2	6.00	0	0	0	0	0	0	f	f
1130	348	2	6.50	0	0	0	0	0	0	f	f
1131	470	2	6.00	0	0	0	0	0	0	f	f
1132	520	2	6.50	0	0	0	0	0	0	f	f
1133	478	2	5.50	0	0	0	0	0	0	f	f
1134	6	2	6.00	0	1	0	0	0	0	f	f
1135	86	2	6.00	0	0	0	0	0	0	t	f
1136	105	2	5.50	0	0	0	0	0	0	f	f
1137	117	2	5.50	0	0	0	0	0	0	t	f
1138	80	2	6.00	0	0	0	0	0	0	f	f
1139	211	2	6.00	0	0	0	0	0	0	f	f
1140	189	2	5.50	0	0	0	0	0	0	t	f
1141	414	2	6.00	0	0	0	0	0	0	f	f
1142	317	2	6.00	0	0	0	0	0	0	f	f
1143	290	2	5.50	0	0	0	0	0	0	t	f
1144	261	2	6.50	0	0	0	0	0	0	f	f
1145	331	2	6.00	0	0	0	0	0	0	f	f
1146	512	2	5.50	0	0	0	0	0	0	f	f
1147	463	2	5.50	0	0	0	0	0	0	f	f
1148	514	2	5.50	0	0	0	0	0	0	f	f
1149	499	2	5.50	0	0	0	0	0	0	f	f
1150	11	2	6.00	0	2	0	0	0	0	f	f
1151	134	2	6.00	0	0	0	0	0	0	f	f
1152	173	2	6.00	0	0	0	0	0	0	f	f
1153	75	2	6.50	1	0	0	0	0	0	f	f
1154	70	2	5.50	0	0	0	0	0	0	f	f
1155	160	2	6.50	0	0	0	0	0	0	f	f
1156	375	2	5.00	0	0	0	0	0	0	f	f
1157	277	2	7.00	1	0	0	0	0	0	f	f
1158	355	2	6.00	0	0	0	0	0	0	f	f
1159	343	2	6.50	0	0	0	0	0	0	f	f
1160	325	2	6.00	0	0	0	0	0	0	f	f
1161	395	2	6.50	0	0	0	0	0	0	f	f
1162	283	2	7.00	0	0	0	0	0	1	f	f
1163	511	2	6.50	0	0	0	0	0	1	t	f
1164	522	2	7.00	0	0	0	0	0	0	f	f
1165	530	2	6.00	0	0	0	0	0	0	f	f
1166	17	2	6.50	0	0	0	0	0	0	f	f
1167	107	2	6.00	0	0	0	0	0	0	f	f
1168	124	2	6.50	0	0	0	0	0	0	f	f
1169	175	2	6.00	0	0	0	0	0	0	t	f
1170	161	2	7.00	0	0	0	0	0	0	f	f
1171	174	2	6.50	0	0	0	0	0	0	f	f
1172	256	2	6.00	0	0	0	0	0	0	f	f
1173	274	2	6.00	0	0	0	0	0	0	f	f
1174	376	2	5.50	0	0	0	0	0	0	f	f
1175	366	2	6.00	0	0	0	0	0	0	t	f
1176	297	2	5.00	0	0	0	0	0	0	f	f
1177	377	2	6.00	0	0	0	0	0	0	f	f
1178	396	2	5.50	0	0	0	0	0	0	f	f
1179	515	2	6.00	0	0	0	0	0	0	f	f
1180	460	2	5.00	0	0	0	0	0	0	f	f
1181	505	2	6.00	0	0	0	0	0	0	f	f
1182	18	2	7.00	0	1	0	0	0	0	f	f
1183	74	2	6.00	0	0	0	0	0	0	f	f
1184	98	2	6.00	0	0	0	0	0	0	f	f
1185	92	2	5.50	0	0	0	0	0	0	t	f
1186	135	2	6.50	0	0	0	0	0	0	f	f
1187	298	2	6.00	0	0	0	0	0	0	f	f
1188	305	2	6.00	0	0	0	0	0	0	f	f
1189	342	2	6.00	0	0	0	0	0	0	f	f
1190	318	2	6.50	0	0	0	0	0	0	f	f
1191	379	2	5.50	0	0	0	0	0	0	f	f
1192	349	2	6.50	0	0	0	0	0	0	f	f
1193	398	2	6.00	0	0	0	0	0	0	f	f
1194	508	2	5.50	0	0	0	0	0	0	f	f
1195	500	2	6.00	0	0	0	0	0	0	f	f
1196	490	2	6.00	0	0	0	0	0	0	f	f
1197	507	2	6.00	0	0	0	0	0	0	f	f
1198	13	2	6.00	0	2	0	0	0	0	f	f
1199	66	2	6.00	0	0	0	0	0	0	f	f
1200	136	2	5.50	0	0	0	0	0	0	f	f
1201	67	2	5.50	0	0	0	0	0	0	f	f
1202	82	2	6.50	1	0	0	0	0	0	f	f
1203	81	2	6.00	0	0	0	0	0	0	f	f
1204	137	2	5.00	0	0	0	0	0	0	f	f
1205	300	2	6.00	0	0	0	0	0	0	f	f
1206	270	2	5.50	0	0	0	0	0	0	f	f
1207	262	2	5.00	0	0	0	0	0	0	f	f
1208	351	2	5.50	0	0	0	0	0	0	f	f
1209	299	2	5.00	0	0	0	0	0	0	f	f
1210	444	2	5.50	0	0	0	0	0	0	t	f
1211	445	2	6.50	0	0	0	0	0	1	f	f
1212	474	2	6.00	0	0	0	0	0	0	f	f
1213	475	2	6.00	0	0	0	0	0	0	f	f
1214	7	2	6.50	0	0	0	0	0	0	f	f
1215	87	2	6.00	0	0	0	0	0	0	f	f
1216	88	2	5.50	0	0	0	0	0	0	f	f
1217	138	2	6.50	0	0	0	0	0	0	f	f
1218	108	2	6.00	0	0	0	0	0	0	f	f
1219	194	2	6.00	0	0	0	0	0	0	t	f
1220	307	2	6.50	0	0	0	0	0	0	f	f
1221	306	2	6.50	0	0	0	0	0	1	f	f
1222	332	2	6.00	0	0	0	0	0	0	f	f
1223	291	2	6.00	0	0	0	0	0	0	f	f
1224	353	2	6.00	0	0	0	0	0	0	t	f
1225	278	2	6.00	0	0	0	0	0	0	f	f
1226	461	2	7.00	1	0	0	0	0	0	f	f
1227	480	2	5.00	0	0	0	0	0	0	f	f
1228	446	2	6.00	0	0	0	0	0	0	f	f
1229	3	2	6.00	0	0	0	0	0	0	f	f
1230	236	2	6.00	0	0	0	0	0	0	f	f
1231	110	2	6.00	0	0	0	0	0	0	f	f
1232	144	2	6.00	0	0	0	0	0	0	f	f
1233	145	2	6.00	0	0	0	0	0	0	f	f
1234	125	2	6.00	0	0	0	0	0	0	f	f
1235	176	2	6.50	0	0	0	0	0	0	f	f
1236	267	2	7.50	1	0	0	0	0	0	f	f
1237	292	2	7.00	1	0	0	0	0	0	f	f
1238	380	2	6.50	0	0	0	0	0	1	f	f
1239	417	2	6.50	0	0	0	0	0	1	f	f
1240	363	2	6.00	0	0	0	0	0	0	f	f
1241	516	2	6.00	0	0	0	0	0	0	f	f
1242	491	2	6.00	0	0	0	0	0	0	f	f
1243	494	2	7.00	1	0	0	0	0	0	f	f
1244	455	2	8.50	1	0	0	0	0	2	f	f
1245	8	2	6.50	0	2	0	0	0	0	f	f
1246	127	2	5.50	0	0	0	0	0	0	f	f
1247	164	2	5.00	0	0	0	0	0	0	t	f
1248	89	2	5.50	0	0	0	0	0	0	f	f
1249	146	2	5.00	0	0	0	0	0	0	f	f
1250	310	2	5.50	0	0	0	0	0	0	f	f
1251	293	2	6.00	0	0	0	0	0	0	f	f
1252	419	2	6.00	0	0	0	0	0	0	f	f
1253	286	2	5.50	0	0	0	0	0	0	f	f
1254	354	2	6.00	0	0	0	0	0	0	f	f
1255	401	2	6.00	0	0	0	0	0	0	f	f
1256	333	2	6.00	0	0	0	0	0	0	f	f
1257	381	2	6.00	0	0	0	0	0	0	f	f
1258	509	2	5.50	0	0	0	0	0	0	f	f
1259	495	2	6.00	0	0	0	0	0	0	f	f
1260	513	2	5.50	0	0	0	0	0	0	f	f
1261	1	2	6.00	0	0	0	0	0	0	f	f
1262	111	2	6.00	0	0	0	0	0	0	f	f
1263	139	2	6.00	0	0	0	0	0	0	f	f
1264	68	2	6.50	0	0	0	0	0	0	f	f
1265	177	2	6.00	0	0	0	0	0	0	f	f
1266	260	2	7.00	1	0	0	0	0	0	f	f
1267	268	2	6.50	0	0	0	0	0	1	f	f
1268	302	2	7.00	1	0	0	0	0	0	f	f
1269	313	2	6.00	0	0	0	0	0	0	f	f
1270	271	2	6.50	0	0	0	0	0	0	f	f
1271	364	2	6.50	0	0	0	0	0	0	f	f
1272	294	2	6.00	0	0	0	0	0	0	f	f
1273	486	2	5.50	0	0	0	0	0	0	f	f
1274	541	2	6.00	0	0	0	0	0	0	f	f
1275	21	2	6.00	0	0	0	0	0	0	f	f
1276	196	2	6.00	0	0	0	0	0	0	t	f
1277	71	2	6.00	0	0	0	0	0	0	f	f
1278	83	2	6.50	0	0	0	0	0	1	f	f
1279	113	2	6.00	0	0	0	0	0	0	f	f
1280	140	2	6.00	0	0	0	0	0	0	f	f
1281	178	2	6.00	0	0	0	0	0	0	f	f
1282	319	2	6.50	0	0	0	0	0	0	f	f
1283	264	2	5.50	0	0	0	0	0	0	t	f
1284	266	2	7.00	1	0	0	0	0	0	f	f
1285	356	2	6.00	0	0	0	0	0	0	f	f
1286	265	2	6.00	0	0	0	0	0	0	f	f
1287	510	2	5.50	0	0	0	0	0	0	f	f
1288	483	2	6.00	0	0	0	0	0	0	f	f
1289	532	2	6.00	0	0	0	0	0	0	f	f
1290	16	2	6.00	0	1	0	0	0	0	f	f
1291	147	2	5.50	0	0	0	0	0	0	t	f
1292	116	2	6.00	0	0	0	0	0	0	f	f
1293	114	2	6.00	0	0	0	0	0	0	f	f
1294	115	2	6.50	0	0	0	0	0	0	f	f
1295	220	2	5.50	0	0	0	0	0	0	f	f
1296	403	2	6.00	0	0	0	0	0	0	f	f
1297	372	2	6.50	0	0	0	0	0	0	t	f
1298	280	2	6.50	0	0	0	0	0	0	f	f
1299	365	2	5.00	0	0	0	0	0	0	f	f
1300	404	2	6.00	0	0	0	0	0	0	f	f
1301	359	2	5.50	0	0	0	0	0	0	f	f
1302	493	2	7.00	1	0	0	0	0	0	f	f
1303	523	2	6.00	0	0	0	0	0	0	f	f
1304	456	2	6.00	0	0	0	0	0	0	f	f
1305	14	2	6.50	0	1	0	0	0	0	f	f
1306	102	2	5.50	0	0	0	0	0	0	f	f
1307	148	2	6.00	0	0	0	0	0	0	f	f
1308	166	2	6.00	0	0	0	0	0	0	f	f
1309	221	2	6.00	0	0	0	0	0	0	f	f
1310	165	2	6.00	0	0	0	0	0	0	f	f
1311	129	2	5.00	0	0	0	0	0	0	f	f
1312	344	2	6.00	0	0	0	0	0	0	f	f
1313	368	2	5.50	0	0	0	0	0	0	f	f
1314	390	2	6.00	0	0	0	0	0	0	f	f
1315	373	2	6.00	0	0	0	0	0	0	f	f
1316	320	2	6.00	0	0	0	0	0	0	f	f
1317	383	2	5.50	0	0	0	0	0	0	t	f
1318	472	2	5.50	0	0	0	0	0	0	f	f
1319	487	2	5.50	0	0	0	0	0	0	f	f
1320	517	2	5.00	0	0	0	0	0	0	t	f
1321	2	2	6.50	0	0	0	0	0	0	f	f
1322	100	2	6.00	0	0	0	0	0	0	f	f
1323	130	2	6.50	0	0	0	0	0	0	f	f
1324	76	2	6.00	0	0	0	0	0	0	f	f
1325	141	2	5.50	0	0	0	0	0	0	f	f
1326	84	2	6.50	0	0	0	0	0	0	f	f
1327	167	2	6.00	0	0	0	0	0	0	f	f
1328	72	2	6.00	0	0	0	0	0	0	f	f
1329	295	2	6.00	0	0	0	0	0	0	f	f
1330	369	2	6.00	0	0	0	0	0	0	f	f
1331	281	2	6.50	0	0	0	0	0	0	f	f
1332	357	2	6.00	0	0	0	0	0	0	f	f
1333	481	2	6.50	0	0	0	0	0	0	f	f
1334	448	2	7.00	1	0	0	0	0	0	f	f
1335	484	2	6.50	0	0	0	0	0	1	t	f
1336	471	2	5.50	0	0	0	0	0	0	f	f
1337	15	2	6.50	0	3	0	0	0	0	f	f
1338	142	2	5.50	0	0	0	0	0	0	f	f
1339	150	2	5.00	0	0	0	0	0	0	t	f
1340	118	2	5.50	0	0	0	0	0	0	f	f
1341	199	2	5.50	0	0	0	0	0	0	f	f
1342	149	2	5.00	0	0	0	0	0	0	f	f
1343	315	2	5.00	0	0	0	0	0	0	f	f
1344	389	2	5.50	0	0	0	0	0	0	f	f
1345	303	2	6.50	0	0	0	0	0	1	f	f
1346	421	2	5.50	0	0	0	0	0	0	f	f
1347	422	2	5.50	0	0	0	0	0	0	f	f
1348	308	2	5.50	0	0	0	0	0	0	f	f
1349	385	2	6.00	0	0	0	0	0	0	t	f
1350	449	2	7.00	0	0	0	0	0	0	f	f
1351	467	2	7.00	1	0	0	0	0	0	f	f
1352	453	2	5.50	0	0	0	0	0	0	f	f
1353	26	2	6.50	0	0	0	0	0	0	f	f
1354	179	2	6.50	0	0	0	0	0	0	f	f
1355	152	2	6.00	0	0	0	0	0	0	t	f
1356	91	2	6.50	0	0	0	0	0	0	f	f
1357	168	2	6.00	0	0	0	0	0	0	f	f
1358	77	2	6.50	0	0	0	0	0	0	f	f
1359	370	2	6.00	0	0	0	0	0	0	f	f
1360	387	2	6.00	0	0	0	0	0	0	f	f
1361	288	2	6.00	0	0	0	0	0	0	t	f
1362	399	2	5.50	0	0	0	0	0	0	f	f
1363	358	2	6.50	0	0	0	0	0	0	f	f
1364	386	2	5.50	0	0	0	0	0	0	f	f
1365	466	2	6.50	0	0	0	0	0	0	f	f
1366	488	2	5.50	0	0	0	0	0	0	f	f
1367	468	2	5.50	0	0	0	0	0	0	f	f
1368	528	2	6.00	0	0	0	0	0	0	f	f
1369	27	2	6.00	0	1	0	0	0	0	t	f
1370	153	2	6.00	0	0	0	0	0	0	t	f
1371	180	2	6.00	0	0	0	0	0	0	f	f
1372	197	2	6.00	0	0	0	0	0	0	f	f
1373	131	2	6.50	0	0	0	0	0	0	f	f
1374	198	2	6.00	0	0	0	0	0	0	f	f
1375	223	2	6.00	0	0	0	0	0	0	f	f
1376	101	2	7.00	0	0	0	0	0	0	f	f
1377	423	2	6.00	0	0	0	0	0	0	t	f
1378	321	2	6.50	0	0	0	0	0	0	f	f
1379	326	2	6.00	0	0	0	0	0	0	f	f
1380	282	2	7.00	1	0	0	0	0	0	f	f
1381	328	2	6.00	0	0	0	0	0	0	f	f
1382	452	2	8.00	0	0	0	0	0	1	f	f
1383	525	2	6.00	0	0	0	0	0	0	f	f
1384	497	2	6.00	0	0	0	0	0	0	f	f
1385	12	2	5.00	0	4	0	0	0	0	f	f
1386	155	2	5.00	0	0	0	0	0	0	f	f
1387	253	2	5.00	0	0	0	0	0	0	f	f
1388	183	2	5.50	0	0	0	0	0	0	f	f
1389	181	2	4.50	0	0	0	0	0	0	f	f
1390	169	2	4.00	0	0	0	0	0	0	f	f
1391	79	2	5.50	0	0	0	0	0	0	f	f
1392	225	2	5.50	0	0	0	0	0	0	f	f
1393	170	2	5.00	0	0	0	0	0	0	f	f
1394	409	2	5.50	0	0	0	0	0	0	f	f
1395	309	2	5.00	0	0	0	0	0	0	f	f
1396	391	2	5.50	0	0	0	0	0	0	f	f
1397	327	2	5.50	0	0	0	0	0	0	f	f
1398	521	2	5.00	0	0	0	0	0	0	f	f
1399	503	2	6.00	0	0	0	0	0	0	f	f
1400	469	2	6.00	0	0	0	0	0	0	f	f
1401	46	2	\N	0	0	0	0	0	0	f	f
1402	35	2	\N	0	0	0	0	0	0	f	f
1403	37	2	\N	0	0	0	0	0	0	f	f
1404	24	2	\N	0	0	0	0	0	0	f	f
1405	29	2	\N	0	0	0	0	0	0	f	f
1406	51	2	\N	0	0	0	0	0	0	f	f
1407	36	2	\N	0	0	0	0	0	0	f	f
1408	54	2	\N	0	0	0	0	0	0	f	f
1409	47	2	\N	0	0	0	0	0	0	f	f
1410	90	2	\N	0	0	0	0	0	0	f	f
1411	19	2	\N	0	0	0	0	0	0	f	f
1412	40	2	\N	0	0	0	0	0	0	f	f
1413	42	2	\N	0	0	0	0	0	0	f	f
1414	99	2	\N	0	0	0	0	0	0	f	f
1415	52	2	\N	0	0	0	0	0	0	f	f
1416	33	2	\N	0	0	0	0	0	0	f	f
1417	93	2	\N	0	0	0	0	0	0	f	f
1418	20	2	\N	0	0	0	0	0	0	f	f
1419	28	2	\N	0	0	0	0	0	0	f	f
1420	61	2	\N	0	0	0	0	0	0	f	f
1421	56	2	\N	0	0	0	0	0	0	f	f
1422	58	2	\N	0	0	0	0	0	0	f	f
1423	62	2	\N	0	0	0	0	0	0	f	f
1424	65	2	\N	0	0	0	0	0	0	f	f
1425	30	2	\N	0	0	0	0	0	0	f	f
1426	104	2	\N	0	0	0	0	0	0	f	f
1427	45	2	\N	0	0	0	0	0	0	f	f
1428	106	2	\N	0	0	0	0	0	0	f	f
1429	205	2	\N	0	0	0	0	0	0	f	f
1430	172	2	\N	0	0	0	0	0	0	f	f
1431	143	2	\N	0	0	0	0	0	0	f	f
1432	186	2	\N	0	0	0	0	0	0	f	f
1433	119	2	\N	0	0	0	0	0	0	f	f
1434	171	2	\N	0	0	0	0	0	0	f	f
1435	184	2	\N	0	0	0	0	0	0	f	f
1436	193	2	\N	0	0	0	0	0	0	f	f
1437	204	2	\N	0	0	0	0	0	0	f	f
1438	112	2	\N	0	0	0	0	0	0	f	f
1439	154	2	\N	0	0	0	0	0	0	f	f
1440	128	2	\N	0	0	0	0	0	0	f	f
1441	202	2	\N	0	0	0	0	0	0	f	f
1442	207	2	\N	0	0	0	0	0	0	f	f
1443	208	2	\N	0	0	0	0	0	0	f	f
1444	162	2	\N	0	0	0	0	0	0	f	f
1445	191	2	\N	0	0	0	0	0	0	f	f
1446	151	2	\N	0	0	0	0	0	0	f	f
1447	182	2	\N	0	0	0	0	0	0	f	f
1448	218	2	\N	0	0	0	0	0	0	f	f
1449	224	2	\N	0	0	0	0	0	0	f	f
1450	227	2	\N	0	0	0	0	0	0	f	f
1451	238	2	\N	0	0	0	0	0	0	f	f
1452	235	2	\N	0	0	0	0	0	0	f	f
1453	232	2	\N	0	0	0	0	0	0	f	f
1454	226	2	\N	0	0	0	0	0	0	f	f
1455	248	2	\N	0	0	0	0	0	0	f	f
1456	241	2	\N	0	0	0	0	0	0	f	f
1457	255	2	\N	0	0	0	0	0	0	f	f
1458	230	2	\N	0	0	0	0	0	0	f	f
1459	284	2	\N	0	0	0	0	0	0	f	f
1460	285	2	\N	0	0	0	0	0	0	f	f
1461	244	2	\N	0	0	0	0	0	0	f	f
1462	245	2	\N	0	0	0	0	0	0	f	f
1463	314	2	\N	0	0	0	0	0	0	f	f
1464	273	2	\N	0	0	0	0	0	0	f	f
1465	240	2	\N	0	0	0	0	0	0	f	f
1466	250	2	\N	0	0	0	0	0	0	f	f
1467	214	2	\N	0	0	0	0	0	0	f	f
1468	215	2	\N	0	0	0	0	0	0	f	f
1469	216	2	\N	0	0	0	0	0	0	f	f
1470	287	2	\N	0	0	0	0	0	0	f	f
1471	228	2	\N	0	0	0	0	0	0	f	f
1472	222	2	\N	0	0	0	0	0	0	f	f
1473	254	2	\N	0	0	0	0	0	0	f	f
1474	233	2	\N	0	0	0	0	0	0	f	f
1475	402	2	\N	0	0	0	0	0	0	f	f
1476	418	2	\N	0	0	0	0	0	0	f	f
1477	405	2	\N	0	0	0	0	0	0	f	f
1478	367	2	\N	0	0	0	0	0	0	f	f
1479	337	2	\N	0	0	0	0	0	0	f	f
1480	406	2	\N	0	0	0	0	0	0	f	f
1481	382	2	\N	0	0	0	0	0	0	f	f
1482	316	2	\N	0	0	0	0	0	0	f	f
1483	378	2	\N	0	0	0	0	0	0	f	f
1484	392	2	\N	0	0	0	0	0	0	f	f
1485	412	2	\N	0	0	0	0	0	0	f	f
1486	360	2	\N	0	0	0	0	0	0	f	f
1487	371	2	\N	0	0	0	0	0	0	f	f
1488	397	2	\N	0	0	0	0	0	0	f	f
1489	400	2	\N	0	0	0	0	0	0	f	f
1490	384	2	\N	0	0	0	0	0	0	f	f
1491	341	2	\N	0	0	0	0	0	0	f	f
1492	416	2	\N	0	0	0	0	0	0	f	f
1493	345	2	\N	0	0	0	0	0	0	f	f
1494	411	2	\N	0	0	0	0	0	0	f	f
1495	237	2	\N	0	0	0	0	0	0	f	f
1496	431	2	\N	0	0	0	0	0	0	f	f
1497	429	2	\N	0	0	0	0	0	0	f	f
1498	433	2	\N	0	0	0	0	0	0	f	f
1499	457	2	\N	0	0	0	0	0	0	f	f
1500	502	2	\N	0	0	0	0	0	0	f	f
1501	450	2	\N	0	0	0	0	0	0	f	f
1502	479	2	\N	0	0	0	0	0	0	f	f
1503	492	2	\N	0	0	0	0	0	0	f	f
1504	485	2	\N	0	0	0	0	0	0	f	f
1505	428	2	\N	0	0	0	0	0	0	f	f
1506	438	2	\N	0	0	0	0	0	0	f	f
1507	441	2	\N	0	0	0	0	0	0	f	f
1508	437	2	\N	0	0	0	0	0	0	f	f
1509	425	2	\N	0	0	0	0	0	0	f	f
1510	426	2	\N	0	0	0	0	0	0	f	f
1511	430	2	\N	0	0	0	0	0	0	f	f
1512	477	2	\N	0	0	0	0	0	0	f	f
1513	420	2	\N	0	0	0	0	0	0	f	f
1514	462	2	\N	0	0	0	0	0	0	f	f
1515	427	2	\N	0	0	0	0	0	0	f	f
1516	504	2	\N	0	0	0	0	0	0	f	f
1517	434	2	\N	0	0	0	0	0	0	f	f
1518	435	2	\N	0	0	0	0	0	0	f	f
1519	473	2	\N	0	0	0	0	0	0	f	f
1520	529	2	\N	0	0	0	0	0	0	f	f
1521	531	2	\N	0	0	0	0	0	0	f	f
1522	219	2	\N	0	0	0	0	0	0	f	f
1523	540	2	\N	0	0	0	0	0	0	f	f
1524	43	2	\N	0	0	0	0	0	0	f	f
1525	44	2	\N	0	0	0	0	0	0	f	f
1526	217	2	\N	0	0	0	0	0	0	f	f
1527	126	2	\N	0	0	0	0	0	0	f	f
1528	301	2	\N	0	0	0	0	0	0	f	f
1529	195	2	\N	0	0	0	0	0	0	f	f
1530	362	2	\N	0	0	0	0	0	0	f	f
1531	229	2	\N	0	0	0	0	0	0	f	f
1532	55	2	\N	0	0	0	0	0	0	f	f
1533	206	2	\N	0	0	0	0	0	0	f	f
1534	247	2	\N	0	0	0	0	0	0	f	f
1535	246	2	\N	0	0	0	0	0	0	f	f
1536	518	2	\N	0	0	0	0	0	0	f	f
1537	527	2	\N	0	0	0	0	0	0	f	f
1538	538	2	\N	0	0	0	0	0	0	f	f
1539	48	2	\N	0	0	0	0	0	0	f	f
1540	258	2	\N	0	0	0	0	0	0	f	f
1541	388	2	\N	0	0	0	0	0	0	f	f
1542	447	2	\N	0	0	0	0	0	0	f	f
1543	34	2	\N	0	0	0	0	0	0	f	f
1544	289	2	\N	0	0	0	0	0	0	f	f
1545	436	2	\N	0	0	0	0	0	0	f	f
1546	498	2	\N	0	0	0	0	0	0	f	f
1547	534	2	\N	0	0	0	0	0	0	f	f
1548	542	2	\N	0	0	0	0	0	0	f	f
1549	543	2	\N	0	0	0	0	0	0	f	f
1550	49	2	\N	0	0	0	0	0	0	f	f
1551	4	2	\N	0	0	0	0	0	0	f	f
1552	201	2	\N	0	0	0	0	0	0	f	f
1553	239	2	\N	0	0	0	0	0	0	f	f
1554	334	2	\N	0	0	0	0	0	0	f	f
1555	279	2	\N	0	0	0	0	0	0	f	f
1556	476	2	\N	0	0	0	0	0	0	f	f
1557	60	2	\N	0	0	0	0	0	0	f	f
1558	57	2	\N	0	0	0	0	0	0	f	f
1559	78	2	\N	0	0	0	0	0	0	f	f
1560	272	2	\N	0	0	0	0	0	0	f	f
1561	524	2	\N	0	0	0	0	0	0	f	f
1562	39	2	\N	0	0	0	0	0	0	f	f
1563	192	2	\N	0	0	0	0	0	0	f	f
1564	59	2	\N	0	0	0	0	0	0	f	f
1565	440	2	\N	0	0	0	0	0	0	f	f
1566	442	2	\N	0	0	0	0	0	0	f	f
1567	25	2	\N	0	0	0	0	0	0	f	f
1568	109	2	\N	0	0	0	0	0	0	f	f
1569	234	2	\N	0	0	0	0	0	0	f	f
1570	410	2	\N	0	0	0	0	0	0	f	f
1571	535	2	\N	0	0	0	0	0	0	f	f
1572	322	2	\N	0	0	0	0	0	0	f	f
1573	53	2	\N	0	0	0	0	0	0	f	f
1574	251	2	\N	0	0	0	0	0	0	f	f
1575	275	2	\N	0	0	0	0	0	0	f	f
1576	335	2	\N	0	0	0	0	0	0	f	f
1577	346	2	\N	0	0	0	0	0	0	f	f
1578	32	2	\N	0	0	0	0	0	0	f	f
1579	158	2	\N	0	0	0	0	0	0	f	f
1580	200	2	\N	0	0	0	0	0	0	f	f
1581	329	2	\N	0	0	0	0	0	0	f	f
1582	276	2	\N	0	0	0	0	0	0	f	f
1583	73	2	\N	0	0	0	0	0	0	f	f
1584	537	2	\N	0	0	0	0	0	0	f	f
1585	519	2	\N	0	0	0	0	0	0	f	f
1586	336	2	\N	0	0	0	0	0	0	f	f
1587	38	2	\N	0	0	0	0	0	0	f	f
1588	190	2	\N	0	0	0	0	0	0	f	f
1589	213	2	\N	0	0	0	0	0	0	f	f
1590	415	2	\N	0	0	0	0	0	0	f	f
1591	22	2	\N	0	0	0	0	0	0	f	f
1592	249	2	\N	0	0	0	0	0	0	f	f
1593	203	2	\N	0	0	0	0	0	0	f	f
1594	407	2	\N	0	0	0	0	0	0	f	f
1595	439	2	\N	0	0	0	0	0	0	f	f
1596	539	2	\N	0	0	0	0	0	0	f	f
1597	496	2	\N	0	0	0	0	0	0	f	f
1598	252	2	\N	0	0	0	0	0	0	f	f
1599	413	2	\N	0	0	0	0	0	0	f	f
1600	408	2	\N	0	0	0	0	0	0	f	f
1601	424	2	\N	0	0	0	0	0	0	f	f
1602	41	2	\N	0	0	0	0	0	0	f	f
1603	259	2	\N	0	0	0	0	0	0	f	f
1604	163	2	\N	0	0	0	0	0	0	f	f
1605	352	2	\N	0	0	0	0	0	0	f	f
1606	350	2	\N	0	0	0	0	0	0	f	f
1607	257	2	\N	0	0	0	0	0	0	f	f
1608	432	2	\N	0	0	0	0	0	0	f	f
1609	501	2	\N	0	0	0	0	0	0	f	f
1610	64	2	\N	0	0	0	0	0	0	f	f
1611	188	2	\N	0	0	0	0	0	0	f	f
1612	212	2	\N	0	0	0	0	0	0	f	f
1613	464	2	\N	0	0	0	0	0	0	f	f
1614	526	2	\N	0	0	0	0	0	0	f	f
1615	533	2	\N	0	0	0	0	0	0	f	f
1616	393	2	\N	0	0	0	0	0	0	f	f
1617	23	2	\N	0	0	0	0	0	0	f	f
1618	50	2	\N	0	0	0	0	0	0	f	f
1619	443	2	\N	0	0	0	0	0	0	f	f
1620	31	2	\N	0	0	0	0	0	0	f	f
1621	185	2	\N	0	0	0	0	0	0	f	f
1622	243	2	\N	0	0	0	0	0	0	f	f
1623	242	2	\N	0	0	0	0	0	0	f	f
1624	324	2	\N	0	0	0	0	0	0	f	f
1625	536	2	\N	0	0	0	0	0	0	f	f
1626	63	2	\N	0	0	0	0	0	0	f	f
1627	231	2	\N	0	0	0	0	0	0	f	f
1628	95	2	\N	0	0	0	0	0	0	f	f
1629	506	2	\N	0	0	0	0	0	0	f	f
1630	5	3	6.00	0	1	0	0	0	0	f	f
1631	94	3	6.50	0	0	0	0	0	0	f	f
1632	132	3	7.00	1	0	0	0	0	0	f	f
1633	93	3	6.50	0	0	0	0	0	0	f	f
1634	157	3	6.50	0	0	0	0	0	0	f	f
1635	200	3	6.00	0	0	0	0	0	0	f	f
1636	338	3	7.00	0	0	0	0	0	0	f	f
1637	296	3	6.50	0	0	0	0	0	0	f	f
1638	394	3	6.00	0	0	0	0	0	0	f	f
1639	339	3	6.00	0	0	0	0	0	0	f	f
1640	276	3	6.00	0	0	0	0	0	0	f	f
1641	364	3	6.00	0	0	0	0	0	0	f	f
1642	312	3	7.50	1	0	0	0	0	1	f	f
1643	482	3	6.00	0	0	0	0	0	0	f	f
1644	459	3	8.00	2	0	0	0	0	0	f	f
1645	465	3	6.50	0	0	0	0	0	2	f	f
1646	9	3	6.00	0	1	0	0	0	0	t	f
1647	209	3	5.50	0	0	0	0	0	0	f	f
1648	123	3	5.50	0	0	0	0	0	0	f	f
1649	85	3	5.50	0	0	0	0	0	0	t	f
1650	121	3	5.50	0	0	0	0	0	0	f	f
1651	103	3	6.00	0	0	0	0	0	0	f	f
1652	341	3	5.50	0	0	0	0	0	0	f	f
1653	340	3	5.50	0	0	0	0	0	0	f	f
1654	263	3	5.50	0	0	0	0	0	0	f	f
1655	269	3	6.00	0	0	0	0	0	0	f	f
1656	346	3	6.00	0	0	0	0	0	0	f	f
1657	374	3	5.50	0	0	0	0	0	0	f	f
1658	336	3	6.00	0	0	0	0	0	0	f	f
1659	458	3	5.50	0	0	0	0	0	0	f	f
1660	451	3	5.50	0	0	0	0	0	0	f	f
1661	489	3	6.00	0	0	0	0	0	0	f	f
1662	10	3	7.00	0	0	0	0	0	0	f	f
1663	96	3	6.50	0	0	0	0	0	0	f	f
1664	97	3	7.00	1	0	0	0	0	0	f	f
1665	133	3	6.00	0	0	0	0	0	0	t	f
1666	159	3	6.50	0	0	0	0	0	0	f	f
1667	69	3	6.50	0	0	0	0	0	0	f	f
1668	229	3	6.00	0	0	0	0	0	0	f	f
1669	347	3	6.00	0	0	0	0	0	0	t	f
1670	304	3	6.00	0	0	0	0	0	0	f	f
1671	361	3	6.00	0	0	0	0	0	0	f	f
1672	330	3	6.00	0	0	0	0	0	0	f	f
1673	348	3	6.00	0	0	0	0	0	0	f	f
1674	289	3	7.00	1	0	0	0	0	0	f	f
1675	498	3	5.50	0	0	0	0	0	0	f	f
1676	470	3	6.00	0	0	0	0	0	0	t	f
1677	478	3	6.00	0	0	0	0	0	0	f	f
1678	6	3	6.00	0	1	0	0	0	0	f	f
1679	86	3	5.50	0	0	0	0	0	0	f	f
1680	105	3	6.00	0	0	0	0	0	0	t	f
1681	117	3	5.50	0	0	0	0	0	0	f	t
1682	80	3	6.00	0	0	0	0	0	0	f	f
1683	414	3	5.50	0	0	0	0	0	0	t	f
1684	316	3	6.50	0	0	0	0	0	0	f	f
1685	317	3	6.00	0	0	0	0	0	0	f	f
1686	290	3	5.50	0	0	0	0	0	0	f	f
1687	261	3	7.00	1	0	0	0	0	0	f	f
1688	331	3	6.00	0	0	0	0	0	0	f	f
1689	512	3	5.50	0	0	0	0	0	0	f	f
1690	463	3	6.00	0	0	0	0	0	0	f	f
1691	479	3	6.00	0	0	0	0	0	0	f	f
1692	514	3	6.50	0	0	0	0	0	0	f	f
1693	499	3	5.50	0	0	0	0	0	0	f	f
1694	11	3	7.50	0	0	0	0	0	0	f	f
1695	134	3	5.50	0	0	0	0	0	0	f	f
1696	173	3	5.50	0	0	0	0	0	0	f	f
1697	75	3	5.50	0	0	0	0	0	0	f	f
1698	70	3	5.00	0	0	0	0	0	0	f	f
1699	160	3	6.00	0	0	0	0	0	0	f	f
1700	375	3	6.00	0	0	0	0	0	0	f	f
1701	277	3	6.00	0	0	0	0	0	0	f	f
1702	355	3	5.50	0	0	0	0	0	0	f	f
1703	343	3	5.50	0	0	0	0	0	0	f	f
1704	393	3	6.00	0	0	0	0	0	0	f	f
1705	395	3	5.50	0	0	0	0	0	0	t	f
1706	283	3	5.50	0	0	0	0	0	0	f	f
1707	511	3	5.50	0	0	0	0	0	0	f	f
1708	464	3	5.50	0	0	0	0	0	0	f	f
1709	457	3	6.00	0	0	0	0	0	0	f	f
1710	17	3	7.00	0	3	0	0	0	0	f	f
1711	107	3	6.50	0	0	0	0	0	0	f	f
1712	124	3	6.00	1	0	0	0	0	0	f	f
1713	175	3	5.00	0	0	0	0	0	0	f	f
1714	213	3	6.00	0	0	0	0	0	0	f	f
1715	161	3	6.00	0	0	0	0	0	0	f	f
1716	228	3	6.00	0	0	0	0	0	0	f	f
1717	174	3	5.00	0	0	0	0	0	0	f	f
1718	274	3	6.00	0	0	0	0	0	0	f	f
1719	392	3	6.00	0	0	0	0	0	0	f	f
1720	376	3	5.50	0	0	0	0	0	0	f	f
1721	366	3	5.50	0	0	0	0	0	0	f	f
1722	377	3	6.50	0	0	0	0	0	0	f	f
1723	515	3	5.00	0	0	0	0	0	0	f	f
1724	460	3	5.50	0	0	0	0	0	0	f	f
1725	505	3	5.50	0	0	0	0	0	0	f	f
1726	18	3	6.50	0	1	0	0	0	0	f	f
1727	215	3	6.00	0	0	0	0	0	0	f	f
1728	74	3	6.00	0	0	0	0	0	0	f	f
1729	98	3	6.00	0	0	0	0	0	0	f	f
1730	92	3	6.00	0	0	0	0	0	0	t	f
1731	135	3	6.50	0	0	0	0	0	0	f	f
1732	305	3	5.50	0	0	0	0	0	0	t	f
1733	397	3	6.50	0	0	0	0	0	0	f	f
1734	342	3	5.50	0	0	0	0	0	0	f	f
1735	318	3	5.50	0	0	0	0	0	0	f	f
1736	379	3	6.50	0	0	0	0	0	0	f	f
1737	349	3	5.50	0	0	0	0	0	0	f	f
1738	508	3	5.00	0	0	0	0	0	0	f	f
1739	500	3	7.00	1	0	0	0	0	0	f	f
1740	507	3	6.00	0	0	0	0	0	0	f	f
1741	13	3	5.00	0	4	0	0	0	0	f	f
1742	66	3	6.50	0	0	0	0	0	1	f	f
1743	136	3	6.00	0	0	0	0	0	0	t	f
1744	67	3	5.50	0	0	0	0	0	0	f	f
1745	233	3	6.00	0	0	0	0	0	0	f	f
1746	104	3	6.00	0	0	0	0	0	0	f	f
1747	82	3	6.00	0	0	0	0	0	0	f	f
1748	81	3	6.50	0	0	0	0	0	1	f	f
1749	300	3	6.00	0	0	0	0	0	1	f	f
1750	270	3	5.50	0	0	0	0	0	0	f	f
1751	262	3	7.50	2	0	0	0	0	0	f	f
1752	351	3	5.50	0	0	0	0	0	0	t	f
1753	299	3	6.00	0	0	0	0	0	0	f	f
1754	444	3	5.00	0	0	0	0	0	0	f	f
1755	445	3	7.00	1	0	0	0	0	0	f	f
1756	474	3	5.50	0	0	0	0	0	0	f	f
1757	7	3	6.00	0	3	0	0	0	0	f	f
1758	87	3	7.50	0	0	0	0	0	2	f	f
1759	88	3	5.50	0	0	0	0	0	0	f	f
1760	138	3	6.00	0	0	0	0	0	0	f	f
1761	109	3	5.50	0	0	0	0	0	0	f	f
1762	108	3	7.00	1	0	0	0	0	0	f	f
1763	194	3	6.00	0	0	0	0	0	0	f	f
1764	307	3	6.50	0	0	0	0	0	0	t	f
1765	332	3	6.00	0	0	0	0	0	0	f	f
1766	291	3	7.00	1	0	0	0	0	0	f	f
1767	353	3	5.00	0	0	0	0	0	0	t	f
1768	410	3	7.50	1	0	0	0	0	0	f	f
1769	461	3	5.00	0	0	0	0	0	0	f	f
1770	480	3	6.50	0	0	0	0	0	1	f	f
1771	477	3	6.00	0	0	0	0	0	0	f	f
1772	446	3	7.00	1	0	0	0	0	1	f	f
1773	3	3	6.00	0	1	0	0	0	0	f	f
1774	126	3	5.50	0	0	0	0	0	0	f	f
1775	110	3	6.00	0	0	0	0	0	0	t	f
1776	145	3	5.50	0	0	0	0	0	0	f	f
1777	125	3	6.50	0	0	0	0	0	0	f	f
1778	301	3	6.00	0	0	0	0	0	0	f	f
1779	267	3	6.50	0	0	0	0	0	0	f	f
1780	292	3	5.50	0	0	0	0	0	0	f	f
1781	380	3	6.00	0	0	0	0	0	0	t	f
1782	417	3	5.50	0	0	0	0	0	0	t	f
1783	285	3	6.00	0	0	0	0	0	0	f	f
1784	363	3	5.50	0	0	0	0	0	0	f	f
1785	516	3	6.00	0	0	0	0	0	0	f	f
1786	491	3	5.50	0	0	0	0	0	0	f	f
1787	494	3	5.50	0	0	0	0	0	0	f	f
1788	455	3	5.50	0	0	0	0	0	0	f	f
1789	8	3	5.50	0	4	0	0	0	0	f	f
1790	127	3	4.50	0	0	0	0	0	0	f	f
1791	164	3	4.50	0	0	0	0	0	0	f	f
1792	89	3	6.00	0	0	0	0	0	0	f	f
1793	146	3	6.00	0	0	0	0	0	0	f	f
1794	218	3	5.50	0	0	0	0	0	0	f	f
1795	257	3	4.00	0	0	0	0	0	0	f	f
1796	310	3	5.50	0	0	0	0	0	0	f	f
1797	293	3	5.50	0	0	0	0	0	0	f	f
1798	354	3	5.00	0	0	0	0	0	0	f	f
1799	333	3	5.50	0	0	0	0	0	0	f	f
1800	381	3	5.00	0	0	0	0	0	0	f	f
1801	412	3	5.50	0	0	0	0	0	0	f	f
1802	509	3	5.50	0	0	0	0	0	0	f	f
1803	495	3	7.00	1	0	0	0	0	0	f	f
1804	513	3	5.50	0	0	0	0	0	0	f	f
1805	47	3	6.00	0	0	0	0	0	0	f	f
1806	1	3	6.00	0	0	0	0	0	0	f	f
1807	111	3	6.50	0	0	0	0	0	0	f	f
1808	139	3	6.00	0	0	0	0	0	0	t	f
1809	68	3	6.00	0	0	0	0	0	0	f	f
1810	177	3	6.00	0	0	0	0	0	0	t	f
1811	193	3	6.00	0	0	0	0	0	0	f	f
1812	273	3	6.50	0	0	0	0	0	0	f	f
1813	260	3	7.00	0	0	0	0	0	0	f	f
1814	268	3	7.50	1	0	0	0	0	0	f	f
1815	302	3	6.50	0	0	0	0	0	0	f	f
1816	313	3	6.00	0	0	0	0	0	0	f	f
1817	271	3	6.50	0	0	0	0	0	1	t	f
1818	294	3	6.50	0	0	0	0	0	0	f	f
1819	485	3	6.00	0	0	0	0	0	0	f	f
1820	486	3	5.00	0	0	0	0	0	0	f	f
1821	4	3	5.50	0	1	0	0	0	0	f	f
1822	71	3	6.50	0	0	0	0	0	1	f	f
1823	83	3	6.00	0	0	0	0	0	0	f	f
1824	113	3	6.50	0	0	0	0	0	0	f	f
1825	178	3	6.00	0	0	0	0	0	0	f	f
1826	112	3	7.00	1	0	0	0	0	0	f	f
1827	319	3	6.50	0	0	0	0	0	0	f	f
1828	264	3	7.00	0	0	0	0	0	0	f	f
1829	266	3	6.50	0	0	0	0	0	1	f	f
1830	356	3	6.00	0	0	0	0	0	0	f	f
1831	360	3	6.00	0	0	0	0	0	0	f	f
1832	265	3	6.50	0	0	0	0	0	0	f	f
1833	334	3	6.00	0	0	0	0	0	0	f	f
1834	279	3	6.00	0	0	0	0	0	0	f	f
1835	450	3	7.00	1	0	0	0	0	0	f	f
1836	510	3	6.00	0	0	0	0	0	0	f	f
1837	16	3	5.00	0	2	0	0	0	0	f	f
1838	116	3	6.00	0	0	0	0	0	0	f	f
1839	114	3	6.00	0	0	0	0	0	0	f	f
1840	115	3	5.50	0	0	0	0	0	0	f	f
1841	220	3	6.00	0	0	0	0	0	0	f	f
1842	224	3	5.50	0	0	0	0	0	0	f	f
1843	403	3	6.00	0	0	0	0	0	0	f	f
1844	372	3	6.00	0	0	0	0	0	0	f	f
1845	280	3	6.50	0	0	0	0	0	0	f	f
1846	365	3	6.00	0	0	0	0	0	0	f	f
1847	404	3	5.50	0	0	0	0	0	0	t	f
1848	359	3	5.50	0	0	0	0	0	0	f	f
1849	493	3	5.00	0	0	0	0	0	0	f	f
1850	531	3	6.00	0	0	0	0	0	0	f	f
1851	523	3	5.50	0	0	0	0	0	0	f	f
1852	456	3	5.50	0	0	0	0	0	0	f	f
1853	14	3	6.00	0	1	0	0	0	0	f	f
1854	148	3	5.50	0	0	0	0	0	0	t	f
1855	221	3	6.00	0	0	0	0	0	0	f	f
1856	186	3	6.50	0	0	0	0	0	0	f	f
1857	165	3	5.00	0	0	0	0	0	0	f	f
1858	129	3	5.50	0	0	0	0	0	0	f	f
1859	344	3	6.00	0	0	0	0	0	0	f	f
1860	368	3	5.50	0	0	0	0	0	0	f	f
1861	390	3	6.00	0	0	0	0	0	0	f	f
1862	373	3	5.00	0	0	0	0	0	0	f	f
1863	324	3	6.00	0	0	0	0	0	0	f	f
1864	382	3	6.00	0	0	0	0	0	0	f	f
1865	320	3	6.50	0	0	0	0	0	0	f	f
1866	472	3	6.00	0	0	0	0	0	0	f	f
1867	487	3	5.50	0	0	0	0	0	0	f	f
1868	517	3	6.00	0	0	0	0	0	0	f	f
1869	2	3	6.50	0	1	0	0	0	0	f	f
1870	100	3	6.00	0	0	0	0	0	0	f	f
1871	130	3	6.00	0	0	0	0	0	0	f	f
1872	76	3	6.00	0	0	0	0	0	0	f	f
1873	141	3	5.50	0	0	0	0	0	0	t	f
1874	84	3	6.00	0	0	0	0	0	0	f	f
1875	72	3	5.00	0	0	0	0	0	0	t	f
1876	295	3	6.00	0	0	0	0	0	0	f	f
1877	369	3	6.00	0	0	0	0	0	0	f	f
1878	281	3	5.50	0	0	0	0	0	0	f	f
1879	384	3	5.50	0	0	0	0	0	0	f	f
1880	420	3	5.50	0	0	0	0	0	0	f	f
1881	357	3	6.00	0	0	0	0	0	0	f	f
1882	481	3	5.50	0	0	0	0	0	0	f	f
1883	448	3	6.50	0	0	0	0	0	0	f	f
1884	484	3	5.50	0	0	0	0	0	0	f	f
1885	15	3	7.00	0	0	0	0	0	0	f	f
1886	142	3	6.50	0	0	0	0	0	0	f	f
1887	150	3	6.00	0	0	0	0	0	0	t	f
1888	206	3	6.00	0	0	0	0	0	0	f	f
1889	118	3	6.50	0	0	0	0	0	0	f	f
1890	149	3	6.50	0	0	0	0	0	1	t	f
1891	315	3	6.00	0	0	0	0	0	0	t	f
1892	389	3	5.50	0	0	0	0	0	0	t	f
1893	303	3	6.00	0	0	0	0	0	0	t	f
1894	314	3	6.00	0	0	0	0	0	0	f	f
1895	287	3	5.50	0	0	0	0	0	0	f	f
1896	308	3	7.00	1	0	0	0	0	0	f	f
1897	449	3	6.50	0	0	0	0	0	0	f	f
1898	467	3	6.00	0	0	0	0	0	0	t	f
1899	453	3	6.00	0	0	0	0	0	0	f	f
1900	518	3	6.00	0	0	0	0	0	0	f	f
1901	26	3	6.00	0	0	0	0	0	0	f	f
1902	179	3	6.00	0	0	0	0	0	0	f	f
1903	152	3	6.00	0	0	0	0	0	0	f	f
1904	91	3	7.00	0	0	0	0	0	0	f	f
1905	151	3	6.00	0	0	0	0	0	0	t	f
1906	77	3	6.50	0	0	0	0	0	0	f	f
1907	370	3	6.00	0	0	0	0	0	0	f	f
1908	387	3	6.00	0	0	0	0	0	0	f	f
1909	288	3	6.50	0	0	0	0	0	0	f	f
1910	399	3	6.50	0	0	0	0	0	0	t	f
1911	358	3	6.00	0	0	0	0	0	0	f	f
1912	407	3	6.00	0	0	0	0	0	0	f	f
1913	466	3	7.50	1	0	0	0	0	0	f	f
1914	488	3	6.00	0	0	0	0	0	1	f	f
1915	468	3	6.00	0	0	0	0	0	0	f	f
1916	528	3	6.50	0	0	0	0	0	0	t	f
1917	27	3	5.50	0	0	0	0	0	0	f	f
1918	154	3	6.50	0	0	0	0	0	0	t	f
1919	153	3	6.00	0	0	0	0	0	0	f	f
1920	180	3	5.50	0	0	0	0	0	0	f	f
1921	197	3	6.00	0	0	0	0	0	0	f	f
1922	131	3	7.00	0	0	0	0	0	0	f	f
1923	198	3	6.00	0	0	0	0	0	0	f	f
1924	101	3	6.50	0	0	0	0	0	0	f	f
1925	272	3	5.50	0	0	0	0	0	0	f	f
1926	423	3	6.00	0	0	0	0	0	0	f	f
1927	321	3	6.00	0	0	0	0	0	0	t	f
1928	282	3	7.00	0	0	0	0	0	0	f	f
1929	328	3	6.50	0	0	0	0	0	0	f	f
1930	452	3	6.00	0	0	0	0	0	0	f	f
1931	524	3	7.00	1	0	0	0	0	0	f	f
1932	497	3	6.00	0	0	0	0	0	0	f	f
1933	12	3	6.00	0	0	0	0	0	0	f	f
1934	155	3	6.50	0	0	0	0	0	0	f	f
1935	183	3	6.00	0	0	0	0	0	0	f	f
1936	181	3	6.50	0	0	0	0	0	0	f	f
1937	169	3	6.00	0	0	0	0	0	0	f	f
1938	79	3	6.00	0	0	0	0	0	0	f	f
1939	170	3	6.00	0	0	0	0	0	0	f	f
1940	345	3	6.00	0	0	0	0	0	0	f	f
1941	413	3	6.00	0	0	0	0	0	0	f	f
1942	408	3	6.00	0	0	0	0	0	0	f	f
1943	309	3	7.00	0	0	0	0	0	0	t	f
1944	391	3	6.00	0	0	0	0	0	0	f	f
1945	327	3	6.50	0	0	0	0	0	0	f	f
1946	521	3	6.00	0	0	0	0	0	0	f	f
1947	473	3	6.00	0	0	0	0	0	0	f	f
1948	469	3	6.00	0	0	0	0	0	0	t	f
1949	46	3	\N	0	0	0	0	0	0	f	f
1950	35	3	\N	0	0	0	0	0	0	f	f
1951	37	3	\N	0	0	0	0	0	0	f	f
1952	24	3	\N	0	0	0	0	0	0	f	f
1953	29	3	\N	0	0	0	0	0	0	f	f
1954	51	3	\N	0	0	0	0	0	0	f	f
1955	36	3	\N	0	0	0	0	0	0	f	f
1956	54	3	\N	0	0	0	0	0	0	f	f
1957	90	3	\N	0	0	0	0	0	0	f	f
1958	21	3	\N	0	0	0	0	0	0	f	f
1959	19	3	\N	0	0	0	0	0	0	f	f
1960	40	3	\N	0	0	0	0	0	0	f	f
1961	42	3	\N	0	0	0	0	0	0	f	f
1962	99	3	\N	0	0	0	0	0	0	f	f
1963	52	3	\N	0	0	0	0	0	0	f	f
1964	33	3	\N	0	0	0	0	0	0	f	f
1965	20	3	\N	0	0	0	0	0	0	f	f
1966	28	3	\N	0	0	0	0	0	0	f	f
1967	61	3	\N	0	0	0	0	0	0	f	f
1968	56	3	\N	0	0	0	0	0	0	f	f
1969	58	3	\N	0	0	0	0	0	0	f	f
1970	62	3	\N	0	0	0	0	0	0	f	f
1971	65	3	\N	0	0	0	0	0	0	f	f
1972	30	3	\N	0	0	0	0	0	0	f	f
1973	45	3	\N	0	0	0	0	0	0	f	f
1974	147	3	\N	0	0	0	0	0	0	f	f
1975	106	3	\N	0	0	0	0	0	0	f	f
1976	205	3	\N	0	0	0	0	0	0	f	f
1977	172	3	\N	0	0	0	0	0	0	f	f
1978	143	3	\N	0	0	0	0	0	0	f	f
1979	119	3	\N	0	0	0	0	0	0	f	f
1980	189	3	\N	0	0	0	0	0	0	f	f
1981	171	3	\N	0	0	0	0	0	0	f	f
1982	144	3	\N	0	0	0	0	0	0	f	f
1983	176	3	\N	0	0	0	0	0	0	f	f
1984	199	3	\N	0	0	0	0	0	0	f	f
1985	184	3	\N	0	0	0	0	0	0	f	f
1986	122	3	\N	0	0	0	0	0	0	f	f
1987	204	3	\N	0	0	0	0	0	0	f	f
1988	196	3	\N	0	0	0	0	0	0	f	f
1989	140	3	\N	0	0	0	0	0	0	f	f
1990	128	3	\N	0	0	0	0	0	0	f	f
1991	202	3	\N	0	0	0	0	0	0	f	f
1992	156	3	\N	0	0	0	0	0	0	f	f
1993	207	3	\N	0	0	0	0	0	0	f	f
1994	120	3	\N	0	0	0	0	0	0	f	f
1995	208	3	\N	0	0	0	0	0	0	f	f
1996	187	3	\N	0	0	0	0	0	0	f	f
1997	162	3	\N	0	0	0	0	0	0	f	f
1998	191	3	\N	0	0	0	0	0	0	f	f
1999	168	3	\N	0	0	0	0	0	0	f	f
2000	182	3	\N	0	0	0	0	0	0	f	f
2001	137	3	\N	0	0	0	0	0	0	f	f
2002	227	3	\N	0	0	0	0	0	0	f	f
2003	238	3	\N	0	0	0	0	0	0	f	f
2004	286	3	\N	0	0	0	0	0	0	f	f
2005	235	3	\N	0	0	0	0	0	0	f	f
2006	232	3	\N	0	0	0	0	0	0	f	f
2007	226	3	\N	0	0	0	0	0	0	f	f
2008	248	3	\N	0	0	0	0	0	0	f	f
2009	241	3	\N	0	0	0	0	0	0	f	f
2010	255	3	\N	0	0	0	0	0	0	f	f
2011	230	3	\N	0	0	0	0	0	0	f	f
2012	211	3	\N	0	0	0	0	0	0	f	f
2013	297	3	\N	0	0	0	0	0	0	f	f
2014	284	3	\N	0	0	0	0	0	0	f	f
2015	244	3	\N	0	0	0	0	0	0	f	f
2016	245	3	\N	0	0	0	0	0	0	f	f
2017	210	3	\N	0	0	0	0	0	0	f	f
2018	240	3	\N	0	0	0	0	0	0	f	f
2019	250	3	\N	0	0	0	0	0	0	f	f
2020	223	3	\N	0	0	0	0	0	0	f	f
2021	214	3	\N	0	0	0	0	0	0	f	f
2022	298	3	\N	0	0	0	0	0	0	f	f
2023	216	3	\N	0	0	0	0	0	0	f	f
2024	278	3	\N	0	0	0	0	0	0	f	f
2025	222	3	\N	0	0	0	0	0	0	f	f
2026	253	3	\N	0	0	0	0	0	0	f	f
2027	254	3	\N	0	0	0	0	0	0	f	f
2028	225	3	\N	0	0	0	0	0	0	f	f
2029	402	3	\N	0	0	0	0	0	0	f	f
2030	418	3	\N	0	0	0	0	0	0	f	f
2031	325	3	\N	0	0	0	0	0	0	f	f
2032	405	3	\N	0	0	0	0	0	0	f	f
2033	367	3	\N	0	0	0	0	0	0	f	f
2034	337	3	\N	0	0	0	0	0	0	f	f
2035	406	3	\N	0	0	0	0	0	0	f	f
2036	378	3	\N	0	0	0	0	0	0	f	f
2037	385	3	\N	0	0	0	0	0	0	f	f
2038	323	3	\N	0	0	0	0	0	0	f	f
2039	326	3	\N	0	0	0	0	0	0	f	f
2040	371	3	\N	0	0	0	0	0	0	f	f
2041	400	3	\N	0	0	0	0	0	0	f	f
2042	396	3	\N	0	0	0	0	0	0	f	f
2043	416	3	\N	0	0	0	0	0	0	f	f
2044	386	3	\N	0	0	0	0	0	0	f	f
2045	409	3	\N	0	0	0	0	0	0	f	f
2046	411	3	\N	0	0	0	0	0	0	f	f
2047	237	3	\N	0	0	0	0	0	0	f	f
2048	431	3	\N	0	0	0	0	0	0	f	f
2049	429	3	\N	0	0	0	0	0	0	f	f
2050	433	3	\N	0	0	0	0	0	0	f	f
2051	522	3	\N	0	0	0	0	0	0	f	f
2052	502	3	\N	0	0	0	0	0	0	f	f
2053	492	3	\N	0	0	0	0	0	0	f	f
2054	428	3	\N	0	0	0	0	0	0	f	f
2055	438	3	\N	0	0	0	0	0	0	f	f
2056	520	3	\N	0	0	0	0	0	0	f	f
2057	441	3	\N	0	0	0	0	0	0	f	f
2058	437	3	\N	0	0	0	0	0	0	f	f
2059	525	3	\N	0	0	0	0	0	0	f	f
2060	425	3	\N	0	0	0	0	0	0	f	f
2061	426	3	\N	0	0	0	0	0	0	f	f
2062	430	3	\N	0	0	0	0	0	0	f	f
2063	462	3	\N	0	0	0	0	0	0	f	f
2064	427	3	\N	0	0	0	0	0	0	f	f
2065	504	3	\N	0	0	0	0	0	0	f	f
2066	434	3	\N	0	0	0	0	0	0	f	f
2067	435	3	\N	0	0	0	0	0	0	f	f
2068	529	3	\N	0	0	0	0	0	0	f	f
2069	219	3	\N	0	0	0	0	0	0	f	f
2070	530	3	\N	0	0	0	0	0	0	f	f
2071	540	3	\N	0	0	0	0	0	0	f	f
2072	541	3	\N	0	0	0	0	0	0	f	f
2073	43	3	\N	0	0	0	0	0	0	f	f
2074	44	3	\N	0	0	0	0	0	0	f	f
2075	236	3	\N	0	0	0	0	0	0	f	f
2076	217	3	\N	0	0	0	0	0	0	f	f
2077	195	3	\N	0	0	0	0	0	0	f	f
2078	362	3	\N	0	0	0	0	0	0	f	f
2079	55	3	\N	0	0	0	0	0	0	f	f
2080	247	3	\N	0	0	0	0	0	0	f	f
2081	421	3	\N	0	0	0	0	0	0	f	f
2082	422	3	\N	0	0	0	0	0	0	f	f
2083	246	3	\N	0	0	0	0	0	0	f	f
2084	527	3	\N	0	0	0	0	0	0	f	f
2085	538	3	\N	0	0	0	0	0	0	f	f
2086	48	3	\N	0	0	0	0	0	0	f	f
2087	258	3	\N	0	0	0	0	0	0	f	f
2088	388	3	\N	0	0	0	0	0	0	f	f
2089	447	3	\N	0	0	0	0	0	0	f	f
2090	34	3	\N	0	0	0	0	0	0	f	f
2091	436	3	\N	0	0	0	0	0	0	f	f
2092	534	3	\N	0	0	0	0	0	0	f	f
2093	532	3	\N	0	0	0	0	0	0	f	f
2094	542	3	\N	0	0	0	0	0	0	f	f
2095	543	3	\N	0	0	0	0	0	0	f	f
2096	49	3	\N	0	0	0	0	0	0	f	f
2097	201	3	\N	0	0	0	0	0	0	f	f
2098	239	3	\N	0	0	0	0	0	0	f	f
2099	483	3	\N	0	0	0	0	0	0	f	f
2100	476	3	\N	0	0	0	0	0	0	f	f
2101	60	3	\N	0	0	0	0	0	0	f	f
2102	57	3	\N	0	0	0	0	0	0	f	f
2103	78	3	\N	0	0	0	0	0	0	f	f
2104	39	3	\N	0	0	0	0	0	0	f	f
2105	192	3	\N	0	0	0	0	0	0	f	f
2106	59	3	\N	0	0	0	0	0	0	f	f
2107	440	3	\N	0	0	0	0	0	0	f	f
2108	398	3	\N	0	0	0	0	0	0	f	f
2109	442	3	\N	0	0	0	0	0	0	f	f
2110	490	3	\N	0	0	0	0	0	0	f	f
2111	25	3	\N	0	0	0	0	0	0	f	f
2112	234	3	\N	0	0	0	0	0	0	f	f
2113	306	3	\N	0	0	0	0	0	0	f	f
2114	535	3	\N	0	0	0	0	0	0	f	f
2115	322	3	\N	0	0	0	0	0	0	f	f
2116	53	3	\N	0	0	0	0	0	0	f	f
2117	251	3	\N	0	0	0	0	0	0	f	f
2118	167	3	\N	0	0	0	0	0	0	f	f
2119	275	3	\N	0	0	0	0	0	0	f	f
2120	335	3	\N	0	0	0	0	0	0	f	f
2121	471	3	\N	0	0	0	0	0	0	f	f
2122	32	3	\N	0	0	0	0	0	0	f	f
2123	158	3	\N	0	0	0	0	0	0	f	f
2124	329	3	\N	0	0	0	0	0	0	f	f
2125	454	3	\N	0	0	0	0	0	0	f	f
2126	73	3	\N	0	0	0	0	0	0	f	f
2127	537	3	\N	0	0	0	0	0	0	f	f
2128	311	3	\N	0	0	0	0	0	0	f	f
2129	519	3	\N	0	0	0	0	0	0	f	f
2130	38	3	\N	0	0	0	0	0	0	f	f
2131	256	3	\N	0	0	0	0	0	0	f	f
2132	190	3	\N	0	0	0	0	0	0	f	f
2133	415	3	\N	0	0	0	0	0	0	f	f
2134	22	3	\N	0	0	0	0	0	0	f	f
2135	249	3	\N	0	0	0	0	0	0	f	f
2136	203	3	\N	0	0	0	0	0	0	f	f
2137	439	3	\N	0	0	0	0	0	0	f	f
2138	539	3	\N	0	0	0	0	0	0	f	f
2139	496	3	\N	0	0	0	0	0	0	f	f
2140	252	3	\N	0	0	0	0	0	0	f	f
2141	424	3	\N	0	0	0	0	0	0	f	f
2142	503	3	\N	0	0	0	0	0	0	f	f
2143	41	3	\N	0	0	0	0	0	0	f	f
2144	259	3	\N	0	0	0	0	0	0	f	f
2145	163	3	\N	0	0	0	0	0	0	f	f
2146	352	3	\N	0	0	0	0	0	0	f	f
2147	475	3	\N	0	0	0	0	0	0	f	f
2148	350	3	\N	0	0	0	0	0	0	f	f
2149	419	3	\N	0	0	0	0	0	0	f	f
2150	401	3	\N	0	0	0	0	0	0	f	f
2151	432	3	\N	0	0	0	0	0	0	f	f
2152	501	3	\N	0	0	0	0	0	0	f	f
2153	64	3	\N	0	0	0	0	0	0	f	f
2154	188	3	\N	0	0	0	0	0	0	f	f
2155	212	3	\N	0	0	0	0	0	0	f	f
2156	526	3	\N	0	0	0	0	0	0	f	f
2157	533	3	\N	0	0	0	0	0	0	f	f
2158	23	3	\N	0	0	0	0	0	0	f	f
2159	50	3	\N	0	0	0	0	0	0	f	f
2160	443	3	\N	0	0	0	0	0	0	f	f
2161	31	3	\N	0	0	0	0	0	0	f	f
2162	185	3	\N	0	0	0	0	0	0	f	f
2163	166	3	\N	0	0	0	0	0	0	f	f
2164	243	3	\N	0	0	0	0	0	0	f	f
2165	242	3	\N	0	0	0	0	0	0	f	f
2166	102	3	\N	0	0	0	0	0	0	f	f
2167	383	3	\N	0	0	0	0	0	0	f	f
2168	536	3	\N	0	0	0	0	0	0	f	f
2169	63	3	\N	0	0	0	0	0	0	f	f
2170	231	3	\N	0	0	0	0	0	0	f	f
2171	95	3	\N	0	0	0	0	0	0	f	f
2172	506	3	\N	0	0	0	0	0	0	f	f
2173	5	4	7.00	0	0	1	0	0	0	f	f
2174	120	4	6.50	0	0	0	0	0	0	f	f
2175	156	4	6.00	0	0	0	0	0	0	f	f
2176	94	4	6.50	0	0	0	0	0	0	f	f
2177	93	4	6.00	0	0	0	0	0	0	f	f
2178	157	4	6.00	0	0	0	0	0	0	f	f
2179	158	4	6.50	0	0	0	0	0	0	f	f
2180	338	4	6.50	0	0	0	0	0	0	f	f
2181	296	4	6.00	0	0	0	0	0	0	f	f
2182	394	4	6.00	0	0	0	0	0	0	f	f
2183	276	4	7.00	0	0	0	0	0	1	f	f
2184	364	4	6.00	0	0	0	0	0	0	f	f
2185	312	4	6.00	0	0	0	0	0	0	f	f
2186	462	4	6.00	0	0	0	0	0	0	f	f
2187	482	4	7.50	1	0	0	0	0	1	f	f
2188	465	4	7.50	2	0	0	0	0	0	f	f
2189	9	4	6.50	0	1	0	0	0	0	f	f
2190	188	4	6.00	0	0	0	0	0	0	f	f
2191	123	4	5.50	0	0	0	0	0	0	f	f
2192	85	4	5.50	0	0	0	0	0	0	f	f
2193	121	4	6.00	0	0	0	0	0	0	f	f
2194	187	4	6.00	0	0	0	0	0	0	f	f
2195	103	4	6.00	0	0	0	0	0	0	f	f
2196	341	4	5.50	0	0	0	0	0	0	t	f
2197	340	4	6.00	0	0	0	0	0	0	f	f
2198	263	4	6.50	0	0	0	0	0	0	f	f
2199	346	4	6.00	0	0	0	0	0	0	f	f
2200	323	4	5.50	0	0	0	0	0	0	f	f
2201	458	4	7.00	0	0	0	0	0	1	f	f
2202	451	4	7.00	1	0	0	0	0	0	f	f
2203	489	4	6.00	0	0	0	0	0	0	f	f
2204	519	4	5.50	0	0	0	0	0	0	f	f
2205	10	4	6.50	0	1	0	0	0	0	f	f
2206	96	4	5.50	0	0	0	0	0	0	f	f
2207	97	4	6.50	0	0	0	0	0	0	f	f
2208	133	4	6.00	0	0	0	0	0	0	f	f
2209	159	4	6.00	0	0	0	0	0	0	t	f
2210	69	4	7.00	0	0	0	0	0	1	f	f
2211	347	4	6.50	0	0	0	0	0	0	f	f
2212	436	4	6.00	0	0	0	0	0	0	f	f
2213	304	4	6.00	0	0	0	0	0	0	f	f
2214	361	4	6.00	0	0	0	0	0	0	f	f
2215	330	4	6.50	0	0	0	0	0	0	f	f
2216	348	4	6.00	0	0	0	0	0	0	t	f
2217	289	4	6.50	0	0	0	0	0	0	f	f
2218	498	4	7.50	1	0	0	0	0	0	f	f
2219	470	4	6.50	0	0	0	0	0	0	t	f
2220	529	4	6.00	0	0	0	0	0	0	f	f
2221	6	4	6.00	0	1	0	0	0	0	f	f
2222	231	4	6.00	0	0	0	0	0	0	f	f
2223	119	4	6.50	0	0	0	0	0	0	f	f
2224	86	4	5.50	0	0	0	0	0	0	t	f
2225	95	4	6.00	0	0	0	0	0	0	f	f
2226	105	4	6.00	0	0	0	0	0	0	f	f
2227	80	4	7.00	1	0	0	0	0	0	t	f
2228	189	4	5.50	0	0	0	0	0	0	f	f
2229	414	4	6.00	0	0	0	0	0	0	t	f
2230	290	4	6.00	0	0	0	0	0	0	f	f
2231	261	4	7.00	0	0	0	0	0	1	f	f
2232	512	4	5.50	0	0	0	0	0	0	f	f
2233	463	4	5.50	0	0	0	0	0	0	f	f
2234	479	4	7.00	1	0	0	0	0	0	f	f
2235	514	4	6.00	0	0	0	0	0	0	f	f
2236	499	4	6.50	0	0	0	0	0	0	f	f
2237	11	4	6.50	0	0	0	0	0	0	f	f
2238	134	4	6.00	0	0	0	0	0	0	f	f
2239	173	4	6.00	0	0	0	0	0	0	t	f
2240	212	4	6.00	0	0	0	0	0	0	f	f
2241	75	4	6.00	0	0	0	0	0	0	f	f
2242	70	4	6.50	0	0	0	0	0	0	f	f
2243	160	4	6.00	0	0	0	0	0	0	f	f
2244	375	4	6.00	0	0	0	0	0	0	f	f
2245	277	4	6.50	0	0	0	0	0	0	f	f
2246	355	4	6.00	0	0	0	0	0	0	f	f
2247	343	4	5.50	0	0	0	0	0	0	f	f
2248	395	4	6.00	0	0	0	0	0	0	f	f
2249	283	4	5.50	0	0	0	0	0	0	f	f
2250	511	4	5.50	0	0	0	0	0	0	f	f
2251	526	4	6.00	0	0	0	0	0	0	f	f
2252	533	4	5.50	0	0	0	0	0	0	f	f
2253	17	4	6.00	0	2	0	0	0	0	f	f
2254	107	4	5.50	0	0	0	0	0	0	f	f
2255	124	4	6.00	0	0	0	0	0	0	t	f
2256	175	4	5.50	0	0	0	0	0	0	t	f
2257	213	4	6.00	0	0	0	0	0	0	f	f
2258	161	4	5.50	0	0	0	0	0	0	t	f
2259	228	4	6.00	0	0	0	0	0	0	f	f
2260	162	4	6.00	0	0	0	0	0	0	f	f
2261	274	4	7.00	1	0	0	0	0	0	f	f
2262	392	4	5.50	0	0	0	0	0	0	f	f
2263	376	4	5.50	0	0	0	0	0	0	f	f
2264	366	4	5.50	0	0	0	0	0	0	t	f
2265	377	4	5.50	0	0	0	0	0	0	f	f
2266	515	4	6.00	0	0	0	0	0	0	f	f
2267	460	4	5.50	0	0	0	0	0	0	f	f
2268	505	4	5.00	0	0	0	0	0	0	f	f
2269	18	4	6.50	0	2	0	0	0	0	f	f
2270	74	4	6.00	0	0	0	0	0	0	f	f
2271	98	4	6.00	0	0	0	0	0	0	f	f
2272	92	4	6.00	0	0	0	0	0	0	t	f
2273	192	4	5.50	0	0	0	0	0	0	f	f
2274	135	4	5.50	0	0	0	0	0	0	t	f
2275	305	4	6.50	0	0	0	0	0	1	f	f
2276	342	4	6.00	0	0	0	0	0	0	f	f
2277	318	4	7.00	1	0	0	0	0	0	f	f
2278	379	4	5.00	0	0	0	0	0	0	t	f
2279	349	4	5.50	0	0	0	0	0	0	t	f
2280	508	4	5.50	0	0	0	0	0	0	f	f
2281	500	4	5.50	0	0	0	0	0	0	f	f
2282	490	4	5.50	0	0	0	0	0	0	t	f
2283	507	4	5.50	0	0	0	0	0	0	f	f
2284	30	4	6.50	0	1	0	0	0	0	f	f
2285	66	4	7.00	1	0	0	0	0	0	t	f
2286	136	4	6.00	0	0	0	0	0	0	f	f
2287	104	4	6.00	0	0	0	0	0	0	f	f
2288	82	4	6.00	0	0	0	0	0	0	f	f
2289	81	4	6.50	0	0	0	0	0	0	f	f
2290	270	4	6.00	0	0	0	0	0	0	f	f
2291	262	4	6.00	0	0	0	0	0	0	t	f
2292	352	4	6.00	0	0	0	0	0	0	f	f
2293	350	4	6.00	0	0	0	0	0	0	f	f
2294	299	4	7.00	0	0	0	0	0	1	f	f
2295	444	4	6.00	0	0	0	0	0	0	f	f
2296	445	4	6.00	0	0	0	0	0	0	f	f
2297	474	4	6.00	0	0	0	0	0	0	f	f
2298	475	4	6.50	0	0	0	0	0	0	f	f
2299	7	4	6.50	0	1	0	0	0	0	f	f
2300	88	4	6.00	0	0	0	0	0	0	f	f
2301	99	4	5.50	0	0	0	0	0	0	f	f
2302	138	4	6.00	0	0	0	0	0	0	t	f
2303	108	4	5.50	0	0	0	0	0	0	t	f
2304	194	4	5.00	0	0	0	0	0	0	f	f
2305	307	4	5.50	0	0	0	0	0	0	f	f
2306	291	4	6.00	0	0	0	0	0	0	f	f
2307	353	4	5.50	0	0	0	0	0	0	t	f
2308	322	4	6.00	0	0	0	0	0	0	f	f
2309	410	4	6.00	0	0	0	0	0	0	f	f
2310	278	4	7.00	1	0	0	0	0	0	f	f
2311	461	4	5.50	0	0	0	0	0	0	f	f
2312	480	4	6.00	0	0	0	0	0	0	f	f
2313	477	4	6.00	0	0	0	0	0	0	f	f
2314	446	4	6.00	0	0	0	0	0	0	f	f
2315	3	4	6.50	0	1	0	0	0	0	f	f
2316	126	4	6.00	0	0	0	0	0	0	f	f
2317	110	4	6.00	0	0	0	0	0	0	f	f
2318	144	4	6.00	0	0	0	0	0	0	f	f
2319	145	4	5.00	0	0	0	0	0	0	f	f
2320	125	4	5.50	0	0	0	0	0	0	t	f
2321	301	4	6.50	0	0	0	0	0	0	f	f
2322	267	4	5.50	0	0	0	0	0	0	f	f
2323	292	4	6.00	0	0	0	0	0	0	f	t
2324	380	4	6.00	0	0	0	0	0	0	f	f
2325	417	4	4.50	0	0	0	0	0	0	f	t
2326	363	4	6.00	0	0	0	0	0	0	f	f
2327	516	4	6.00	0	0	0	0	0	0	f	f
2328	494	4	5.00	0	0	0	0	0	0	f	f
2329	455	4	6.00	0	0	0	0	0	0	f	f
2330	492	4	6.00	0	0	0	0	0	0	f	f
2331	8	4	6.50	0	2	0	0	0	0	f	f
2332	127	4	5.00	0	0	0	0	0	0	f	f
2333	164	4	5.50	0	0	0	0	0	0	f	f
2334	89	4	6.00	1	0	0	0	0	0	t	f
2335	218	4	5.50	0	0	0	0	0	0	f	f
2336	219	4	5.50	0	0	0	0	0	0	f	f
2337	310	4	6.50	0	0	0	0	0	1	f	f
2338	293	4	6.00	0	0	0	0	0	0	t	f
2339	354	4	5.50	0	0	0	0	0	0	f	f
2340	401	4	5.50	0	0	0	0	0	0	f	f
2341	333	4	6.00	0	0	0	0	0	0	f	f
2342	381	4	5.50	0	0	0	0	0	0	f	f
2343	412	4	5.50	0	0	0	0	0	0	f	f
2344	509	4	6.00	0	0	0	0	0	0	f	f
2345	495	4	6.00	0	0	0	0	0	0	f	f
2346	513	4	5.00	0	0	0	0	0	0	f	f
2347	47	4	6.00	0	0	0	0	0	0	f	f
2348	111	4	6.00	0	0	0	0	0	0	f	f
2349	139	4	6.50	0	0	0	0	0	0	f	f
2350	68	4	6.50	0	0	0	0	0	0	f	f
2351	177	4	6.50	0	0	0	0	0	0	f	f
2352	193	4	6.00	0	0	0	0	0	0	f	f
2353	184	4	6.00	0	0	0	0	0	0	f	f
2354	273	4	7.00	0	0	0	0	0	1	f	f
2355	260	4	8.50	2	0	0	0	0	1	f	f
2356	268	4	7.00	0	0	0	0	0	0	f	f
2357	302	4	6.50	0	0	0	0	0	0	f	f
2358	313	4	7.00	1	0	0	0	0	0	f	f
2359	271	4	7.00	0	0	0	0	0	0	f	f
2360	294	4	6.00	0	0	0	0	0	0	f	f
2361	485	4	6.00	0	0	0	0	0	0	f	f
2362	486	4	5.50	0	0	0	0	0	0	f	f
2363	21	4	6.50	0	2	0	0	0	0	f	f
2364	196	4	6.00	0	0	0	0	0	0	f	f
2365	71	4	7.50	1	0	0	0	0	1	t	f
2366	83	4	6.50	0	0	0	0	0	0	f	f
2367	113	4	5.00	0	0	0	0	0	0	f	f
2368	112	4	5.00	0	0	0	0	0	0	f	f
2369	319	4	6.50	0	0	0	0	0	0	f	f
2370	264	4	5.50	0	0	0	0	0	0	f	f
2371	266	4	6.00	0	0	0	0	0	0	f	f
2372	356	4	6.00	0	0	0	0	0	0	f	f
2373	360	4	5.50	0	0	0	0	0	0	f	f
2374	265	4	6.50	0	0	0	0	0	1	f	f
2375	334	4	7.00	1	0	0	0	0	0	f	f
2376	450	4	5.50	0	0	0	0	0	0	f	f
2377	510	4	7.00	1	0	0	0	0	0	f	f
2378	16	4	6.00	0	0	0	0	0	0	f	f
2379	116	4	6.00	0	0	0	0	0	0	f	f
2380	114	4	6.50	0	0	0	0	0	0	f	f
2381	115	4	6.00	0	0	0	0	0	0	f	f
2382	220	4	6.00	0	0	0	0	0	0	f	f
2383	224	4	6.00	0	0	0	0	0	0	f	f
2384	372	4	6.00	0	0	0	0	0	0	f	f
2385	280	4	6.50	0	0	0	0	0	0	f	f
2386	365	4	6.00	0	0	0	0	0	0	f	f
2387	404	4	6.00	0	0	0	0	0	0	f	f
2388	359	4	5.50	0	0	0	0	0	0	f	f
2389	493	4	5.50	0	0	0	0	0	0	f	f
2390	531	4	6.00	0	0	0	0	0	0	f	f
2391	523	4	6.00	0	0	0	0	0	0	f	f
2392	456	4	6.00	0	0	0	0	0	0	f	f
2393	14	4	5.50	0	3	0	0	0	0	f	f
2394	102	4	6.00	0	0	0	0	0	0	f	f
2395	148	4	6.00	0	0	0	0	0	0	t	f
2396	221	4	5.50	0	0	0	0	0	0	t	f
2397	186	4	5.00	0	0	0	0	0	0	f	f
2398	165	4	5.50	0	0	0	0	0	0	f	f
2399	129	4	6.50	0	0	0	0	0	1	f	f
2400	344	4	6.00	0	0	0	0	0	0	f	f
2401	368	4	5.50	0	0	0	0	0	0	f	f
2402	373	4	6.00	0	0	0	0	0	0	f	f
2403	324	4	6.00	0	0	0	0	0	0	f	f
2404	383	4	5.00	0	0	0	0	0	0	f	f
2405	337	4	6.50	1	0	0	0	0	0	f	f
2406	472	4	7.00	0	0	0	0	0	0	f	f
2407	487	4	5.50	0	0	0	0	0	0	f	f
2408	517	4	5.50	0	0	0	0	0	0	f	f
2409	2	4	6.00	0	0	0	0	0	0	f	f
2410	100	4	6.00	0	0	0	0	0	0	f	f
2411	130	4	6.00	0	0	0	0	0	0	t	f
2412	76	4	6.50	0	0	0	0	0	0	f	f
2413	141	4	6.00	0	0	0	0	0	0	f	f
2414	202	4	6.00	0	0	0	0	0	0	f	f
2415	167	4	7.00	0	0	0	0	0	0	f	f
2416	275	4	7.00	1	0	0	0	0	0	f	f
2417	295	4	6.00	0	0	0	0	0	0	f	f
2418	281	4	7.00	0	0	0	0	0	0	f	f
2419	384	4	6.00	0	0	0	0	0	0	f	f
2420	420	4	6.00	0	0	0	0	0	0	f	f
2421	357	4	6.00	0	0	0	0	0	0	f	f
2422	448	4	6.50	0	0	0	0	0	1	f	f
2423	484	4	6.00	0	0	0	0	0	0	f	f
2424	471	4	5.50	0	0	0	0	0	0	f	f
2425	15	4	7.00	0	2	0	0	0	0	f	f
2426	150	4	6.00	0	0	0	0	0	0	f	f
2427	206	4	4.50	0	0	0	0	0	0	f	f
2428	118	4	6.00	0	0	0	0	0	0	f	f
2429	149	4	5.00	0	0	0	0	1	0	t	f
2430	315	4	5.50	0	0	0	0	0	0	f	f
2431	389	4	6.00	0	0	0	0	0	0	f	f
2432	303	4	6.00	0	0	0	0	0	0	f	f
2433	314	4	6.00	0	0	0	0	0	0	f	f
2434	287	4	6.50	0	0	0	0	0	0	f	f
2435	308	4	6.00	0	0	0	0	0	0	f	f
2436	449	4	6.50	0	0	0	0	0	1	f	f
2437	527	4	6.00	0	0	0	0	0	0	f	f
2438	467	4	6.00	0	0	0	0	0	0	f	f
2439	453	4	6.00	0	0	0	0	0	0	f	f
2440	518	4	6.50	1	0	0	0	0	0	f	f
2441	26	4	6.00	0	3	0	0	0	0	f	f
2442	179	4	5.00	0	0	0	0	0	0	f	f
2443	152	4	5.00	0	0	0	0	0	0	f	f
2444	91	4	4.50	0	0	0	0	0	0	f	f
2445	151	4	5.00	0	0	0	0	0	0	f	f
2446	77	4	5.00	0	0	0	0	0	0	f	f
2447	370	4	6.00	0	0	0	0	0	0	f	f
2448	387	4	5.50	0	0	0	0	0	0	f	f
2449	288	4	5.50	0	0	0	0	0	0	f	f
2450	399	4	5.00	0	0	0	0	0	0	f	f
2451	358	4	5.50	0	0	0	0	0	0	f	f
2452	407	4	6.00	0	0	0	0	0	0	f	f
2453	496	4	5.00	0	0	0	1	0	0	f	f
2454	466	4	6.00	0	0	0	0	0	0	f	f
2455	468	4	5.50	0	0	0	0	0	0	f	f
2456	528	4	5.50	0	0	0	0	0	0	f	f
2457	27	4	5.00	0	3	0	0	0	0	f	f
2458	128	4	6.00	0	0	0	0	0	0	f	f
2459	180	4	5.00	0	0	0	0	0	0	f	f
2460	197	4	5.00	0	0	0	0	0	0	t	f
2461	131	4	5.00	0	0	0	0	0	0	f	f
2462	223	4	5.50	0	0	0	0	0	0	f	f
2463	101	4	5.50	0	0	0	0	0	0	f	f
2464	272	4	6.00	0	0	0	0	0	0	f	f
2465	423	4	5.00	0	0	0	0	0	0	f	f
2466	321	4	4.50	0	0	0	0	0	0	f	f
2467	326	4	5.00	0	0	0	0	0	0	f	f
2468	282	4	6.00	0	0	0	0	0	0	t	f
2469	437	4	6.00	0	0	0	0	0	0	f	f
2470	452	4	5.50	0	0	0	0	0	0	f	f
2471	524	4	5.50	0	0	0	0	0	0	f	f
2472	497	4	5.50	0	0	0	0	0	0	f	f
2473	12	4	6.50	0	1	0	0	0	0	f	f
2474	155	4	6.00	0	0	0	0	0	0	f	f
2475	183	4	6.50	0	0	0	0	0	0	f	f
2476	181	4	6.50	0	0	0	0	0	0	f	f
2477	169	4	6.50	0	0	0	0	0	0	f	f
2478	79	4	7.00	0	0	0	0	0	0	f	f
2479	435	4	6.00	0	0	0	0	0	0	f	f
2480	413	4	5.50	0	0	0	0	0	0	t	f
2481	408	4	6.00	0	0	0	0	0	0	f	f
2482	309	4	6.50	0	0	0	0	0	0	f	f
2483	327	4	5.50	0	0	0	0	0	0	t	f
2484	434	4	6.00	0	0	0	0	0	0	f	f
2485	521	4	6.00	0	0	0	0	0	0	f	f
2486	473	4	7.50	0	0	0	0	0	0	t	f
2487	469	4	6.00	0	0	0	0	0	0	f	f
2488	46	4	\N	0	0	0	0	0	0	f	f
2489	35	4	\N	0	0	0	0	0	0	f	f
2490	37	4	\N	0	0	0	0	0	0	f	f
2491	24	4	\N	0	0	0	0	0	0	f	f
2492	29	4	\N	0	0	0	0	0	0	f	f
2493	51	4	\N	0	0	0	0	0	0	f	f
2494	36	4	\N	0	0	0	0	0	0	f	f
2495	54	4	\N	0	0	0	0	0	0	f	f
2496	1	4	\N	0	0	0	0	0	0	f	f
2497	90	4	\N	0	0	0	0	0	0	f	f
2498	19	4	\N	0	0	0	0	0	0	f	f
2499	40	4	\N	0	0	0	0	0	0	f	f
2500	42	4	\N	0	0	0	0	0	0	f	f
2501	52	4	\N	0	0	0	0	0	0	f	f
2502	33	4	\N	0	0	0	0	0	0	f	f
2503	20	4	\N	0	0	0	0	0	0	f	f
2504	28	4	\N	0	0	0	0	0	0	f	f
2505	61	4	\N	0	0	0	0	0	0	f	f
2506	56	4	\N	0	0	0	0	0	0	f	f
2507	58	4	\N	0	0	0	0	0	0	f	f
2508	62	4	\N	0	0	0	0	0	0	f	f
2509	65	4	\N	0	0	0	0	0	0	f	f
2510	45	4	\N	0	0	0	0	0	0	f	f
2511	146	4	\N	0	0	0	0	0	0	f	f
2512	147	4	\N	0	0	0	0	0	0	f	f
2513	106	4	\N	0	0	0	0	0	0	f	f
2514	205	4	\N	0	0	0	0	0	0	f	f
2515	172	4	\N	0	0	0	0	0	0	f	f
2516	143	4	\N	0	0	0	0	0	0	f	f
2517	171	4	\N	0	0	0	0	0	0	f	f
2518	176	4	\N	0	0	0	0	0	0	f	f
2519	199	4	\N	0	0	0	0	0	0	f	f
2520	122	4	\N	0	0	0	0	0	0	f	f
2521	204	4	\N	0	0	0	0	0	0	f	f
2522	140	4	\N	0	0	0	0	0	0	f	f
2523	154	4	\N	0	0	0	0	0	0	f	f
2524	207	4	\N	0	0	0	0	0	0	f	f
2525	208	4	\N	0	0	0	0	0	0	f	f
2526	174	4	\N	0	0	0	0	0	0	f	f
2527	191	4	\N	0	0	0	0	0	0	f	f
2528	168	4	\N	0	0	0	0	0	0	f	f
2529	170	4	\N	0	0	0	0	0	0	f	f
2530	182	4	\N	0	0	0	0	0	0	f	f
2531	137	4	\N	0	0	0	0	0	0	f	f
2532	227	4	\N	0	0	0	0	0	0	f	f
2533	238	4	\N	0	0	0	0	0	0	f	f
2534	286	4	\N	0	0	0	0	0	0	f	f
2535	235	4	\N	0	0	0	0	0	0	f	f
2536	232	4	\N	0	0	0	0	0	0	f	f
2537	226	4	\N	0	0	0	0	0	0	f	f
2538	248	4	\N	0	0	0	0	0	0	f	f
2539	241	4	\N	0	0	0	0	0	0	f	f
2540	255	4	\N	0	0	0	0	0	0	f	f
2541	230	4	\N	0	0	0	0	0	0	f	f
2542	211	4	\N	0	0	0	0	0	0	f	f
2543	297	4	\N	0	0	0	0	0	0	f	f
2544	284	4	\N	0	0	0	0	0	0	f	f
2545	285	4	\N	0	0	0	0	0	0	f	f
2546	244	4	\N	0	0	0	0	0	0	f	f
2547	245	4	\N	0	0	0	0	0	0	f	f
2548	210	4	\N	0	0	0	0	0	0	f	f
2549	240	4	\N	0	0	0	0	0	0	f	f
2550	250	4	\N	0	0	0	0	0	0	f	f
2551	214	4	\N	0	0	0	0	0	0	f	f
2552	215	4	\N	0	0	0	0	0	0	f	f
2553	298	4	\N	0	0	0	0	0	0	f	f
2554	216	4	\N	0	0	0	0	0	0	f	f
2555	269	4	\N	0	0	0	0	0	0	f	f
2556	222	4	\N	0	0	0	0	0	0	f	f
2557	253	4	\N	0	0	0	0	0	0	f	f
2558	254	4	\N	0	0	0	0	0	0	f	f
2559	225	4	\N	0	0	0	0	0	0	f	f
2560	233	4	\N	0	0	0	0	0	0	f	f
2561	402	4	\N	0	0	0	0	0	0	f	f
2562	418	4	\N	0	0	0	0	0	0	f	f
2563	325	4	\N	0	0	0	0	0	0	f	f
2564	405	4	\N	0	0	0	0	0	0	f	f
2565	367	4	\N	0	0	0	0	0	0	f	f
2566	390	4	\N	0	0	0	0	0	0	f	f
2567	320	4	\N	0	0	0	0	0	0	f	f
2568	406	4	\N	0	0	0	0	0	0	f	f
2569	382	4	\N	0	0	0	0	0	0	f	f
2570	316	4	\N	0	0	0	0	0	0	f	f
2571	378	4	\N	0	0	0	0	0	0	f	f
2572	385	4	\N	0	0	0	0	0	0	f	f
2573	371	4	\N	0	0	0	0	0	0	f	f
2574	397	4	\N	0	0	0	0	0	0	f	f
2575	400	4	\N	0	0	0	0	0	0	f	f
2576	369	4	\N	0	0	0	0	0	0	f	f
2577	339	4	\N	0	0	0	0	0	0	f	f
2578	396	4	\N	0	0	0	0	0	0	f	f
2579	416	4	\N	0	0	0	0	0	0	f	f
2580	386	4	\N	0	0	0	0	0	0	f	f
2581	391	4	\N	0	0	0	0	0	0	f	f
2582	345	4	\N	0	0	0	0	0	0	f	f
2583	409	4	\N	0	0	0	0	0	0	f	f
2584	411	4	\N	0	0	0	0	0	0	f	f
2585	351	4	\N	0	0	0	0	0	0	f	f
2586	237	4	\N	0	0	0	0	0	0	f	f
2587	431	4	\N	0	0	0	0	0	0	f	f
2588	429	4	\N	0	0	0	0	0	0	f	f
2589	433	4	\N	0	0	0	0	0	0	f	f
2590	522	4	\N	0	0	0	0	0	0	f	f
2591	457	4	\N	0	0	0	0	0	0	f	f
2592	502	4	\N	0	0	0	0	0	0	f	f
2593	428	4	\N	0	0	0	0	0	0	f	f
2594	438	4	\N	0	0	0	0	0	0	f	f
2595	478	4	\N	0	0	0	0	0	0	f	f
2596	520	4	\N	0	0	0	0	0	0	f	f
2597	441	4	\N	0	0	0	0	0	0	f	f
2598	525	4	\N	0	0	0	0	0	0	f	f
2599	425	4	\N	0	0	0	0	0	0	f	f
2600	426	4	\N	0	0	0	0	0	0	f	f
2601	430	4	\N	0	0	0	0	0	0	f	f
2602	481	4	\N	0	0	0	0	0	0	f	f
2603	459	4	\N	0	0	0	0	0	0	f	f
2604	427	4	\N	0	0	0	0	0	0	f	f
2605	504	4	\N	0	0	0	0	0	0	f	f
2606	530	4	\N	0	0	0	0	0	0	f	f
2607	540	4	\N	0	0	0	0	0	0	f	f
2608	541	4	\N	0	0	0	0	0	0	f	f
2609	43	4	\N	0	0	0	0	0	0	f	f
2610	44	4	\N	0	0	0	0	0	0	f	f
2611	236	4	\N	0	0	0	0	0	0	f	f
2612	217	4	\N	0	0	0	0	0	0	f	f
2613	195	4	\N	0	0	0	0	0	0	f	f
2614	362	4	\N	0	0	0	0	0	0	f	f
2615	491	4	\N	0	0	0	0	0	0	f	f
2616	229	4	\N	0	0	0	0	0	0	f	f
2617	55	4	\N	0	0	0	0	0	0	f	f
2618	247	4	\N	0	0	0	0	0	0	f	f
2619	142	4	\N	0	0	0	0	0	0	f	f
2620	421	4	\N	0	0	0	0	0	0	f	f
2621	422	4	\N	0	0	0	0	0	0	f	f
2622	246	4	\N	0	0	0	0	0	0	f	f
2623	538	4	\N	0	0	0	0	0	0	f	f
2624	48	4	\N	0	0	0	0	0	0	f	f
2625	258	4	\N	0	0	0	0	0	0	f	f
2626	388	4	\N	0	0	0	0	0	0	f	f
2627	447	4	\N	0	0	0	0	0	0	f	f
2628	34	4	\N	0	0	0	0	0	0	f	f
2629	534	4	\N	0	0	0	0	0	0	f	f
2630	532	4	\N	0	0	0	0	0	0	f	f
2631	542	4	\N	0	0	0	0	0	0	f	f
2632	543	4	\N	0	0	0	0	0	0	f	f
2633	49	4	\N	0	0	0	0	0	0	f	f
2634	4	4	\N	0	0	0	0	0	0	f	f
2635	201	4	\N	0	0	0	0	0	0	f	f
2636	239	4	\N	0	0	0	0	0	0	f	f
2637	178	4	\N	0	0	0	0	0	0	f	f
2638	279	4	\N	0	0	0	0	0	0	f	f
2639	483	4	\N	0	0	0	0	0	0	f	f
2640	476	4	\N	0	0	0	0	0	0	f	f
2641	60	4	\N	0	0	0	0	0	0	f	f
2642	57	4	\N	0	0	0	0	0	0	f	f
2643	153	4	\N	0	0	0	0	0	0	f	f
2644	198	4	\N	0	0	0	0	0	0	f	f
2645	78	4	\N	0	0	0	0	0	0	f	f
2646	328	4	\N	0	0	0	0	0	0	f	f
2647	39	4	\N	0	0	0	0	0	0	f	f
2648	59	4	\N	0	0	0	0	0	0	f	f
2649	440	4	\N	0	0	0	0	0	0	f	f
2650	398	4	\N	0	0	0	0	0	0	f	f
2651	442	4	\N	0	0	0	0	0	0	f	f
2652	25	4	\N	0	0	0	0	0	0	f	f
2653	87	4	\N	0	0	0	0	0	0	f	f
2654	109	4	\N	0	0	0	0	0	0	f	f
2655	234	4	\N	0	0	0	0	0	0	f	f
2656	306	4	\N	0	0	0	0	0	0	f	f
2657	332	4	\N	0	0	0	0	0	0	f	f
2658	535	4	\N	0	0	0	0	0	0	f	f
2659	53	4	\N	0	0	0	0	0	0	f	f
2660	251	4	\N	0	0	0	0	0	0	f	f
2661	84	4	\N	0	0	0	0	0	0	f	f
2662	72	4	\N	0	0	0	0	0	0	f	f
2663	335	4	\N	0	0	0	0	0	0	f	f
2664	32	4	\N	0	0	0	0	0	0	f	f
2665	132	4	\N	0	0	0	0	0	0	f	f
2666	200	4	\N	0	0	0	0	0	0	f	f
2667	329	4	\N	0	0	0	0	0	0	f	f
2668	454	4	\N	0	0	0	0	0	0	f	f
2669	209	4	\N	0	0	0	0	0	0	f	f
2670	374	4	\N	0	0	0	0	0	0	f	f
2671	73	4	\N	0	0	0	0	0	0	f	f
2672	537	4	\N	0	0	0	0	0	0	f	f
2673	311	4	\N	0	0	0	0	0	0	f	f
2674	336	4	\N	0	0	0	0	0	0	f	f
2675	38	4	\N	0	0	0	0	0	0	f	f
2676	256	4	\N	0	0	0	0	0	0	f	f
2677	190	4	\N	0	0	0	0	0	0	f	f
2678	415	4	\N	0	0	0	0	0	0	f	f
2679	22	4	\N	0	0	0	0	0	0	f	f
2680	249	4	\N	0	0	0	0	0	0	f	f
2681	203	4	\N	0	0	0	0	0	0	f	f
2682	439	4	\N	0	0	0	0	0	0	f	f
2683	488	4	\N	0	0	0	0	0	0	f	f
2684	539	4	\N	0	0	0	0	0	0	f	f
2685	252	4	\N	0	0	0	0	0	0	f	f
2686	424	4	\N	0	0	0	0	0	0	f	f
2687	503	4	\N	0	0	0	0	0	0	f	f
2688	41	4	\N	0	0	0	0	0	0	f	f
2689	13	4	\N	0	0	0	0	0	0	f	f
2690	67	4	\N	0	0	0	0	0	0	f	f
2691	259	4	\N	0	0	0	0	0	0	f	f
2692	163	4	\N	0	0	0	0	0	0	f	f
2693	300	4	\N	0	0	0	0	0	0	f	f
2694	257	4	\N	0	0	0	0	0	0	f	f
2695	419	4	\N	0	0	0	0	0	0	f	f
2696	432	4	\N	0	0	0	0	0	0	f	f
2697	501	4	\N	0	0	0	0	0	0	f	f
2698	64	4	\N	0	0	0	0	0	0	f	f
2699	464	4	\N	0	0	0	0	0	0	f	f
2700	393	4	\N	0	0	0	0	0	0	f	f
2701	23	4	\N	0	0	0	0	0	0	f	f
2702	50	4	\N	0	0	0	0	0	0	f	f
2703	443	4	\N	0	0	0	0	0	0	f	f
2704	403	4	\N	0	0	0	0	0	0	f	f
2705	31	4	\N	0	0	0	0	0	0	f	f
2706	185	4	\N	0	0	0	0	0	0	f	f
2707	166	4	\N	0	0	0	0	0	0	f	f
2708	243	4	\N	0	0	0	0	0	0	f	f
2709	242	4	\N	0	0	0	0	0	0	f	f
2710	536	4	\N	0	0	0	0	0	0	f	f
2711	63	4	\N	0	0	0	0	0	0	f	f
2712	117	4	\N	0	0	0	0	0	0	f	f
2713	331	4	\N	0	0	0	0	0	0	f	f
2714	317	4	\N	0	0	0	0	0	0	f	f
2715	506	4	\N	0	0	0	0	0	0	f	f
2716	5	5	6.50	0	1	0	0	0	0	f	f
2717	120	5	6.00	0	0	0	0	0	0	t	f
2718	156	5	6.00	0	0	0	0	0	0	f	f
2719	94	5	6.50	0	0	0	0	0	0	f	f
2720	93	5	5.00	0	0	0	0	0	0	f	f
2721	158	5	6.50	0	0	0	0	0	0	f	f
2722	338	5	5.50	0	0	0	0	0	0	f	t
2723	296	5	6.00	0	0	0	0	0	0	f	f
2724	339	5	6.00	0	0	0	0	0	0	f	f
2725	276	5	6.50	0	0	0	0	0	0	f	f
2726	364	5	6.00	0	0	0	0	0	0	f	f
2727	482	5	7.50	1	0	0	0	0	0	f	f
2728	459	5	6.00	0	0	0	0	0	0	f	f
2729	465	5	5.50	0	0	0	0	0	0	f	f
2730	9	5	6.50	0	2	0	0	0	0	f	f
2731	188	5	6.00	0	0	0	0	0	0	f	f
2732	85	5	5.00	0	0	0	0	0	0	f	f
2733	73	5	6.50	0	0	0	0	0	1	f	f
2734	121	5	5.50	0	0	0	0	0	0	f	f
2735	103	5	6.00	0	0	0	0	0	0	f	f
2736	341	5	5.00	0	0	0	0	0	0	t	f
2737	263	5	6.50	0	0	0	0	0	0	f	f
2738	269	5	7.00	1	0	0	0	0	0	f	f
2739	346	5	6.00	0	0	0	0	0	0	f	f
2740	323	5	6.00	0	0	0	0	0	0	f	f
2741	374	5	5.00	0	0	0	0	0	0	f	f
2742	336	5	6.50	0	0	0	0	0	0	f	f
2743	458	5	6.00	0	0	0	0	0	0	f	f
2744	451	5	6.00	0	0	0	0	0	0	f	f
2745	489	5	6.00	0	0	0	0	0	0	t	f
2746	10	5	6.50	0	2	0	0	0	0	f	f
2747	96	5	5.50	0	0	0	0	0	0	f	f
2748	97	5	5.50	0	0	0	0	0	0	f	f
2749	159	5	5.50	0	0	0	0	0	0	f	f
2750	69	5	6.00	0	0	0	0	0	0	f	f
2751	122	5	6.00	0	0	0	0	0	0	f	f
2752	229	5	5.50	0	0	0	0	0	0	f	f
2753	347	5	6.00	0	0	0	0	0	0	f	f
2754	304	5	6.00	0	0	0	0	0	0	f	f
2755	361	5	5.50	0	0	0	0	0	0	f	f
2756	330	5	6.00	0	0	0	0	0	0	f	f
2757	348	5	6.00	0	0	0	0	0	0	f	f
2758	289	5	6.00	0	0	0	0	0	0	f	f
2759	498	5	6.00	0	0	0	0	0	0	f	f
2760	470	5	6.00	0	0	0	0	0	0	f	f
2761	478	5	6.00	0	0	0	0	0	0	f	f
2762	6	5	6.00	0	1	0	0	0	0	f	f
2763	119	5	6.00	0	0	0	0	0	0	f	f
2764	95	5	6.00	0	0	0	0	0	0	f	f
2765	105	5	6.00	0	0	0	0	0	0	f	f
2766	117	5	6.00	0	0	0	0	0	0	t	f
2767	80	5	5.50	0	0	0	0	0	0	f	f
2768	414	5	6.00	0	0	0	0	0	0	f	f
2769	316	5	6.00	0	0	0	0	0	0	f	f
2770	317	5	6.00	0	0	0	0	0	0	t	f
2771	290	5	6.00	0	0	0	0	0	0	t	f
2772	261	5	7.00	1	0	0	0	0	0	f	f
2773	512	5	6.00	0	0	0	0	0	0	f	f
2774	463	5	6.50	0	0	0	0	0	0	f	f
2775	479	5	5.50	0	0	0	0	0	0	f	f
2776	514	5	5.50	0	0	0	0	0	0	f	f
2777	499	5	5.00	0	0	0	0	0	1	f	t
2778	28	5	6.50	0	1	0	0	0	0	f	f
2779	134	5	6.50	0	0	0	0	0	0	f	f
2780	173	5	6.00	0	0	0	0	0	0	f	f
2781	75	5	5.50	0	0	0	0	0	0	f	f
2782	70	5	7.00	1	0	0	0	0	0	t	f
2783	160	5	6.00	0	0	0	0	0	0	t	f
2784	375	5	6.00	0	0	0	0	0	0	f	f
2785	277	5	6.50	0	0	0	0	0	1	f	f
2786	355	5	6.50	0	0	0	0	0	0	f	f
2787	343	5	5.50	0	0	0	0	0	0	f	f
2788	325	5	5.50	0	0	0	0	0	0	t	f
2789	393	5	6.00	0	0	0	0	0	0	f	f
2790	283	5	6.00	0	0	0	0	0	0	f	f
2791	511	5	6.00	0	0	0	0	0	0	t	f
2792	464	5	6.00	0	0	0	0	0	0	f	f
2793	526	5	5.50	0	0	0	0	0	0	f	f
2794	17	5	6.00	0	0	0	0	0	0	f	f
2795	107	5	6.00	0	0	0	0	0	0	f	f
2796	124	5	6.00	0	0	0	0	0	0	f	f
2797	190	5	5.50	0	0	0	0	0	0	f	f
2798	175	5	6.00	0	0	0	0	0	0	f	f
2799	161	5	5.00	0	0	0	0	0	0	f	f
2800	274	5	5.50	0	0	0	0	0	0	f	f
2801	392	5	5.50	0	0	0	0	0	0	f	f
2802	366	5	6.00	0	0	0	0	0	0	f	f
2803	297	5	5.00	0	0	0	0	0	0	f	f
2804	377	5	6.00	0	0	0	0	0	0	f	f
2805	515	5	6.00	0	0	0	0	0	0	f	f
2806	460	5	5.50	0	0	0	0	0	0	t	f
2807	505	5	6.00	0	0	0	0	0	0	f	f
2808	18	5	6.00	0	3	0	0	0	0	f	f
2809	74	5	5.50	0	0	0	0	0	0	f	f
2810	98	5	5.00	0	0	0	0	0	0	t	f
2811	92	5	4.50	0	0	0	0	0	0	t	f
2812	135	5	5.00	0	0	0	0	0	0	t	f
2813	305	5	5.50	0	0	0	0	0	0	t	f
2814	342	5	5.00	0	0	0	0	0	0	f	f
2815	318	5	5.50	0	0	0	0	0	0	f	f
2816	379	5	5.50	0	0	0	0	0	0	f	f
2817	349	5	5.50	0	0	0	0	0	0	t	f
2818	430	5	6.00	0	0	0	0	0	0	f	f
2819	398	5	5.50	0	0	0	0	0	0	f	f
2820	508	5	5.00	0	0	0	0	0	0	f	f
2821	500	5	5.50	0	0	0	0	0	0	f	f
2822	490	5	5.50	0	0	0	0	0	0	f	f
2823	507	5	5.50	0	0	0	0	0	0	f	f
2824	30	5	6.00	0	0	0	0	0	0	f	f
2825	66	5	7.00	0	0	0	0	0	1	f	f
2826	163	5	6.00	0	0	0	0	0	0	f	f
2827	67	5	7.00	0	0	0	0	0	1	f	f
2828	104	5	6.50	0	0	0	0	0	0	f	f
2829	82	5	6.00	0	0	0	0	0	0	f	f
2830	81	5	6.00	0	0	0	0	0	0	t	f
2831	270	5	6.50	0	0	0	0	0	0	t	f
2832	262	5	6.50	0	0	0	0	0	0	f	f
2833	351	5	6.50	0	0	0	0	0	0	f	f
2834	352	5	6.00	0	0	0	0	0	0	f	f
2835	350	5	6.00	0	0	0	0	0	0	f	f
2836	444	5	7.00	1	0	0	0	0	0	f	f
2837	445	5	6.50	0	0	0	0	0	0	f	f
2838	474	5	6.00	0	0	0	0	0	0	f	f
2839	475	5	7.00	1	0	0	0	0	0	f	f
2840	7	5	6.00	0	1	0	0	0	0	f	f
2841	87	5	5.50	0	0	0	0	0	0	f	f
2842	88	5	6.50	0	0	0	0	0	0	f	f
2843	99	5	6.00	0	0	0	0	0	0	f	f
2844	138	5	5.50	0	0	0	0	0	0	f	f
2845	109	5	7.00	1	0	0	0	0	0	f	f
2846	108	5	6.00	0	0	0	0	0	0	f	f
2847	194	5	6.00	0	0	0	0	0	1	f	f
2848	332	5	6.00	0	0	0	0	0	0	f	f
2849	291	5	5.50	0	0	0	0	0	0	f	f
2850	353	5	6.00	0	0	0	0	0	0	f	f
2851	322	5	6.50	0	0	0	0	0	0	f	f
2852	410	5	5.00	0	0	0	0	0	0	f	f
2853	461	5	5.50	0	0	0	0	0	0	f	f
2854	477	5	5.00	0	0	0	0	0	0	f	f
2855	446	5	6.00	0	0	0	0	0	0	f	f
2856	3	5	6.50	0	0	0	0	0	0	f	f
2857	236	5	6.00	0	0	0	0	0	0	f	f
2858	217	5	6.00	0	0	0	0	0	0	f	f
2859	126	5	6.50	0	0	0	0	0	0	f	f
2860	110	5	6.50	0	0	0	0	0	1	f	f
2861	144	5	6.50	0	0	0	0	0	0	f	f
2862	145	5	6.00	0	0	0	0	0	0	f	f
2863	125	5	6.50	0	0	0	0	0	0	f	f
2864	176	5	6.00	0	0	0	0	0	0	f	f
2865	301	5	6.00	0	0	0	0	0	0	t	f
2866	267	5	7.00	1	0	0	0	0	0	f	f
2867	284	5	6.00	0	0	0	0	0	0	f	f
2868	516	5	6.00	0	0	0	0	0	0	f	f
2869	491	5	7.50	1	0	0	0	0	0	f	f
2870	494	5	6.00	0	0	0	0	0	0	f	f
2871	455	5	7.50	1	0	0	0	0	1	f	f
2872	8	5	6.50	0	2	0	0	0	0	f	f
2873	127	5	6.50	0	0	0	0	0	0	t	f
2874	164	5	6.00	0	0	0	0	0	0	t	f
2875	89	5	5.50	0	0	0	0	0	0	f	f
2876	146	5	6.00	0	0	0	0	0	0	f	f
2877	218	5	5.00	0	0	0	0	0	0	f	f
2878	219	5	6.00	0	0	0	0	0	0	f	f
2879	293	5	7.50	1	0	0	0	0	0	f	f
2880	286	5	6.50	0	0	0	0	0	1	f	f
2881	354	5	6.00	0	0	0	0	0	0	t	f
2882	333	5	6.50	0	0	0	0	0	0	f	f
2883	381	5	6.50	0	0	0	0	0	0	f	f
2884	501	5	6.00	0	0	0	0	0	0	f	f
2885	509	5	7.00	1	0	0	0	0	0	t	f
2886	495	5	6.00	0	0	0	0	0	0	f	f
2887	513	5	5.50	0	0	0	0	0	0	f	f
2888	1	5	7.00	0	1	0	0	0	0	f	f
2889	111	5	6.00	0	0	0	0	0	0	f	f
2890	139	5	5.50	0	0	0	0	0	0	f	f
2891	68	5	6.50	0	0	0	0	0	0	f	f
2892	177	5	5.00	0	0	0	0	0	0	f	t
2893	193	5	6.00	0	0	0	0	0	0	f	f
2894	90	5	6.00	0	0	0	0	0	0	f	f
2895	184	5	5.50	0	0	0	0	0	0	f	f
2896	273	5	6.50	0	0	0	0	0	0	t	f
2897	260	5	8.00	1	0	0	0	0	1	f	f
2898	268	5	7.00	0	0	0	0	0	0	f	f
2899	302	5	6.00	0	0	0	0	0	0	f	f
2900	313	5	6.50	0	0	0	0	0	1	f	f
2901	271	5	7.00	1	0	0	0	0	0	f	f
2902	447	5	5.50	0	0	0	0	0	0	f	f
2903	486	5	5.50	0	0	0	0	0	0	f	f
2904	21	5	6.00	0	2	0	0	0	0	f	f
2905	196	5	5.50	0	0	0	0	0	0	f	f
2906	113	5	6.00	0	0	0	0	0	0	f	f
2907	201	5	5.50	0	0	0	0	0	0	f	f
2908	239	5	4.50	0	0	0	0	0	0	f	f
2909	319	5	6.00	0	0	0	0	0	0	f	f
2910	264	5	6.50	0	0	0	0	0	0	f	f
2911	266	5	5.50	0	0	0	0	0	0	f	f
2912	356	5	6.00	0	0	0	0	0	0	f	f
2913	360	5	6.00	0	0	0	0	0	0	f	f
2914	265	5	6.00	0	0	0	0	0	0	f	f
2915	334	5	6.00	0	0	0	0	0	0	f	f
2916	279	5	6.50	0	0	0	0	0	0	f	f
2917	450	5	5.50	0	0	0	0	0	0	f	f
2918	510	5	5.50	0	0	0	0	0	0	f	f
2919	483	5	6.00	0	0	0	0	0	0	f	f
2920	16	5	6.00	0	1	0	0	0	0	f	f
2921	116	5	7.00	0	0	0	0	0	1	f	f
2922	114	5	6.50	0	0	0	0	0	0	f	f
2923	115	5	6.00	0	0	0	0	0	0	t	f
2924	224	5	5.50	0	0	0	0	0	0	t	f
2925	143	5	6.00	0	0	0	0	0	0	f	f
2926	403	5	6.00	0	0	0	0	0	0	f	f
2927	372	5	5.00	0	0	0	0	0	0	f	f
2928	280	5	6.00	0	0	0	0	0	0	f	f
2929	365	5	6.00	0	0	0	0	0	0	f	f
2930	359	5	6.00	0	0	0	0	0	0	f	f
2931	493	5	5.50	0	0	0	0	0	0	f	f
2932	531	5	6.00	0	0	0	0	0	0	f	f
2933	502	5	6.00	0	0	0	0	0	0	f	f
2934	456	5	7.50	1	0	0	0	0	0	t	f
2935	14	5	6.00	0	0	0	0	0	0	f	f
2936	102	5	6.50	0	0	0	0	0	0	f	f
2937	148	5	6.00	0	0	0	0	0	0	f	f
2938	186	5	6.50	0	0	0	0	0	0	f	f
2939	165	5	6.00	0	0	0	0	0	0	f	f
2940	344	5	5.50	0	0	0	0	0	0	f	f
2941	368	5	5.50	0	0	0	0	0	0	f	f
2942	373	5	6.00	0	0	0	0	0	0	f	f
2943	324	5	6.50	0	0	0	0	0	0	f	f
2944	320	5	6.50	0	0	0	0	0	0	f	f
2945	433	5	6.00	0	0	0	0	0	0	f	f
2946	383	5	6.00	0	0	0	0	0	0	f	f
2947	406	5	6.00	0	0	0	0	0	0	f	f
2948	472	5	6.00	0	0	0	0	0	0	f	f
2949	487	5	6.00	0	0	0	0	0	0	f	f
2950	517	5	6.00	0	0	0	0	0	0	f	f
2951	2	5	7.00	0	0	0	0	0	0	f	f
2952	100	5	6.00	0	0	0	0	0	0	f	f
2953	130	5	5.50	0	0	0	0	0	0	f	f
2954	76	5	6.50	0	0	0	0	0	1	f	f
2955	141	5	6.00	0	0	0	0	0	0	f	f
2956	84	5	6.00	0	0	0	0	0	0	f	f
2957	202	5	6.00	0	0	0	0	0	0	f	f
2958	72	5	5.50	0	0	0	0	0	0	f	f
2959	227	5	6.00	0	0	0	0	0	0	f	f
2960	275	5	6.00	0	0	0	0	0	0	f	f
2961	295	5	6.00	0	0	0	0	0	0	f	f
2962	369	5	6.00	0	0	0	0	0	0	f	f
2963	281	5	6.50	0	0	0	0	0	0	f	f
2964	448	5	6.50	1	0	0	0	0	0	f	f
2965	484	5	6.00	0	0	0	0	0	0	f	f
2966	471	5	7.00	1	0	0	0	0	0	f	f
2967	15	5	6.00	0	1	0	0	0	0	f	f
2968	142	5	6.50	0	0	0	0	0	0	f	f
2969	150	5	6.00	0	0	0	0	0	0	f	f
2970	206	5	6.00	0	0	0	0	0	0	f	f
2971	118	5	6.00	0	0	0	0	0	0	f	f
2972	149	5	5.50	0	0	0	0	0	0	f	f
2973	315	5	6.50	0	0	0	0	0	0	f	f
2974	389	5	6.00	0	0	0	0	0	0	f	f
2975	314	5	6.00	0	0	0	0	0	0	f	f
2976	287	5	7.00	1	0	0	0	0	0	f	f
2977	308	5	6.50	0	0	0	0	0	1	f	f
2978	385	5	7.00	1	0	0	0	0	0	f	f
2979	449	5	7.00	0	0	0	0	0	1	f	f
2980	467	5	6.00	0	0	0	0	0	0	f	f
2981	453	5	7.50	1	0	0	0	0	1	f	f
2982	518	5	6.00	0	0	0	0	0	0	f	f
2983	26	5	6.00	0	2	0	0	0	0	f	f
2984	179	5	5.50	0	0	0	0	0	0	f	f
2985	152	5	6.00	0	0	0	0	0	0	f	f
2986	91	5	5.50	0	0	0	0	0	0	f	f
2987	151	5	5.50	0	0	0	0	0	0	f	f
2988	203	5	6.00	0	0	0	0	0	0	t	f
2989	77	5	6.50	0	0	0	0	0	1	f	f
2990	370	5	6.00	0	0	0	0	0	0	f	f
2991	288	5	5.00	0	0	0	0	0	0	f	f
2992	399	5	6.00	0	0	0	0	0	0	f	f
2993	358	5	5.50	0	0	0	0	0	0	f	f
2994	466	5	5.50	0	0	0	0	0	0	f	f
2995	488	5	7.50	1	0	0	0	0	0	t	f
2996	468	5	6.00	0	0	0	0	0	0	f	f
2997	539	5	6.00	0	0	0	0	0	0	t	f
2998	528	5	6.00	0	0	0	0	0	0	f	f
2999	27	5	6.00	0	3	0	0	0	0	f	f
3000	128	5	5.50	0	0	0	0	0	0	f	f
3001	180	5	5.50	0	0	0	0	0	0	t	f
3002	197	5	5.50	0	0	0	0	0	0	f	f
3003	131	5	5.00	0	0	0	0	0	0	f	f
3004	250	5	4.50	0	0	0	0	0	0	f	f
3005	101	5	6.00	0	0	0	0	0	0	f	f
3006	272	5	6.00	0	0	0	0	0	0	t	f
3007	371	5	6.00	0	0	0	0	0	0	f	f
3008	321	5	5.50	0	0	0	0	0	0	f	f
3009	326	5	6.00	0	0	0	0	0	0	f	f
3010	282	5	6.00	0	0	0	0	0	0	f	f
3011	328	5	5.00	0	0	0	0	0	0	t	f
3012	437	5	6.00	0	0	0	0	0	0	f	f
3013	452	5	7.00	1	0	0	0	0	0	f	f
3014	542	5	6.00	0	0	0	0	0	0	f	f
3015	12	5	6.50	0	2	0	0	0	0	f	f
3016	155	5	6.00	0	0	0	0	0	0	f	f
3017	183	5	6.00	0	0	0	0	0	0	f	f
3018	181	5	5.50	0	0	0	0	0	0	t	f
3019	169	5	5.00	0	0	0	0	0	0	f	f
3020	79	5	6.50	0	0	0	0	0	0	t	f
3021	225	5	6.00	0	0	0	0	0	0	f	f
3022	170	5	6.00	0	0	0	0	0	0	f	f
3023	345	5	5.50	0	0	0	0	0	0	t	f
3024	435	5	6.00	0	0	0	0	0	0	f	f
3025	413	5	5.50	0	0	0	0	0	0	t	f
3026	309	5	5.50	0	0	0	0	0	0	f	f
3027	327	5	6.00	0	0	0	0	0	0	f	f
3028	521	5	5.50	0	0	0	0	0	0	f	f
3029	473	5	5.00	0	0	0	0	0	0	f	f
3030	469	5	5.00	0	0	0	0	0	0	f	f
3031	46	5	\N	0	0	0	0	0	0	f	f
3032	35	5	\N	0	0	0	0	0	0	f	f
3033	11	5	\N	0	0	0	0	0	0	f	f
3034	37	5	\N	0	0	0	0	0	0	f	f
3035	24	5	\N	0	0	0	0	0	0	f	f
3036	29	5	\N	0	0	0	0	0	0	f	f
3037	51	5	\N	0	0	0	0	0	0	f	f
3038	36	5	\N	0	0	0	0	0	0	f	f
3039	54	5	\N	0	0	0	0	0	0	f	f
3040	47	5	\N	0	0	0	0	0	0	f	f
3041	83	5	\N	0	0	0	0	0	0	f	f
3042	71	5	\N	0	0	0	0	0	0	f	f
3043	19	5	\N	0	0	0	0	0	0	f	f
3044	40	5	\N	0	0	0	0	0	0	f	f
3045	42	5	\N	0	0	0	0	0	0	f	f
3046	52	5	\N	0	0	0	0	0	0	f	f
3047	33	5	\N	0	0	0	0	0	0	f	f
3048	20	5	\N	0	0	0	0	0	0	f	f
3049	61	5	\N	0	0	0	0	0	0	f	f
3050	56	5	\N	0	0	0	0	0	0	f	f
3051	58	5	\N	0	0	0	0	0	0	f	f
3052	62	5	\N	0	0	0	0	0	0	f	f
3053	65	5	\N	0	0	0	0	0	0	f	f
3054	45	5	\N	0	0	0	0	0	0	f	f
3055	147	5	\N	0	0	0	0	0	0	f	f
3056	106	5	\N	0	0	0	0	0	0	f	f
3057	205	5	\N	0	0	0	0	0	0	f	f
3058	172	5	\N	0	0	0	0	0	0	f	f
3059	129	5	\N	0	0	0	0	0	0	f	f
3060	189	5	\N	0	0	0	0	0	0	f	f
3061	171	5	\N	0	0	0	0	0	0	f	f
3062	199	5	\N	0	0	0	0	0	0	f	f
3063	204	5	\N	0	0	0	0	0	0	f	f
3064	112	5	\N	0	0	0	0	0	0	f	f
3065	140	5	\N	0	0	0	0	0	0	f	f
3066	154	5	\N	0	0	0	0	0	0	f	f
3067	207	5	\N	0	0	0	0	0	0	f	f
3068	208	5	\N	0	0	0	0	0	0	f	f
3069	187	5	\N	0	0	0	0	0	0	f	f
3070	174	5	\N	0	0	0	0	0	0	f	f
3071	162	5	\N	0	0	0	0	0	0	f	f
3072	191	5	\N	0	0	0	0	0	0	f	f
3073	168	5	\N	0	0	0	0	0	0	f	f
3074	182	5	\N	0	0	0	0	0	0	f	f
3075	137	5	\N	0	0	0	0	0	0	f	f
3076	220	5	\N	0	0	0	0	0	0	f	f
3077	238	5	\N	0	0	0	0	0	0	f	f
3078	235	5	\N	0	0	0	0	0	0	f	f
3079	310	5	\N	0	0	0	0	0	0	f	f
3080	232	5	\N	0	0	0	0	0	0	f	f
3081	226	5	\N	0	0	0	0	0	0	f	f
3082	248	5	\N	0	0	0	0	0	0	f	f
3083	241	5	\N	0	0	0	0	0	0	f	f
3084	255	5	\N	0	0	0	0	0	0	f	f
3085	221	5	\N	0	0	0	0	0	0	f	f
3086	230	5	\N	0	0	0	0	0	0	f	f
3087	211	5	\N	0	0	0	0	0	0	f	f
3088	292	5	\N	0	0	0	0	0	0	f	f
3089	285	5	\N	0	0	0	0	0	0	f	f
3090	244	5	\N	0	0	0	0	0	0	f	f
3091	245	5	\N	0	0	0	0	0	0	f	f
3092	210	5	\N	0	0	0	0	0	0	f	f
3093	240	5	\N	0	0	0	0	0	0	f	f
3094	223	5	\N	0	0	0	0	0	0	f	f
3095	214	5	\N	0	0	0	0	0	0	f	f
3096	215	5	\N	0	0	0	0	0	0	f	f
3097	298	5	\N	0	0	0	0	0	0	f	f
3098	216	5	\N	0	0	0	0	0	0	f	f
3099	307	5	\N	0	0	0	0	0	0	f	f
3100	278	5	\N	0	0	0	0	0	0	f	f
3101	312	5	\N	0	0	0	0	0	0	f	f
3102	228	5	\N	0	0	0	0	0	0	f	f
3103	222	5	\N	0	0	0	0	0	0	f	f
3104	253	5	\N	0	0	0	0	0	0	f	f
3105	254	5	\N	0	0	0	0	0	0	f	f
3106	233	5	\N	0	0	0	0	0	0	f	f
3107	299	5	\N	0	0	0	0	0	0	f	f
3108	402	5	\N	0	0	0	0	0	0	f	f
3109	418	5	\N	0	0	0	0	0	0	f	f
3110	405	5	\N	0	0	0	0	0	0	f	f
3111	367	5	\N	0	0	0	0	0	0	f	f
3112	404	5	\N	0	0	0	0	0	0	f	f
3113	337	5	\N	0	0	0	0	0	0	f	f
3114	390	5	\N	0	0	0	0	0	0	f	f
3115	382	5	\N	0	0	0	0	0	0	f	f
3116	378	5	\N	0	0	0	0	0	0	f	f
3117	380	5	\N	0	0	0	0	0	0	f	f
3118	412	5	\N	0	0	0	0	0	0	f	f
3119	397	5	\N	0	0	0	0	0	0	f	f
3120	400	5	\N	0	0	0	0	0	0	f	f
3121	384	5	\N	0	0	0	0	0	0	f	f
3122	357	5	\N	0	0	0	0	0	0	f	f
3123	394	5	\N	0	0	0	0	0	0	f	f
3124	340	5	\N	0	0	0	0	0	0	f	f
3125	376	5	\N	0	0	0	0	0	0	f	f
3126	396	5	\N	0	0	0	0	0	0	f	f
3127	416	5	\N	0	0	0	0	0	0	f	f
3128	386	5	\N	0	0	0	0	0	0	f	f
3129	391	5	\N	0	0	0	0	0	0	f	f
3130	409	5	\N	0	0	0	0	0	0	f	f
3131	411	5	\N	0	0	0	0	0	0	f	f
3132	237	5	\N	0	0	0	0	0	0	f	f
3133	431	5	\N	0	0	0	0	0	0	f	f
3134	429	5	\N	0	0	0	0	0	0	f	f
3135	522	5	\N	0	0	0	0	0	0	f	f
3136	457	5	\N	0	0	0	0	0	0	f	f
3137	523	5	\N	0	0	0	0	0	0	f	f
3138	492	5	\N	0	0	0	0	0	0	f	f
3139	485	5	\N	0	0	0	0	0	0	f	f
3140	428	5	\N	0	0	0	0	0	0	f	f
3141	438	5	\N	0	0	0	0	0	0	f	f
3142	520	5	\N	0	0	0	0	0	0	f	f
3143	441	5	\N	0	0	0	0	0	0	f	f
3144	525	5	\N	0	0	0	0	0	0	f	f
3145	497	5	\N	0	0	0	0	0	0	f	f
3146	425	5	\N	0	0	0	0	0	0	f	f
3147	426	5	\N	0	0	0	0	0	0	f	f
3148	480	5	\N	0	0	0	0	0	0	f	f
3149	420	5	\N	0	0	0	0	0	0	f	f
3150	481	5	\N	0	0	0	0	0	0	f	f
3151	462	5	\N	0	0	0	0	0	0	f	f
3152	427	5	\N	0	0	0	0	0	0	f	f
3153	504	5	\N	0	0	0	0	0	0	f	f
3154	434	5	\N	0	0	0	0	0	0	f	f
3155	529	5	\N	0	0	0	0	0	0	f	f
3156	530	5	\N	0	0	0	0	0	0	f	f
3157	540	5	\N	0	0	0	0	0	0	f	f
3158	541	5	\N	0	0	0	0	0	0	f	f
3159	43	5	\N	0	0	0	0	0	0	f	f
3160	44	5	\N	0	0	0	0	0	0	f	f
3161	417	5	\N	0	0	0	0	0	0	f	f
3162	363	5	\N	0	0	0	0	0	0	f	f
3163	195	5	\N	0	0	0	0	0	0	f	f
3164	362	5	\N	0	0	0	0	0	0	f	f
3165	55	5	\N	0	0	0	0	0	0	f	f
3166	247	5	\N	0	0	0	0	0	0	f	f
3167	421	5	\N	0	0	0	0	0	0	f	f
3168	422	5	\N	0	0	0	0	0	0	f	f
3169	246	5	\N	0	0	0	0	0	0	f	f
3170	303	5	\N	0	0	0	0	0	0	f	f
3171	527	5	\N	0	0	0	0	0	0	f	f
3172	538	5	\N	0	0	0	0	0	0	f	f
3173	48	5	\N	0	0	0	0	0	0	f	f
3174	258	5	\N	0	0	0	0	0	0	f	f
3175	388	5	\N	0	0	0	0	0	0	f	f
3176	294	5	\N	0	0	0	0	0	0	f	f
3177	34	5	\N	0	0	0	0	0	0	f	f
3178	133	5	\N	0	0	0	0	0	0	f	f
3179	436	5	\N	0	0	0	0	0	0	f	f
3180	534	5	\N	0	0	0	0	0	0	f	f
3181	532	5	\N	0	0	0	0	0	0	f	f
3182	543	5	\N	0	0	0	0	0	0	f	f
3183	49	5	\N	0	0	0	0	0	0	f	f
3184	4	5	\N	0	0	0	0	0	0	f	f
3185	178	5	\N	0	0	0	0	0	0	f	f
3186	476	5	\N	0	0	0	0	0	0	f	f
3187	60	5	\N	0	0	0	0	0	0	f	f
3188	57	5	\N	0	0	0	0	0	0	f	f
3189	153	5	\N	0	0	0	0	0	0	f	f
3190	198	5	\N	0	0	0	0	0	0	f	f
3191	78	5	\N	0	0	0	0	0	0	f	f
3192	423	5	\N	0	0	0	0	0	0	f	f
3193	524	5	\N	0	0	0	0	0	0	f	f
3194	39	5	\N	0	0	0	0	0	0	f	f
3195	192	5	\N	0	0	0	0	0	0	f	f
3196	59	5	\N	0	0	0	0	0	0	f	f
3197	440	5	\N	0	0	0	0	0	0	f	f
3198	442	5	\N	0	0	0	0	0	0	f	f
3199	25	5	\N	0	0	0	0	0	0	f	f
3200	234	5	\N	0	0	0	0	0	0	f	f
3201	306	5	\N	0	0	0	0	0	0	f	f
3202	535	5	\N	0	0	0	0	0	0	f	f
3203	53	5	\N	0	0	0	0	0	0	f	f
3204	251	5	\N	0	0	0	0	0	0	f	f
3205	167	5	\N	0	0	0	0	0	0	f	f
3206	335	5	\N	0	0	0	0	0	0	f	f
3207	32	5	\N	0	0	0	0	0	0	f	f
3208	157	5	\N	0	0	0	0	0	0	f	f
3209	132	5	\N	0	0	0	0	0	0	f	f
3210	200	5	\N	0	0	0	0	0	0	f	f
3211	329	5	\N	0	0	0	0	0	0	f	f
3212	454	5	\N	0	0	0	0	0	0	f	f
3213	209	5	\N	0	0	0	0	0	0	f	f
3214	537	5	\N	0	0	0	0	0	0	f	f
3215	311	5	\N	0	0	0	0	0	0	f	f
3216	123	5	\N	0	0	0	0	0	0	f	f
3217	519	5	\N	0	0	0	0	0	0	f	f
3218	38	5	\N	0	0	0	0	0	0	f	f
3219	256	5	\N	0	0	0	0	0	0	f	f
3220	213	5	\N	0	0	0	0	0	0	f	f
3221	415	5	\N	0	0	0	0	0	0	f	f
3222	22	5	\N	0	0	0	0	0	0	f	f
3223	249	5	\N	0	0	0	0	0	0	f	f
3224	407	5	\N	0	0	0	0	0	0	f	f
3225	387	5	\N	0	0	0	0	0	0	f	f
3226	439	5	\N	0	0	0	0	0	0	f	f
3227	496	5	\N	0	0	0	0	0	0	f	f
3228	252	5	\N	0	0	0	0	0	0	f	f
3229	408	5	\N	0	0	0	0	0	0	f	f
3230	424	5	\N	0	0	0	0	0	0	f	f
3231	503	5	\N	0	0	0	0	0	0	f	f
3232	41	5	\N	0	0	0	0	0	0	f	f
3233	13	5	\N	0	0	0	0	0	0	f	f
3234	136	5	\N	0	0	0	0	0	0	f	f
3235	259	5	\N	0	0	0	0	0	0	f	f
3236	300	5	\N	0	0	0	0	0	0	f	f
3237	257	5	\N	0	0	0	0	0	0	f	f
3238	419	5	\N	0	0	0	0	0	0	f	f
3239	401	5	\N	0	0	0	0	0	0	f	f
3240	432	5	\N	0	0	0	0	0	0	f	f
3241	64	5	\N	0	0	0	0	0	0	f	f
3242	212	5	\N	0	0	0	0	0	0	f	f
3243	395	5	\N	0	0	0	0	0	0	f	f
3244	533	5	\N	0	0	0	0	0	0	f	f
3245	23	5	\N	0	0	0	0	0	0	f	f
3246	50	5	\N	0	0	0	0	0	0	f	f
3247	443	5	\N	0	0	0	0	0	0	f	f
3248	31	5	\N	0	0	0	0	0	0	f	f
3249	185	5	\N	0	0	0	0	0	0	f	f
3250	166	5	\N	0	0	0	0	0	0	f	f
3251	243	5	\N	0	0	0	0	0	0	f	f
3252	242	5	\N	0	0	0	0	0	0	f	f
3253	536	5	\N	0	0	0	0	0	0	f	f
3254	63	5	\N	0	0	0	0	0	0	f	f
3255	231	5	\N	0	0	0	0	0	0	f	f
3256	86	5	\N	0	0	0	0	0	0	f	f
3257	331	5	\N	0	0	0	0	0	0	f	f
3258	506	5	\N	0	0	0	0	0	0	f	f
3262	157	6	7.00	0	0	0	0	0	0	f	f
3263	158	6	6.50	0	0	0	0	0	0	f	f
3264	200	6	6.00	0	0	0	0	0	0	f	f
3265	296	6	6.00	0	0	0	0	0	0	f	f
3266	394	6	6.00	0	0	0	0	0	0	f	f
3267	339	6	6.00	0	0	0	0	0	0	f	f
3268	276	6	7.00	1	0	0	0	0	0	f	f
3269	364	6	6.00	0	0	0	0	0	0	f	f
3270	329	6	6.00	0	0	0	0	0	0	f	f
3271	462	6	5.50	0	0	0	0	0	0	f	f
3272	482	6	6.00	0	0	0	0	0	0	f	f
3273	465	6	6.00	0	0	0	0	0	0	f	f
3274	9	6	6.00	0	0	0	0	0	0	f	f
3275	123	6	6.00	0	0	0	0	0	0	f	f
3276	85	6	6.50	0	0	0	0	0	0	f	f
3277	121	6	6.50	0	0	0	0	0	0	f	f
3278	103	6	6.50	0	0	0	0	0	0	f	f
3279	341	6	6.00	0	0	0	0	0	0	f	f
3280	340	6	6.50	0	0	0	0	0	0	f	f
3281	263	6	7.00	1	0	0	0	0	0	f	f
3282	269	6	6.50	1	0	0	0	0	0	f	f
3283	311	6	6.00	0	0	0	0	0	0	f	f
3284	323	6	7.00	1	0	0	0	0	0	f	f
3285	374	6	6.00	0	0	0	0	0	0	f	f
3286	336	6	6.50	0	0	0	0	0	0	f	f
3287	458	6	8.00	1	0	0	0	0	1	f	f
3288	489	6	6.00	0	0	0	0	0	1	f	f
3289	519	6	6.00	0	0	0	0	0	0	f	f
3290	10	6	7.00	0	1	0	0	0	0	f	f
3291	97	6	6.00	0	0	0	0	0	0	f	f
3292	210	6	5.50	0	0	0	0	0	0	f	f
3293	159	6	6.00	0	0	0	0	0	0	t	f
3294	69	6	5.50	0	0	0	0	0	0	f	f
3295	229	6	5.00	0	0	0	0	0	0	f	f
3296	347	6	5.50	0	0	0	0	0	0	f	f
3297	361	6	6.00	0	0	0	0	0	0	f	f
3298	330	6	6.00	0	0	0	0	0	0	f	f
3299	348	6	6.00	0	0	0	0	0	0	f	f
3300	289	6	5.50	0	0	0	0	0	0	t	f
3301	534	6	6.00	0	0	0	0	0	0	f	f
3302	470	6	5.50	0	0	0	0	0	0	f	f
3303	520	6	6.00	0	0	0	0	0	0	f	f
3304	478	6	7.00	1	0	0	0	0	0	f	f
3305	6	6	6.00	0	1	0	0	0	0	f	f
3306	119	6	6.50	0	0	0	0	0	0	t	f
3307	86	6	6.00	0	0	0	0	0	0	f	f
3308	95	6	6.00	0	0	0	0	0	0	f	f
3309	105	6	6.00	0	0	0	0	0	0	f	f
3310	117	6	5.50	0	0	0	0	0	0	f	f
3311	80	6	6.00	0	0	0	0	0	0	f	f
3312	189	6	5.50	0	0	0	0	0	0	t	f
3313	316	6	6.00	0	0	0	0	0	0	f	f
3314	317	6	6.00	0	0	0	0	0	0	f	f
3315	290	6	7.00	1	0	0	0	0	0	f	f
3316	261	6	6.00	0	0	0	0	0	0	f	f
3317	331	6	5.00	0	0	0	0	0	0	f	f
3318	512	6	5.50	0	0	0	0	0	0	f	f
3319	463	6	5.50	0	0	0	0	0	0	f	f
3320	479	6	6.00	0	0	0	0	0	0	t	f
3321	28	6	6.50	0	4	0	0	0	0	f	f
3322	134	6	5.00	0	0	0	0	0	0	f	f
3323	173	6	4.50	0	0	0	0	0	0	t	f
3324	212	6	5.00	0	0	0	0	0	0	f	f
3325	70	6	5.00	0	0	0	0	0	0	f	f
3326	106	6	6.00	0	0	0	0	0	0	f	f
3327	205	6	5.50	0	0	0	0	0	0	f	f
3328	160	6	4.50	0	0	0	0	0	0	f	f
3329	375	6	5.00	0	0	0	0	0	0	f	f
3330	277	6	5.50	0	0	0	0	0	0	f	f
3331	355	6	5.00	0	0	0	0	0	0	f	f
3332	283	6	6.00	0	0	0	0	0	1	f	f
3333	511	6	5.00	0	0	0	0	0	0	f	f
3334	464	6	6.50	1	0	0	0	0	0	f	f
3335	457	6	6.00	0	0	0	0	0	0	f	f
3336	526	6	5.00	0	0	0	0	0	0	f	f
3337	17	6	6.00	0	2	0	0	0	0	f	f
3338	107	6	5.00	0	0	0	0	0	0	f	f
3339	124	6	5.50	0	0	0	0	0	0	f	f
3340	190	6	5.50	0	0	0	0	0	0	t	f
3341	175	6	6.00	0	0	0	0	0	0	f	f
3342	161	6	5.50	0	0	0	0	0	0	f	f
3343	174	6	6.00	0	0	0	0	0	0	f	f
3344	162	6	6.00	0	0	0	0	0	0	f	f
3345	274	6	5.50	0	0	0	0	0	0	f	f
3346	392	6	6.00	0	0	0	0	0	1	f	f
3347	297	6	5.00	0	0	0	0	0	0	t	f
3348	377	6	5.50	0	0	0	0	0	0	f	f
3349	396	6	6.00	0	0	0	0	0	0	f	f
3350	515	6	6.00	0	0	0	0	0	0	f	f
3351	460	6	7.00	1	0	0	0	0	0	f	f
3352	505	6	6.00	0	0	0	0	0	0	f	f
3353	18	6	6.00	0	2	0	0	0	0	f	f
3354	215	6	5.50	0	0	0	0	0	0	f	f
3355	98	6	6.00	0	0	0	0	0	0	f	f
3356	192	6	6.00	0	0	0	0	0	0	t	f
3357	135	6	6.50	0	0	0	0	0	1	f	f
3358	214	6	5.00	0	0	0	0	0	0	t	f
3359	298	6	5.50	0	0	0	0	0	0	f	f
3360	305	6	5.50	0	0	0	0	0	0	t	f
3361	342	6	5.50	0	0	0	0	0	0	f	f
3362	318	6	5.50	0	0	0	0	0	0	f	f
3363	379	6	6.00	0	0	0	0	0	0	f	f
3364	349	6	5.00	0	0	0	0	0	0	f	f
3365	508	6	6.00	0	0	0	0	0	0	f	f
3366	500	6	5.50	0	0	0	0	0	0	f	f
3367	490	6	6.00	0	0	0	0	0	0	f	f
3368	507	6	7.50	1	0	0	0	0	0	f	f
3369	13	6	6.00	0	1	0	0	0	0	f	f
3370	66	6	8.00	1	0	0	0	0	1	f	f
3371	163	6	6.50	0	0	0	0	0	0	f	f
3372	67	6	6.50	0	0	0	0	0	0	f	f
3373	104	6	6.50	0	0	0	0	0	0	f	f
3374	82	6	6.00	0	0	0	0	0	0	f	f
3375	81	6	6.00	0	0	0	0	0	0	f	f
3376	270	6	7.50	1	0	0	0	0	0	f	f
3377	351	6	6.50	0	0	0	0	0	0	f	f
3378	352	6	6.00	0	0	0	0	0	0	f	f
3379	350	6	6.00	0	0	0	0	0	0	f	f
3380	411	6	5.50	0	0	0	0	0	0	f	f
3381	299	6	6.00	0	0	0	0	0	0	t	f
3382	444	6	7.00	1	0	0	0	0	0	f	f
3383	474	6	8.50	1	0	0	0	0	3	f	f
3384	475	6	6.00	0	0	0	0	0	0	f	f
3385	7	6	6.00	0	0	0	0	0	0	f	f
3386	216	6	6.00	0	0	0	0	0	0	f	f
3387	88	6	6.00	0	0	0	0	0	0	f	f
3388	99	6	5.50	0	0	0	0	0	0	f	f
3389	138	6	5.50	0	0	0	0	0	0	t	f
3390	108	6	5.00	0	0	0	0	0	0	f	f
3391	307	6	6.50	0	0	0	0	0	0	t	f
3392	306	6	6.00	0	0	0	0	0	0	f	f
3393	332	6	5.50	0	0	0	0	0	0	f	f
3394	291	6	5.50	0	0	0	0	0	0	f	f
3395	278	6	6.50	0	0	0	0	0	0	f	f
3396	461	6	6.00	0	0	0	0	0	0	f	f
3397	480	6	5.00	0	0	0	0	0	0	f	f
3398	477	6	6.00	0	0	0	0	0	0	f	f
3399	446	6	5.50	0	0	0	0	0	0	f	f
3400	3	6	6.00	0	3	0	0	0	0	f	f
3401	236	6	5.00	0	0	0	0	0	0	f	f
3402	126	6	5.50	0	0	0	0	0	0	t	f
3403	195	6	5.50	0	0	0	0	0	0	f	f
3404	145	6	6.00	0	0	0	0	0	0	f	f
3405	125	6	6.00	0	0	0	0	0	0	f	f
3406	301	6	7.00	0	0	0	0	0	0	t	f
3407	284	6	6.50	0	0	0	0	0	1	f	f
3408	417	6	6.00	0	0	0	0	0	0	f	f
3409	285	6	5.50	0	0	0	0	0	0	f	f
3410	516	6	6.00	0	0	0	0	0	1	f	f
3411	491	6	8.00	2	0	0	0	0	0	f	f
3412	494	6	5.50	0	0	0	0	0	0	f	f
3413	455	6	6.00	0	0	0	0	0	0	t	f
3414	492	6	6.50	0	0	0	0	0	0	f	f
3415	8	6	6.50	0	0	0	0	0	0	f	f
3416	127	6	7.00	0	0	0	0	0	0	f	f
3417	164	6	6.00	0	0	0	0	0	0	t	f
3418	89	6	7.00	0	0	0	0	0	0	f	f
3419	146	6	6.50	0	0	0	0	0	0	f	f
3420	219	6	6.00	0	0	0	0	0	0	f	f
3421	310	6	7.00	1	0	0	0	0	0	f	f
3422	293	6	6.50	0	0	0	0	0	0	f	f
3423	286	6	6.50	0	0	0	0	0	0	f	f
3424	354	6	6.00	0	0	0	0	0	0	f	f
3425	401	6	6.00	0	0	0	0	0	0	f	f
3426	333	6	6.00	0	0	0	0	0	0	f	f
3427	501	6	6.00	0	0	0	0	0	0	t	f
3428	509	6	6.00	0	0	0	0	0	0	f	f
3429	513	6	5.50	0	0	0	0	0	0	f	f
3430	1	6	7.00	0	0	0	0	0	0	f	f
3431	111	6	6.50	0	0	0	0	0	0	f	f
3432	139	6	6.00	0	0	0	0	0	0	f	f
3433	68	6	6.50	0	0	0	0	0	0	f	f
3434	90	6	6.50	0	0	0	0	0	0	t	f
3435	273	6	6.50	0	0	0	0	0	0	f	f
3436	260	6	5.00	0	0	0	1	0	0	f	f
3437	268	6	6.50	0	0	0	0	0	0	f	f
3438	302	6	6.00	0	0	0	0	0	0	f	f
3439	313	6	5.50	0	0	0	0	0	0	t	f
3440	271	6	6.50	0	0	0	0	0	0	f	f
3441	447	6	5.00	0	0	0	0	0	0	f	f
3442	485	6	6.00	0	0	0	0	0	0	f	f
3443	486	6	6.50	0	0	0	0	0	0	f	f
3444	4	6	6.00	0	1	0	0	0	0	f	f
3445	196	6	6.00	0	0	0	0	0	0	f	f
3446	71	6	7.00	0	0	0	0	0	0	f	f
3447	113	6	6.50	0	0	0	0	0	0	f	f
3448	201	6	6.00	0	0	0	0	0	0	f	f
3449	178	6	5.00	0	0	0	0	0	0	f	f
3450	112	6	5.50	0	0	0	0	0	0	f	f
3451	319	6	5.50	0	0	0	0	0	0	f	f
3452	264	6	6.50	0	0	0	0	0	0	f	f
3453	266	6	7.50	1	0	0	0	0	0	f	f
3454	356	6	6.00	0	0	0	0	0	0	f	f
3455	265	6	6.00	0	0	0	0	0	0	f	f
3456	334	6	6.00	0	0	0	0	0	0	f	f
3457	279	6	5.50	0	0	0	0	0	0	t	f
3458	450	6	7.00	1	0	0	0	0	0	f	f
3459	510	6	6.00	0	0	0	0	0	0	f	f
3460	16	6	5.00	0	1	0	0	0	0	f	f
3461	116	6	6.00	0	0	0	0	0	0	f	f
3462	114	6	5.50	0	0	0	0	0	0	f	f
3463	115	6	5.50	0	0	0	0	0	0	f	f
3464	220	6	5.00	0	0	0	0	0	0	f	f
3465	224	6	5.50	0	0	0	0	0	0	t	f
3466	143	6	5.50	0	0	0	0	0	0	f	f
3467	403	6	6.00	0	0	0	0	0	0	f	f
3468	280	6	5.50	0	0	0	0	0	0	f	f
3469	365	6	6.00	0	0	0	0	0	0	f	f
3470	359	6	5.50	0	0	0	0	0	0	f	f
3471	493	6	5.50	0	0	0	0	0	0	f	f
3472	531	6	6.00	0	0	0	0	0	0	f	f
3473	523	6	6.00	0	0	0	0	0	0	f	f
3474	502	6	5.50	0	0	0	0	0	0	f	f
3475	456	6	6.00	0	0	0	0	0	0	f	f
3476	14	6	6.00	0	4	0	0	0	0	f	f
3477	102	6	5.50	0	0	0	0	0	0	t	f
3478	148	6	5.50	0	0	0	0	0	0	f	f
3479	166	6	6.00	0	0	0	0	0	0	f	f
3480	186	6	5.00	0	0	0	0	0	0	f	f
3481	165	6	5.00	0	0	0	0	0	0	f	f
3482	129	6	5.50	0	0	0	0	0	0	f	f
3483	344	6	5.00	0	0	0	0	0	0	f	f
3484	368	6	5.50	0	0	0	0	0	0	f	f
3485	324	6	6.00	0	0	0	0	0	0	f	f
3486	320	6	4.00	0	0	0	0	0	0	f	t
3487	383	6	6.00	0	0	0	0	0	0	f	f
3488	406	6	6.00	0	0	0	0	0	0	f	f
3489	472	6	5.00	0	0	0	0	0	0	f	f
3490	517	6	5.50	0	0	0	0	0	0	f	f
3491	536	6	6.00	0	0	0	0	0	0	f	f
3492	2	6	5.50	0	1	0	0	0	0	f	f
3493	100	6	6.00	0	0	0	0	0	0	f	f
3494	130	6	6.00	0	0	0	0	0	0	f	f
3495	76	6	6.50	0	0	0	0	0	0	f	f
3496	202	6	6.00	0	0	0	0	0	0	t	f
3497	167	6	6.00	0	0	0	0	0	0	f	f
3498	72	6	6.50	0	0	0	0	0	0	t	f
3499	227	6	6.00	0	0	0	0	0	0	f	f
3500	275	6	6.00	0	0	0	0	0	0	f	f
3501	295	6	7.00	1	0	0	0	0	0	t	f
3502	281	6	6.50	0	0	0	0	0	0	f	f
3503	384	6	6.00	0	0	0	0	0	0	f	f
3504	357	6	6.00	0	0	0	0	0	0	f	f
3505	481	6	6.00	0	0	0	0	0	0	f	f
3506	448	6	7.50	1	0	0	0	0	1	f	f
3507	471	6	6.00	0	0	0	0	0	1	f	f
3508	15	6	7.00	0	0	0	0	0	0	t	f
3509	142	6	6.00	0	0	0	0	0	0	f	f
3510	150	6	6.00	0	0	0	0	0	0	f	f
3511	118	6	6.50	0	0	0	0	0	0	f	f
3512	149	6	7.00	0	0	0	0	0	0	f	f
3513	315	6	6.00	0	0	0	0	0	0	f	f
3514	389	6	5.50	0	0	0	0	0	0	f	f
3515	303	6	6.00	0	0	0	0	0	0	f	f
3516	314	6	6.50	0	0	0	0	0	0	f	f
3517	287	6	6.50	0	0	0	0	0	0	f	f
3518	308	6	7.00	0	0	0	0	0	0	f	f
3519	385	6	6.00	0	0	0	0	0	0	f	f
3520	527	6	6.00	0	0	0	0	0	0	t	f
3521	467	6	6.50	1	0	0	1	0	0	f	f
3522	453	6	6.00	0	0	0	0	0	0	f	f
3523	518	6	6.00	0	0	0	0	0	0	t	f
3524	26	6	5.50	0	3	0	0	0	0	f	f
3525	222	6	6.50	0	0	0	0	0	1	f	f
3526	152	6	5.50	0	0	0	0	0	0	f	f
3527	91	6	5.50	0	0	0	0	0	0	t	f
3528	203	6	6.50	0	0	0	0	0	1	f	f
3529	168	6	6.50	0	0	0	0	0	0	f	f
3530	77	6	6.00	1	0	0	0	0	0	f	f
3531	249	6	5.00	0	0	0	0	0	0	f	f
3532	370	6	5.50	0	0	0	0	0	0	f	f
3533	288	6	5.50	0	0	0	0	0	0	f	f
3534	399	6	6.00	0	0	0	0	0	0	t	f
3535	358	6	5.50	0	0	0	0	0	0	t	f
3536	386	6	6.00	0	0	0	0	0	0	f	f
3537	466	6	7.00	1	0	0	0	0	0	f	f
3538	488	6	6.00	0	0	0	0	0	0	f	f
3539	468	6	7.00	1	0	0	0	0	0	f	f
3540	27	6	5.50	0	1	0	0	0	0	f	f
3541	78	6	6.50	1	0	0	0	0	0	f	f
3542	128	6	5.50	0	0	0	0	0	0	f	f
3543	154	6	6.00	0	0	0	0	0	0	f	f
3544	153	6	5.50	0	0	0	0	0	0	f	f
3545	180	6	6.00	0	0	0	0	0	0	f	f
3546	198	6	6.50	0	0	0	0	0	0	f	f
3547	101	6	6.50	0	0	0	0	0	1	f	f
3548	272	6	5.50	0	0	0	0	0	0	t	f
3549	423	6	6.00	0	0	0	0	0	0	f	f
3550	321	6	6.50	0	0	0	0	0	0	f	f
3551	282	6	6.50	0	0	0	0	0	0	f	f
3552	328	6	6.00	0	0	0	0	0	0	f	f
3553	452	6	6.00	0	0	0	0	0	0	f	f
3554	525	6	5.00	0	0	0	0	0	0	f	f
3555	12	6	6.50	0	1	1	0	0	0	f	f
3556	155	6	5.50	0	0	0	0	0	0	f	f
3557	183	6	6.50	0	0	0	0	0	0	f	f
3558	181	6	6.00	0	0	0	0	0	0	f	f
3559	169	6	5.50	0	0	0	0	0	0	f	f
3560	79	6	6.00	0	0	0	0	0	0	t	f
3561	345	6	6.00	0	0	0	0	0	0	f	f
3562	435	6	6.00	0	0	0	0	0	0	f	f
3563	413	6	6.00	0	0	0	0	0	0	f	f
3564	408	6	5.50	0	0	0	0	0	0	f	f
3565	309	6	5.50	0	0	0	0	0	0	t	f
3566	327	6	5.50	0	0	0	0	0	0	f	f
3567	521	6	5.50	0	0	0	0	0	0	f	f
3568	473	6	5.50	0	0	0	0	0	0	f	f
3569	503	6	6.00	0	0	0	0	0	0	f	f
3570	469	6	6.00	0	0	0	0	0	0	f	f
3571	46	6	\N	0	0	0	0	0	0	f	f
3572	35	6	\N	0	0	0	0	0	0	f	f
3573	11	6	\N	0	0	0	0	0	0	f	f
3574	37	6	\N	0	0	0	0	0	0	f	f
3575	75	6	\N	0	0	0	0	0	0	f	f
3576	24	6	\N	0	0	0	0	0	0	f	f
3577	29	6	\N	0	0	0	0	0	0	f	f
3578	51	6	\N	0	0	0	0	0	0	f	f
3579	36	6	\N	0	0	0	0	0	0	f	f
3580	92	6	\N	0	0	0	0	0	0	f	f
3581	54	6	\N	0	0	0	0	0	0	f	f
3582	47	6	\N	0	0	0	0	0	0	f	f
3583	96	6	\N	0	0	0	0	0	0	f	f
3584	21	6	\N	0	0	0	0	0	0	f	f
3585	83	6	\N	0	0	0	0	0	0	f	f
3586	19	6	\N	0	0	0	0	0	0	f	f
3587	40	6	\N	0	0	0	0	0	0	f	f
3588	74	6	\N	0	0	0	0	0	0	f	f
3589	42	6	\N	0	0	0	0	0	0	f	f
3590	52	6	\N	0	0	0	0	0	0	f	f
3591	33	6	\N	0	0	0	0	0	0	f	f
3592	93	6	\N	0	0	0	0	0	0	f	f
3593	20	6	\N	0	0	0	0	0	0	f	f
3594	61	6	\N	0	0	0	0	0	0	f	f
3595	56	6	\N	0	0	0	0	0	0	f	f
3596	58	6	\N	0	0	0	0	0	0	f	f
3597	62	6	\N	0	0	0	0	0	0	f	f
3598	65	6	\N	0	0	0	0	0	0	f	f
3599	30	6	\N	0	0	0	0	0	0	f	f
3600	45	6	\N	0	0	0	0	0	0	f	f
3601	147	6	\N	0	0	0	0	0	0	f	f
3602	172	6	\N	0	0	0	0	0	0	f	f
3603	171	6	\N	0	0	0	0	0	0	f	f
3604	144	6	\N	0	0	0	0	0	0	f	f
3605	176	6	\N	0	0	0	0	0	0	f	f
3606	199	6	\N	0	0	0	0	0	0	f	f
3607	184	6	\N	0	0	0	0	0	0	f	f
3608	193	6	\N	0	0	0	0	0	0	f	f
3609	122	6	\N	0	0	0	0	0	0	f	f
3610	204	6	\N	0	0	0	0	0	0	f	f
3611	140	6	\N	0	0	0	0	0	0	f	f
3612	197	6	\N	0	0	0	0	0	0	f	f
3613	141	6	\N	0	0	0	0	0	0	f	f
3614	207	6	\N	0	0	0	0	0	0	f	f
3615	208	6	\N	0	0	0	0	0	0	f	f
3616	187	6	\N	0	0	0	0	0	0	f	f
3617	191	6	\N	0	0	0	0	0	0	f	f
3618	151	6	\N	0	0	0	0	0	0	f	f
3619	170	6	\N	0	0	0	0	0	0	f	f
3620	182	6	\N	0	0	0	0	0	0	f	f
3621	137	6	\N	0	0	0	0	0	0	f	f
3622	218	6	\N	0	0	0	0	0	0	f	f
3623	238	6	\N	0	0	0	0	0	0	f	f
3624	235	6	\N	0	0	0	0	0	0	f	f
3625	232	6	\N	0	0	0	0	0	0	f	f
3626	226	6	\N	0	0	0	0	0	0	f	f
3627	248	6	\N	0	0	0	0	0	0	f	f
3628	241	6	\N	0	0	0	0	0	0	f	f
3629	255	6	\N	0	0	0	0	0	0	f	f
3630	221	6	\N	0	0	0	0	0	0	f	f
3631	230	6	\N	0	0	0	0	0	0	f	f
3632	211	6	\N	0	0	0	0	0	0	f	f
3633	292	6	\N	0	0	0	0	0	0	f	f
3634	244	6	\N	0	0	0	0	0	0	f	f
3635	245	6	\N	0	0	0	0	0	0	f	f
3636	304	6	\N	0	0	0	0	0	0	f	f
3637	240	6	\N	0	0	0	0	0	0	f	f
3638	250	6	\N	0	0	0	0	0	0	f	f
3639	223	6	\N	0	0	0	0	0	0	f	f
3640	312	6	\N	0	0	0	0	0	0	f	f
3641	228	6	\N	0	0	0	0	0	0	f	f
3642	253	6	\N	0	0	0	0	0	0	f	f
3643	254	6	\N	0	0	0	0	0	0	f	f
3644	225	6	\N	0	0	0	0	0	0	f	f
3645	233	6	\N	0	0	0	0	0	0	f	f
3646	402	6	\N	0	0	0	0	0	0	f	f
3647	418	6	\N	0	0	0	0	0	0	f	f
3648	325	6	\N	0	0	0	0	0	0	f	f
3649	343	6	\N	0	0	0	0	0	0	f	f
3650	405	6	\N	0	0	0	0	0	0	f	f
3651	367	6	\N	0	0	0	0	0	0	f	f
3652	404	6	\N	0	0	0	0	0	0	f	f
3653	373	6	\N	0	0	0	0	0	0	f	f
3654	337	6	\N	0	0	0	0	0	0	f	f
3655	390	6	\N	0	0	0	0	0	0	f	f
3656	382	6	\N	0	0	0	0	0	0	f	f
3657	414	6	\N	0	0	0	0	0	0	f	f
3658	378	6	\N	0	0	0	0	0	0	f	f
3659	380	6	\N	0	0	0	0	0	0	f	f
3660	412	6	\N	0	0	0	0	0	0	f	f
3661	360	6	\N	0	0	0	0	0	0	f	f
3662	326	6	\N	0	0	0	0	0	0	f	f
3663	371	6	\N	0	0	0	0	0	0	f	f
3664	397	6	\N	0	0	0	0	0	0	f	f
3665	353	6	\N	0	0	0	0	0	0	f	f
3666	400	6	\N	0	0	0	0	0	0	f	f
3667	369	6	\N	0	0	0	0	0	0	f	f
3668	338	6	\N	0	0	0	0	0	0	f	f
3669	376	6	\N	0	0	0	0	0	0	f	f
3670	416	6	\N	0	0	0	0	0	0	f	f
3671	366	6	\N	0	0	0	0	0	0	f	f
3672	391	6	\N	0	0	0	0	0	0	f	f
3673	409	6	\N	0	0	0	0	0	0	f	f
3674	237	6	\N	0	0	0	0	0	0	f	f
3675	431	6	\N	0	0	0	0	0	0	f	f
3676	429	6	\N	0	0	0	0	0	0	f	f
3677	433	6	\N	0	0	0	0	0	0	f	f
3678	522	6	\N	0	0	0	0	0	0	f	f
3679	514	6	\N	0	0	0	0	0	0	f	f
3680	495	6	\N	0	0	0	0	0	0	f	f
3681	449	6	\N	0	0	0	0	0	0	f	f
3682	428	6	\N	0	0	0	0	0	0	f	f
3683	438	6	\N	0	0	0	0	0	0	f	f
3684	441	6	\N	0	0	0	0	0	0	f	f
3685	437	6	\N	0	0	0	0	0	0	f	f
3686	497	6	\N	0	0	0	0	0	0	f	f
3687	425	6	\N	0	0	0	0	0	0	f	f
3688	426	6	\N	0	0	0	0	0	0	f	f
3689	430	6	\N	0	0	0	0	0	0	f	f
3690	420	6	\N	0	0	0	0	0	0	f	f
3691	459	6	\N	0	0	0	0	0	0	f	f
3692	427	6	\N	0	0	0	0	0	0	f	f
3693	484	6	\N	0	0	0	0	0	0	f	f
3694	504	6	\N	0	0	0	0	0	0	f	f
3695	434	6	\N	0	0	0	0	0	0	f	f
3696	529	6	\N	0	0	0	0	0	0	f	f
3697	530	6	\N	0	0	0	0	0	0	f	f
3698	540	6	\N	0	0	0	0	0	0	f	f
3699	541	6	\N	0	0	0	0	0	0	f	f
3700	43	6	\N	0	0	0	0	0	0	f	f
3701	44	6	\N	0	0	0	0	0	0	f	f
3702	110	6	\N	0	0	0	0	0	0	f	f
3703	217	6	\N	0	0	0	0	0	0	f	f
3704	363	6	\N	0	0	0	0	0	0	f	f
3705	362	6	\N	0	0	0	0	0	0	f	f
3706	267	6	\N	0	0	0	0	0	0	f	f
3707	55	6	\N	0	0	0	0	0	0	f	f
3708	206	6	\N	0	0	0	0	0	0	f	f
3709	247	6	\N	0	0	0	0	0	0	f	f
3710	421	6	\N	0	0	0	0	0	0	f	f
3711	422	6	\N	0	0	0	0	0	0	f	f
3712	246	6	\N	0	0	0	0	0	0	f	f
3713	538	6	\N	0	0	0	0	0	0	f	f
3714	48	6	\N	0	0	0	0	0	0	f	f
3715	177	6	\N	0	0	0	0	0	0	f	f
3716	258	6	\N	0	0	0	0	0	0	f	f
3717	388	6	\N	0	0	0	0	0	0	f	f
3718	294	6	\N	0	0	0	0	0	0	f	f
3719	34	6	\N	0	0	0	0	0	0	f	f
3720	133	6	\N	0	0	0	0	0	0	f	f
3721	436	6	\N	0	0	0	0	0	0	f	f
3722	498	6	\N	0	0	0	0	0	0	f	f
3723	532	6	\N	0	0	0	0	0	0	f	f
3724	542	6	\N	0	0	0	0	0	0	f	f
3725	543	6	\N	0	0	0	0	0	0	f	f
3726	528	6	\N	0	0	0	0	0	0	f	f
3727	49	6	\N	0	0	0	0	0	0	f	f
3728	239	6	\N	0	0	0	0	0	0	f	f
3729	483	6	\N	0	0	0	0	0	0	f	f
3730	476	6	\N	0	0	0	0	0	0	f	f
3731	60	6	\N	0	0	0	0	0	0	f	f
3732	57	6	\N	0	0	0	0	0	0	f	f
3733	131	6	\N	0	0	0	0	0	0	f	f
3734	524	6	\N	0	0	0	0	0	0	f	f
3735	39	6	\N	0	0	0	0	0	0	f	f
3736	59	6	\N	0	0	0	0	0	0	f	f
3737	440	6	\N	0	0	0	0	0	0	f	f
3738	398	6	\N	0	0	0	0	0	0	f	f
3739	442	6	\N	0	0	0	0	0	0	f	f
3740	25	6	\N	0	0	0	0	0	0	f	f
3741	87	6	\N	0	0	0	0	0	0	f	f
3742	109	6	\N	0	0	0	0	0	0	f	f
3743	194	6	\N	0	0	0	0	0	0	f	f
3744	234	6	\N	0	0	0	0	0	0	f	f
3745	410	6	\N	0	0	0	0	0	0	f	f
3746	535	6	\N	0	0	0	0	0	0	f	f
3747	322	6	\N	0	0	0	0	0	0	f	f
3748	53	6	\N	0	0	0	0	0	0	f	f
3749	251	6	\N	0	0	0	0	0	0	f	f
3750	84	6	\N	0	0	0	0	0	0	f	f
3751	335	6	\N	0	0	0	0	0	0	f	f
3752	346	6	\N	0	0	0	0	0	0	f	f
3753	32	6	\N	0	0	0	0	0	0	f	f
3754	132	6	\N	0	0	0	0	0	0	f	f
3755	94	6	\N	0	0	0	0	0	0	f	f
3756	454	6	\N	0	0	0	0	0	0	f	f
3757	209	6	\N	0	0	0	0	0	0	f	f
3758	73	6	\N	0	0	0	0	0	0	f	f
3759	537	6	\N	0	0	0	0	0	0	f	f
3760	451	6	\N	0	0	0	0	0	0	f	f
3761	38	6	\N	0	0	0	0	0	0	f	f
3762	256	6	\N	0	0	0	0	0	0	f	f
3763	213	6	\N	0	0	0	0	0	0	f	f
3764	415	6	\N	0	0	0	0	0	0	f	f
3765	22	6	\N	0	0	0	0	0	0	f	f
3766	179	6	\N	0	0	0	0	0	0	f	f
3767	407	6	\N	0	0	0	0	0	0	f	f
3768	387	6	\N	0	0	0	0	0	0	f	f
3769	439	6	\N	0	0	0	0	0	0	f	f
3770	539	6	\N	0	0	0	0	0	0	f	f
3771	496	6	\N	0	0	0	0	0	0	f	f
3772	252	6	\N	0	0	0	0	0	0	f	f
3773	424	6	\N	0	0	0	0	0	0	f	f
3774	41	6	\N	0	0	0	0	0	0	f	f
3775	136	6	\N	0	0	0	0	0	0	f	f
3776	259	6	\N	0	0	0	0	0	0	f	f
3777	262	6	\N	0	0	0	0	0	0	f	f
3778	300	6	\N	0	0	0	0	0	0	f	f
3779	445	6	\N	0	0	0	0	0	0	f	f
3780	257	6	\N	0	0	0	0	0	0	f	f
3781	419	6	\N	0	0	0	0	0	0	f	f
3782	432	6	\N	0	0	0	0	0	0	f	f
3783	381	6	\N	0	0	0	0	0	0	f	f
3784	64	6	\N	0	0	0	0	0	0	f	f
3785	188	6	\N	0	0	0	0	0	0	f	f
3786	395	6	\N	0	0	0	0	0	0	f	f
3787	533	6	\N	0	0	0	0	0	0	f	f
3788	393	6	\N	0	0	0	0	0	0	f	f
3789	23	6	\N	0	0	0	0	0	0	f	f
3790	50	6	\N	0	0	0	0	0	0	f	f
3791	443	6	\N	0	0	0	0	0	0	f	f
3792	372	6	\N	0	0	0	0	0	0	f	f
3793	31	6	\N	0	0	0	0	0	0	f	f
3794	185	6	\N	0	0	0	0	0	0	f	f
3795	243	6	\N	0	0	0	0	0	0	f	f
3796	242	6	\N	0	0	0	0	0	0	f	f
3797	487	6	\N	0	0	0	0	0	0	f	f
3798	63	6	\N	0	0	0	0	0	0	f	f
3799	231	6	\N	0	0	0	0	0	0	f	f
3800	499	6	\N	0	0	0	0	0	0	f	f
3801	506	6	\N	0	0	0	0	0	0	f	f
3802	5	7	6.00	0	0	0	0	0	0	f	f
3803	120	7	6.50	0	0	0	0	0	0	f	f
3804	156	7	6.00	0	0	0	0	0	0	f	f
3805	132	7	6.00	0	0	0	0	0	0	f	f
3806	157	7	6.00	0	0	0	0	0	0	t	f
3807	158	7	6.00	0	0	0	0	0	0	f	f
3808	200	7	6.50	0	0	0	0	0	0	f	f
3809	338	7	6.00	0	0	0	0	0	0	f	f
3810	296	7	6.00	0	0	0	0	0	0	t	f
3811	394	7	6.00	0	0	0	0	0	0	f	f
3812	329	7	6.00	0	0	0	0	0	0	f	f
3813	462	7	6.00	0	0	0	0	0	0	f	f
3814	482	7	5.50	0	0	0	0	0	0	t	f
3815	459	7	6.00	0	0	0	0	0	0	t	f
3816	465	7	6.00	0	0	0	0	0	0	f	f
3817	20	7	6.50	0	0	0	0	0	0	f	f
3818	188	7	6.00	0	0	0	0	0	0	f	f
3819	209	7	6.00	0	0	0	0	0	0	t	f
3820	85	7	6.50	0	0	0	0	0	0	t	f
3821	73	7	7.00	1	0	0	0	0	0	f	f
3822	187	7	6.50	0	0	0	0	0	0	f	f
3823	103	7	6.50	0	0	0	0	0	0	f	f
3824	341	7	6.50	0	0	0	0	0	0	f	f
3825	340	7	6.50	0	0	0	0	0	0	f	f
3826	263	7	7.00	1	0	0	0	0	0	f	f
3827	269	7	7.00	0	0	0	0	0	1	f	f
3828	311	7	5.50	0	0	0	0	0	0	f	f
3829	346	7	6.00	0	0	0	0	0	0	t	f
3830	458	7	5.50	0	0	0	0	0	0	f	f
3831	451	7	6.00	0	0	0	0	0	0	f	f
3832	519	7	6.50	0	0	0	0	0	1	f	f
3833	10	7	6.50	0	2	0	0	0	0	f	f
3834	96	7	5.50	0	0	0	0	0	0	f	f
3835	97	7	5.50	0	0	0	0	0	0	f	f
3836	133	7	6.00	0	0	0	0	0	0	f	f
3837	159	7	5.00	0	0	0	0	0	0	f	f
3838	69	7	6.50	0	0	0	0	0	0	f	f
3839	229	7	5.00	0	0	0	0	0	0	f	f
3840	304	7	5.50	0	0	0	0	0	0	f	f
3841	361	7	5.50	0	0	0	0	0	0	f	f
3842	330	7	6.00	0	0	0	0	0	0	f	f
3843	348	7	6.00	0	0	0	0	0	0	f	f
3844	289	7	5.00	0	0	0	0	0	0	f	f
3845	470	7	6.00	0	0	0	0	0	0	t	f
3846	520	7	6.00	0	0	0	0	0	0	f	f
3847	478	7	5.50	0	0	0	0	0	0	f	f
3848	529	7	6.00	0	0	0	0	0	0	f	f
3849	6	7	6.00	0	0	0	0	0	0	f	f
3850	119	7	6.00	0	0	0	0	0	0	t	f
3851	86	7	6.50	0	0	0	0	0	0	f	f
3852	171	7	6.00	0	0	0	0	0	0	t	f
3853	95	7	6.00	0	0	0	0	0	0	f	f
3854	105	7	6.00	0	0	0	0	0	0	f	f
3855	117	7	6.00	0	0	0	0	0	0	f	f
3856	80	7	7.50	1	0	0	0	0	0	f	f
3857	211	7	6.00	0	0	0	0	0	0	f	f
3858	189	7	6.00	0	0	0	0	0	0	t	f
3859	316	7	5.50	0	0	0	0	0	0	f	f
3860	317	7	6.50	0	0	0	0	0	0	f	f
3861	290	7	7.00	0	0	0	0	0	1	f	f
3862	261	7	8.00	1	0	0	0	0	1	f	f
3863	512	7	6.00	0	0	0	0	0	0	f	f
3864	463	7	6.50	0	0	0	0	0	0	f	f
3865	28	7	6.00	0	1	0	0	0	0	f	f
3866	134	7	6.00	0	0	0	0	0	0	f	f
3867	173	7	5.50	0	0	0	0	0	0	f	f
3868	75	7	7.00	1	0	0	0	0	0	f	f
3869	70	7	5.50	0	0	0	0	0	0	f	f
3870	106	7	6.00	0	0	0	0	0	0	f	f
3871	277	7	6.50	0	0	0	0	0	0	f	f
3872	355	7	6.00	0	0	0	0	0	0	f	f
3873	343	7	5.50	0	0	0	0	0	0	t	f
3874	325	7	6.00	0	0	0	0	0	0	t	f
3875	393	7	6.00	0	0	0	0	0	0	f	f
3876	283	7	6.50	0	0	0	0	0	1	t	f
3877	464	7	6.00	0	0	0	0	0	0	f	f
3878	457	7	5.50	0	0	0	0	0	0	t	f
3879	17	7	6.00	0	2	0	0	0	0	f	f
3880	107	7	6.50	1	0	0	0	0	0	f	f
3881	124	7	6.50	0	0	0	0	0	0	t	f
3882	190	7	6.00	0	0	0	0	0	0	f	f
3883	191	7	5.50	0	0	0	0	0	0	t	f
3884	175	7	6.00	0	0	0	0	0	0	f	f
3885	161	7	6.00	0	0	0	0	0	0	f	f
3886	274	7	6.00	0	0	0	0	0	0	f	f
3887	392	7	6.00	0	0	0	0	0	0	t	f
3888	376	7	6.00	0	0	0	0	0	0	f	f
3889	366	7	6.00	0	0	0	0	0	0	f	f
3890	297	7	6.00	0	0	0	0	0	0	f	f
3891	377	7	6.00	0	0	0	0	0	0	f	f
3892	515	7	6.00	0	0	0	0	0	0	f	f
3893	460	7	6.00	0	0	0	0	0	0	f	f
3894	505	7	5.50	0	0	0	0	0	0	f	f
3895	18	7	6.00	0	0	0	0	0	0	f	f
3896	215	7	6.00	0	0	0	0	0	0	f	f
3897	98	7	6.50	0	0	0	0	0	0	f	f
3898	92	7	6.00	0	0	0	0	0	0	f	f
3899	135	7	6.00	0	0	0	0	0	0	f	f
3900	305	7	5.50	0	0	0	0	0	0	t	f
3901	426	7	4.50	0	0	0	1	0	0	f	f
3902	342	7	6.00	0	0	0	0	0	0	f	f
3903	318	7	5.50	0	0	0	0	0	0	f	f
3904	379	7	5.50	0	0	0	0	0	0	f	f
3905	349	7	6.50	0	0	0	0	0	0	f	f
3906	430	7	6.00	0	0	0	0	0	0	f	f
3907	508	7	5.50	0	0	0	0	0	0	t	f
3908	500	7	5.50	0	0	0	0	0	0	f	f
3909	490	7	6.00	0	0	0	0	0	0	f	f
3910	507	7	6.50	0	0	0	0	0	0	f	f
3911	13	7	6.50	0	0	0	0	0	0	f	f
3912	66	7	6.00	0	0	0	0	0	0	f	f
3913	136	7	6.50	0	0	0	0	0	0	f	f
3914	67	7	6.50	0	0	0	0	0	0	f	f
3915	104	7	6.50	0	0	0	0	0	0	f	f
3916	82	7	6.00	0	0	0	0	0	0	f	f
3917	81	7	6.00	0	0	0	0	0	0	f	f
3918	300	7	6.00	0	0	0	0	0	0	f	f
3919	270	7	6.50	0	0	0	0	0	1	f	f
3920	262	7	6.50	0	0	0	0	0	0	f	f
3921	351	7	6.50	0	0	0	0	0	0	t	f
3922	352	7	6.00	0	0	0	0	0	0	f	f
3923	299	7	6.00	0	0	0	0	0	0	t	f
3924	444	7	5.50	0	0	0	0	0	0	t	f
3925	474	7	7.00	1	0	0	0	0	0	f	f
3926	475	7	6.00	0	0	0	0	0	0	f	f
3927	7	7	6.00	0	2	0	0	0	0	f	f
3928	216	7	5.50	0	0	0	0	0	0	f	f
3929	88	7	5.50	0	0	0	0	0	0	f	f
3930	99	7	5.50	0	0	0	0	0	0	f	f
3931	108	7	6.00	0	0	0	0	0	0	t	f
3932	194	7	6.00	0	0	0	0	0	0	f	f
3933	307	7	6.00	0	0	0	0	0	0	f	f
3934	306	7	6.00	0	0	0	0	0	0	f	f
3935	332	7	5.50	0	0	0	0	0	0	f	f
3936	291	7	6.00	0	0	0	0	0	0	f	f
3937	353	7	5.00	0	0	0	0	0	0	f	f
3938	278	7	5.50	0	0	0	0	0	0	f	f
3939	461	7	5.50	0	0	0	0	0	0	f	f
3940	480	7	5.00	0	0	0	0	0	0	f	f
3941	446	7	6.00	0	0	0	0	0	0	f	f
3942	3	7	6.50	0	0	0	0	0	0	f	f
3943	126	7	6.00	0	0	0	0	0	0	f	f
3944	110	7	6.00	0	0	0	0	0	0	f	f
3945	195	7	6.00	0	0	0	0	0	0	f	f
3946	145	7	5.50	0	0	0	0	0	0	f	f
3947	125	7	7.00	0	0	0	0	0	0	f	f
3948	176	7	6.00	0	0	0	0	0	0	f	f
3949	362	7	6.00	0	0	0	0	0	0	f	f
3950	301	7	5.50	0	0	0	0	0	0	f	f
3951	267	7	6.00	0	0	0	0	0	0	f	f
3952	292	7	6.00	0	0	0	0	0	0	f	f
3953	284	7	6.50	0	0	0	0	0	0	f	f
3954	285	7	6.00	0	0	0	0	0	0	f	f
3955	516	7	6.00	0	0	0	0	0	0	f	f
3956	491	7	6.00	0	0	0	0	0	0	f	f
3957	494	7	5.00	0	0	0	0	0	0	f	f
3958	8	7	6.00	0	0	0	0	0	0	t	f
3959	127	7	6.00	0	0	0	0	0	0	f	f
3960	164	7	6.50	0	0	0	0	0	0	f	f
3961	89	7	6.50	0	0	0	0	0	0	f	f
3962	146	7	6.00	0	0	0	0	0	0	t	f
3963	293	7	5.50	0	0	0	0	0	0	f	f
3964	419	7	6.00	0	0	0	0	0	0	f	f
3965	286	7	5.50	0	0	0	0	0	0	f	f
3966	354	7	6.00	0	0	0	0	0	0	f	f
3967	333	7	5.50	0	0	0	0	0	0	f	f
3968	418	7	6.00	0	0	0	0	0	0	f	f
3969	381	7	5.50	0	0	0	0	0	0	f	f
3970	501	7	5.50	0	0	0	0	0	0	f	f
3971	509	7	6.00	0	0	0	0	0	0	f	f
3972	495	7	6.00	0	0	0	0	0	0	f	f
3973	513	7	6.00	0	0	0	0	0	0	f	f
3974	1	7	5.00	0	1	0	0	0	0	f	f
3975	111	7	5.50	0	0	0	0	0	0	f	f
3976	139	7	6.00	0	0	0	0	0	0	t	f
3977	68	7	6.00	0	0	0	0	0	0	f	f
3978	193	7	6.00	0	0	0	0	0	0	f	f
3979	90	7	6.00	0	0	0	0	0	0	f	f
3980	184	7	5.50	0	0	0	0	0	0	t	f
3981	268	7	6.50	0	0	0	0	0	0	f	f
3982	313	7	6.00	0	0	0	0	0	0	t	f
3983	271	7	5.50	0	0	0	0	0	0	f	f
3984	294	7	6.00	0	0	0	0	0	0	f	f
3985	447	7	7.50	1	0	0	0	0	0	f	f
3986	486	7	6.50	0	0	0	0	0	0	f	f
3987	541	7	6.00	0	0	0	0	0	0	f	f
3988	4	7	6.00	0	1	0	0	0	0	f	f
3989	196	7	5.50	0	0	0	0	0	0	t	f
3990	71	7	6.50	0	0	0	0	0	0	f	f
3991	83	7	6.00	0	0	0	0	0	0	f	f
3992	113	7	5.50	0	0	0	0	0	0	f	f
3993	178	7	5.00	0	0	0	0	0	0	f	f
3994	112	7	5.50	0	0	0	0	0	0	f	f
3995	319	7	6.50	0	0	0	0	0	0	f	f
3996	264	7	6.00	0	0	0	0	0	0	f	f
3997	266	7	6.00	0	0	0	0	0	0	f	f
3998	360	7	5.50	0	0	0	0	0	0	f	f
3999	334	7	5.00	0	0	0	0	0	0	f	f
4000	279	7	5.50	0	0	0	0	0	0	f	f
4001	510	7	5.00	0	0	0	0	0	0	f	f
4002	483	7	6.00	0	0	0	0	0	0	t	f
4003	532	7	5.50	0	0	0	0	0	0	f	f
4004	16	7	8.00	0	0	1	0	0	0	f	f
4005	147	7	6.50	0	0	0	0	0	0	f	f
4006	114	7	6.50	0	0	0	0	0	0	f	f
4007	115	7	6.00	0	0	0	0	0	0	f	f
4008	224	7	4.00	0	0	0	0	0	0	f	t
4009	226	7	5.00	0	0	0	0	0	0	t	f
4010	143	7	5.50	0	0	0	0	0	0	t	f
4011	403	7	5.50	0	0	0	0	0	0	t	f
4012	280	7	6.00	0	0	0	0	0	0	f	f
4013	365	7	6.50	0	0	0	0	0	0	f	f
4014	404	7	6.00	0	0	0	0	0	0	f	f
4015	359	7	6.00	0	0	0	0	0	0	f	f
4016	493	7	6.00	0	0	0	0	0	0	f	f
4017	531	7	6.00	0	0	0	0	0	0	f	f
4018	523	7	6.00	0	0	0	0	0	0	f	f
4019	456	7	5.50	0	0	0	0	0	0	f	f
4020	14	7	6.00	0	0	0	0	0	0	f	f
4021	185	7	6.50	0	0	0	0	0	0	f	f
4022	102	7	6.00	0	0	0	0	0	0	f	f
4023	148	7	6.00	0	0	0	0	0	0	f	f
4024	186	7	6.00	0	0	0	0	0	0	f	f
4025	165	7	6.50	0	0	0	0	0	0	t	f
4026	129	7	5.50	0	0	0	0	0	0	f	f
4027	344	7	6.00	0	0	0	0	0	0	f	f
4028	368	7	6.00	0	0	0	0	0	0	t	f
4029	373	7	5.50	0	0	0	0	0	0	f	f
4030	324	7	5.50	0	0	0	0	0	0	t	f
4031	382	7	6.00	0	0	0	0	0	0	t	f
4032	383	7	6.00	0	0	0	0	0	0	f	f
4033	472	7	5.50	0	0	0	0	0	0	f	f
4034	487	7	5.50	0	0	0	0	0	0	f	f
4035	2	7	5.50	0	1	0	0	0	0	f	f
4036	100	7	6.50	0	0	0	0	0	0	f	f
4037	130	7	5.00	0	0	0	0	0	0	t	f
4038	76	7	5.50	0	0	0	0	0	0	f	f
4039	84	7	5.50	0	0	0	0	0	0	t	f
4040	72	7	6.00	0	0	0	0	0	0	f	f
4041	227	7	6.00	0	0	0	0	0	0	t	f
4042	275	7	5.50	0	0	0	0	0	0	f	f
4043	295	7	6.00	0	0	0	0	0	0	f	f
4044	335	7	6.00	0	0	0	0	0	0	f	f
4045	281	7	6.50	0	0	0	0	0	0	f	f
4046	384	7	6.00	0	0	0	0	0	0	t	f
4047	481	7	6.00	0	0	0	0	0	0	f	f
4048	448	7	5.50	0	0	0	0	0	0	f	f
4049	484	7	6.00	0	0	0	0	0	0	f	f
4050	471	7	5.00	0	0	0	0	0	0	f	f
4051	15	7	6.00	0	0	0	0	0	0	f	f
4052	245	7	6.00	0	0	0	0	0	0	f	f
4053	142	7	6.50	0	0	0	0	0	0	f	f
4054	150	7	6.00	0	0	0	0	0	0	t	f
4055	118	7	6.50	0	0	0	0	0	0	f	f
4056	199	7	6.00	0	0	0	0	0	0	f	f
4057	315	7	6.00	0	0	0	0	0	0	f	f
4058	389	7	5.50	0	0	0	0	0	0	f	f
4059	314	7	5.50	0	0	0	0	0	0	f	f
4060	385	7	6.00	0	0	0	0	0	0	f	f
4061	449	7	5.50	0	0	0	0	0	0	t	f
4062	527	7	6.00	0	0	0	0	0	0	f	f
4063	467	7	5.50	0	0	0	0	0	0	f	f
4064	453	7	5.50	0	0	0	0	0	0	f	f
4065	518	7	5.50	0	0	0	0	0	0	f	f
4066	26	7	6.00	0	0	0	0	0	0	t	f
4067	179	7	6.00	0	0	0	0	0	0	f	f
4068	91	7	6.50	0	0	0	0	0	0	f	f
4069	151	7	6.00	0	0	0	0	0	0	f	f
4070	203	7	6.00	0	0	0	0	0	0	f	f
4071	168	7	5.50	0	0	0	0	0	0	f	f
4072	77	7	7.00	0	0	0	0	0	0	f	f
4073	370	7	7.00	0	0	0	0	0	0	f	f
4074	288	7	6.50	0	0	0	0	0	0	f	f
4075	399	7	6.00	0	0	0	0	0	0	f	f
4076	358	7	6.00	0	0	0	0	0	0	f	f
4077	386	7	5.50	0	0	0	0	0	0	f	f
4078	496	7	6.00	0	0	0	0	0	0	f	f
4079	466	7	7.50	1	0	0	0	0	0	f	f
4080	488	7	5.50	0	0	0	0	0	0	f	f
4081	468	7	6.50	0	0	0	0	0	0	f	f
4082	19	7	6.00	0	1	0	0	0	0	f	f
4083	78	7	6.00	0	0	0	0	0	0	t	f
4084	128	7	6.50	0	0	0	0	0	1	f	f
4085	154	7	6.00	0	0	0	0	0	0	f	f
4086	180	7	6.00	0	0	0	0	0	0	f	f
4087	198	7	5.50	0	0	0	0	0	0	t	f
4088	101	7	5.00	0	0	0	0	0	0	f	f
4089	272	7	7.00	1	0	0	0	0	0	f	f
4090	321	7	6.00	0	0	0	0	0	0	f	f
4091	326	7	6.00	0	0	0	0	0	0	f	f
4092	282	7	6.50	0	0	0	0	0	0	f	f
4093	328	7	6.00	0	0	0	0	0	0	f	f
4094	437	7	6.00	0	0	0	0	0	0	f	f
4095	452	7	6.00	0	0	0	0	0	0	f	f
4096	525	7	6.00	0	0	0	0	0	0	f	f
4097	497	7	6.00	0	0	0	0	0	0	f	f
4098	12	7	6.00	0	0	0	0	0	0	f	f
4099	183	7	6.00	0	0	0	0	0	0	t	f
4100	181	7	6.50	0	0	0	0	0	0	t	f
4101	182	7	6.00	0	0	0	0	0	0	f	f
4102	169	7	6.50	0	0	0	0	0	0	f	f
4103	79	7	6.00	0	0	0	0	0	0	f	f
4104	225	7	5.50	0	0	0	0	0	0	f	f
4105	345	7	5.50	0	0	0	0	0	0	f	f
4106	413	7	6.00	0	0	0	0	0	0	f	f
4107	309	7	6.50	0	0	0	0	0	0	f	f
4108	327	7	6.00	0	0	0	0	0	0	f	f
4109	434	7	6.00	0	0	0	0	0	0	f	f
4110	521	7	6.00	0	0	0	0	0	0	f	f
4111	473	7	5.00	0	0	0	0	0	0	f	f
4112	503	7	6.00	0	0	0	0	0	0	f	f
4113	469	7	5.50	0	0	0	0	0	0	f	f
4114	46	7	\N	0	0	0	0	0	0	f	f
4115	35	7	\N	0	0	0	0	0	0	f	f
4116	11	7	\N	0	0	0	0	0	0	f	f
4117	37	7	\N	0	0	0	0	0	0	f	f
4118	24	7	\N	0	0	0	0	0	0	f	f
4119	29	7	\N	0	0	0	0	0	0	f	f
4120	51	7	\N	0	0	0	0	0	0	f	f
4121	36	7	\N	0	0	0	0	0	0	f	f
4122	54	7	\N	0	0	0	0	0	0	f	f
4123	47	7	\N	0	0	0	0	0	0	f	f
4124	21	7	\N	0	0	0	0	0	0	f	f
4125	27	7	\N	0	0	0	0	0	0	f	f
4126	40	7	\N	0	0	0	0	0	0	f	f
4127	74	7	\N	0	0	0	0	0	0	f	f
4128	42	7	\N	0	0	0	0	0	0	f	f
4129	52	7	\N	0	0	0	0	0	0	f	f
4130	33	7	\N	0	0	0	0	0	0	f	f
4131	93	7	\N	0	0	0	0	0	0	f	f
4132	61	7	\N	0	0	0	0	0	0	f	f
4133	56	7	\N	0	0	0	0	0	0	f	f
4134	58	7	\N	0	0	0	0	0	0	f	f
4135	62	7	\N	0	0	0	0	0	0	f	f
4136	65	7	\N	0	0	0	0	0	0	f	f
4137	30	7	\N	0	0	0	0	0	0	f	f
4138	45	7	\N	0	0	0	0	0	0	f	f
4139	205	7	\N	0	0	0	0	0	0	f	f
4140	172	7	\N	0	0	0	0	0	0	f	f
4141	116	7	\N	0	0	0	0	0	0	f	f
4142	144	7	\N	0	0	0	0	0	0	f	f
4143	149	7	\N	0	0	0	0	0	0	f	f
4144	122	7	\N	0	0	0	0	0	0	f	f
4145	204	7	\N	0	0	0	0	0	0	f	f
4146	140	7	\N	0	0	0	0	0	0	f	f
4147	197	7	\N	0	0	0	0	0	0	f	f
4148	138	7	\N	0	0	0	0	0	0	f	f
4149	141	7	\N	0	0	0	0	0	0	f	f
4150	202	7	\N	0	0	0	0	0	0	f	f
4151	207	7	\N	0	0	0	0	0	0	f	f
4152	208	7	\N	0	0	0	0	0	0	f	f
4153	121	7	\N	0	0	0	0	0	0	f	f
4154	174	7	\N	0	0	0	0	0	0	f	f
4155	162	7	\N	0	0	0	0	0	0	f	f
4156	170	7	\N	0	0	0	0	0	0	f	f
4157	155	7	\N	0	0	0	0	0	0	f	f
4158	137	7	\N	0	0	0	0	0	0	f	f
4159	218	7	\N	0	0	0	0	0	0	f	f
4160	220	7	\N	0	0	0	0	0	0	f	f
4161	238	7	\N	0	0	0	0	0	0	f	f
4162	235	7	\N	0	0	0	0	0	0	f	f
4163	310	7	\N	0	0	0	0	0	0	f	f
4164	232	7	\N	0	0	0	0	0	0	f	f
4165	248	7	\N	0	0	0	0	0	0	f	f
4166	241	7	\N	0	0	0	0	0	0	f	f
4167	255	7	\N	0	0	0	0	0	0	f	f
4168	221	7	\N	0	0	0	0	0	0	f	f
4169	230	7	\N	0	0	0	0	0	0	f	f
4170	244	7	\N	0	0	0	0	0	0	f	f
4171	308	7	\N	0	0	0	0	0	0	f	f
4172	273	7	\N	0	0	0	0	0	0	f	f
4173	210	7	\N	0	0	0	0	0	0	f	f
4174	240	7	\N	0	0	0	0	0	0	f	f
4175	265	7	\N	0	0	0	0	0	0	f	f
4176	250	7	\N	0	0	0	0	0	0	f	f
4177	223	7	\N	0	0	0	0	0	0	f	f
4178	214	7	\N	0	0	0	0	0	0	f	f
4179	298	7	\N	0	0	0	0	0	0	f	f
4180	287	7	\N	0	0	0	0	0	0	f	f
4181	312	7	\N	0	0	0	0	0	0	f	f
4182	228	7	\N	0	0	0	0	0	0	f	f
4183	222	7	\N	0	0	0	0	0	0	f	f
4184	253	7	\N	0	0	0	0	0	0	f	f
4185	254	7	\N	0	0	0	0	0	0	f	f
4186	233	7	\N	0	0	0	0	0	0	f	f
4187	402	7	\N	0	0	0	0	0	0	f	f
4188	375	7	\N	0	0	0	0	0	0	f	f
4189	405	7	\N	0	0	0	0	0	0	f	f
4190	367	7	\N	0	0	0	0	0	0	f	f
4191	337	7	\N	0	0	0	0	0	0	f	f
4192	390	7	\N	0	0	0	0	0	0	f	f
4193	320	7	\N	0	0	0	0	0	0	f	f
4194	406	7	\N	0	0	0	0	0	0	f	f
4195	414	7	\N	0	0	0	0	0	0	f	f
4196	378	7	\N	0	0	0	0	0	0	f	f
4197	380	7	\N	0	0	0	0	0	0	f	f
4198	323	7	\N	0	0	0	0	0	0	f	f
4199	412	7	\N	0	0	0	0	0	0	f	f
4200	347	7	\N	0	0	0	0	0	0	f	f
4201	356	7	\N	0	0	0	0	0	0	f	f
4202	371	7	\N	0	0	0	0	0	0	f	f
4203	397	7	\N	0	0	0	0	0	0	f	f
4204	400	7	\N	0	0	0	0	0	0	f	f
4205	357	7	\N	0	0	0	0	0	0	f	f
4206	369	7	\N	0	0	0	0	0	0	f	f
4207	339	7	\N	0	0	0	0	0	0	f	f
4208	396	7	\N	0	0	0	0	0	0	f	f
4209	416	7	\N	0	0	0	0	0	0	f	f
4210	391	7	\N	0	0	0	0	0	0	f	f
4211	409	7	\N	0	0	0	0	0	0	f	f
4212	411	7	\N	0	0	0	0	0	0	f	f
4213	237	7	\N	0	0	0	0	0	0	f	f
4214	431	7	\N	0	0	0	0	0	0	f	f
4215	429	7	\N	0	0	0	0	0	0	f	f
4216	433	7	\N	0	0	0	0	0	0	f	f
4217	522	7	\N	0	0	0	0	0	0	f	f
4218	502	7	\N	0	0	0	0	0	0	f	f
4219	517	7	\N	0	0	0	0	0	0	f	f
4220	450	7	\N	0	0	0	0	0	0	f	f
4221	479	7	\N	0	0	0	0	0	0	f	f
4222	455	7	\N	0	0	0	0	0	0	f	f
4223	514	7	\N	0	0	0	0	0	0	f	f
4224	492	7	\N	0	0	0	0	0	0	f	f
4225	485	7	\N	0	0	0	0	0	0	f	f
4226	428	7	\N	0	0	0	0	0	0	f	f
4227	438	7	\N	0	0	0	0	0	0	f	f
4228	441	7	\N	0	0	0	0	0	0	f	f
4229	425	7	\N	0	0	0	0	0	0	f	f
4230	477	7	\N	0	0	0	0	0	0	f	f
4231	420	7	\N	0	0	0	0	0	0	f	f
4232	427	7	\N	0	0	0	0	0	0	f	f
4233	489	7	\N	0	0	0	0	0	0	f	f
4234	504	7	\N	0	0	0	0	0	0	f	f
4235	435	7	\N	0	0	0	0	0	0	f	f
4236	219	7	\N	0	0	0	0	0	0	f	f
4237	530	7	\N	0	0	0	0	0	0	f	f
4238	540	7	\N	0	0	0	0	0	0	f	f
4239	43	7	\N	0	0	0	0	0	0	f	f
4240	44	7	\N	0	0	0	0	0	0	f	f
4241	236	7	\N	0	0	0	0	0	0	f	f
4242	217	7	\N	0	0	0	0	0	0	f	f
4243	417	7	\N	0	0	0	0	0	0	f	f
4244	363	7	\N	0	0	0	0	0	0	f	f
4245	55	7	\N	0	0	0	0	0	0	f	f
4246	206	7	\N	0	0	0	0	0	0	f	f
4247	247	7	\N	0	0	0	0	0	0	f	f
4248	421	7	\N	0	0	0	0	0	0	f	f
4249	422	7	\N	0	0	0	0	0	0	f	f
4250	246	7	\N	0	0	0	0	0	0	f	f
4251	303	7	\N	0	0	0	0	0	0	f	f
4252	538	7	\N	0	0	0	0	0	0	f	f
4253	48	7	\N	0	0	0	0	0	0	f	f
4254	177	7	\N	0	0	0	0	0	0	f	f
4255	258	7	\N	0	0	0	0	0	0	f	f
4256	388	7	\N	0	0	0	0	0	0	f	f
4257	302	7	\N	0	0	0	0	0	0	f	f
4258	260	7	\N	0	0	0	0	0	0	f	f
4259	34	7	\N	0	0	0	0	0	0	f	f
4260	436	7	\N	0	0	0	0	0	0	f	f
4261	498	7	\N	0	0	0	0	0	0	f	f
4262	534	7	\N	0	0	0	0	0	0	f	f
4263	542	7	\N	0	0	0	0	0	0	f	f
4264	543	7	\N	0	0	0	0	0	0	f	f
4265	528	7	\N	0	0	0	0	0	0	f	f
4266	49	7	\N	0	0	0	0	0	0	f	f
4267	201	7	\N	0	0	0	0	0	0	f	f
4268	239	7	\N	0	0	0	0	0	0	f	f
4269	476	7	\N	0	0	0	0	0	0	f	f
4270	60	7	\N	0	0	0	0	0	0	f	f
4271	57	7	\N	0	0	0	0	0	0	f	f
4272	153	7	\N	0	0	0	0	0	0	f	f
4273	131	7	\N	0	0	0	0	0	0	f	f
4274	423	7	\N	0	0	0	0	0	0	f	f
4275	524	7	\N	0	0	0	0	0	0	f	f
4276	39	7	\N	0	0	0	0	0	0	f	f
4277	192	7	\N	0	0	0	0	0	0	f	f
4278	59	7	\N	0	0	0	0	0	0	f	f
4279	440	7	\N	0	0	0	0	0	0	f	f
4280	398	7	\N	0	0	0	0	0	0	f	f
4281	442	7	\N	0	0	0	0	0	0	f	f
4282	25	7	\N	0	0	0	0	0	0	f	f
4283	87	7	\N	0	0	0	0	0	0	f	f
4284	109	7	\N	0	0	0	0	0	0	f	f
4285	234	7	\N	0	0	0	0	0	0	f	f
4286	410	7	\N	0	0	0	0	0	0	f	f
4287	535	7	\N	0	0	0	0	0	0	f	f
4288	322	7	\N	0	0	0	0	0	0	f	f
4289	53	7	\N	0	0	0	0	0	0	f	f
4290	251	7	\N	0	0	0	0	0	0	f	f
4291	167	7	\N	0	0	0	0	0	0	f	f
4292	32	7	\N	0	0	0	0	0	0	f	f
4293	94	7	\N	0	0	0	0	0	0	f	f
4294	364	7	\N	0	0	0	0	0	0	f	f
4295	276	7	\N	0	0	0	0	0	0	f	f
4296	454	7	\N	0	0	0	0	0	0	f	f
4297	9	7	\N	0	0	0	0	0	0	f	f
4298	374	7	\N	0	0	0	0	0	0	f	f
4299	537	7	\N	0	0	0	0	0	0	f	f
4300	123	7	\N	0	0	0	0	0	0	f	f
4301	336	7	\N	0	0	0	0	0	0	f	f
4302	38	7	\N	0	0	0	0	0	0	f	f
4303	256	7	\N	0	0	0	0	0	0	f	f
4304	213	7	\N	0	0	0	0	0	0	f	f
4305	415	7	\N	0	0	0	0	0	0	f	f
4306	22	7	\N	0	0	0	0	0	0	f	f
4307	249	7	\N	0	0	0	0	0	0	f	f
4308	407	7	\N	0	0	0	0	0	0	f	f
4309	387	7	\N	0	0	0	0	0	0	f	f
4310	439	7	\N	0	0	0	0	0	0	f	f
4311	152	7	\N	0	0	0	0	0	0	f	f
4312	539	7	\N	0	0	0	0	0	0	f	f
4313	252	7	\N	0	0	0	0	0	0	f	f
4314	408	7	\N	0	0	0	0	0	0	f	f
4315	424	7	\N	0	0	0	0	0	0	f	f
4316	41	7	\N	0	0	0	0	0	0	f	f
4317	259	7	\N	0	0	0	0	0	0	f	f
4318	163	7	\N	0	0	0	0	0	0	f	f
4319	350	7	\N	0	0	0	0	0	0	f	f
4320	445	7	\N	0	0	0	0	0	0	f	f
4321	257	7	\N	0	0	0	0	0	0	f	f
4322	401	7	\N	0	0	0	0	0	0	f	f
4323	432	7	\N	0	0	0	0	0	0	f	f
4324	64	7	\N	0	0	0	0	0	0	f	f
4325	212	7	\N	0	0	0	0	0	0	f	f
4326	160	7	\N	0	0	0	0	0	0	f	f
4327	395	7	\N	0	0	0	0	0	0	f	f
4328	526	7	\N	0	0	0	0	0	0	f	f
4329	533	7	\N	0	0	0	0	0	0	f	f
4330	511	7	\N	0	0	0	0	0	0	f	f
4331	23	7	\N	0	0	0	0	0	0	f	f
4332	50	7	\N	0	0	0	0	0	0	f	f
4333	443	7	\N	0	0	0	0	0	0	f	f
4334	372	7	\N	0	0	0	0	0	0	f	f
4335	31	7	\N	0	0	0	0	0	0	f	f
4336	166	7	\N	0	0	0	0	0	0	f	f
4337	243	7	\N	0	0	0	0	0	0	f	f
4338	242	7	\N	0	0	0	0	0	0	f	f
4339	536	7	\N	0	0	0	0	0	0	f	f
4340	63	7	\N	0	0	0	0	0	0	f	f
4341	231	7	\N	0	0	0	0	0	0	f	f
4342	331	7	\N	0	0	0	0	0	0	f	f
4343	499	7	\N	0	0	0	0	0	0	f	f
4344	506	7	\N	0	0	0	0	0	0	f	f
4345	5	8	6.50	0	1	0	0	0	0	f	f
4346	156	8	5.50	0	0	0	0	0	0	f	f
4347	94	8	5.50	0	0	0	0	0	0	f	f
4348	157	8	6.00	0	0	0	0	0	0	f	f
4349	338	8	6.00	0	0	0	0	0	0	f	f
4350	296	8	5.50	0	0	0	0	0	0	f	f
4351	339	8	7.00	1	0	0	0	0	0	f	f
4352	276	8	6.50	0	0	0	0	0	0	f	f
4353	312	8	6.00	0	0	0	0	0	0	f	f
4354	329	8	6.50	0	0	0	0	0	0	f	f
4355	454	8	6.00	0	0	0	0	0	0	t	f
4356	462	8	6.00	0	0	0	0	0	0	f	f
4357	482	8	6.00	0	0	0	0	0	0	f	f
4358	459	8	5.50	0	0	0	0	0	0	f	f
4359	465	8	5.00	0	0	0	0	0	0	f	f
4360	9	8	7.00	0	2	0	0	0	0	f	f
4361	85	8	6.50	0	0	0	0	0	0	f	f
4362	208	8	6.00	0	0	0	0	0	0	f	f
4363	73	8	6.00	0	0	0	0	0	1	f	t
4364	121	8	6.00	0	0	0	0	0	0	t	f
4365	103	8	6.00	0	0	0	0	0	0	f	f
4366	341	8	5.00	0	0	0	0	0	0	f	f
4367	340	8	6.00	0	0	0	0	0	0	t	f
4368	263	8	6.00	0	0	0	0	0	0	f	f
4369	311	8	5.50	0	0	0	0	0	0	f	f
4370	346	8	5.50	0	0	0	0	0	0	f	f
4371	374	8	6.00	0	0	0	0	0	0	f	f
4372	336	8	6.00	0	0	0	0	0	0	t	f
4373	458	8	7.00	1	0	0	0	0	0	f	f
4374	451	8	7.00	1	0	0	0	0	0	f	f
4375	489	8	6.00	0	0	0	0	0	0	f	f
4376	10	8	7.50	0	2	0	0	0	0	f	f
4377	133	8	5.00	0	0	0	0	0	0	f	f
4378	159	8	6.00	0	0	0	0	0	1	t	f
4379	69	8	5.50	0	0	0	0	0	0	f	f
4380	122	8	6.50	1	0	0	0	0	0	f	f
4381	229	8	5.00	0	0	0	0	0	0	f	f
4382	436	8	6.00	0	0	0	0	0	0	t	f
4383	304	8	5.50	0	0	0	0	0	0	f	f
4384	361	8	5.00	0	0	0	0	0	0	f	f
4385	330	8	5.50	0	0	0	0	0	0	f	f
4386	348	8	5.00	0	0	0	0	0	0	f	f
4387	289	8	7.00	1	0	0	0	0	0	f	f
4388	428	8	6.00	0	0	0	0	0	0	f	f
4389	534	8	6.50	0	0	0	0	0	0	t	f
4390	520	8	6.00	0	0	0	0	0	0	f	f
4391	478	8	6.00	0	0	0	0	0	0	t	f
4392	6	8	6.50	0	0	0	0	0	0	f	f
4393	119	8	6.50	0	0	0	0	0	0	t	f
4394	86	8	6.00	0	0	0	0	0	0	f	f
4395	171	8	6.00	0	0	0	0	0	0	f	f
4396	80	8	6.00	0	0	0	0	0	0	f	f
4397	189	8	5.50	0	0	0	0	0	0	f	f
4398	316	8	6.50	0	0	0	0	0	0	f	f
4399	317	8	6.00	0	0	0	0	0	0	f	f
4400	290	8	6.00	0	0	0	0	0	0	f	f
4401	261	8	5.50	0	0	0	0	0	0	f	f
4402	331	8	6.00	0	0	0	0	0	0	f	f
4403	512	8	5.50	0	0	0	0	0	0	f	f
4404	506	8	5.50	0	0	0	0	0	0	f	f
4405	463	8	6.00	0	0	0	0	0	0	f	f
4406	514	8	6.00	0	0	0	0	0	0	f	f
4407	28	8	6.50	0	1	0	0	0	0	f	f
4408	134	8	6.00	0	0	0	0	0	0	f	f
4409	75	8	7.00	0	0	0	0	0	0	f	f
4410	70	8	6.50	0	0	0	0	0	0	f	f
4411	106	8	7.00	0	0	0	0	0	0	f	f
4412	205	8	6.00	0	0	0	0	0	0	f	f
4413	172	8	6.00	0	0	0	0	0	0	f	f
4414	160	8	5.50	0	0	0	0	0	0	t	f
4415	277	8	6.00	0	0	0	0	0	0	t	f
4416	343	8	6.50	0	0	0	0	0	0	f	f
4417	325	8	6.50	0	0	0	0	0	0	f	f
4418	393	8	6.00	0	0	0	0	0	0	f	f
4419	283	8	6.50	0	0	0	0	0	0	f	f
4420	511	8	6.00	0	0	0	0	0	0	f	f
4421	457	8	7.00	1	0	0	0	0	0	t	f
4422	17	8	6.00	0	2	0	0	0	0	f	f
4423	107	8	5.00	0	0	0	0	0	0	t	f
4424	124	8	5.50	0	0	0	0	0	0	f	f
4425	190	8	5.50	0	0	0	0	0	0	f	f
4426	175	8	5.50	0	0	0	0	0	0	f	f
4427	161	8	6.00	0	0	0	0	0	0	f	f
4428	162	8	6.00	0	0	0	0	0	0	f	f
4429	274	8	5.50	0	0	0	0	0	0	f	f
4430	392	8	5.50	0	0	0	0	0	0	f	f
4431	376	8	5.50	0	0	0	0	0	0	f	f
4432	416	8	5.50	0	0	0	0	0	0	f	f
4433	297	8	6.50	0	0	0	0	0	0	t	f
4434	396	8	6.00	0	0	0	0	0	0	f	f
4435	515	8	5.50	0	0	0	0	0	0	t	f
4436	460	8	7.00	0	0	0	0	0	0	f	f
4437	505	8	6.00	0	0	0	0	0	0	f	f
4438	18	8	7.50	0	2	0	0	0	0	f	f
4439	215	8	5.50	0	0	0	0	1	0	f	f
4440	98	8	6.00	0	0	0	0	0	0	f	f
4441	92	8	6.00	0	0	0	0	0	0	f	f
4442	135	8	6.00	0	0	0	0	0	0	f	f
4443	298	8	7.00	1	0	0	0	0	0	f	f
4444	305	8	6.50	0	0	0	0	0	0	f	f
4445	426	8	5.00	0	0	0	0	0	0	f	f
4446	342	8	6.00	0	0	0	0	0	0	t	f
4447	318	8	5.50	0	0	0	0	0	0	f	f
4448	425	8	5.50	0	0	0	0	0	0	f	f
4449	349	8	5.50	0	0	0	0	0	0	f	f
4450	508	8	6.00	0	0	0	0	0	0	f	f
4451	500	8	5.50	0	0	0	0	0	0	f	f
4452	490	8	6.00	0	0	0	0	0	0	f	f
4453	507	8	6.00	0	0	0	0	0	0	t	f
4454	13	8	6.00	0	3	0	0	0	0	f	f
4455	66	8	6.00	0	0	0	0	0	0	f	f
4456	136	8	5.00	0	0	0	0	0	0	f	f
4457	67	8	6.00	0	0	0	0	0	0	t	f
4458	104	8	5.00	0	0	0	0	0	0	f	f
4459	82	8	5.50	0	0	0	0	0	0	f	f
4460	300	8	5.50	0	0	0	0	0	0	f	f
4461	270	8	6.00	0	0	0	0	0	0	f	f
4462	262	8	7.00	0	0	0	0	0	0	f	f
4463	351	8	5.50	0	0	0	0	0	0	f	f
4464	352	8	6.00	0	0	0	0	0	0	f	f
4465	350	8	5.50	0	0	0	0	0	0	f	f
4466	299	8	6.00	0	0	0	0	0	0	f	f
4467	444	8	5.00	0	0	0	0	0	0	f	f
4468	474	8	5.50	0	0	0	0	0	0	f	f
4469	475	8	5.50	0	0	0	0	0	0	f	f
4470	25	8	6.00	0	1	0	0	0	0	f	f
4471	88	8	6.00	0	0	0	0	0	0	f	f
4472	99	8	6.00	0	0	0	0	0	0	f	f
4473	138	8	5.50	0	0	0	0	0	0	f	f
4474	108	8	5.50	0	0	0	0	0	0	t	f
4475	194	8	6.00	0	0	0	0	0	0	f	f
4476	307	8	6.00	0	0	0	0	0	0	t	f
4477	306	8	5.50	0	0	0	0	0	0	f	f
4478	332	8	5.50	0	0	0	0	0	0	t	f
4479	291	8	5.50	0	0	0	0	0	0	f	f
4480	353	8	6.00	0	0	0	0	0	0	t	f
4481	278	8	6.00	0	0	0	0	0	0	f	f
4482	461	8	5.50	0	0	0	0	0	0	f	f
4483	480	8	5.00	0	0	0	0	0	0	f	f
4484	477	8	6.00	0	0	0	0	0	0	f	f
4485	446	8	6.00	0	0	0	0	0	0	f	f
4486	3	8	6.00	0	0	0	0	0	0	f	f
4487	126	8	6.50	0	0	0	0	0	0	f	f
4488	110	8	5.50	0	0	0	0	0	0	f	f
4489	195	8	6.00	0	0	0	0	0	0	t	f
4490	144	8	6.00	0	0	0	0	0	0	f	f
4491	125	8	6.50	0	0	0	0	0	0	f	f
4492	362	8	5.50	0	0	0	0	0	0	f	f
4493	301	8	6.50	0	0	0	0	0	1	f	f
4494	267	8	6.00	0	0	0	0	0	0	f	f
4495	292	8	6.50	0	0	0	0	0	0	t	f
4496	284	8	7.00	1	0	0	0	0	0	f	f
4497	285	8	7.00	0	0	0	0	0	0	f	f
4498	516	8	6.00	0	0	0	0	0	0	f	f
4499	494	8	6.00	0	0	0	0	0	0	f	f
4500	492	8	6.00	0	0	0	0	0	0	f	f
4501	8	8	6.00	0	3	0	0	0	0	f	f
4502	127	8	5.50	0	0	0	0	0	0	f	f
4503	164	8	5.00	0	0	0	0	0	0	t	f
4504	89	8	5.50	0	0	0	0	0	0	f	f
4505	146	8	5.00	0	0	0	0	0	0	f	f
4506	402	8	6.00	0	0	0	0	0	0	f	f
4507	419	8	5.00	0	0	0	0	0	0	f	f
4508	286	8	6.50	1	0	0	0	0	0	f	f
4509	354	8	6.00	0	0	0	0	0	0	f	f
4510	333	8	6.50	0	0	0	0	0	0	f	f
4511	381	8	5.50	0	0	0	0	0	0	f	f
4512	412	8	6.00	0	0	0	0	0	1	f	f
4513	501	8	6.00	0	0	0	0	0	0	f	f
4514	509	8	6.00	0	0	0	0	0	0	f	f
4515	495	8	6.50	1	0	0	0	0	0	f	f
4516	513	8	5.50	0	0	0	0	0	0	t	f
4517	1	8	5.50	0	2	0	0	0	0	f	f
4518	111	8	5.50	0	0	0	0	0	0	f	f
4519	68	8	6.00	0	0	0	0	0	0	f	f
4520	193	8	5.00	0	0	0	0	0	0	f	f
4521	90	8	6.00	0	0	0	0	0	0	f	f
4522	184	8	6.00	1	0	0	0	0	0	t	f
4523	268	8	6.50	0	0	0	0	0	1	f	f
4524	313	8	6.00	0	0	0	0	0	0	f	f
4525	271	8	6.00	0	0	0	0	0	0	f	f
4526	294	8	6.00	0	0	0	0	0	0	f	f
4527	447	8	7.00	1	0	0	0	0	0	f	f
4528	485	8	5.50	0	0	0	0	0	0	f	f
4529	486	8	5.50	0	0	0	0	0	0	f	f
4530	4	8	6.50	0	1	0	0	0	0	f	f
4531	196	8	6.50	0	0	0	0	0	0	f	f
4532	71	8	6.50	0	0	0	0	0	1	f	f
4533	83	8	5.50	0	0	0	0	0	0	f	f
4534	113	8	6.50	0	0	0	0	0	0	t	f
4535	201	8	6.00	0	0	0	0	0	0	f	f
4536	178	8	5.50	0	0	0	0	0	0	f	f
4537	112	8	6.00	0	0	0	0	0	0	f	f
4538	319	8	6.00	0	0	0	0	0	0	f	f
4539	264	8	7.00	0	0	0	0	0	0	f	f
4540	266	8	7.50	1	0	0	0	0	0	f	f
4541	360	8	6.00	0	0	0	0	0	0	f	f
4542	265	8	7.00	1	0	0	0	0	0	f	f
4543	334	8	5.50	0	0	0	0	0	0	t	f
4544	279	8	6.50	0	0	0	0	0	1	f	f
4545	483	8	6.00	0	0	0	0	0	0	f	f
4546	16	8	6.00	0	0	0	0	0	0	f	f
4547	147	8	6.50	0	0	0	0	0	0	f	f
4548	114	8	6.50	0	0	0	0	0	0	f	f
4549	115	8	6.00	0	0	0	0	0	0	f	f
4550	143	8	6.00	0	0	0	0	0	0	f	f
4551	405	8	6.00	0	0	0	0	0	0	f	f
4552	403	8	6.00	0	0	0	0	0	0	f	f
4553	280	8	6.50	0	0	0	0	0	0	f	f
4554	365	8	6.00	0	0	0	0	0	0	f	f
4555	404	8	5.50	0	0	0	0	0	0	f	f
4556	359	8	6.00	0	0	0	0	0	0	f	f
4557	493	8	6.00	0	0	0	0	0	0	f	f
4558	531	8	6.00	0	0	0	0	0	0	f	f
4559	502	8	6.00	0	0	0	0	0	0	f	f
4560	456	8	6.00	0	0	0	0	0	0	f	f
4561	14	8	6.00	0	2	0	0	0	0	f	f
4562	185	8	6.00	0	0	0	0	0	0	f	f
4563	102	8	7.00	0	0	0	0	0	0	f	f
4564	148	8	6.00	0	0	0	0	0	0	f	f
4565	166	8	6.00	0	0	0	0	0	0	f	f
4566	186	8	5.50	0	0	0	0	0	0	f	f
4567	165	8	6.00	0	0	0	0	0	0	f	f
4568	368	8	5.00	0	0	0	0	0	0	f	f
4569	373	8	6.00	0	0	0	0	0	0	t	f
4570	324	8	6.50	0	0	0	0	0	1	f	f
4571	320	8	6.00	0	0	0	0	0	0	f	f
4572	406	8	6.00	0	0	0	0	0	0	t	f
4573	472	8	7.00	1	0	0	0	0	0	t	f
4574	487	8	6.00	0	0	0	0	0	0	f	f
4575	517	8	5.50	0	0	0	0	0	0	f	f
4576	2	8	6.50	0	0	0	0	0	0	f	f
4577	100	8	6.50	0	0	0	0	0	0	t	f
4578	130	8	6.00	0	0	0	0	0	0	f	f
4579	76	8	6.50	0	0	0	0	0	0	f	f
4580	84	8	6.00	0	0	0	0	0	0	t	f
4581	202	8	6.00	0	0	0	0	0	0	f	f
4582	167	8	6.00	0	0	0	0	0	0	f	f
4583	72	8	6.00	0	0	0	0	0	0	f	f
4584	275	8	6.50	0	0	0	0	0	0	f	f
4585	295	8	6.50	0	0	0	0	0	0	f	f
4586	335	8	6.00	0	0	0	0	0	0	f	f
4587	281	8	6.50	0	0	0	0	0	0	f	f
4588	357	8	6.00	0	0	0	0	0	0	f	f
4589	481	8	7.00	1	0	0	0	0	0	f	f
4590	448	8	6.00	0	0	0	0	0	0	f	f
4591	471	8	6.50	0	0	0	0	0	0	f	f
4592	15	8	6.50	0	1	0	0	0	0	f	f
4593	245	8	5.50	0	0	0	0	0	0	f	f
4594	142	8	5.50	0	0	0	0	0	0	f	f
4595	150	8	6.00	0	0	0	0	0	0	t	f
4596	118	8	5.50	0	0	0	0	0	0	f	f
4597	199	8	5.50	0	0	0	0	0	0	f	f
4598	315	8	5.50	0	0	0	0	0	0	f	f
4599	389	8	6.00	0	0	0	0	0	0	f	f
4600	303	8	5.50	0	0	0	0	0	0	t	f
4601	314	8	5.00	0	0	0	0	0	0	t	f
4602	287	8	5.50	0	0	0	0	0	0	f	f
4603	308	8	6.00	0	0	0	0	0	0	f	f
4604	449	8	5.50	0	0	0	0	0	0	f	f
4605	467	8	5.00	0	0	0	0	0	0	f	f
4606	453	8	6.00	0	0	0	0	0	0	f	f
4607	518	8	6.00	0	0	0	0	0	0	f	f
4608	22	8	7.00	0	1	0	0	0	0	f	f
4609	179	8	5.50	0	0	0	0	0	0	f	f
4610	152	8	6.50	0	0	0	0	0	1	f	f
4611	91	8	7.00	1	0	0	0	0	0	f	f
4612	151	8	6.00	0	0	0	0	0	0	f	f
4613	168	8	6.00	0	0	0	0	0	0	f	f
4614	77	8	6.00	0	0	0	0	0	0	f	f
4615	370	8	6.00	0	0	0	0	0	0	f	f
4616	288	8	5.50	0	0	0	0	0	0	t	f
4617	399	8	5.00	0	0	0	0	0	0	f	f
4618	358	8	5.50	0	0	0	0	0	0	t	f
4619	386	8	6.00	0	0	0	0	0	0	f	f
4620	496	8	6.00	0	0	0	0	0	0	f	f
4621	466	8	5.50	0	0	0	0	0	0	f	f
4622	488	8	6.50	0	0	0	0	0	0	f	f
4623	468	8	5.50	0	0	0	0	0	0	f	f
4624	19	8	5.00	0	2	0	0	0	0	f	f
4625	78	8	6.00	0	0	0	0	0	0	f	f
4626	128	8	6.00	0	0	0	0	0	0	f	f
4627	154	8	5.50	0	0	0	0	0	0	f	f
4628	153	8	6.50	0	0	0	0	0	0	f	f
4629	180	8	6.00	0	0	0	0	0	0	f	f
4630	198	8	6.50	0	0	0	0	0	0	f	f
4631	101	8	6.00	0	0	0	0	0	0	f	f
4632	272	8	6.50	0	0	0	0	0	0	f	f
4633	321	8	7.00	1	0	0	0	0	0	f	f
4634	326	8	5.50	0	0	0	0	0	0	f	f
4635	282	8	7.50	0	0	0	0	0	2	f	f
4636	328	8	6.50	0	0	0	0	0	0	f	f
4637	452	8	7.00	1	0	0	0	0	0	t	f
4638	525	8	6.50	0	0	0	0	0	1	f	f
4639	497	8	7.00	1	0	0	0	0	0	t	f
4640	12	8	6.00	0	2	0	0	0	0	f	f
4641	155	8	6.00	0	0	0	0	0	0	f	f
4642	181	8	6.00	0	0	0	0	0	0	f	f
4643	182	8	6.50	0	0	0	0	0	0	f	f
4644	169	8	5.50	0	0	0	0	0	0	t	f
4645	79	8	6.50	0	0	0	0	0	0	f	f
4646	225	8	4.50	0	0	0	0	0	0	f	f
4647	170	8	6.00	0	0	0	0	0	0	f	f
4648	345	8	7.00	1	0	0	0	0	0	t	f
4649	413	8	6.00	0	0	0	0	0	0	t	f
4650	409	8	6.00	0	0	0	0	0	0	f	f
4651	309	8	6.00	0	0	0	0	0	0	f	f
4652	327	8	6.50	0	0	0	0	0	0	f	f
4653	521	8	6.00	0	0	0	0	0	0	f	f
4654	473	8	6.50	1	0	0	0	0	0	f	f
4655	469	8	7.00	0	0	0	0	0	2	f	f
4656	46	8	\N	0	0	0	0	0	0	f	f
4657	35	8	\N	0	0	0	0	0	0	f	f
4658	11	8	\N	0	0	0	0	0	0	f	f
4659	37	8	\N	0	0	0	0	0	0	f	f
4660	24	8	\N	0	0	0	0	0	0	f	f
4661	29	8	\N	0	0	0	0	0	0	f	f
4662	51	8	\N	0	0	0	0	0	0	f	f
4663	36	8	\N	0	0	0	0	0	0	f	f
4664	105	8	\N	0	0	0	0	0	0	f	f
4665	54	8	\N	0	0	0	0	0	0	f	f
4666	47	8	\N	0	0	0	0	0	0	f	f
4667	96	8	\N	0	0	0	0	0	0	f	f
4668	21	8	\N	0	0	0	0	0	0	f	f
4669	27	8	\N	0	0	0	0	0	0	f	f
4670	40	8	\N	0	0	0	0	0	0	f	f
4671	74	8	\N	0	0	0	0	0	0	f	f
4672	7	8	\N	0	0	0	0	0	0	f	f
4673	42	8	\N	0	0	0	0	0	0	f	f
4674	52	8	\N	0	0	0	0	0	0	f	f
4675	33	8	\N	0	0	0	0	0	0	f	f
4676	93	8	\N	0	0	0	0	0	0	f	f
4677	20	8	\N	0	0	0	0	0	0	f	f
4678	61	8	\N	0	0	0	0	0	0	f	f
4679	26	8	\N	0	0	0	0	0	0	f	f
4680	56	8	\N	0	0	0	0	0	0	f	f
4681	58	8	\N	0	0	0	0	0	0	f	f
4682	62	8	\N	0	0	0	0	0	0	f	f
4683	65	8	\N	0	0	0	0	0	0	f	f
4684	30	8	\N	0	0	0	0	0	0	f	f
4685	81	8	\N	0	0	0	0	0	0	f	f
4686	45	8	\N	0	0	0	0	0	0	f	f
4687	116	8	\N	0	0	0	0	0	0	f	f
4688	129	8	\N	0	0	0	0	0	0	f	f
4689	173	8	\N	0	0	0	0	0	0	f	f
4690	176	8	\N	0	0	0	0	0	0	f	f
4691	145	8	\N	0	0	0	0	0	0	f	f
4692	149	8	\N	0	0	0	0	0	0	f	f
4693	204	8	\N	0	0	0	0	0	0	f	f
4694	140	8	\N	0	0	0	0	0	0	f	f
4695	197	8	\N	0	0	0	0	0	0	f	f
4696	141	8	\N	0	0	0	0	0	0	f	f
4697	207	8	\N	0	0	0	0	0	0	f	f
4698	120	8	\N	0	0	0	0	0	0	f	f
4699	187	8	\N	0	0	0	0	0	0	f	f
4700	174	8	\N	0	0	0	0	0	0	f	f
4701	191	8	\N	0	0	0	0	0	0	f	f
4702	137	8	\N	0	0	0	0	0	0	f	f
4703	218	8	\N	0	0	0	0	0	0	f	f
4704	220	8	\N	0	0	0	0	0	0	f	f
4705	224	8	\N	0	0	0	0	0	0	f	f
4706	227	8	\N	0	0	0	0	0	0	f	f
4707	238	8	\N	0	0	0	0	0	0	f	f
4708	235	8	\N	0	0	0	0	0	0	f	f
4709	310	8	\N	0	0	0	0	0	0	f	f
4710	232	8	\N	0	0	0	0	0	0	f	f
4711	226	8	\N	0	0	0	0	0	0	f	f
4712	248	8	\N	0	0	0	0	0	0	f	f
4713	241	8	\N	0	0	0	0	0	0	f	f
4714	255	8	\N	0	0	0	0	0	0	f	f
4715	221	8	\N	0	0	0	0	0	0	f	f
4716	230	8	\N	0	0	0	0	0	0	f	f
4717	211	8	\N	0	0	0	0	0	0	f	f
4718	244	8	\N	0	0	0	0	0	0	f	f
4719	273	8	\N	0	0	0	0	0	0	f	f
4720	210	8	\N	0	0	0	0	0	0	f	f
4721	240	8	\N	0	0	0	0	0	0	f	f
4722	250	8	\N	0	0	0	0	0	0	f	f
4723	223	8	\N	0	0	0	0	0	0	f	f
4724	214	8	\N	0	0	0	0	0	0	f	f
4725	216	8	\N	0	0	0	0	0	0	f	f
4726	269	8	\N	0	0	0	0	0	0	f	f
4727	228	8	\N	0	0	0	0	0	0	f	f
4728	222	8	\N	0	0	0	0	0	0	f	f
4729	253	8	\N	0	0	0	0	0	0	f	f
4730	254	8	\N	0	0	0	0	0	0	f	f
4731	233	8	\N	0	0	0	0	0	0	f	f
4732	418	8	\N	0	0	0	0	0	0	f	f
4733	355	8	\N	0	0	0	0	0	0	f	f
4734	375	8	\N	0	0	0	0	0	0	f	f
4735	367	8	\N	0	0	0	0	0	0	f	f
4736	337	8	\N	0	0	0	0	0	0	f	f
4737	390	8	\N	0	0	0	0	0	0	f	f
4738	382	8	\N	0	0	0	0	0	0	f	f
4739	414	8	\N	0	0	0	0	0	0	f	f
4740	378	8	\N	0	0	0	0	0	0	f	f
4741	380	8	\N	0	0	0	0	0	0	f	f
4742	385	8	\N	0	0	0	0	0	0	f	f
4743	323	8	\N	0	0	0	0	0	0	f	f
4744	347	8	\N	0	0	0	0	0	0	f	f
4745	356	8	\N	0	0	0	0	0	0	f	f
4746	371	8	\N	0	0	0	0	0	0	f	f
4747	379	8	\N	0	0	0	0	0	0	f	f
4748	397	8	\N	0	0	0	0	0	0	f	f
4749	400	8	\N	0	0	0	0	0	0	f	f
4750	384	8	\N	0	0	0	0	0	0	f	f
4751	369	8	\N	0	0	0	0	0	0	f	f
4752	394	8	\N	0	0	0	0	0	0	f	f
4753	366	8	\N	0	0	0	0	0	0	f	f
4754	391	8	\N	0	0	0	0	0	0	f	f
4755	411	8	\N	0	0	0	0	0	0	f	f
4756	237	8	\N	0	0	0	0	0	0	f	f
4757	431	8	\N	0	0	0	0	0	0	f	f
4758	429	8	\N	0	0	0	0	0	0	f	f
4759	433	8	\N	0	0	0	0	0	0	f	f
4760	522	8	\N	0	0	0	0	0	0	f	f
4761	523	8	\N	0	0	0	0	0	0	f	f
4762	450	8	\N	0	0	0	0	0	0	f	f
4763	479	8	\N	0	0	0	0	0	0	f	f
4764	455	8	\N	0	0	0	0	0	0	f	f
4765	438	8	\N	0	0	0	0	0	0	f	f
4766	441	8	\N	0	0	0	0	0	0	f	f
4767	510	8	\N	0	0	0	0	0	0	f	f
4768	437	8	\N	0	0	0	0	0	0	f	f
4769	430	8	\N	0	0	0	0	0	0	f	f
4770	420	8	\N	0	0	0	0	0	0	f	f
4771	427	8	\N	0	0	0	0	0	0	f	f
4772	484	8	\N	0	0	0	0	0	0	f	f
4773	504	8	\N	0	0	0	0	0	0	f	f
4774	434	8	\N	0	0	0	0	0	0	f	f
4775	435	8	\N	0	0	0	0	0	0	f	f
4776	529	8	\N	0	0	0	0	0	0	f	f
4777	219	8	\N	0	0	0	0	0	0	f	f
4778	530	8	\N	0	0	0	0	0	0	f	f
4779	540	8	\N	0	0	0	0	0	0	f	f
4780	541	8	\N	0	0	0	0	0	0	f	f
4781	43	8	\N	0	0	0	0	0	0	f	f
4782	44	8	\N	0	0	0	0	0	0	f	f
4783	236	8	\N	0	0	0	0	0	0	f	f
4784	217	8	\N	0	0	0	0	0	0	f	f
4785	417	8	\N	0	0	0	0	0	0	f	f
4786	363	8	\N	0	0	0	0	0	0	f	f
4787	491	8	\N	0	0	0	0	0	0	f	f
4788	55	8	\N	0	0	0	0	0	0	f	f
4789	206	8	\N	0	0	0	0	0	0	f	f
4790	247	8	\N	0	0	0	0	0	0	f	f
4791	421	8	\N	0	0	0	0	0	0	f	f
4792	422	8	\N	0	0	0	0	0	0	f	f
4793	246	8	\N	0	0	0	0	0	0	f	f
4794	527	8	\N	0	0	0	0	0	0	f	f
4795	538	8	\N	0	0	0	0	0	0	f	f
4796	48	8	\N	0	0	0	0	0	0	f	f
4797	177	8	\N	0	0	0	0	0	0	f	f
4798	258	8	\N	0	0	0	0	0	0	f	f
4799	139	8	\N	0	0	0	0	0	0	f	f
4800	388	8	\N	0	0	0	0	0	0	f	f
4801	302	8	\N	0	0	0	0	0	0	f	f
4802	260	8	\N	0	0	0	0	0	0	f	f
4803	34	8	\N	0	0	0	0	0	0	f	f
4804	97	8	\N	0	0	0	0	0	0	f	f
4805	498	8	\N	0	0	0	0	0	0	f	f
4806	532	8	\N	0	0	0	0	0	0	f	f
4807	542	8	\N	0	0	0	0	0	0	f	f
4808	543	8	\N	0	0	0	0	0	0	f	f
4809	528	8	\N	0	0	0	0	0	0	f	f
4810	470	8	\N	0	0	0	0	0	0	f	f
4811	49	8	\N	0	0	0	0	0	0	f	f
4812	239	8	\N	0	0	0	0	0	0	f	f
4813	476	8	\N	0	0	0	0	0	0	f	f
4814	60	8	\N	0	0	0	0	0	0	f	f
4815	57	8	\N	0	0	0	0	0	0	f	f
4816	131	8	\N	0	0	0	0	0	0	f	f
4817	423	8	\N	0	0	0	0	0	0	f	f
4818	524	8	\N	0	0	0	0	0	0	f	f
4819	39	8	\N	0	0	0	0	0	0	f	f
4820	192	8	\N	0	0	0	0	0	0	f	f
4821	59	8	\N	0	0	0	0	0	0	f	f
4822	440	8	\N	0	0	0	0	0	0	f	f
4823	398	8	\N	0	0	0	0	0	0	f	f
4824	442	8	\N	0	0	0	0	0	0	f	f
4825	87	8	\N	0	0	0	0	0	0	f	f
4826	109	8	\N	0	0	0	0	0	0	f	f
4827	234	8	\N	0	0	0	0	0	0	f	f
4828	410	8	\N	0	0	0	0	0	0	f	f
4829	535	8	\N	0	0	0	0	0	0	f	f
4830	322	8	\N	0	0	0	0	0	0	f	f
4831	53	8	\N	0	0	0	0	0	0	f	f
4832	251	8	\N	0	0	0	0	0	0	f	f
4833	32	8	\N	0	0	0	0	0	0	f	f
4834	158	8	\N	0	0	0	0	0	0	f	f
4835	132	8	\N	0	0	0	0	0	0	f	f
4836	200	8	\N	0	0	0	0	0	0	f	f
4837	364	8	\N	0	0	0	0	0	0	f	f
4838	209	8	\N	0	0	0	0	0	0	f	f
4839	537	8	\N	0	0	0	0	0	0	f	f
4840	123	8	\N	0	0	0	0	0	0	f	f
4841	519	8	\N	0	0	0	0	0	0	f	f
4842	38	8	\N	0	0	0	0	0	0	f	f
4843	256	8	\N	0	0	0	0	0	0	f	f
4844	213	8	\N	0	0	0	0	0	0	f	f
4845	377	8	\N	0	0	0	0	0	0	f	f
4846	415	8	\N	0	0	0	0	0	0	f	f
4847	249	8	\N	0	0	0	0	0	0	f	f
4848	203	8	\N	0	0	0	0	0	0	f	f
4849	407	8	\N	0	0	0	0	0	0	f	f
4850	387	8	\N	0	0	0	0	0	0	f	f
4851	439	8	\N	0	0	0	0	0	0	f	f
4852	539	8	\N	0	0	0	0	0	0	f	f
4853	183	8	\N	0	0	0	0	0	0	f	f
4854	252	8	\N	0	0	0	0	0	0	f	f
4855	408	8	\N	0	0	0	0	0	0	f	f
4856	424	8	\N	0	0	0	0	0	0	f	f
4857	503	8	\N	0	0	0	0	0	0	f	f
4858	41	8	\N	0	0	0	0	0	0	f	f
4859	259	8	\N	0	0	0	0	0	0	f	f
4860	163	8	\N	0	0	0	0	0	0	f	f
4861	445	8	\N	0	0	0	0	0	0	f	f
4862	257	8	\N	0	0	0	0	0	0	f	f
4863	293	8	\N	0	0	0	0	0	0	f	f
4864	401	8	\N	0	0	0	0	0	0	f	f
4865	432	8	\N	0	0	0	0	0	0	f	f
4866	64	8	\N	0	0	0	0	0	0	f	f
4867	188	8	\N	0	0	0	0	0	0	f	f
4868	212	8	\N	0	0	0	0	0	0	f	f
4869	395	8	\N	0	0	0	0	0	0	f	f
4870	464	8	\N	0	0	0	0	0	0	f	f
4871	526	8	\N	0	0	0	0	0	0	f	f
4872	533	8	\N	0	0	0	0	0	0	f	f
4873	23	8	\N	0	0	0	0	0	0	f	f
4874	50	8	\N	0	0	0	0	0	0	f	f
4875	443	8	\N	0	0	0	0	0	0	f	f
4876	372	8	\N	0	0	0	0	0	0	f	f
4877	31	8	\N	0	0	0	0	0	0	f	f
4878	243	8	\N	0	0	0	0	0	0	f	f
4879	242	8	\N	0	0	0	0	0	0	f	f
4880	383	8	\N	0	0	0	0	0	0	f	f
4881	536	8	\N	0	0	0	0	0	0	f	f
4882	344	8	\N	0	0	0	0	0	0	f	f
4883	63	8	\N	0	0	0	0	0	0	f	f
4884	231	8	\N	0	0	0	0	0	0	f	f
4885	95	8	\N	0	0	0	0	0	0	f	f
4886	117	8	\N	0	0	0	0	0	0	f	f
4887	499	8	\N	0	0	0	0	0	0	f	f
4888	5	9	6.00	0	1	0	0	0	0	f	f
4889	120	9	6.50	0	0	0	0	0	0	f	f
4890	156	9	6.00	0	0	0	0	0	0	f	f
4891	94	9	6.00	0	0	0	0	0	0	f	f
4892	93	9	6.00	0	0	0	0	0	0	f	f
4893	157	9	6.00	0	0	0	0	0	0	f	f
4894	158	9	5.50	0	0	0	0	0	0	f	f
4895	200	9	6.50	0	0	0	0	0	0	f	f
4896	338	9	6.00	0	0	0	0	0	0	f	f
4897	296	9	7.00	0	0	0	0	0	1	f	f
4898	339	9	6.00	0	0	0	0	0	0	t	f
4899	276	9	6.00	0	0	0	0	0	0	f	f
4900	364	9	6.00	0	0	0	0	0	0	f	f
4901	329	9	6.00	0	0	0	0	0	0	f	f
4902	462	9	7.00	1	0	0	0	0	0	f	f
4903	459	9	6.00	0	0	0	0	0	0	f	f
4904	9	9	6.00	0	0	0	0	0	0	f	f
4905	209	9	6.50	0	0	0	0	0	0	t	f
4906	123	9	6.00	0	0	0	0	0	0	f	f
4907	121	9	6.50	0	0	0	0	0	0	f	f
4908	187	9	5.50	0	0	0	0	0	0	f	f
4909	341	9	6.00	0	0	0	0	0	0	f	f
4910	340	9	6.00	0	0	0	0	0	0	f	f
4911	263	9	5.50	0	0	0	0	0	0	f	f
4912	269	9	5.50	0	0	0	0	0	0	t	f
4913	346	9	6.00	0	0	0	0	0	0	f	f
4914	323	9	6.00	0	0	0	0	0	0	f	f
4915	374	9	6.00	0	0	0	0	0	0	f	f
4916	458	9	5.50	0	0	0	0	0	0	f	f
4917	451	9	5.50	0	0	0	0	0	0	f	f
4918	489	9	5.50	0	0	0	0	0	0	f	f
4919	519	9	5.50	0	0	0	0	0	0	f	f
4920	10	9	6.00	0	2	0	0	0	0	t	f
4921	133	9	6.50	0	0	0	0	0	0	f	f
4922	159	9	5.00	0	0	0	0	0	0	t	f
4923	69	9	6.50	0	0	0	0	0	0	f	f
4924	122	9	5.50	0	0	0	0	0	0	t	f
4925	229	9	5.50	0	0	0	0	0	0	f	f
4926	436	9	6.00	0	0	0	0	0	0	f	f
4927	304	9	6.00	0	0	0	0	0	0	f	f
4928	361	9	6.00	0	0	0	0	0	0	f	f
4929	330	9	5.50	0	0	0	0	0	0	t	f
4930	348	9	6.00	0	0	0	0	0	0	f	f
4931	289	9	6.50	0	0	0	0	0	1	f	f
4932	534	9	6.00	0	0	0	0	0	0	f	f
4933	470	9	7.00	1	0	0	0	0	0	f	f
4934	520	9	6.00	0	0	0	0	0	0	f	f
4935	478	9	5.50	0	0	0	0	0	0	f	f
4936	6	9	5.50	0	1	0	0	0	0	f	f
4937	119	9	6.50	0	0	0	0	0	0	f	f
4938	86	9	7.00	1	0	0	0	0	0	f	f
4939	95	9	7.00	1	0	0	0	0	0	f	f
4940	105	9	6.50	0	0	0	0	0	1	f	f
4941	117	9	6.50	0	0	0	0	0	0	f	f
4942	80	9	6.00	0	0	0	0	0	0	f	f
4943	189	9	6.00	0	0	0	0	0	0	f	f
4944	316	9	6.00	0	0	0	0	0	1	f	f
4945	317	9	6.50	0	0	0	0	0	0	f	f
4946	261	9	6.00	0	0	0	0	0	0	t	f
4947	512	9	6.00	0	0	0	0	0	0	f	f
4948	506	9	5.50	0	0	0	0	0	0	f	f
4949	463	9	7.00	1	0	0	0	0	0	f	f
4950	514	9	5.50	0	0	0	0	0	0	f	f
4951	499	9	6.50	0	0	0	0	0	1	f	f
4952	11	9	6.50	0	0	0	0	0	0	f	f
4953	134	9	7.00	0	0	0	0	0	0	f	f
4954	75	9	6.50	0	0	0	0	0	0	f	f
4955	70	9	6.50	0	0	0	0	0	0	f	f
4956	106	9	6.50	0	0	0	0	0	0	t	f
4957	205	9	6.00	0	0	0	0	0	0	f	f
4958	172	9	6.00	0	0	0	0	0	0	f	f
4959	160	9	6.00	0	0	0	0	0	0	f	f
4960	277	9	6.00	0	0	0	0	0	0	f	f
4961	355	9	6.50	0	0	0	0	0	0	f	f
4962	325	9	6.00	0	0	0	0	0	0	f	f
4963	393	9	6.00	0	0	0	0	0	0	f	f
4964	283	9	7.00	0	0	0	0	0	1	f	f
4965	464	9	8.00	2	0	0	0	0	0	f	f
4966	457	9	6.00	0	0	0	0	0	0	f	f
4967	17	9	7.50	0	3	0	0	0	0	f	f
4968	107	9	6.00	0	0	0	0	0	0	f	f
4969	190	9	5.50	0	0	0	0	0	0	f	f
4970	213	9	5.00	0	0	0	0	0	0	f	t
4971	161	9	5.50	0	0	0	0	0	0	f	f
4972	174	9	5.00	0	0	0	0	0	0	f	f
4973	162	9	6.00	0	0	0	0	0	0	f	f
4974	274	9	5.50	0	0	0	0	0	0	f	f
4975	376	9	5.50	0	0	0	0	0	0	f	f
4976	366	9	6.00	0	0	0	0	0	0	f	f
4977	297	9	5.50	0	0	0	0	0	0	f	f
4978	377	9	5.50	0	0	0	0	0	0	f	f
4979	396	9	5.50	0	0	0	0	0	0	f	f
4980	515	9	6.00	0	0	0	0	0	0	f	f
4981	460	9	5.50	0	0	0	0	0	0	f	f
4982	18	9	6.00	0	2	0	0	0	0	t	f
4983	74	9	6.00	0	0	0	0	0	0	f	f
4984	98	9	6.00	0	0	0	0	0	0	f	f
4985	92	9	6.00	0	0	0	0	0	0	f	f
4986	135	9	5.50	0	0	0	0	0	0	f	f
4987	305	9	5.50	0	0	0	0	0	0	f	f
4988	426	9	5.00	0	0	0	0	0	0	f	f
4989	342	9	5.50	0	0	0	0	0	0	f	f
4990	318	9	5.50	0	0	0	0	0	0	f	f
4991	379	9	5.50	0	0	0	0	0	0	t	f
4992	349	9	6.00	0	0	0	0	0	0	f	f
4993	508	9	5.50	0	0	0	0	0	0	f	f
4994	500	9	5.00	0	0	0	0	0	0	f	f
4995	490	9	5.00	0	0	0	0	0	0	t	f
4996	507	9	5.00	0	0	0	0	0	0	f	f
4997	13	9	6.00	0	0	0	0	0	0	f	f
4998	66	9	6.50	0	0	0	0	0	0	f	f
4999	67	9	6.50	0	0	0	0	0	0	f	f
5000	104	9	7.00	0	0	0	0	0	0	f	f
5001	82	9	6.00	0	0	0	0	0	0	f	f
5002	81	9	6.00	0	0	0	0	0	0	f	f
5003	137	9	6.50	0	0	0	0	0	0	f	f
5004	300	9	6.00	0	0	0	0	0	0	f	f
5005	270	9	6.50	0	0	0	0	0	1	f	f
5006	262	9	8.00	1	0	0	0	0	0	f	f
5007	352	9	6.00	0	0	0	0	0	0	f	f
5008	350	9	6.00	0	0	0	0	0	0	f	f
5009	299	9	7.00	1	0	0	0	0	0	f	f
5010	444	9	6.00	0	0	0	0	0	1	f	f
5011	474	9	6.50	0	0	0	0	0	0	f	f
5012	475	9	6.00	0	0	0	0	0	0	t	f
5013	7	9	6.00	0	1	0	0	0	0	t	f
5014	216	9	6.00	0	0	0	0	0	0	f	f
5015	88	9	6.50	0	0	0	0	0	0	f	f
5016	99	9	6.50	0	0	0	0	0	1	f	f
5017	138	9	7.00	1	0	0	0	0	0	f	f
5018	108	9	6.00	0	0	0	0	0	0	f	f
5019	307	9	6.00	0	0	0	0	0	0	f	f
5020	306	9	6.50	0	0	0	0	0	0	f	f
5021	332	9	6.00	0	0	0	0	0	0	f	f
5022	353	9	6.00	0	0	0	0	0	0	f	f
5023	461	9	7.00	0	0	0	0	0	0	f	f
5024	480	9	6.00	0	0	0	0	0	0	f	f
5025	477	9	6.00	0	0	0	0	0	0	f	f
5026	446	9	7.00	0	0	0	0	0	0	f	f
5027	3	9	6.50	0	0	0	0	0	0	f	f
5028	126	9	6.50	0	0	0	0	0	0	f	f
5029	110	9	6.00	0	0	0	0	0	0	f	f
5030	195	9	6.00	0	0	0	0	0	0	f	f
5031	144	9	5.50	0	0	0	0	0	0	f	f
5032	125	9	6.00	0	0	0	0	0	0	f	f
5033	176	9	6.00	0	0	0	0	0	0	f	f
5034	362	9	6.00	0	0	0	0	0	0	f	f
5035	301	9	6.00	0	0	0	0	0	0	f	f
5036	267	9	6.00	0	0	0	0	0	0	f	f
5037	292	9	6.00	0	0	0	0	0	0	t	f
5038	284	9	6.50	0	0	0	0	0	0	f	f
5039	285	9	5.50	0	0	0	0	0	0	f	f
5040	516	9	5.50	0	0	0	0	0	0	t	f
5041	494	9	5.50	0	0	0	0	0	0	f	f
5042	492	9	6.00	0	0	0	0	0	0	f	f
5043	8	9	6.00	0	1	0	0	0	0	f	f
5044	127	9	6.00	0	0	0	0	0	0	f	f
5045	164	9	6.00	0	0	0	0	0	0	f	f
5046	89	9	6.00	0	0	0	0	0	0	f	f
5047	146	9	6.50	0	0	0	0	0	0	f	f
5048	402	9	6.00	0	0	0	0	0	0	f	f
5049	293	9	6.00	0	0	0	0	0	0	f	f
5050	286	9	6.00	0	0	0	0	0	0	f	f
5051	354	9	6.00	0	0	0	0	0	0	t	f
5052	333	9	5.50	0	0	0	0	0	0	f	f
5053	418	9	6.00	0	0	0	0	0	0	f	f
5054	381	9	5.50	0	0	0	0	0	0	f	f
5055	501	9	6.50	0	0	0	0	0	0	f	f
5056	509	9	5.00	0	0	0	1	0	0	f	f
5057	495	9	5.50	0	0	0	0	0	0	t	f
5058	513	9	5.50	0	0	0	0	0	0	f	f
5059	1	9	6.50	0	1	0	0	0	0	f	f
5060	111	9	6.00	0	0	0	0	0	0	t	f
5061	139	9	5.50	0	0	0	0	0	0	f	f
5062	68	9	6.00	0	0	0	0	0	0	f	f
5063	90	9	6.00	0	0	0	0	0	0	f	f
5064	184	9	6.00	0	0	0	0	0	0	f	f
5065	268	9	6.00	0	0	0	0	0	0	t	f
5066	302	9	6.00	0	0	0	0	0	0	f	f
5067	313	9	6.00	0	0	0	0	0	0	f	f
5068	271	9	5.50	0	0	0	0	0	0	f	f
5069	294	9	7.00	1	0	0	0	0	0	f	f
5070	447	9	5.50	0	0	0	0	0	0	f	f
5071	485	9	5.50	0	0	0	0	0	0	f	f
5072	486	9	5.00	0	0	0	0	0	0	t	f
5073	4	9	7.00	0	0	1	0	0	0	f	f
5074	196	9	5.00	0	0	0	0	0	0	f	f
5075	71	9	6.50	0	0	0	0	0	0	f	f
5076	83	9	6.50	0	0	0	0	0	0	f	f
5077	113	9	6.00	0	0	0	0	0	0	f	f
5078	201	9	6.00	0	0	0	0	0	0	f	f
5079	178	9	6.00	0	0	0	0	0	0	t	f
5080	319	9	5.50	0	0	0	0	0	0	f	f
5081	266	9	7.00	1	0	0	0	0	0	f	f
5082	360	9	5.50	0	0	0	0	0	0	f	f
5083	265	9	6.00	0	0	0	0	0	0	f	f
5084	334	9	6.50	0	0	0	0	0	0	f	f
5085	279	9	7.00	0	0	0	0	0	1	f	f
5086	450	9	5.50	0	0	0	0	0	0	f	f
5087	510	9	5.50	0	0	0	0	0	0	f	f
5088	483	9	6.50	0	0	0	0	0	0	f	f
5089	16	9	6.00	0	2	0	0	0	0	f	f
5090	147	9	6.00	0	0	0	0	0	0	f	f
5091	114	9	7.00	1	0	0	0	0	0	f	f
5092	115	9	5.50	0	0	0	0	0	0	t	f
5093	143	9	6.00	0	0	0	0	0	0	f	f
5094	403	9	6.00	0	0	0	0	0	0	f	f
5095	280	9	5.00	0	0	0	0	0	0	f	f
5096	404	9	5.50	0	0	0	0	0	0	t	f
5097	359	9	5.50	0	0	0	0	0	0	f	f
5098	443	9	6.00	0	0	0	0	0	0	f	f
5099	493	9	5.50	0	0	0	0	0	0	f	f
5100	531	9	6.00	0	0	0	0	0	0	f	f
5101	523	9	6.00	0	0	0	0	0	0	f	f
5102	502	9	6.50	0	0	0	0	0	1	f	f
5103	456	9	6.00	0	0	0	0	0	0	t	f
5104	14	9	6.50	0	0	0	0	0	0	f	f
5105	102	9	6.50	0	0	0	0	0	0	t	f
5106	148	9	6.50	0	0	0	0	0	0	f	f
5107	166	9	6.00	0	0	0	0	0	0	f	f
5108	165	9	6.00	0	0	0	0	0	0	f	f
5109	129	9	6.50	0	0	0	0	0	0	f	f
5110	255	9	5.50	0	0	0	0	0	0	t	f
5111	344	9	5.50	0	0	0	0	0	0	f	f
5112	368	9	5.50	0	0	0	0	0	0	f	f
5113	373	9	6.00	0	0	0	0	0	0	f	f
5114	324	9	6.00	0	0	0	0	0	0	f	f
5115	320	9	6.00	0	0	0	0	0	0	f	f
5116	383	9	6.00	0	0	0	0	0	0	f	f
5117	472	9	6.00	0	0	0	0	0	0	f	f
5118	487	9	6.50	0	0	0	0	0	0	f	f
5119	2	9	7.00	0	1	0	0	0	0	f	f
5120	100	9	6.50	0	0	0	0	0	0	f	f
5121	130	9	6.00	0	0	0	0	0	0	f	f
5122	76	9	6.50	0	0	0	0	0	0	f	f
5123	84	9	7.00	1	0	0	0	0	0	f	f
5124	251	9	6.00	0	0	0	0	0	0	f	f
5125	167	9	5.50	0	0	0	0	0	0	f	f
5126	72	9	6.00	0	0	0	0	0	0	f	f
5127	295	9	6.50	0	0	0	0	0	0	f	f
5128	335	9	5.50	0	0	0	0	0	0	f	f
5129	281	9	7.00	0	0	0	0	0	0	f	f
5130	357	9	6.00	0	0	0	0	0	0	f	f
5131	481	9	6.50	0	0	0	0	0	1	f	f
5132	448	9	6.00	0	0	0	0	0	0	f	f
5133	484	9	6.00	0	0	0	0	0	0	f	f
5134	471	9	7.00	1	0	0	0	0	0	f	f
5135	15	9	6.00	0	1	0	0	0	0	f	f
5136	142	9	6.00	0	0	0	0	0	0	t	f
5137	206	9	6.00	0	0	0	0	0	0	f	f
5138	118	9	5.50	0	0	0	0	0	0	f	f
5139	199	9	5.50	0	0	0	0	0	0	f	f
5140	315	9	6.50	0	0	0	0	0	0	f	f
5141	389	9	6.00	0	0	0	0	0	0	f	f
5142	303	9	7.00	0	0	0	0	0	1	f	f
5143	314	9	6.00	0	0	0	0	0	0	t	f
5144	287	9	6.50	0	0	0	0	0	0	f	f
5145	308	9	5.50	0	0	0	0	0	0	t	f
5146	385	9	6.00	0	0	0	0	0	0	t	f
5147	467	9	7.00	1	0	0	0	0	0	f	f
5148	453	9	7.00	1	0	0	0	0	0	f	f
5149	518	9	6.00	0	0	0	0	0	0	f	f
5150	537	9	6.00	0	0	0	0	0	0	f	f
5151	22	9	6.50	0	0	0	0	0	0	f	f
5152	152	9	6.00	0	0	0	0	0	0	f	f
5153	91	9	6.50	0	0	0	0	0	0	f	f
5154	151	9	6.00	0	0	0	0	0	0	t	f
5155	168	9	6.00	0	0	0	0	0	0	f	f
5156	77	9	7.00	0	0	0	0	0	0	f	f
5157	370	9	6.00	0	0	0	0	0	0	t	f
5158	387	9	6.00	0	0	0	0	0	0	t	f
5159	288	9	6.00	0	0	0	0	0	0	f	f
5160	399	9	6.00	0	0	0	0	0	0	f	f
5161	358	9	6.50	0	0	0	0	0	0	f	f
5162	386	9	6.00	0	0	0	0	0	0	f	f
5163	496	9	6.00	0	0	0	0	0	0	f	f
5164	466	9	5.50	0	0	0	0	0	0	f	f
5165	488	9	5.50	0	0	0	0	0	0	f	f
5166	468	9	5.50	0	0	0	0	0	0	f	f
5167	19	9	7.00	0	3	0	0	0	0	f	f
5168	78	9	5.50	0	0	0	0	0	0	f	f
5169	128	9	6.00	0	0	0	0	0	0	f	f
5170	154	9	5.50	0	0	0	0	0	0	f	f
5171	180	9	6.00	0	0	0	0	0	0	f	f
5172	198	9	4.00	0	0	0	0	0	0	t	f
5173	101	9	6.00	0	0	0	0	0	0	f	f
5174	272	9	7.00	1	0	0	0	0	0	f	f
5175	371	9	5.50	0	0	0	0	0	0	t	f
5176	321	9	5.50	0	0	0	0	0	0	f	f
5177	282	9	6.00	0	0	0	0	0	0	f	f
5178	328	9	6.00	0	0	0	0	0	0	t	f
5179	437	9	6.00	0	0	0	0	0	0	t	f
5180	452	9	5.50	0	0	0	0	0	0	f	f
5181	525	9	5.50	0	0	0	0	0	0	f	f
5182	497	9	5.50	0	0	0	0	0	0	f	f
5183	12	9	6.00	0	3	0	0	0	0	f	f
5184	155	9	5.50	0	0	0	0	0	0	f	f
5185	183	9	5.50	0	0	0	0	0	0	f	f
5186	182	9	5.50	0	0	0	0	0	0	f	f
5187	169	9	5.00	0	0	0	0	0	0	t	f
5188	79	9	6.50	0	0	0	0	0	0	t	f
5189	170	9	5.50	0	0	0	0	0	0	f	f
5190	345	9	5.50	0	0	0	0	0	0	t	f
5191	408	9	5.50	0	0	0	0	0	0	f	f
5192	309	9	7.00	1	0	0	0	0	0	f	f
5193	327	9	5.00	0	0	0	0	0	0	f	f
5194	521	9	5.50	0	0	0	0	0	0	f	f
5195	473	9	5.00	0	0	0	0	0	0	t	f
5196	503	9	6.00	0	0	0	0	0	0	f	f
5197	469	9	6.00	0	0	0	0	0	0	f	f
5198	46	9	\N	0	0	0	0	0	0	f	f
5199	35	9	\N	0	0	0	0	0	0	f	f
5200	37	9	\N	0	0	0	0	0	0	f	f
5201	24	9	\N	0	0	0	0	0	0	f	f
5202	29	9	\N	0	0	0	0	0	0	f	f
5203	51	9	\N	0	0	0	0	0	0	f	f
5204	36	9	\N	0	0	0	0	0	0	f	f
5205	54	9	\N	0	0	0	0	0	0	f	f
5206	47	9	\N	0	0	0	0	0	0	f	f
5207	96	9	\N	0	0	0	0	0	0	f	f
5208	21	9	\N	0	0	0	0	0	0	f	f
5209	27	9	\N	0	0	0	0	0	0	f	f
5210	40	9	\N	0	0	0	0	0	0	f	f
5211	42	9	\N	0	0	0	0	0	0	f	f
5212	52	9	\N	0	0	0	0	0	0	f	f
5213	33	9	\N	0	0	0	0	0	0	f	f
5214	20	9	\N	0	0	0	0	0	0	f	f
5215	28	9	\N	0	0	0	0	0	0	f	f
5216	85	9	\N	0	0	0	0	0	0	f	f
5217	61	9	\N	0	0	0	0	0	0	f	f
5218	26	9	\N	0	0	0	0	0	0	f	f
5219	56	9	\N	0	0	0	0	0	0	f	f
5220	58	9	\N	0	0	0	0	0	0	f	f
5221	62	9	\N	0	0	0	0	0	0	f	f
5222	65	9	\N	0	0	0	0	0	0	f	f
5223	30	9	\N	0	0	0	0	0	0	f	f
5224	45	9	\N	0	0	0	0	0	0	f	f
5225	116	9	\N	0	0	0	0	0	0	f	f
5226	186	9	\N	0	0	0	0	0	0	f	f
5227	171	9	\N	0	0	0	0	0	0	f	f
5228	173	9	\N	0	0	0	0	0	0	f	f
5229	145	9	\N	0	0	0	0	0	0	f	f
5230	150	9	\N	0	0	0	0	0	0	f	f
5231	149	9	\N	0	0	0	0	0	0	f	f
5232	193	9	\N	0	0	0	0	0	0	f	f
5233	204	9	\N	0	0	0	0	0	0	f	f
5234	112	9	\N	0	0	0	0	0	0	f	f
5235	140	9	\N	0	0	0	0	0	0	f	f
5236	197	9	\N	0	0	0	0	0	0	f	f
5237	141	9	\N	0	0	0	0	0	0	f	f
5238	202	9	\N	0	0	0	0	0	0	f	f
5239	207	9	\N	0	0	0	0	0	0	f	f
5240	208	9	\N	0	0	0	0	0	0	f	f
5241	191	9	\N	0	0	0	0	0	0	f	f
5242	175	9	\N	0	0	0	0	0	0	f	f
5243	218	9	\N	0	0	0	0	0	0	f	f
5244	220	9	\N	0	0	0	0	0	0	f	f
5245	224	9	\N	0	0	0	0	0	0	f	f
5246	227	9	\N	0	0	0	0	0	0	f	f
5247	238	9	\N	0	0	0	0	0	0	f	f
5248	235	9	\N	0	0	0	0	0	0	f	f
5249	310	9	\N	0	0	0	0	0	0	f	f
5250	232	9	\N	0	0	0	0	0	0	f	f
5251	226	9	\N	0	0	0	0	0	0	f	f
5252	248	9	\N	0	0	0	0	0	0	f	f
5253	241	9	\N	0	0	0	0	0	0	f	f
5254	221	9	\N	0	0	0	0	0	0	f	f
5255	230	9	\N	0	0	0	0	0	0	f	f
5256	211	9	\N	0	0	0	0	0	0	f	f
5257	244	9	\N	0	0	0	0	0	0	f	f
5258	245	9	\N	0	0	0	0	0	0	f	f
5259	273	9	\N	0	0	0	0	0	0	f	f
5260	210	9	\N	0	0	0	0	0	0	f	f
5261	240	9	\N	0	0	0	0	0	0	f	f
5262	264	9	\N	0	0	0	0	0	0	f	f
5263	250	9	\N	0	0	0	0	0	0	f	f
5264	223	9	\N	0	0	0	0	0	0	f	f
5265	214	9	\N	0	0	0	0	0	0	f	f
5266	215	9	\N	0	0	0	0	0	0	f	f
5267	298	9	\N	0	0	0	0	0	0	f	f
5268	278	9	\N	0	0	0	0	0	0	f	f
5269	312	9	\N	0	0	0	0	0	0	f	f
5270	228	9	\N	0	0	0	0	0	0	f	f
5271	222	9	\N	0	0	0	0	0	0	f	f
5272	253	9	\N	0	0	0	0	0	0	f	f
5273	254	9	\N	0	0	0	0	0	0	f	f
5274	225	9	\N	0	0	0	0	0	0	f	f
5275	233	9	\N	0	0	0	0	0	0	f	f
5276	375	9	\N	0	0	0	0	0	0	f	f
5277	343	9	\N	0	0	0	0	0	0	f	f
5278	405	9	\N	0	0	0	0	0	0	f	f
5279	367	9	\N	0	0	0	0	0	0	f	f
5280	337	9	\N	0	0	0	0	0	0	f	f
5281	390	9	\N	0	0	0	0	0	0	f	f
5282	406	9	\N	0	0	0	0	0	0	f	f
5283	382	9	\N	0	0	0	0	0	0	f	f
5284	414	9	\N	0	0	0	0	0	0	f	f
5285	378	9	\N	0	0	0	0	0	0	f	f
5286	392	9	\N	0	0	0	0	0	0	f	f
5287	380	9	\N	0	0	0	0	0	0	f	f
5288	412	9	\N	0	0	0	0	0	0	f	f
5289	347	9	\N	0	0	0	0	0	0	f	f
5290	356	9	\N	0	0	0	0	0	0	f	f
5291	326	9	\N	0	0	0	0	0	0	f	f
5292	397	9	\N	0	0	0	0	0	0	f	f
5293	400	9	\N	0	0	0	0	0	0	f	f
5294	384	9	\N	0	0	0	0	0	0	f	f
5295	369	9	\N	0	0	0	0	0	0	f	f
5296	394	9	\N	0	0	0	0	0	0	f	f
5297	416	9	\N	0	0	0	0	0	0	f	f
5298	391	9	\N	0	0	0	0	0	0	f	f
5299	409	9	\N	0	0	0	0	0	0	f	f
5300	411	9	\N	0	0	0	0	0	0	f	f
5301	351	9	\N	0	0	0	0	0	0	f	f
5302	237	9	\N	0	0	0	0	0	0	f	f
5303	431	9	\N	0	0	0	0	0	0	f	f
5304	429	9	\N	0	0	0	0	0	0	f	f
5305	433	9	\N	0	0	0	0	0	0	f	f
5306	522	9	\N	0	0	0	0	0	0	f	f
5307	517	9	\N	0	0	0	0	0	0	f	f
5308	479	9	\N	0	0	0	0	0	0	f	f
5309	455	9	\N	0	0	0	0	0	0	f	f
5310	449	9	\N	0	0	0	0	0	0	f	f
5311	428	9	\N	0	0	0	0	0	0	f	f
5312	438	9	\N	0	0	0	0	0	0	f	f
5313	441	9	\N	0	0	0	0	0	0	f	f
5314	425	9	\N	0	0	0	0	0	0	f	f
5315	430	9	\N	0	0	0	0	0	0	f	f
5316	420	9	\N	0	0	0	0	0	0	f	f
5317	427	9	\N	0	0	0	0	0	0	f	f
5318	504	9	\N	0	0	0	0	0	0	f	f
5319	505	9	\N	0	0	0	0	0	0	f	f
5320	434	9	\N	0	0	0	0	0	0	f	f
5321	435	9	\N	0	0	0	0	0	0	f	f
5322	529	9	\N	0	0	0	0	0	0	f	f
5323	219	9	\N	0	0	0	0	0	0	f	f
5324	530	9	\N	0	0	0	0	0	0	f	f
5325	540	9	\N	0	0	0	0	0	0	f	f
5326	541	9	\N	0	0	0	0	0	0	f	f
5327	43	9	\N	0	0	0	0	0	0	f	f
5328	44	9	\N	0	0	0	0	0	0	f	f
5329	236	9	\N	0	0	0	0	0	0	f	f
5330	217	9	\N	0	0	0	0	0	0	f	f
5331	417	9	\N	0	0	0	0	0	0	f	f
5332	363	9	\N	0	0	0	0	0	0	f	f
5333	491	9	\N	0	0	0	0	0	0	f	f
5334	55	9	\N	0	0	0	0	0	0	f	f
5335	247	9	\N	0	0	0	0	0	0	f	f
5336	421	9	\N	0	0	0	0	0	0	f	f
5337	422	9	\N	0	0	0	0	0	0	f	f
5338	246	9	\N	0	0	0	0	0	0	f	f
5339	527	9	\N	0	0	0	0	0	0	f	f
5340	538	9	\N	0	0	0	0	0	0	f	f
5341	48	9	\N	0	0	0	0	0	0	f	f
5342	177	9	\N	0	0	0	0	0	0	f	f
5343	258	9	\N	0	0	0	0	0	0	f	f
5344	388	9	\N	0	0	0	0	0	0	f	f
5345	260	9	\N	0	0	0	0	0	0	f	f
5346	34	9	\N	0	0	0	0	0	0	f	f
5347	97	9	\N	0	0	0	0	0	0	f	f
5348	498	9	\N	0	0	0	0	0	0	f	f
5349	532	9	\N	0	0	0	0	0	0	f	f
5350	542	9	\N	0	0	0	0	0	0	f	f
5351	543	9	\N	0	0	0	0	0	0	f	f
5352	528	9	\N	0	0	0	0	0	0	f	f
5353	49	9	\N	0	0	0	0	0	0	f	f
5354	239	9	\N	0	0	0	0	0	0	f	f
5355	476	9	\N	0	0	0	0	0	0	f	f
5356	60	9	\N	0	0	0	0	0	0	f	f
5357	57	9	\N	0	0	0	0	0	0	f	f
5358	153	9	\N	0	0	0	0	0	0	f	f
5359	131	9	\N	0	0	0	0	0	0	f	f
5360	423	9	\N	0	0	0	0	0	0	f	f
5361	524	9	\N	0	0	0	0	0	0	f	f
5362	39	9	\N	0	0	0	0	0	0	f	f
5363	192	9	\N	0	0	0	0	0	0	f	f
5364	59	9	\N	0	0	0	0	0	0	f	f
5365	440	9	\N	0	0	0	0	0	0	f	f
5366	398	9	\N	0	0	0	0	0	0	f	f
5367	442	9	\N	0	0	0	0	0	0	f	f
5368	25	9	\N	0	0	0	0	0	0	f	f
5369	87	9	\N	0	0	0	0	0	0	f	f
5370	109	9	\N	0	0	0	0	0	0	f	f
5371	194	9	\N	0	0	0	0	0	0	f	f
5372	234	9	\N	0	0	0	0	0	0	f	f
5373	410	9	\N	0	0	0	0	0	0	f	f
5374	291	9	\N	0	0	0	0	0	0	f	f
5375	535	9	\N	0	0	0	0	0	0	f	f
5376	322	9	\N	0	0	0	0	0	0	f	f
5377	53	9	\N	0	0	0	0	0	0	f	f
5378	275	9	\N	0	0	0	0	0	0	f	f
5379	32	9	\N	0	0	0	0	0	0	f	f
5380	132	9	\N	0	0	0	0	0	0	f	f
5381	465	9	\N	0	0	0	0	0	0	f	f
5382	454	9	\N	0	0	0	0	0	0	f	f
5383	103	9	\N	0	0	0	0	0	0	f	f
5384	73	9	\N	0	0	0	0	0	0	f	f
5385	311	9	\N	0	0	0	0	0	0	f	f
5386	482	9	\N	0	0	0	0	0	0	f	f
5387	336	9	\N	0	0	0	0	0	0	f	f
5388	38	9	\N	0	0	0	0	0	0	f	f
5389	256	9	\N	0	0	0	0	0	0	f	f
5390	124	9	\N	0	0	0	0	0	0	f	f
5391	415	9	\N	0	0	0	0	0	0	f	f
5392	179	9	\N	0	0	0	0	0	0	f	f
5393	249	9	\N	0	0	0	0	0	0	f	f
5394	203	9	\N	0	0	0	0	0	0	f	f
5395	407	9	\N	0	0	0	0	0	0	f	f
5396	439	9	\N	0	0	0	0	0	0	f	f
5397	539	9	\N	0	0	0	0	0	0	f	f
5398	181	9	\N	0	0	0	0	0	0	f	f
5399	252	9	\N	0	0	0	0	0	0	f	f
5400	413	9	\N	0	0	0	0	0	0	f	f
5401	424	9	\N	0	0	0	0	0	0	f	f
5402	41	9	\N	0	0	0	0	0	0	f	f
5403	136	9	\N	0	0	0	0	0	0	f	f
5404	259	9	\N	0	0	0	0	0	0	f	f
5405	163	9	\N	0	0	0	0	0	0	f	f
5406	445	9	\N	0	0	0	0	0	0	f	f
5407	257	9	\N	0	0	0	0	0	0	f	f
5408	419	9	\N	0	0	0	0	0	0	f	f
5409	401	9	\N	0	0	0	0	0	0	f	f
5410	432	9	\N	0	0	0	0	0	0	f	f
5411	64	9	\N	0	0	0	0	0	0	f	f
5412	188	9	\N	0	0	0	0	0	0	f	f
5413	212	9	\N	0	0	0	0	0	0	f	f
5414	395	9	\N	0	0	0	0	0	0	f	f
5415	526	9	\N	0	0	0	0	0	0	f	f
5416	533	9	\N	0	0	0	0	0	0	f	f
5417	511	9	\N	0	0	0	0	0	0	f	f
5418	23	9	\N	0	0	0	0	0	0	f	f
5419	50	9	\N	0	0	0	0	0	0	f	f
5420	365	9	\N	0	0	0	0	0	0	f	f
5421	372	9	\N	0	0	0	0	0	0	f	f
5422	31	9	\N	0	0	0	0	0	0	f	f
5423	185	9	\N	0	0	0	0	0	0	f	f
5424	243	9	\N	0	0	0	0	0	0	f	f
5425	242	9	\N	0	0	0	0	0	0	f	f
5426	536	9	\N	0	0	0	0	0	0	f	f
5427	63	9	\N	0	0	0	0	0	0	f	f
5428	231	9	\N	0	0	0	0	0	0	f	f
5429	331	9	\N	0	0	0	0	0	0	f	f
5430	290	9	\N	0	0	0	0	0	0	f	f
5431	5	10	6.50	0	1	0	0	0	0	f	f
5432	120	10	5.50	0	0	0	0	0	0	f	f
5433	156	10	6.00	0	0	0	0	0	0	f	f
5434	94	10	6.00	0	0	0	0	0	0	f	f
5435	93	10	6.00	0	0	0	0	0	0	f	f
5436	157	10	5.50	0	0	0	0	0	0	f	f
5437	296	10	5.50	0	0	0	0	0	0	f	f
5438	339	10	6.00	0	0	0	0	0	0	f	f
5439	276	10	5.50	0	0	0	0	0	0	f	f
5440	312	10	5.00	0	0	0	0	0	0	f	f
5441	329	10	5.50	0	0	0	0	0	0	t	f
5442	454	10	5.50	0	0	0	0	0	0	f	f
5443	462	10	5.50	0	0	0	0	0	0	f	f
5444	482	10	5.00	0	0	0	0	0	0	f	f
5445	459	10	5.50	0	0	0	0	0	0	t	f
5446	465	10	5.00	0	0	0	0	0	0	t	f
5447	9	10	6.00	0	1	0	0	0	0	f	f
5448	85	10	7.00	1	0	0	0	0	0	f	f
5449	73	10	6.50	0	0	0	0	0	1	f	f
5450	121	10	6.00	0	0	0	0	0	0	f	f
5451	103	10	6.00	0	0	0	0	0	0	f	f
5452	341	10	6.00	0	0	0	0	0	0	f	f
5453	340	10	6.00	0	0	0	0	0	0	f	f
5454	263	10	6.00	0	0	0	0	0	0	f	f
5455	269	10	6.00	0	0	0	0	0	0	f	f
5456	311	10	6.50	0	0	0	0	0	0	f	f
5457	323	10	6.00	0	0	0	0	0	0	f	f
5458	374	10	6.00	0	0	0	0	0	0	f	f
5459	336	10	6.50	0	0	0	0	0	0	f	f
5460	458	10	6.50	0	0	0	0	0	1	t	f
5461	451	10	7.50	2	0	0	0	0	0	t	f
5462	489	10	6.00	0	0	0	0	0	0	f	f
5463	10	10	6.50	0	2	0	0	0	0	f	f
5464	96	10	5.00	0	0	0	0	0	0	f	f
5465	97	10	5.50	0	0	0	0	0	0	f	f
5466	133	10	5.50	0	0	0	0	0	0	f	f
5467	69	10	6.00	0	0	0	0	0	0	f	f
5468	122	10	6.00	0	0	0	0	0	0	f	f
5469	304	10	5.50	0	0	0	0	0	0	t	f
5470	361	10	5.00	0	0	0	0	0	0	f	f
5471	330	10	6.00	0	0	0	0	0	0	f	f
5472	348	10	5.00	0	0	0	0	0	0	f	f
5473	289	10	6.00	0	0	0	0	0	0	t	f
5474	534	10	6.00	0	0	0	0	0	0	f	f
5475	470	10	5.50	0	0	0	0	0	0	f	f
5476	520	10	5.50	0	0	0	0	0	0	f	f
5477	478	10	5.50	0	0	0	0	0	0	f	f
5478	529	10	6.00	0	0	0	0	0	0	f	f
5479	6	10	6.00	0	0	0	0	0	0	f	f
5480	119	10	6.50	0	0	0	0	0	0	f	f
5481	95	10	6.00	0	0	0	0	0	0	f	f
5482	105	10	6.00	0	0	0	0	0	0	f	f
5483	117	10	6.50	0	0	0	0	0	0	f	f
5484	80	10	6.00	0	0	0	0	0	0	f	f
5485	189	10	6.50	0	0	0	0	0	0	t	f
5486	316	10	6.50	0	0	0	0	0	0	f	f
5487	317	10	6.00	0	0	0	0	0	0	f	f
5488	290	10	6.00	0	0	0	0	0	0	t	f
5489	261	10	5.50	0	0	0	0	0	0	f	f
5490	512	10	5.00	0	0	0	1	0	0	f	f
5491	506	10	6.50	0	0	0	0	0	0	f	f
5492	463	10	6.00	0	0	0	0	0	0	f	f
5493	479	10	6.00	0	0	0	0	0	0	f	f
5494	499	10	6.00	0	0	0	0	0	0	f	f
5495	11	10	6.50	0	2	0	0	0	0	f	f
5496	134	10	5.50	0	0	0	0	0	0	t	f
5497	75	10	5.00	0	0	0	0	0	0	f	f
5498	70	10	5.50	0	0	0	0	0	0	f	f
5499	106	10	6.00	0	0	0	0	0	0	f	f
5500	205	10	6.00	0	0	0	0	0	0	f	f
5501	160	10	5.50	0	0	0	0	0	0	f	f
5502	277	10	6.50	0	0	0	0	0	0	f	f
5503	355	10	5.50	0	0	0	0	0	0	f	f
5504	325	10	6.00	0	0	0	0	0	0	f	f
5505	393	10	5.50	0	0	0	0	0	0	f	f
5506	283	10	6.00	0	0	0	0	0	0	f	f
5507	464	10	5.50	0	0	0	0	0	0	f	f
5508	457	10	7.00	1	0	0	0	0	0	f	f
5509	526	10	6.50	0	0	0	0	0	1	f	f
5510	17	10	6.00	0	1	0	0	0	0	f	f
5511	124	10	5.00	0	0	0	0	0	0	t	f
5512	175	10	5.50	0	0	0	0	0	0	f	f
5513	161	10	5.50	0	0	0	0	0	0	f	f
5514	174	10	5.50	0	0	0	0	0	0	f	f
5515	162	10	5.50	0	0	0	0	0	0	f	f
5516	274	10	5.00	0	0	0	0	0	0	f	f
5517	392	10	5.00	0	0	0	0	0	0	t	f
5518	376	10	5.00	0	0	0	0	0	0	t	f
5519	366	10	5.00	0	0	0	0	0	0	f	f
5520	297	10	5.50	0	0	0	0	0	0	f	f
5521	377	10	5.50	0	0	0	0	0	0	f	f
5522	396	10	4.50	0	0	0	0	0	0	f	f
5523	515	10	5.00	0	0	0	0	0	0	f	f
5524	460	10	5.00	0	0	0	0	0	0	t	f
5525	505	10	5.00	0	0	0	0	0	0	f	f
5526	18	10	6.00	0	1	0	0	0	0	f	f
5527	74	10	6.50	0	0	0	0	0	1	f	f
5528	98	10	6.50	0	0	0	0	0	0	f	f
5529	92	10	7.00	1	0	0	0	0	0	f	f
5530	192	10	6.00	0	0	0	0	0	0	t	f
5531	135	10	7.00	0	0	0	0	0	0	f	f
5532	298	10	6.00	0	0	0	0	0	0	f	f
5533	305	10	7.00	1	0	0	0	0	0	t	f
5534	397	10	6.00	0	0	0	0	0	0	f	f
5535	342	10	6.00	0	0	0	0	0	0	f	f
5536	318	10	6.00	0	0	0	0	0	0	f	f
5537	378	10	6.00	0	0	0	0	0	0	f	f
5538	349	10	6.00	0	0	0	0	0	0	t	f
5539	508	10	5.00	0	0	0	0	0	0	f	f
5540	500	10	6.00	0	0	0	0	0	0	f	f
5541	490	10	5.50	0	0	0	0	0	0	f	f
5542	13	10	5.50	0	1	0	0	0	0	f	f
5543	66	10	6.00	0	0	0	0	0	0	f	f
5544	67	10	5.50	0	0	0	0	0	0	f	f
5545	104	10	6.00	0	0	0	0	0	0	f	f
5546	82	10	6.00	0	0	0	0	0	0	f	f
5547	81	10	6.00	0	0	0	0	0	0	f	f
5548	137	10	6.00	0	0	0	0	0	0	t	f
5549	300	10	7.00	1	0	0	0	0	0	f	f
5550	270	10	6.50	0	0	0	0	0	0	f	f
5551	262	10	7.00	0	0	0	0	0	1	f	f
5552	352	10	6.00	0	0	0	0	0	0	f	f
5553	350	10	5.50	0	0	0	0	0	0	f	f
5554	299	10	5.50	0	0	0	0	0	0	f	f
5555	444	10	5.50	0	0	0	0	0	0	f	f
5556	474	10	5.50	0	0	0	0	0	0	f	f
5557	475	10	6.00	0	0	0	0	0	0	f	f
5558	7	10	6.00	0	1	0	0	0	0	f	f
5559	216	10	6.00	0	0	0	0	0	0	f	f
5560	88	10	6.50	0	0	0	0	0	0	f	f
5561	99	10	7.00	1	0	0	0	0	0	f	f
5562	138	10	5.00	0	0	0	0	0	0	f	f
5563	194	10	6.00	0	0	0	0	0	0	f	f
5564	307	10	7.00	0	0	0	0	0	0	f	f
5565	306	10	7.00	1	0	0	0	0	0	f	f
5566	332	10	6.00	0	0	0	0	0	0	f	f
5567	291	10	6.00	0	0	0	0	0	0	f	f
5568	353	10	6.00	0	0	0	0	0	0	f	f
5569	410	10	6.00	0	0	0	0	0	0	f	f
5570	278	10	6.00	0	0	0	0	0	0	f	f
5571	461	10	6.50	0	0	0	0	0	0	f	f
5572	480	10	6.00	0	0	0	0	0	0	f	f
5573	477	10	6.00	0	0	0	0	0	0	f	f
5574	3	10	6.00	0	0	0	0	0	0	f	f
5575	126	10	6.00	0	0	0	0	0	0	f	f
5576	110	10	6.50	0	0	0	0	0	0	f	f
5577	195	10	6.00	0	0	0	0	0	0	f	f
5578	144	10	6.00	0	0	0	0	0	0	f	f
5579	125	10	6.50	0	0	0	0	0	0	f	f
5580	176	10	6.00	0	0	0	0	0	0	f	f
5581	362	10	6.00	0	0	0	0	0	0	f	f
5582	301	10	6.50	0	0	0	0	0	0	f	f
5583	267	10	7.00	1	0	0	0	0	0	f	f
5584	292	10	7.00	0	0	0	0	0	0	f	f
5585	284	10	5.50	0	0	0	0	0	0	f	f
5586	285	10	7.00	1	0	0	0	0	0	f	f
5587	516	10	6.00	0	0	0	0	0	0	f	f
5588	494	10	5.00	0	0	0	0	0	0	f	f
5589	492	10	6.00	0	0	0	0	0	0	f	f
5590	8	10	7.00	0	0	0	0	0	0	f	f
5591	127	10	6.50	0	0	0	0	0	0	f	f
5592	164	10	6.50	0	0	0	0	0	0	f	f
5593	89	10	6.50	0	0	0	0	0	0	f	f
5594	146	10	6.00	0	0	0	0	0	0	t	f
5595	402	10	6.00	0	0	0	0	0	0	f	f
5596	293	10	6.00	0	0	0	0	0	0	f	f
5597	286	10	7.00	1	0	0	0	0	0	f	f
5598	354	10	6.50	0	0	0	0	0	0	f	f
5599	401	10	6.00	0	0	0	0	0	0	f	f
5600	333	10	6.00	0	0	0	0	0	0	f	f
5601	381	10	6.50	0	0	0	0	0	1	f	f
5602	501	10	6.00	0	0	0	0	0	0	f	f
5603	509	10	6.00	0	0	0	0	0	0	f	f
5604	513	10	6.00	0	0	0	0	0	0	f	f
5605	1	10	7.00	0	0	1	0	0	0	f	f
5606	111	10	6.50	0	0	0	0	0	0	f	f
5607	139	10	6.00	0	0	0	0	0	0	f	f
5608	68	10	7.50	1	0	0	0	0	0	f	f
5609	193	10	5.50	0	0	0	0	0	0	f	f
5610	90	10	6.00	0	0	0	0	0	0	f	f
5611	184	10	6.00	0	0	0	0	0	0	f	f
5612	268	10	6.50	0	0	0	0	0	0	f	f
5613	302	10	6.00	0	0	0	0	0	0	f	f
5614	313	10	5.50	0	0	0	0	0	0	t	f
5615	271	10	6.50	0	0	0	0	0	0	f	f
5616	294	10	6.00	0	0	0	0	0	0	f	f
5617	447	10	6.50	0	0	0	0	0	1	f	f
5618	485	10	5.50	0	0	0	0	0	0	f	f
5619	4	10	7.00	0	0	1	0	0	0	f	f
5620	71	10	5.50	0	0	0	0	0	0	f	f
5621	83	10	6.00	0	0	0	0	0	0	f	f
5622	113	10	5.50	0	0	0	0	0	0	f	f
5623	140	10	6.50	0	0	0	0	0	0	f	f
5624	201	10	6.00	0	0	0	0	0	0	f	f
5625	319	10	5.50	0	0	0	0	0	0	t	f
5626	266	10	6.00	0	0	0	0	0	0	t	f
5627	356	10	6.00	0	0	0	0	0	0	f	f
5628	360	10	5.50	0	0	0	0	0	0	t	f
5629	265	10	6.50	0	0	0	0	0	0	f	f
5630	334	10	6.00	0	0	0	0	0	0	f	f
5631	279	10	5.50	0	0	0	0	0	0	f	f
5632	450	10	5.50	0	0	0	0	0	0	f	f
5633	510	10	6.00	0	0	0	0	0	0	f	f
5634	483	10	6.00	0	0	0	0	0	0	f	f
5635	16	10	6.00	0	3	0	0	0	0	f	f
5636	147	10	6.00	0	0	0	0	0	0	t	f
5637	114	10	5.50	0	0	0	0	0	0	f	f
5638	115	10	5.50	0	0	0	0	0	0	f	f
5639	224	10	6.00	0	0	0	0	0	0	f	f
5640	143	10	6.00	0	0	0	0	0	0	f	f
5641	405	10	5.50	0	0	0	0	0	0	f	f
5642	403	10	5.50	0	0	0	0	0	0	f	f
5643	280	10	7.00	1	0	0	0	0	0	f	f
5644	365	10	5.50	0	0	0	0	0	0	f	f
5645	404	10	4.50	0	0	0	0	0	0	f	t
5646	359	10	6.00	0	0	0	0	0	0	f	f
5647	493	10	5.50	0	0	0	0	0	0	f	f
5648	531	10	5.50	0	0	0	0	0	0	t	f
5649	502	10	6.00	0	0	0	0	0	0	f	f
5650	456	10	6.00	0	0	0	0	0	0	f	f
5651	14	10	6.50	0	2	0	0	0	0	f	f
5652	102	10	6.00	0	0	0	0	0	0	f	f
5653	148	10	6.00	0	0	0	0	0	0	f	f
5654	166	10	6.00	0	0	0	0	0	0	f	f
5655	165	10	5.00	0	0	0	0	0	0	f	f
5656	129	10	6.00	0	0	0	0	0	0	f	f
5657	344	10	6.50	0	0	0	0	0	1	f	f
5658	373	10	6.00	0	0	0	0	0	0	f	f
5659	324	10	6.50	0	0	0	0	0	0	f	f
5660	320	10	6.00	0	0	0	0	0	0	f	f
5661	433	10	6.00	0	0	0	0	0	0	t	f
5662	383	10	6.00	0	0	0	0	0	0	f	f
5663	406	10	6.00	0	0	0	0	0	0	f	f
5664	472	10	6.00	0	0	0	0	0	0	f	f
5665	487	10	7.50	1	0	0	0	0	0	f	f
5666	517	10	5.50	0	0	0	0	0	0	f	f
5667	2	10	7.00	0	1	0	0	0	0	f	f
5668	100	10	5.50	0	0	0	0	0	0	t	f
5669	130	10	5.50	0	0	0	0	0	0	f	f
5670	76	10	6.00	0	0	0	0	0	0	t	f
5671	84	10	6.50	0	0	0	0	0	0	t	f
5672	202	10	6.00	0	0	0	0	0	0	f	f
5673	72	10	6.00	0	0	0	0	0	0	t	f
5674	275	10	6.00	0	0	0	0	0	0	f	f
5675	295	10	6.00	0	0	0	0	0	0	f	f
5676	335	10	5.50	0	0	0	0	0	0	f	f
5677	281	10	6.00	0	0	0	0	0	0	f	f
5678	384	10	6.00	0	0	0	0	0	0	f	f
5679	357	10	6.00	0	0	0	0	0	0	t	f
5680	481	10	5.00	0	0	0	1	0	0	f	f
5681	448	10	6.00	0	0	0	0	0	0	f	f
5682	471	10	5.50	0	0	0	0	0	0	f	f
5683	15	10	5.50	0	2	0	0	0	0	f	f
5684	142	10	5.50	0	0	0	0	0	0	f	f
5685	150	10	5.50	0	0	0	0	0	0	f	f
5686	206	10	5.50	0	0	0	0	0	0	f	f
5687	118	10	6.00	0	0	0	0	0	0	f	f
5688	149	10	5.50	0	0	0	0	0	0	t	f
5689	315	10	6.50	0	0	0	0	0	0	f	f
5690	389	10	5.00	0	0	0	0	0	0	f	f
5691	314	10	6.50	0	0	0	0	0	0	f	f
5692	287	10	6.50	0	0	0	0	0	0	f	f
5693	308	10	6.00	0	0	0	0	0	0	f	f
5694	449	10	7.00	1	0	0	0	0	0	f	f
5695	467	10	5.50	0	0	0	0	0	0	f	f
5696	453	10	6.00	0	0	0	0	0	0	f	f
5697	518	10	5.50	0	0	0	0	0	0	f	f
5698	537	10	6.00	0	0	0	0	0	0	f	f
5699	22	10	6.00	0	2	0	0	0	0	f	f
5700	179	10	6.00	0	0	0	0	0	0	f	f
5701	152	10	6.00	0	0	0	0	0	0	f	f
5702	91	10	5.50	0	0	0	0	0	0	f	f
5703	151	10	6.00	0	0	0	0	0	1	f	f
5704	168	10	6.00	0	0	0	0	0	0	t	f
5705	77	10	6.00	0	0	0	0	0	0	f	f
5706	370	10	6.00	0	0	0	0	0	0	f	f
5707	387	10	6.50	0	0	0	0	0	0	f	f
5708	288	10	5.50	0	0	0	0	0	0	f	f
5709	358	10	5.50	0	0	0	0	0	0	t	f
5710	386	10	6.00	0	0	0	0	0	0	f	f
5711	496	10	5.50	0	0	0	0	0	0	f	f
5712	466	10	6.50	1	0	0	0	0	0	f	f
5713	488	10	6.00	0	0	0	0	0	0	f	f
5714	468	10	7.00	1	0	0	0	0	0	f	f
5715	19	10	6.00	0	0	0	0	0	0	f	f
5716	78	10	7.00	0	0	0	0	0	0	f	f
5717	128	10	6.50	0	0	0	0	0	0	f	f
5718	154	10	7.00	0	0	0	0	0	1	t	f
5719	153	10	6.50	0	0	0	0	0	0	f	f
5720	180	10	6.00	0	0	0	0	0	0	f	f
5721	250	10	6.50	0	0	0	0	0	0	f	f
5722	101	10	6.50	0	0	0	0	0	0	f	f
5723	272	10	7.00	1	0	0	0	0	0	f	f
5724	423	10	6.00	0	0	0	0	0	0	f	f
5725	321	10	6.50	0	0	0	0	0	0	f	f
5726	326	10	6.50	0	0	0	0	0	0	f	f
5727	282	10	7.00	0	0	0	0	0	0	f	f
5728	328	10	6.00	0	0	0	0	0	0	f	f
5729	525	10	6.00	0	0	0	0	0	0	f	f
5730	497	10	6.50	0	0	0	0	0	0	f	f
5731	12	10	6.50	0	2	0	0	0	0	f	f
5732	155	10	6.00	0	0	0	0	0	0	f	f
5733	183	10	5.50	0	0	0	0	1	0	f	f
5734	169	10	6.50	0	0	0	0	0	0	f	f
5735	79	10	6.50	0	0	0	0	0	0	f	f
5736	170	10	6.50	0	0	0	0	0	0	t	f
5737	345	10	6.00	0	0	0	0	0	0	f	f
5738	413	10	6.00	0	0	0	0	0	0	f	f
5739	408	10	6.00	0	0	0	0	0	0	f	f
5740	409	10	6.00	0	0	0	0	0	0	f	f
5741	327	10	6.00	0	0	0	0	0	0	f	f
5742	521	10	6.00	0	0	0	0	0	0	f	f
5743	473	10	6.00	0	0	0	0	0	1	t	f
5744	503	10	6.00	0	0	0	0	0	0	f	f
5745	469	10	7.00	1	0	0	0	0	0	f	f
5746	46	10	\N	0	0	0	0	0	0	f	f
5747	35	10	\N	0	0	0	0	0	0	f	f
5748	37	10	\N	0	0	0	0	0	0	f	f
5749	24	10	\N	0	0	0	0	0	0	f	f
5750	29	10	\N	0	0	0	0	0	0	f	f
5751	51	10	\N	0	0	0	0	0	0	f	f
5752	36	10	\N	0	0	0	0	0	0	f	f
5753	54	10	\N	0	0	0	0	0	0	f	f
5754	47	10	\N	0	0	0	0	0	0	f	f
5755	21	10	\N	0	0	0	0	0	0	f	f
5756	27	10	\N	0	0	0	0	0	0	f	f
5757	40	10	\N	0	0	0	0	0	0	f	f
5758	42	10	\N	0	0	0	0	0	0	f	f
5759	52	10	\N	0	0	0	0	0	0	f	f
5760	33	10	\N	0	0	0	0	0	0	f	f
5761	20	10	\N	0	0	0	0	0	0	f	f
5762	28	10	\N	0	0	0	0	0	0	f	f
5763	61	10	\N	0	0	0	0	0	0	f	f
5764	26	10	\N	0	0	0	0	0	0	f	f
5765	56	10	\N	0	0	0	0	0	0	f	f
5766	58	10	\N	0	0	0	0	0	0	f	f
5767	62	10	\N	0	0	0	0	0	0	f	f
5768	65	10	\N	0	0	0	0	0	0	f	f
5769	30	10	\N	0	0	0	0	0	0	f	f
5770	45	10	\N	0	0	0	0	0	0	f	f
5771	172	10	\N	0	0	0	0	0	0	f	f
5772	116	10	\N	0	0	0	0	0	0	f	f
5773	186	10	\N	0	0	0	0	0	0	f	f
5774	171	10	\N	0	0	0	0	0	0	f	f
5775	173	10	\N	0	0	0	0	0	0	f	f
5776	145	10	\N	0	0	0	0	0	0	f	f
5777	199	10	\N	0	0	0	0	0	0	f	f
5778	204	10	\N	0	0	0	0	0	0	f	f
5779	112	10	\N	0	0	0	0	0	0	f	f
5780	196	10	\N	0	0	0	0	0	0	f	f
5781	197	10	\N	0	0	0	0	0	0	f	f
5782	108	10	\N	0	0	0	0	0	0	f	f
5783	141	10	\N	0	0	0	0	0	0	f	f
5784	207	10	\N	0	0	0	0	0	0	f	f
5785	208	10	\N	0	0	0	0	0	0	f	f
5786	187	10	\N	0	0	0	0	0	0	f	f
5787	191	10	\N	0	0	0	0	0	0	f	f
5788	107	10	\N	0	0	0	0	0	0	f	f
5789	182	10	\N	0	0	0	0	0	0	f	f
5790	218	10	\N	0	0	0	0	0	0	f	f
5791	220	10	\N	0	0	0	0	0	0	f	f
5792	227	10	\N	0	0	0	0	0	0	f	f
5793	238	10	\N	0	0	0	0	0	0	f	f
5794	235	10	\N	0	0	0	0	0	0	f	f
5795	310	10	\N	0	0	0	0	0	0	f	f
5796	232	10	\N	0	0	0	0	0	0	f	f
5797	226	10	\N	0	0	0	0	0	0	f	f
5798	248	10	\N	0	0	0	0	0	0	f	f
5799	241	10	\N	0	0	0	0	0	0	f	f
5800	255	10	\N	0	0	0	0	0	0	f	f
5801	221	10	\N	0	0	0	0	0	0	f	f
5802	230	10	\N	0	0	0	0	0	0	f	f
5803	211	10	\N	0	0	0	0	0	0	f	f
5804	244	10	\N	0	0	0	0	0	0	f	f
5805	245	10	\N	0	0	0	0	0	0	f	f
5806	273	10	\N	0	0	0	0	0	0	f	f
5807	210	10	\N	0	0	0	0	0	0	f	f
5808	240	10	\N	0	0	0	0	0	0	f	f
5809	264	10	\N	0	0	0	0	0	0	f	f
5810	223	10	\N	0	0	0	0	0	0	f	f
5811	214	10	\N	0	0	0	0	0	0	f	f
5812	215	10	\N	0	0	0	0	0	0	f	f
5813	228	10	\N	0	0	0	0	0	0	f	f
5814	222	10	\N	0	0	0	0	0	0	f	f
5815	253	10	\N	0	0	0	0	0	0	f	f
5816	254	10	\N	0	0	0	0	0	0	f	f
5817	225	10	\N	0	0	0	0	0	0	f	f
5818	233	10	\N	0	0	0	0	0	0	f	f
5819	418	10	\N	0	0	0	0	0	0	f	f
5820	375	10	\N	0	0	0	0	0	0	f	f
5821	343	10	\N	0	0	0	0	0	0	f	f
5822	367	10	\N	0	0	0	0	0	0	f	f
5823	337	10	\N	0	0	0	0	0	0	f	f
5824	390	10	\N	0	0	0	0	0	0	f	f
5825	382	10	\N	0	0	0	0	0	0	f	f
5826	414	10	\N	0	0	0	0	0	0	f	f
5827	380	10	\N	0	0	0	0	0	0	f	f
5828	385	10	\N	0	0	0	0	0	0	f	f
5829	412	10	\N	0	0	0	0	0	0	f	f
5830	347	10	\N	0	0	0	0	0	0	f	f
5831	371	10	\N	0	0	0	0	0	0	f	f
5832	379	10	\N	0	0	0	0	0	0	f	f
5833	400	10	\N	0	0	0	0	0	0	f	f
5834	369	10	\N	0	0	0	0	0	0	f	f
5835	394	10	\N	0	0	0	0	0	0	f	f
5836	338	10	\N	0	0	0	0	0	0	f	f
5837	416	10	\N	0	0	0	0	0	0	f	f
5838	399	10	\N	0	0	0	0	0	0	f	f
5839	391	10	\N	0	0	0	0	0	0	f	f
5840	411	10	\N	0	0	0	0	0	0	f	f
5841	351	10	\N	0	0	0	0	0	0	f	f
5842	237	10	\N	0	0	0	0	0	0	f	f
5843	431	10	\N	0	0	0	0	0	0	f	f
5844	429	10	\N	0	0	0	0	0	0	f	f
5845	522	10	\N	0	0	0	0	0	0	f	f
5846	523	10	\N	0	0	0	0	0	0	f	f
5847	446	10	\N	0	0	0	0	0	0	f	f
5848	455	10	\N	0	0	0	0	0	0	f	f
5849	514	10	\N	0	0	0	0	0	0	f	f
5850	495	10	\N	0	0	0	0	0	0	f	f
5851	486	10	\N	0	0	0	0	0	0	f	f
5852	428	10	\N	0	0	0	0	0	0	f	f
5853	438	10	\N	0	0	0	0	0	0	f	f
5854	441	10	\N	0	0	0	0	0	0	f	f
5855	437	10	\N	0	0	0	0	0	0	f	f
5856	452	10	\N	0	0	0	0	0	0	f	f
5857	425	10	\N	0	0	0	0	0	0	f	f
5858	426	10	\N	0	0	0	0	0	0	f	f
5859	430	10	\N	0	0	0	0	0	0	f	f
5860	420	10	\N	0	0	0	0	0	0	f	f
5861	427	10	\N	0	0	0	0	0	0	f	f
5862	484	10	\N	0	0	0	0	0	0	f	f
5863	504	10	\N	0	0	0	0	0	0	f	f
5864	434	10	\N	0	0	0	0	0	0	f	f
5865	435	10	\N	0	0	0	0	0	0	f	f
5866	219	10	\N	0	0	0	0	0	0	f	f
5867	530	10	\N	0	0	0	0	0	0	f	f
5868	540	10	\N	0	0	0	0	0	0	f	f
5869	541	10	\N	0	0	0	0	0	0	f	f
5870	43	10	\N	0	0	0	0	0	0	f	f
5871	44	10	\N	0	0	0	0	0	0	f	f
5872	236	10	\N	0	0	0	0	0	0	f	f
5873	217	10	\N	0	0	0	0	0	0	f	f
5874	417	10	\N	0	0	0	0	0	0	f	f
5875	363	10	\N	0	0	0	0	0	0	f	f
5876	491	10	\N	0	0	0	0	0	0	f	f
5877	229	10	\N	0	0	0	0	0	0	f	f
5878	55	10	\N	0	0	0	0	0	0	f	f
5879	247	10	\N	0	0	0	0	0	0	f	f
5880	421	10	\N	0	0	0	0	0	0	f	f
5881	422	10	\N	0	0	0	0	0	0	f	f
5882	246	10	\N	0	0	0	0	0	0	f	f
5883	303	10	\N	0	0	0	0	0	0	f	f
5884	527	10	\N	0	0	0	0	0	0	f	f
5885	538	10	\N	0	0	0	0	0	0	f	f
5886	48	10	\N	0	0	0	0	0	0	f	f
5887	177	10	\N	0	0	0	0	0	0	f	f
5888	258	10	\N	0	0	0	0	0	0	f	f
5889	388	10	\N	0	0	0	0	0	0	f	f
5890	260	10	\N	0	0	0	0	0	0	f	f
5891	34	10	\N	0	0	0	0	0	0	f	f
5892	159	10	\N	0	0	0	0	0	0	f	f
5893	436	10	\N	0	0	0	0	0	0	f	f
5894	498	10	\N	0	0	0	0	0	0	f	f
5895	532	10	\N	0	0	0	0	0	0	f	f
5896	542	10	\N	0	0	0	0	0	0	f	f
5897	543	10	\N	0	0	0	0	0	0	f	f
5898	528	10	\N	0	0	0	0	0	0	f	f
5899	49	10	\N	0	0	0	0	0	0	f	f
5900	239	10	\N	0	0	0	0	0	0	f	f
5901	178	10	\N	0	0	0	0	0	0	f	f
5902	476	10	\N	0	0	0	0	0	0	f	f
5903	60	10	\N	0	0	0	0	0	0	f	f
5904	57	10	\N	0	0	0	0	0	0	f	f
5905	198	10	\N	0	0	0	0	0	0	f	f
5906	131	10	\N	0	0	0	0	0	0	f	f
5907	524	10	\N	0	0	0	0	0	0	f	f
5908	39	10	\N	0	0	0	0	0	0	f	f
5909	59	10	\N	0	0	0	0	0	0	f	f
5910	440	10	\N	0	0	0	0	0	0	f	f
5911	398	10	\N	0	0	0	0	0	0	f	f
5912	507	10	\N	0	0	0	0	0	0	f	f
5913	442	10	\N	0	0	0	0	0	0	f	f
5914	25	10	\N	0	0	0	0	0	0	f	f
5915	87	10	\N	0	0	0	0	0	0	f	f
5916	109	10	\N	0	0	0	0	0	0	f	f
5917	234	10	\N	0	0	0	0	0	0	f	f
5918	535	10	\N	0	0	0	0	0	0	f	f
5919	322	10	\N	0	0	0	0	0	0	f	f
5920	53	10	\N	0	0	0	0	0	0	f	f
5921	251	10	\N	0	0	0	0	0	0	f	f
5922	167	10	\N	0	0	0	0	0	0	f	f
5923	346	10	\N	0	0	0	0	0	0	f	f
5924	32	10	\N	0	0	0	0	0	0	f	f
5925	158	10	\N	0	0	0	0	0	0	f	f
5926	132	10	\N	0	0	0	0	0	0	f	f
5927	200	10	\N	0	0	0	0	0	0	f	f
5928	364	10	\N	0	0	0	0	0	0	f	f
5929	209	10	\N	0	0	0	0	0	0	f	f
5930	123	10	\N	0	0	0	0	0	0	f	f
5931	519	10	\N	0	0	0	0	0	0	f	f
5932	38	10	\N	0	0	0	0	0	0	f	f
5933	256	10	\N	0	0	0	0	0	0	f	f
5934	190	10	\N	0	0	0	0	0	0	f	f
5935	213	10	\N	0	0	0	0	0	0	f	f
5936	415	10	\N	0	0	0	0	0	0	f	f
5937	249	10	\N	0	0	0	0	0	0	f	f
5938	203	10	\N	0	0	0	0	0	0	f	f
5939	407	10	\N	0	0	0	0	0	0	f	f
5940	439	10	\N	0	0	0	0	0	0	f	f
5941	539	10	\N	0	0	0	0	0	0	f	f
5942	181	10	\N	0	0	0	0	0	0	f	f
5943	252	10	\N	0	0	0	0	0	0	f	f
5944	309	10	\N	0	0	0	0	0	0	f	f
5945	424	10	\N	0	0	0	0	0	0	f	f
5946	41	10	\N	0	0	0	0	0	0	f	f
5947	136	10	\N	0	0	0	0	0	0	f	f
5948	259	10	\N	0	0	0	0	0	0	f	f
5949	163	10	\N	0	0	0	0	0	0	f	f
5950	445	10	\N	0	0	0	0	0	0	f	f
5951	257	10	\N	0	0	0	0	0	0	f	f
5952	419	10	\N	0	0	0	0	0	0	f	f
5953	432	10	\N	0	0	0	0	0	0	f	f
5954	64	10	\N	0	0	0	0	0	0	f	f
5955	188	10	\N	0	0	0	0	0	0	f	f
5956	212	10	\N	0	0	0	0	0	0	f	f
5957	395	10	\N	0	0	0	0	0	0	f	f
5958	533	10	\N	0	0	0	0	0	0	f	f
5959	511	10	\N	0	0	0	0	0	0	f	f
5960	23	10	\N	0	0	0	0	0	0	f	f
5961	50	10	\N	0	0	0	0	0	0	f	f
5962	443	10	\N	0	0	0	0	0	0	f	f
5963	372	10	\N	0	0	0	0	0	0	f	f
5964	31	10	\N	0	0	0	0	0	0	f	f
5965	185	10	\N	0	0	0	0	0	0	f	f
5966	243	10	\N	0	0	0	0	0	0	f	f
5967	242	10	\N	0	0	0	0	0	0	f	f
5968	368	10	\N	0	0	0	0	0	0	f	f
5969	536	10	\N	0	0	0	0	0	0	f	f
5970	63	10	\N	0	0	0	0	0	0	f	f
5971	231	10	\N	0	0	0	0	0	0	f	f
5972	86	10	\N	0	0	0	0	0	0	f	f
5973	331	10	\N	0	0	0	0	0	0	f	f
5974	5	11	5.00	0	3	0	0	0	0	f	f
5975	120	11	5.00	0	0	0	0	0	0	f	f
5976	156	11	5.00	0	0	0	0	0	0	f	f
5977	94	11	5.00	0	0	0	0	0	0	f	f
5978	93	11	5.50	0	0	0	0	0	0	f	f
5979	157	11	4.50	0	0	0	0	0	0	f	f
5980	158	11	5.00	0	0	0	0	0	0	f	f
5981	296	11	4.50	0	0	0	0	0	0	f	f
5982	276	11	4.50	0	0	0	0	0	0	f	f
5983	312	11	6.00	0	0	0	0	0	0	f	f
5984	329	11	5.50	0	0	0	0	0	0	f	f
5985	454	11	5.50	0	0	0	0	0	0	f	f
5986	462	11	5.00	0	0	0	0	0	0	f	f
5987	482	11	6.00	0	0	0	0	0	0	f	f
5988	459	11	5.50	0	0	0	0	0	0	f	f
5989	465	11	5.00	0	0	0	0	0	0	f	f
5990	9	11	6.00	0	0	0	0	0	0	f	f
5991	29	11	6.00	0	0	0	0	0	0	f	f
5992	85	11	6.50	0	0	0	0	0	0	f	f
5993	208	11	6.00	0	0	0	0	0	0	f	f
5994	73	11	7.00	0	0	0	0	0	1	f	f
5995	121	11	7.50	1	0	0	0	0	0	f	f
5996	103	11	6.50	0	0	0	0	0	0	f	f
5997	341	11	6.50	0	0	0	0	0	0	f	f
5998	263	11	6.00	0	0	0	0	0	0	t	f
5999	269	11	6.00	0	0	0	0	0	0	f	f
6000	311	11	6.50	0	0	0	0	0	0	f	f
6001	346	11	6.50	0	0	0	0	0	0	f	f
6002	323	11	6.00	0	0	0	0	0	0	f	f
6003	336	11	6.00	0	0	0	0	0	0	f	f
6004	458	11	7.00	0	0	0	0	0	1	f	f
6005	489	11	7.00	1	0	0	0	0	0	f	f
6006	10	11	7.00	0	0	0	0	0	0	f	f
6007	96	11	6.50	0	0	0	0	0	0	f	f
6008	97	11	7.00	0	0	0	0	0	0	f	f
6009	133	11	6.00	0	0	0	0	0	0	f	f
6010	159	11	5.50	0	0	0	0	0	0	f	f
6011	69	11	6.50	0	0	0	0	0	0	f	f
6012	122	11	6.00	0	0	0	0	0	0	f	f
6013	436	11	6.00	0	0	0	0	0	0	f	f
6014	304	11	6.00	0	0	0	0	0	0	f	f
6015	361	11	5.50	0	0	0	0	0	0	f	f
6016	330	11	5.50	0	0	0	0	0	0	f	f
6017	348	11	6.00	0	0	0	0	0	0	t	f
6018	289	11	5.50	0	0	0	0	0	0	f	f
6019	470	11	5.50	0	0	0	0	0	0	f	f
6020	520	11	5.50	0	0	0	0	0	0	f	f
6021	478	11	5.50	0	0	0	0	0	0	f	f
6022	6	11	6.50	0	0	0	0	0	0	f	f
6023	119	11	6.00	0	0	0	0	0	0	f	f
6024	86	11	6.00	0	0	0	0	0	0	f	f
6025	105	11	6.50	0	0	0	0	0	0	f	f
6026	117	11	6.50	0	0	0	0	0	0	f	f
6027	189	11	6.00	0	0	0	0	0	0	f	f
6028	316	11	6.00	0	0	0	0	0	0	f	f
6029	290	11	5.50	0	0	0	0	0	0	t	f
6030	261	11	6.50	0	0	0	0	0	0	f	f
6031	331	11	5.50	0	0	0	0	0	0	f	f
6032	512	11	4.50	0	0	0	0	0	0	t	f
6033	506	11	5.00	0	0	0	0	0	0	f	f
6034	463	11	5.50	0	0	0	0	0	0	f	f
6035	479	11	6.00	0	0	0	0	0	0	t	f
6036	514	11	6.00	0	0	0	0	0	0	f	f
6037	499	11	6.00	0	0	0	0	0	0	f	f
6038	11	11	6.00	0	1	0	0	0	0	f	f
6039	134	11	6.00	0	0	0	0	0	0	f	f
6040	75	11	6.00	0	0	0	0	0	0	t	f
6041	70	11	5.50	0	0	0	0	0	0	f	f
6042	106	11	5.50	0	0	0	0	0	0	f	f
6043	205	11	5.00	0	0	0	0	0	0	t	f
6044	160	11	6.00	0	0	0	0	0	0	f	f
6045	277	11	6.50	0	0	0	0	0	0	f	f
6046	355	11	6.00	0	0	0	0	0	0	f	f
6047	325	11	5.50	0	0	0	0	0	0	f	f
6048	393	11	6.00	0	0	0	0	0	0	f	f
6049	283	11	6.50	0	0	0	0	0	0	f	f
6050	464	11	6.00	0	0	0	0	0	0	f	f
6051	457	11	5.50	0	0	0	0	0	0	f	f
6052	526	11	6.00	0	0	0	0	0	0	f	f
6053	17	11	6.50	0	2	1	0	0	0	f	f
6054	124	11	5.00	0	0	0	0	0	0	t	f
6055	190	11	6.00	0	0	0	0	0	0	f	f
6056	191	11	6.00	0	0	0	0	0	0	f	f
6057	175	11	5.50	0	0	0	0	0	0	t	f
6058	213	11	6.00	0	0	0	0	0	0	f	f
6059	161	11	5.50	0	0	0	0	0	0	t	f
6060	162	11	6.50	0	0	0	0	0	0	f	f
6061	274	11	5.50	0	0	0	0	0	0	f	f
6062	392	11	5.50	0	0	0	0	0	0	f	f
6063	366	11	6.50	0	0	0	0	0	1	f	f
6064	297	11	7.00	0	0	0	0	0	0	f	f
6065	377	11	6.00	0	0	0	0	0	0	f	f
6066	396	11	6.00	0	0	0	0	0	0	f	f
6067	515	11	6.00	0	0	0	0	0	0	f	f
6068	505	11	7.00	1	0	0	0	0	0	f	f
6069	18	11	6.50	0	2	0	0	0	0	f	f
6070	74	11	6.50	0	0	0	0	0	1	t	f
6071	98	11	5.50	0	0	0	0	0	0	f	f
6072	92	11	7.00	1	0	0	0	0	0	f	f
6073	192	11	5.00	0	0	0	0	0	0	f	f
6074	135	11	6.00	0	0	0	0	0	0	f	f
6075	298	11	6.00	0	0	0	0	0	0	f	f
6076	342	11	6.00	0	0	0	0	0	0	f	f
6077	318	11	5.50	0	0	0	0	0	0	t	f
6078	379	11	6.00	0	0	0	0	0	0	f	f
6079	349	11	6.00	0	0	0	0	0	0	f	f
6080	508	11	5.50	1	0	0	1	0	0	f	f
6081	490	11	5.50	0	0	0	0	0	0	f	f
6082	507	11	6.00	0	0	0	0	0	0	f	f
6083	13	11	6.00	0	0	0	0	0	0	f	f
6084	66	11	7.00	0	0	0	0	0	1	f	f
6085	136	11	6.00	0	0	0	0	0	0	f	f
6086	67	11	6.50	0	0	0	0	0	1	f	f
6087	104	11	6.00	0	0	0	0	0	0	t	f
6088	82	11	5.50	0	0	0	0	0	0	t	f
6089	81	11	6.50	0	0	0	0	0	0	f	f
6090	300	11	6.50	0	0	0	0	0	0	f	f
6091	270	11	6.50	0	0	0	0	0	0	f	f
6092	262	11	6.50	0	0	0	0	0	0	f	f
6093	352	11	6.00	0	0	0	0	0	0	f	f
6094	299	11	6.00	0	0	0	0	0	0	t	f
6095	444	11	7.00	1	0	0	0	0	0	f	f
6096	445	11	6.00	0	0	0	0	0	0	f	f
6097	474	11	7.00	1	0	0	0	0	0	f	f
6098	475	11	6.00	0	0	0	0	0	0	f	f
6099	7	11	6.50	0	0	0	0	0	0	f	f
6100	216	11	6.00	0	0	0	0	0	0	f	f
6101	88	11	6.50	0	0	0	0	0	0	f	f
6102	99	11	5.50	0	0	0	0	0	0	f	f
6103	138	11	6.00	0	0	0	0	0	0	f	f
6104	307	11	6.00	0	0	0	0	0	0	f	f
6105	332	11	6.00	0	0	0	0	0	0	f	f
6106	291	11	6.50	0	0	0	0	0	0	f	f
6107	353	11	6.00	0	0	0	0	0	0	f	f
6108	322	11	6.00	0	0	0	0	0	0	f	f
6109	410	11	6.00	0	0	0	0	0	0	f	f
6110	278	11	6.00	0	0	0	0	0	0	f	f
6111	461	11	5.50	0	0	0	0	0	0	f	f
6112	480	11	5.50	0	0	0	0	0	0	f	f
6113	477	11	6.00	0	0	0	0	0	0	f	f
6114	446	11	6.00	0	0	0	0	0	0	f	f
6115	3	11	6.00	0	2	0	0	0	0	f	f
6116	126	11	5.00	0	0	0	0	0	0	f	f
6117	110	11	5.50	0	0	0	0	0	0	f	f
6118	195	11	5.50	0	0	0	0	0	0	f	f
6119	144	11	6.00	0	0	0	0	0	0	f	f
6120	125	11	5.50	0	0	0	0	0	0	f	f
6121	176	11	6.00	0	0	0	0	0	0	f	f
6122	362	11	6.00	0	0	0	0	0	0	f	f
6123	301	11	5.00	0	0	0	0	0	0	f	f
6124	267	11	6.50	0	0	0	0	0	0	t	f
6125	292	11	5.50	0	0	0	0	0	0	f	f
6126	284	11	6.00	0	0	0	0	0	0	f	f
6127	285	11	5.50	0	0	0	0	0	0	f	f
6128	516	11	6.00	0	0	0	0	0	0	f	f
6129	494	11	5.50	0	0	0	0	0	0	f	f
6130	492	11	5.50	0	0	0	0	0	0	f	f
6131	8	11	6.00	0	0	0	0	0	0	f	f
6132	127	11	7.00	0	0	0	0	0	0	f	f
6133	164	11	6.00	0	0	0	0	0	0	f	f
6134	89	11	6.50	0	0	0	0	0	0	f	f
6135	146	11	6.00	0	0	0	0	0	0	f	f
6136	310	11	6.50	0	0	0	0	0	0	f	f
6137	293	11	5.50	0	0	0	0	0	0	t	f
6138	286	11	6.00	0	0	0	0	0	0	f	f
6139	354	11	6.00	0	0	0	0	0	0	f	f
6140	401	11	6.00	0	0	0	0	0	0	f	f
6141	333	11	5.50	0	0	0	0	0	0	f	f
6142	381	11	5.00	0	0	0	0	0	0	f	f
6143	501	11	6.00	0	0	0	0	0	0	f	f
6144	509	11	6.00	0	0	0	0	0	0	f	f
6145	513	11	5.50	0	0	0	0	0	0	f	f
6146	1	11	6.00	0	2	0	0	0	0	f	f
6147	111	11	6.00	0	0	0	0	0	0	f	f
6148	68	11	5.50	0	0	0	0	0	0	f	f
6149	177	11	5.00	0	0	0	0	0	0	f	f
6150	193	11	5.50	0	0	0	0	0	0	f	f
6151	90	11	6.00	0	0	0	0	0	0	f	f
6152	184	11	6.00	0	0	0	0	0	0	f	f
6153	260	11	5.50	0	0	0	0	0	0	f	f
6154	268	11	6.00	0	0	0	0	0	0	t	f
6155	302	11	6.00	0	0	0	0	0	0	f	f
6156	313	11	5.00	0	0	0	0	0	0	f	f
6157	271	11	7.00	1	0	0	0	0	0	f	f
6158	294	11	5.50	0	0	0	0	0	0	f	f
6159	447	11	7.00	0	0	0	0	0	0	f	f
6160	485	11	6.00	0	0	0	0	0	1	f	f
6161	4	11	5.50	0	2	0	0	0	0	f	f
6162	196	11	6.00	0	0	0	0	0	0	f	f
6163	83	11	5.50	0	0	0	0	0	0	f	f
6164	113	11	5.00	0	0	0	0	0	0	f	f
6165	140	11	5.00	0	0	0	0	0	0	f	f
6166	201	11	5.50	0	0	0	0	0	0	f	f
6167	178	11	6.00	0	0	0	0	0	0	f	f
6168	319	11	5.00	0	0	0	0	0	0	f	f
6169	266	11	5.50	0	0	0	0	0	0	f	f
6170	356	11	5.50	0	0	0	0	0	0	f	f
6171	360	11	5.00	0	0	0	0	0	0	f	f
6172	265	11	5.50	0	0	0	0	0	0	f	f
6173	279	11	5.50	0	0	0	0	0	0	t	f
6174	450	11	5.00	0	0	0	0	0	0	t	f
6175	510	11	6.00	0	0	0	0	0	0	f	f
6176	483	11	5.50	0	0	0	0	0	0	t	f
6177	16	11	5.50	0	2	0	0	0	0	f	f
6178	147	11	6.50	0	0	0	0	0	0	f	f
6179	116	11	6.00	0	0	0	0	0	0	f	f
6180	115	11	7.50	1	0	0	0	0	0	f	f
6181	220	11	5.50	0	0	0	0	0	0	f	f
6182	224	11	5.00	0	0	0	0	0	0	f	f
6183	226	11	6.50	0	0	0	0	0	0	f	f
6184	143	11	7.00	0	0	0	0	0	2	f	f
6185	405	11	6.00	0	0	0	0	0	0	f	f
6186	280	11	7.00	1	0	0	0	0	0	f	f
6187	365	11	5.50	0	0	0	0	0	0	f	f
6188	359	11	5.50	0	0	0	0	0	0	t	f
6189	443	11	6.00	0	0	0	0	0	0	f	f
6190	493	11	6.00	0	0	0	0	0	0	f	f
6191	456	11	6.50	0	0	0	0	0	0	f	f
6192	14	11	6.50	0	0	0	0	0	0	f	f
6193	102	11	6.00	0	0	0	0	0	0	f	f
6194	148	11	6.50	0	0	0	0	0	0	f	f
6195	166	11	5.50	0	0	0	0	0	0	f	f
6196	165	11	6.00	0	0	0	0	0	0	f	f
6197	344	11	6.50	0	0	0	0	0	0	f	f
6198	368	11	6.50	0	0	0	0	0	1	f	f
6199	373	11	6.00	0	0	0	0	0	0	t	f
6200	324	11	6.50	0	0	0	0	0	0	f	f
6201	382	11	6.00	0	0	0	0	0	0	t	f
6202	320	11	7.00	1	0	0	0	0	0	f	f
6203	383	11	6.00	0	0	0	0	0	0	t	f
6204	406	11	6.00	0	0	0	0	0	0	t	f
6205	472	11	6.00	0	0	0	0	0	0	f	f
6206	487	11	5.50	0	0	0	0	0	0	f	f
6207	517	11	6.00	0	0	0	0	0	0	f	f
6208	2	11	6.50	0	0	0	0	0	0	f	f
6209	100	11	6.50	0	0	0	0	0	1	f	f
6210	130	11	6.00	0	0	0	0	0	0	f	f
6211	76	11	7.00	1	0	0	0	0	0	f	f
6212	84	11	6.50	0	0	0	0	0	0	f	f
6213	251	11	6.00	0	0	0	0	0	0	f	f
6214	72	11	6.00	0	0	0	0	0	0	f	f
6215	227	11	6.00	0	0	0	0	0	0	f	f
6216	275	11	7.00	0	0	0	0	0	0	t	f
6217	295	11	6.50	0	0	0	0	0	0	t	f
6218	369	11	6.00	0	0	0	0	0	0	f	f
6219	281	11	6.50	0	0	0	0	0	0	f	f
6220	384	11	6.00	0	0	0	0	0	0	f	f
6221	357	11	6.00	0	0	0	0	0	0	f	f
6222	448	11	6.00	0	0	0	0	0	0	f	f
6223	471	11	6.00	0	0	0	0	0	0	f	f
6224	15	11	6.50	0	0	0	0	0	0	t	f
6225	142	11	6.50	0	0	0	0	0	0	f	f
6226	150	11	6.00	0	0	0	0	0	0	f	f
6227	118	11	7.00	0	0	0	0	0	0	f	f
6228	199	11	6.50	0	0	0	0	0	0	t	f
6229	149	11	6.50	0	0	0	0	0	0	f	f
6230	315	11	7.00	0	0	0	0	0	0	f	f
6231	314	11	6.50	0	0	0	0	0	1	f	f
6232	287	11	7.00	0	0	0	0	0	0	f	f
6233	308	11	5.50	0	0	0	0	0	0	f	f
6234	385	11	6.00	0	0	0	0	0	0	f	f
6235	449	11	8.50	1	0	0	0	0	1	f	f
6236	527	11	6.00	0	0	0	0	0	0	f	f
6237	467	11	7.50	1	0	0	0	0	0	f	f
6238	453	11	6.00	0	0	0	0	0	0	f	f
6239	518	11	6.00	0	0	0	0	0	0	f	f
6240	22	11	7.00	0	0	0	0	0	0	f	f
6241	152	11	6.00	0	0	0	0	0	0	f	f
6242	91	11	7.00	0	0	0	0	0	0	f	f
6243	151	11	7.00	0	0	0	0	0	0	f	f
6244	168	11	6.00	0	0	0	0	0	0	f	f
6245	77	11	6.50	0	0	0	0	0	0	f	f
6246	370	11	6.00	0	0	0	0	0	0	f	f
6247	387	11	6.00	0	0	0	0	0	0	f	f
6248	288	11	6.00	0	0	0	0	0	0	f	f
6249	399	11	6.00	0	0	0	0	0	0	t	f
6250	358	11	6.00	0	0	0	0	0	0	f	f
6251	407	11	6.00	0	0	0	0	0	0	f	f
6252	496	11	6.00	0	0	0	0	0	0	f	f
6253	466	11	6.00	0	0	0	0	0	0	f	f
6254	488	11	6.00	0	0	0	0	0	0	f	f
6255	468	11	6.00	0	0	0	0	0	0	f	f
6256	19	11	6.00	0	2	0	0	0	0	f	f
6257	78	11	5.50	0	0	0	0	0	0	f	f
6258	128	11	5.50	0	0	0	0	0	0	f	f
6259	154	11	5.00	0	0	0	0	0	0	f	f
6260	153	11	5.50	0	0	0	0	0	0	f	f
6261	197	11	6.00	0	0	0	0	0	0	f	f
6262	250	11	5.50	0	0	0	0	0	0	f	f
6263	101	11	5.50	0	0	0	0	0	0	f	f
6264	272	11	5.00	0	0	0	0	0	0	f	f
6265	321	11	6.00	0	0	0	0	0	0	t	f
6266	326	11	5.50	0	0	0	0	0	0	f	f
6267	282	11	5.50	0	0	0	0	0	0	f	f
6268	328	11	6.00	0	0	0	0	0	0	f	f
6269	452	11	6.00	0	0	0	0	0	0	f	f
6270	525	11	6.00	0	0	0	0	0	0	f	f
6271	497	11	5.50	0	0	0	0	0	0	f	f
6272	12	11	7.00	0	0	0	0	0	0	f	f
6273	155	11	6.50	0	0	0	0	0	0	t	f
6274	183	11	6.00	0	0	0	0	0	0	t	f
6275	182	11	6.50	0	0	0	0	0	0	t	f
6276	169	11	6.50	0	0	0	0	0	0	f	f
6277	79	11	6.50	0	0	0	0	0	0	f	f
6278	170	11	6.00	0	0	0	0	0	0	f	f
6279	345	11	5.50	0	0	0	0	0	0	f	f
6280	413	11	6.00	0	0	0	0	0	0	t	f
6281	408	11	6.00	0	0	0	0	0	0	f	f
6282	409	11	5.00	0	0	0	0	0	0	f	f
6283	327	11	5.50	0	0	0	0	0	0	f	f
6284	521	11	5.50	0	0	0	0	0	0	f	f
6285	473	11	6.00	0	0	0	0	0	0	f	f
6286	469	11	5.50	0	0	0	0	0	0	f	f
6287	46	11	\N	0	0	0	0	0	0	f	f
6288	35	11	\N	0	0	0	0	0	0	f	f
6289	37	11	\N	0	0	0	0	0	0	f	f
6290	24	11	\N	0	0	0	0	0	0	f	f
6291	51	11	\N	0	0	0	0	0	0	f	f
6292	36	11	\N	0	0	0	0	0	0	f	f
6293	80	11	\N	0	0	0	0	0	0	f	f
6294	54	11	\N	0	0	0	0	0	0	f	f
6295	47	11	\N	0	0	0	0	0	0	f	f
6296	21	11	\N	0	0	0	0	0	0	f	f
6297	71	11	\N	0	0	0	0	0	0	f	f
6298	27	11	\N	0	0	0	0	0	0	f	f
6299	40	11	\N	0	0	0	0	0	0	f	f
6300	42	11	\N	0	0	0	0	0	0	f	f
6301	52	11	\N	0	0	0	0	0	0	f	f
6302	33	11	\N	0	0	0	0	0	0	f	f
6303	20	11	\N	0	0	0	0	0	0	f	f
6304	28	11	\N	0	0	0	0	0	0	f	f
6305	61	11	\N	0	0	0	0	0	0	f	f
6306	26	11	\N	0	0	0	0	0	0	f	f
6307	56	11	\N	0	0	0	0	0	0	f	f
6308	58	11	\N	0	0	0	0	0	0	f	f
6309	62	11	\N	0	0	0	0	0	0	f	f
6310	65	11	\N	0	0	0	0	0	0	f	f
6311	30	11	\N	0	0	0	0	0	0	f	f
6312	45	11	\N	0	0	0	0	0	0	f	f
6313	172	11	\N	0	0	0	0	0	0	f	f
6314	129	11	\N	0	0	0	0	0	0	f	f
6315	186	11	\N	0	0	0	0	0	0	f	f
6316	171	11	\N	0	0	0	0	0	0	f	f
6317	173	11	\N	0	0	0	0	0	0	f	f
6318	145	11	\N	0	0	0	0	0	0	f	f
6319	204	11	\N	0	0	0	0	0	0	f	f
6320	112	11	\N	0	0	0	0	0	0	f	f
6321	180	11	\N	0	0	0	0	0	0	f	f
6322	108	11	\N	0	0	0	0	0	0	f	f
6323	141	11	\N	0	0	0	0	0	0	f	f
6324	202	11	\N	0	0	0	0	0	0	f	f
6325	207	11	\N	0	0	0	0	0	0	f	f
6326	187	11	\N	0	0	0	0	0	0	f	f
6327	174	11	\N	0	0	0	0	0	0	f	f
6328	107	11	\N	0	0	0	0	0	0	f	f
6329	137	11	\N	0	0	0	0	0	0	f	f
6330	218	11	\N	0	0	0	0	0	0	f	f
6331	238	11	\N	0	0	0	0	0	0	f	f
6332	235	11	\N	0	0	0	0	0	0	f	f
6333	232	11	\N	0	0	0	0	0	0	f	f
6334	248	11	\N	0	0	0	0	0	0	f	f
6335	241	11	\N	0	0	0	0	0	0	f	f
6336	255	11	\N	0	0	0	0	0	0	f	f
6337	221	11	\N	0	0	0	0	0	0	f	f
6338	230	11	\N	0	0	0	0	0	0	f	f
6339	211	11	\N	0	0	0	0	0	0	f	f
6340	244	11	\N	0	0	0	0	0	0	f	f
6341	245	11	\N	0	0	0	0	0	0	f	f
6342	273	11	\N	0	0	0	0	0	0	f	f
6343	210	11	\N	0	0	0	0	0	0	f	f
6344	240	11	\N	0	0	0	0	0	0	f	f
6345	264	11	\N	0	0	0	0	0	0	f	f
6346	223	11	\N	0	0	0	0	0	0	f	f
6347	214	11	\N	0	0	0	0	0	0	f	f
6348	215	11	\N	0	0	0	0	0	0	f	f
6349	228	11	\N	0	0	0	0	0	0	f	f
6350	222	11	\N	0	0	0	0	0	0	f	f
6351	253	11	\N	0	0	0	0	0	0	f	f
6352	254	11	\N	0	0	0	0	0	0	f	f
6353	225	11	\N	0	0	0	0	0	0	f	f
6354	233	11	\N	0	0	0	0	0	0	f	f
6355	402	11	\N	0	0	0	0	0	0	f	f
6356	418	11	\N	0	0	0	0	0	0	f	f
6357	375	11	\N	0	0	0	0	0	0	f	f
6358	343	11	\N	0	0	0	0	0	0	f	f
6359	367	11	\N	0	0	0	0	0	0	f	f
6360	404	11	\N	0	0	0	0	0	0	f	f
6361	337	11	\N	0	0	0	0	0	0	f	f
6362	390	11	\N	0	0	0	0	0	0	f	f
6363	414	11	\N	0	0	0	0	0	0	f	f
6364	378	11	\N	0	0	0	0	0	0	f	f
6365	380	11	\N	0	0	0	0	0	0	f	f
6366	412	11	\N	0	0	0	0	0	0	f	f
6367	347	11	\N	0	0	0	0	0	0	f	f
6368	371	11	\N	0	0	0	0	0	0	f	f
6369	397	11	\N	0	0	0	0	0	0	f	f
6370	400	11	\N	0	0	0	0	0	0	f	f
6371	339	11	\N	0	0	0	0	0	0	f	f
6372	394	11	\N	0	0	0	0	0	0	f	f
6373	338	11	\N	0	0	0	0	0	0	f	f
6374	340	11	\N	0	0	0	0	0	0	f	f
6375	376	11	\N	0	0	0	0	0	0	f	f
6376	416	11	\N	0	0	0	0	0	0	f	f
6377	386	11	\N	0	0	0	0	0	0	f	f
6378	391	11	\N	0	0	0	0	0	0	f	f
6379	411	11	\N	0	0	0	0	0	0	f	f
6380	351	11	\N	0	0	0	0	0	0	f	f
6381	237	11	\N	0	0	0	0	0	0	f	f
6382	431	11	\N	0	0	0	0	0	0	f	f
6383	429	11	\N	0	0	0	0	0	0	f	f
6384	433	11	\N	0	0	0	0	0	0	f	f
6385	522	11	\N	0	0	0	0	0	0	f	f
6386	523	11	\N	0	0	0	0	0	0	f	f
6387	502	11	\N	0	0	0	0	0	0	f	f
6388	455	11	\N	0	0	0	0	0	0	f	f
6389	495	11	\N	0	0	0	0	0	0	f	f
6390	486	11	\N	0	0	0	0	0	0	f	f
6391	428	11	\N	0	0	0	0	0	0	f	f
6392	438	11	\N	0	0	0	0	0	0	f	f
6393	441	11	\N	0	0	0	0	0	0	f	f
6394	437	11	\N	0	0	0	0	0	0	f	f
6395	425	11	\N	0	0	0	0	0	0	f	f
6396	426	11	\N	0	0	0	0	0	0	f	f
6397	500	11	\N	0	0	0	0	0	0	f	f
6398	430	11	\N	0	0	0	0	0	0	f	f
6399	420	11	\N	0	0	0	0	0	0	f	f
6400	481	11	\N	0	0	0	0	0	0	f	f
6401	427	11	\N	0	0	0	0	0	0	f	f
6402	484	11	\N	0	0	0	0	0	0	f	f
6403	504	11	\N	0	0	0	0	0	0	f	f
6404	434	11	\N	0	0	0	0	0	0	f	f
6405	435	11	\N	0	0	0	0	0	0	f	f
6406	529	11	\N	0	0	0	0	0	0	f	f
6407	531	11	\N	0	0	0	0	0	0	f	f
6408	219	11	\N	0	0	0	0	0	0	f	f
6409	530	11	\N	0	0	0	0	0	0	f	f
6410	540	11	\N	0	0	0	0	0	0	f	f
6411	541	11	\N	0	0	0	0	0	0	f	f
6412	43	11	\N	0	0	0	0	0	0	f	f
6413	44	11	\N	0	0	0	0	0	0	f	f
6414	236	11	\N	0	0	0	0	0	0	f	f
6415	217	11	\N	0	0	0	0	0	0	f	f
6416	417	11	\N	0	0	0	0	0	0	f	f
6417	363	11	\N	0	0	0	0	0	0	f	f
6418	491	11	\N	0	0	0	0	0	0	f	f
6419	229	11	\N	0	0	0	0	0	0	f	f
6420	55	11	\N	0	0	0	0	0	0	f	f
6421	206	11	\N	0	0	0	0	0	0	f	f
6422	247	11	\N	0	0	0	0	0	0	f	f
6423	421	11	\N	0	0	0	0	0	0	f	f
6424	422	11	\N	0	0	0	0	0	0	f	f
6425	246	11	\N	0	0	0	0	0	0	f	f
6426	303	11	\N	0	0	0	0	0	0	f	f
6427	389	11	\N	0	0	0	0	0	0	f	f
6428	538	11	\N	0	0	0	0	0	0	f	f
6429	48	11	\N	0	0	0	0	0	0	f	f
6430	258	11	\N	0	0	0	0	0	0	f	f
6431	139	11	\N	0	0	0	0	0	0	f	f
6432	388	11	\N	0	0	0	0	0	0	f	f
6433	34	11	\N	0	0	0	0	0	0	f	f
6434	498	11	\N	0	0	0	0	0	0	f	f
6435	534	11	\N	0	0	0	0	0	0	f	f
6436	532	11	\N	0	0	0	0	0	0	f	f
6437	542	11	\N	0	0	0	0	0	0	f	f
6438	543	11	\N	0	0	0	0	0	0	f	f
6439	528	11	\N	0	0	0	0	0	0	f	f
6440	49	11	\N	0	0	0	0	0	0	f	f
6441	239	11	\N	0	0	0	0	0	0	f	f
6442	334	11	\N	0	0	0	0	0	0	f	f
6443	476	11	\N	0	0	0	0	0	0	f	f
6444	60	11	\N	0	0	0	0	0	0	f	f
6445	57	11	\N	0	0	0	0	0	0	f	f
6446	198	11	\N	0	0	0	0	0	0	f	f
6447	131	11	\N	0	0	0	0	0	0	f	f
6448	423	11	\N	0	0	0	0	0	0	f	f
6449	524	11	\N	0	0	0	0	0	0	f	f
6450	39	11	\N	0	0	0	0	0	0	f	f
6451	59	11	\N	0	0	0	0	0	0	f	f
6452	440	11	\N	0	0	0	0	0	0	f	f
6453	305	11	\N	0	0	0	0	0	0	f	f
6454	398	11	\N	0	0	0	0	0	0	f	f
6455	442	11	\N	0	0	0	0	0	0	f	f
6456	25	11	\N	0	0	0	0	0	0	f	f
6457	87	11	\N	0	0	0	0	0	0	f	f
6458	109	11	\N	0	0	0	0	0	0	f	f
6459	194	11	\N	0	0	0	0	0	0	f	f
6460	234	11	\N	0	0	0	0	0	0	f	f
6461	306	11	\N	0	0	0	0	0	0	f	f
6462	535	11	\N	0	0	0	0	0	0	f	f
6463	53	11	\N	0	0	0	0	0	0	f	f
6464	167	11	\N	0	0	0	0	0	0	f	f
6465	335	11	\N	0	0	0	0	0	0	f	f
6466	32	11	\N	0	0	0	0	0	0	f	f
6467	132	11	\N	0	0	0	0	0	0	f	f
6468	200	11	\N	0	0	0	0	0	0	f	f
6469	364	11	\N	0	0	0	0	0	0	f	f
6470	209	11	\N	0	0	0	0	0	0	f	f
6471	374	11	\N	0	0	0	0	0	0	f	f
6472	537	11	\N	0	0	0	0	0	0	f	f
6473	123	11	\N	0	0	0	0	0	0	f	f
6474	451	11	\N	0	0	0	0	0	0	f	f
6475	519	11	\N	0	0	0	0	0	0	f	f
6476	38	11	\N	0	0	0	0	0	0	f	f
6477	256	11	\N	0	0	0	0	0	0	f	f
6478	415	11	\N	0	0	0	0	0	0	f	f
6479	460	11	\N	0	0	0	0	0	0	f	f
6480	179	11	\N	0	0	0	0	0	0	f	f
6481	249	11	\N	0	0	0	0	0	0	f	f
6482	203	11	\N	0	0	0	0	0	0	f	f
6483	439	11	\N	0	0	0	0	0	0	f	f
6484	539	11	\N	0	0	0	0	0	0	f	f
6485	181	11	\N	0	0	0	0	0	0	f	f
6486	252	11	\N	0	0	0	0	0	0	f	f
6487	309	11	\N	0	0	0	0	0	0	f	f
6488	424	11	\N	0	0	0	0	0	0	f	f
6489	503	11	\N	0	0	0	0	0	0	f	f
6490	41	11	\N	0	0	0	0	0	0	f	f
6491	259	11	\N	0	0	0	0	0	0	f	f
6492	163	11	\N	0	0	0	0	0	0	f	f
6493	350	11	\N	0	0	0	0	0	0	f	f
6494	257	11	\N	0	0	0	0	0	0	f	f
6495	419	11	\N	0	0	0	0	0	0	f	f
6496	432	11	\N	0	0	0	0	0	0	f	f
6497	64	11	\N	0	0	0	0	0	0	f	f
6498	188	11	\N	0	0	0	0	0	0	f	f
6499	212	11	\N	0	0	0	0	0	0	f	f
6500	395	11	\N	0	0	0	0	0	0	f	f
6501	533	11	\N	0	0	0	0	0	0	f	f
6502	511	11	\N	0	0	0	0	0	0	f	f
6503	23	11	\N	0	0	0	0	0	0	f	f
6504	50	11	\N	0	0	0	0	0	0	f	f
6505	114	11	\N	0	0	0	0	0	0	f	f
6506	403	11	\N	0	0	0	0	0	0	f	f
6507	372	11	\N	0	0	0	0	0	0	f	f
6508	31	11	\N	0	0	0	0	0	0	f	f
6509	185	11	\N	0	0	0	0	0	0	f	f
6510	243	11	\N	0	0	0	0	0	0	f	f
6511	242	11	\N	0	0	0	0	0	0	f	f
6512	536	11	\N	0	0	0	0	0	0	f	f
6513	63	11	\N	0	0	0	0	0	0	f	f
6514	231	11	\N	0	0	0	0	0	0	f	f
6515	95	11	\N	0	0	0	0	0	0	f	f
6516	317	11	\N	0	0	0	0	0	0	f	f
6517	5	12	5.50	0	3	0	0	0	0	f	f
6518	120	12	5.50	0	0	0	0	0	0	t	f
6519	156	12	5.00	0	0	0	0	0	0	f	f
6520	94	12	6.00	0	0	0	0	0	1	f	f
6521	93	12	6.00	0	0	0	0	0	0	f	f
6522	157	12	5.00	0	0	0	0	0	0	f	f
6523	158	12	4.50	0	0	0	0	0	0	f	f
6524	338	12	5.50	0	0	0	0	0	0	t	f
6525	296	12	5.00	0	0	0	0	0	0	f	f
6526	394	12	6.00	0	0	0	0	0	0	f	f
6527	276	12	6.00	0	0	0	0	0	0	f	f
6528	312	12	6.00	0	0	0	0	0	0	f	f
6529	329	12	6.00	0	0	0	0	0	0	f	f
6530	454	12	7.00	1	0	0	0	0	0	f	f
6531	462	12	5.50	0	0	0	0	0	0	f	f
6532	459	12	6.00	0	0	0	0	0	0	f	f
6533	20	12	6.50	0	0	0	0	0	0	f	f
6534	188	12	6.00	0	0	0	0	0	0	t	f
6535	123	12	6.00	0	0	0	0	0	0	f	f
6536	85	12	6.50	0	0	0	0	0	0	f	f
6537	208	12	6.50	0	0	0	0	0	0	f	f
6538	103	12	6.50	0	0	0	0	0	0	f	f
6539	341	12	6.50	1	0	0	0	0	0	f	f
6540	263	12	6.00	0	0	0	1	0	1	f	f
6541	269	12	6.00	0	0	0	0	0	0	f	f
6542	311	12	8.00	2	0	0	0	0	0	f	f
6543	427	12	6.00	0	0	0	0	0	0	f	f
6544	323	12	6.00	0	0	0	0	0	0	f	f
6545	374	12	5.50	0	0	0	0	0	0	f	f
6546	451	12	5.50	0	0	0	0	0	0	f	f
6547	489	12	6.00	0	0	0	0	0	0	f	f
6548	519	12	5.50	0	0	0	0	0	0	f	f
6549	10	12	5.00	0	3	0	0	0	0	f	f
6550	96	12	5.50	0	0	0	0	0	0	t	f
6551	97	12	5.50	0	0	0	0	0	0	t	f
6552	133	12	6.00	0	0	0	0	0	1	f	f
6553	69	12	6.50	0	0	0	0	0	1	f	f
6554	122	12	6.00	0	0	0	0	0	0	f	f
6555	347	12	6.50	0	0	0	0	0	1	t	f
6556	304	12	6.00	0	0	0	0	0	0	f	f
6557	361	12	6.00	0	0	0	0	0	0	f	f
6558	330	12	6.00	0	0	0	0	0	0	f	f
6559	348	12	5.50	0	0	0	0	0	0	t	f
6560	289	12	5.50	0	0	0	0	0	0	f	f
6561	534	12	5.50	0	0	0	0	0	0	f	f
6562	470	12	7.00	1	0	0	0	0	0	f	f
6563	520	12	5.50	0	0	0	0	0	0	f	f
6564	478	12	7.50	2	0	0	0	0	0	f	f
6565	6	12	6.00	0	1	0	0	0	0	f	f
6566	119	12	6.50	0	0	0	0	0	0	f	f
6567	86	12	6.00	0	0	0	0	0	0	f	f
6568	95	12	6.00	0	0	0	0	0	0	f	f
6569	105	12	6.50	0	0	0	0	0	0	f	f
6570	117	12	7.00	1	0	0	0	0	0	f	f
6571	80	12	6.00	0	0	0	0	0	0	f	f
6572	189	12	6.00	0	0	0	0	0	0	t	f
6573	317	12	7.00	0	0	0	0	0	0	f	f
6574	290	12	7.50	0	0	0	0	0	2	f	f
6575	261	12	7.00	1	0	0	0	0	0	f	f
6576	331	12	6.50	1	0	0	0	0	0	f	f
6577	512	12	6.00	0	0	0	0	0	0	f	f
6578	463	12	6.00	0	0	0	0	0	0	f	f
6579	479	12	7.50	2	0	0	0	0	0	f	f
6580	499	12	7.00	0	0	0	0	0	2	f	f
6581	11	12	5.50	0	3	0	0	0	0	f	f
6582	134	12	5.00	0	0	0	0	0	0	f	f
6583	173	12	5.00	0	0	0	0	0	0	f	f
6584	75	12	5.00	0	0	0	0	0	0	f	f
6585	70	12	5.50	0	0	0	0	0	0	f	f
6586	106	12	5.50	0	0	0	0	0	0	f	f
6587	172	12	6.50	1	0	0	0	0	0	f	f
6588	160	12	5.50	0	0	0	0	0	0	f	f
6589	375	12	5.50	0	0	0	0	0	0	f	f
6590	277	12	6.00	0	0	0	0	0	1	f	f
6591	355	12	5.50	0	0	0	0	0	0	t	f
6592	325	12	5.50	0	0	0	0	0	0	t	f
6593	283	12	5.50	0	0	0	0	0	0	f	f
6594	511	12	6.00	0	0	0	0	0	0	f	f
6595	464	12	6.00	0	0	0	0	0	0	f	f
6596	457	12	5.00	0	0	0	0	0	0	f	f
6597	17	12	6.50	0	1	0	0	0	0	f	f
6598	124	12	6.00	0	0	0	0	0	0	f	f
6599	190	12	5.00	0	0	0	0	0	0	f	f
6600	191	12	6.50	0	0	0	0	0	0	t	f
6601	175	12	6.00	0	0	0	0	0	0	f	f
6602	213	12	6.00	0	0	0	0	0	0	f	f
6603	161	12	5.50	0	0	0	0	0	0	f	f
6604	162	12	6.50	0	0	0	0	0	0	f	f
6605	256	12	6.00	0	0	0	0	0	0	f	f
6606	274	12	7.00	1	0	0	0	0	0	t	f
6607	376	12	6.00	0	0	0	0	0	0	t	f
6608	366	12	5.50	0	0	0	0	0	0	f	f
6609	297	12	6.00	0	0	0	0	0	0	f	f
6610	396	12	6.00	0	0	0	0	0	0	f	f
6611	460	12	7.00	0	0	0	0	0	1	f	f
6612	505	12	5.00	0	0	0	0	0	0	f	f
6613	18	12	6.00	0	3	0	0	0	0	f	f
6614	74	12	6.50	1	0	0	0	0	0	f	f
6615	98	12	5.50	0	0	0	0	0	0	f	f
6616	92	12	6.50	1	0	0	0	0	0	f	f
6617	192	12	5.00	0	0	0	0	0	0	f	f
6618	135	12	4.50	0	0	0	0	0	0	f	t
6619	298	12	6.50	0	0	0	0	0	1	f	f
6620	305	12	6.00	0	0	0	0	0	0	f	f
6621	342	12	6.50	0	0	0	0	0	0	f	f
6622	318	12	6.00	0	0	0	0	0	0	f	f
6623	379	12	5.50	0	0	0	0	0	0	f	f
6624	378	12	5.50	0	0	0	0	0	0	t	f
6625	349	12	6.00	0	0	0	0	0	0	f	f
6626	508	12	6.50	0	0	0	0	0	1	f	f
6627	500	12	6.00	0	0	0	0	0	0	f	f
6628	490	12	7.00	1	0	0	0	0	0	f	f
6629	13	12	5.50	0	1	0	0	0	0	f	f
6630	66	12	6.50	0	0	0	0	0	0	f	f
6631	136	12	6.50	0	0	0	0	0	0	f	f
6632	67	12	6.00	0	0	0	0	0	0	f	f
6633	104	12	5.50	0	0	0	0	0	0	f	f
6634	81	12	6.00	0	0	0	0	0	0	f	f
6635	300	12	6.00	0	0	0	0	0	0	f	f
6636	270	12	6.00	0	0	0	0	0	0	f	f
6637	262	12	4.50	0	0	0	1	0	0	t	f
6638	411	12	6.00	0	0	0	0	0	0	f	f
6639	299	12	6.00	0	0	0	0	0	0	f	f
6640	444	12	6.00	0	0	0	0	0	0	f	f
6641	445	12	6.50	0	0	0	0	0	0	f	f
6642	474	12	5.50	0	0	0	0	0	0	f	f
6643	475	12	6.00	0	0	0	0	0	0	f	f
6644	7	12	6.00	0	1	0	0	0	0	f	f
6645	88	12	6.00	0	0	0	0	0	0	f	f
6646	99	12	6.00	0	0	0	0	0	0	f	f
6647	109	12	5.50	0	0	0	0	0	0	t	f
6648	108	12	5.50	0	0	0	0	0	0	f	f
6649	307	12	6.50	0	0	0	0	0	0	f	f
6650	306	12	7.00	1	0	0	0	0	0	f	f
6651	332	12	6.00	0	0	0	0	0	0	t	f
6652	291	12	5.50	0	0	0	0	0	0	f	f
6653	353	12	5.50	0	0	0	0	0	0	f	f
6654	400	12	5.50	0	0	0	0	0	0	t	f
6655	278	12	6.50	0	0	0	0	0	0	f	f
6656	461	12	5.50	0	0	0	0	0	0	f	f
6657	480	12	6.00	0	0	0	0	0	0	f	f
6658	477	12	6.00	0	0	0	0	0	0	f	f
6659	446	12	6.00	0	0	0	0	0	0	f	f
6660	3	12	6.50	0	0	0	0	0	0	f	f
6661	217	12	6.00	0	0	0	0	0	0	f	f
6662	126	12	6.00	0	0	0	0	0	0	f	f
6663	110	12	6.50	0	0	0	0	0	0	f	f
6664	195	12	6.00	0	0	0	0	0	0	f	f
6665	144	12	6.00	0	0	0	0	0	0	f	f
6666	125	12	6.00	0	0	0	0	0	0	f	f
6667	362	12	6.00	0	0	0	0	0	0	f	f
6668	301	12	6.50	0	0	0	0	0	0	f	f
6669	267	12	6.50	0	0	0	0	0	0	f	f
6670	292	12	7.00	1	0	0	0	0	0	t	f
6671	284	12	7.00	0	0	0	0	0	1	f	f
6672	285	12	6.50	0	0	0	0	0	0	f	f
6673	516	12	6.00	0	0	0	0	0	0	f	f
6674	494	12	6.00	0	0	0	0	0	0	f	f
6675	492	12	6.50	1	0	0	0	0	0	f	f
6676	8	12	6.50	0	2	0	0	0	0	f	f
6677	127	12	5.50	0	0	0	0	0	0	f	f
6678	164	12	6.00	0	0	0	0	0	0	f	f
6679	89	12	5.00	0	0	0	0	0	0	f	f
6680	146	12	5.50	0	0	0	0	0	0	f	f
6681	310	12	5.50	0	0	0	0	0	0	f	f
6682	293	12	5.50	0	0	0	0	0	0	f	f
6683	286	12	5.50	0	0	0	0	0	0	f	f
6684	354	12	6.00	0	0	0	0	0	0	f	f
6685	401	12	6.00	0	0	0	0	0	0	f	f
6686	333	12	6.00	0	0	0	0	0	0	f	f
6687	381	12	5.50	0	0	0	0	0	0	f	f
6688	501	12	5.50	0	0	0	0	0	0	f	f
6689	509	12	5.00	0	0	0	0	0	0	f	f
6690	495	12	6.00	0	0	0	0	0	0	t	f
6691	513	12	5.50	0	0	0	0	0	0	f	f
6692	1	12	8.00	0	0	1	0	0	0	f	f
6693	111	12	6.00	0	0	0	0	0	0	f	f
6694	139	12	6.50	0	0	0	0	0	0	f	f
6695	68	12	6.00	0	0	0	0	0	0	t	f
6696	90	12	6.50	0	0	0	0	0	0	f	f
6697	273	12	6.50	0	0	0	0	0	0	f	f
6698	260	12	7.00	1	0	0	0	0	0	f	f
6699	268	12	6.00	0	0	0	0	0	0	f	f
6700	302	12	6.00	0	0	0	0	0	0	f	f
6701	313	12	6.50	0	0	0	0	0	0	f	f
6702	271	12	6.50	0	0	0	0	0	0	f	f
6703	294	12	6.00	0	0	0	0	0	0	f	f
6704	447	12	5.00	0	0	0	0	0	0	t	f
6705	485	12	6.00	0	0	0	0	0	0	f	f
6706	4	12	6.00	0	1	0	0	0	0	f	f
6707	196	12	6.00	0	0	0	0	0	0	t	f
6708	83	12	6.50	0	0	0	0	0	0	f	f
6709	113	12	6.50	0	0	0	0	0	1	f	f
6710	140	12	6.00	0	0	0	0	0	0	f	f
6711	201	12	6.00	0	0	0	0	0	0	f	f
6712	240	12	6.00	0	0	0	0	0	0	f	f
6713	112	12	6.50	0	0	0	0	0	0	f	f
6714	319	12	6.00	0	0	0	0	0	0	f	f
6715	356	12	6.00	0	0	0	0	0	0	f	f
6716	360	12	6.00	0	0	0	0	0	0	f	f
6717	265	12	7.00	0	0	0	0	0	1	f	f
6718	279	12	7.50	2	0	0	0	0	0	f	f
6719	450	12	6.50	0	0	0	0	0	1	f	f
6720	510	12	6.00	0	0	0	0	0	0	f	f
6721	483	12	7.00	1	0	0	0	0	0	f	f
6722	23	12	6.50	0	1	0	0	0	0	f	f
6723	147	12	6.50	0	0	0	0	0	0	f	f
6724	116	12	6.00	0	0	0	0	0	0	f	f
6725	115	12	5.50	0	0	0	0	0	0	t	f
6726	220	12	5.50	0	0	0	0	0	0	f	f
6727	226	12	6.50	0	0	0	0	0	0	f	f
6728	143	12	6.00	0	0	0	0	0	0	t	f
6729	403	12	6.00	0	0	0	0	0	0	f	f
6730	280	12	6.00	0	0	0	0	0	0	f	f
6731	365	12	5.00	0	0	0	0	0	0	f	f
6732	359	12	6.50	0	0	0	0	0	0	f	f
6733	493	12	6.00	0	0	0	0	0	0	f	f
6734	502	12	6.00	0	0	0	0	0	0	f	f
6735	456	12	7.50	2	0	0	0	0	0	t	f
6736	14	12	6.50	0	2	0	0	0	0	f	f
6737	185	12	6.00	0	0	0	0	0	0	f	f
6738	148	12	5.50	0	0	0	0	0	0	f	f
6739	166	12	6.00	0	0	0	0	0	0	t	f
6740	165	12	6.00	0	0	0	0	0	0	f	f
6741	129	12	6.00	0	0	0	0	0	0	f	f
6742	344	12	6.50	0	0	0	0	0	0	f	f
6743	368	12	5.00	0	0	0	0	0	0	f	f
6744	373	12	5.50	0	0	0	0	0	0	f	f
6745	382	12	5.50	0	0	0	0	0	0	f	f
6746	320	12	6.00	0	0	0	0	0	0	f	f
6747	433	12	5.50	0	0	0	0	0	0	f	f
6748	406	12	6.00	0	0	0	0	0	0	f	f
6749	472	12	7.00	0	0	0	0	0	0	f	f
6750	487	12	7.00	0	0	0	0	0	0	f	f
6751	517	12	7.00	1	0	0	0	0	0	f	f
6752	2	12	7.00	0	1	0	0	0	0	f	f
6753	100	12	6.00	0	0	0	0	0	0	f	f
6754	130	12	6.50	0	0	0	0	0	0	f	f
6755	76	12	6.50	0	0	0	0	0	0	f	f
6756	202	12	6.00	0	0	0	0	0	0	f	f
6757	72	12	7.00	1	0	0	0	0	0	f	f
6758	227	12	5.50	0	0	0	0	0	0	t	f
6759	275	12	6.00	0	0	0	0	0	0	f	f
6760	295	12	6.50	0	0	0	0	0	0	f	f
6761	369	12	6.50	0	0	0	0	0	1	f	f
6762	281	12	6.50	0	0	0	0	0	1	f	f
6763	384	12	6.00	0	0	0	0	0	0	f	f
6764	420	12	6.00	0	0	0	0	0	0	f	f
6765	357	12	6.50	0	0	0	0	0	1	t	f
6766	448	12	7.00	1	0	0	0	0	0	f	f
6767	484	12	7.00	1	0	0	0	0	0	f	f
6768	15	12	6.00	0	2	0	0	0	0	f	f
6769	142	12	5.50	0	0	0	0	0	0	t	f
6770	150	12	6.00	0	0	0	0	0	0	f	f
6771	206	12	4.50	0	0	0	0	0	0	f	f
6772	118	12	6.00	0	0	0	0	0	0	f	f
6773	199	12	5.00	0	0	0	0	0	0	f	f
6774	149	12	5.00	0	0	0	0	0	0	f	f
6775	315	12	7.00	1	0	0	0	0	0	f	f
6776	303	12	6.50	0	0	0	0	0	1	f	f
6777	314	12	7.00	1	0	0	0	0	0	t	f
6778	422	12	6.00	0	0	0	0	0	0	f	f
6779	287	12	6.50	0	0	0	0	0	0	f	f
6780	308	12	5.50	0	0	0	0	0	0	f	f
6781	449	12	5.50	0	0	0	0	0	0	f	f
6782	467	12	5.00	0	0	0	0	0	0	f	f
6783	453	12	6.00	0	0	0	0	0	0	f	f
6784	22	12	5.00	0	5	0	0	0	0	f	f
6785	222	12	4.50	0	0	0	0	0	0	f	f
6786	152	12	5.00	0	0	0	0	0	0	f	f
6787	91	12	4.50	0	0	0	0	0	0	f	f
6788	203	12	5.00	0	0	0	0	0	0	f	f
6789	168	12	5.00	0	0	0	0	0	0	f	f
6790	370	12	4.50	0	0	0	0	0	0	f	f
6791	288	12	7.00	0	0	0	0	0	0	f	f
6792	399	12	5.00	0	0	0	0	0	0	f	f
6793	358	12	5.50	0	0	0	0	0	0	f	f
6794	386	12	6.00	0	0	0	0	0	0	f	f
6795	407	12	5.00	0	0	0	0	0	0	f	f
6796	496	12	5.00	0	0	0	0	0	0	f	f
6797	488	12	5.50	0	0	0	0	0	0	f	f
6798	539	12	5.00	0	0	0	0	0	0	f	f
6799	528	12	5.50	0	0	0	0	0	0	f	f
6800	19	12	5.50	0	3	1	0	0	0	f	f
6801	78	12	5.50	0	0	0	0	0	0	f	f
6802	128	12	5.50	0	0	0	0	0	0	f	f
6803	154	12	6.00	0	0	0	0	0	0	f	f
6804	153	12	5.00	0	0	0	0	0	0	f	f
6805	180	12	5.00	0	0	0	0	0	0	f	f
6806	197	12	6.00	0	0	0	0	0	0	f	f
6807	101	12	5.50	0	0	0	0	0	0	f	f
6808	272	12	5.50	0	0	0	0	0	0	f	f
6809	321	12	5.00	0	0	0	0	0	0	f	f
6810	326	12	5.50	0	0	0	0	0	0	f	f
6811	282	12	6.50	0	0	0	0	0	0	f	f
6812	328	12	6.00	0	0	0	0	0	0	f	f
6813	452	12	5.50	0	0	0	0	0	0	f	f
6814	525	12	5.50	0	0	0	0	0	0	f	f
6815	497	12	5.50	0	0	0	0	0	0	f	f
6816	12	12	6.50	0	2	0	0	0	0	f	f
6817	155	12	5.50	0	0	0	0	0	0	f	f
6818	183	12	5.50	0	0	0	0	0	0	t	f
6819	181	12	6.50	0	0	0	0	0	0	f	f
6820	169	12	5.50	0	0	0	0	0	0	f	f
6821	79	12	6.00	0	0	0	0	0	0	f	f
6822	170	12	6.00	0	0	0	0	0	0	f	f
6823	345	12	6.00	0	0	0	0	0	0	t	f
6824	413	12	6.00	0	0	0	0	0	0	f	f
6825	409	12	6.00	0	0	0	0	0	0	f	f
6826	391	12	5.50	0	0	0	0	0	0	t	f
6827	327	12	5.50	0	0	0	0	0	0	f	f
6828	521	12	6.00	0	0	0	0	0	0	f	f
6829	473	12	6.00	0	0	0	0	0	0	f	f
6830	503	12	6.50	0	0	0	0	0	1	f	f
6831	469	12	5.50	1	0	0	0	0	0	t	f
6832	46	12	\N	0	0	0	0	0	0	f	f
6833	35	12	\N	0	0	0	0	0	0	f	f
6834	37	12	\N	0	0	0	0	0	0	f	f
6835	24	12	\N	0	0	0	0	0	0	f	f
6836	29	12	\N	0	0	0	0	0	0	f	f
6837	16	12	\N	0	0	0	0	0	0	f	f
6838	51	12	\N	0	0	0	0	0	0	f	f
6839	36	12	\N	0	0	0	0	0	0	f	f
6840	54	12	\N	0	0	0	0	0	0	f	f
6841	47	12	\N	0	0	0	0	0	0	f	f
6842	21	12	\N	0	0	0	0	0	0	f	f
6843	71	12	\N	0	0	0	0	0	0	f	f
6844	27	12	\N	0	0	0	0	0	0	f	f
6845	40	12	\N	0	0	0	0	0	0	f	f
6846	42	12	\N	0	0	0	0	0	0	f	f
6847	52	12	\N	0	0	0	0	0	0	f	f
6848	33	12	\N	0	0	0	0	0	0	f	f
6849	28	12	\N	0	0	0	0	0	0	f	f
6850	61	12	\N	0	0	0	0	0	0	f	f
6851	26	12	\N	0	0	0	0	0	0	f	f
6852	56	12	\N	0	0	0	0	0	0	f	f
6853	58	12	\N	0	0	0	0	0	0	f	f
6854	62	12	\N	0	0	0	0	0	0	f	f
6855	65	12	\N	0	0	0	0	0	0	f	f
6856	30	12	\N	0	0	0	0	0	0	f	f
6857	45	12	\N	0	0	0	0	0	0	f	f
6858	205	12	\N	0	0	0	0	0	0	f	f
6859	186	12	\N	0	0	0	0	0	0	f	f
6860	171	12	\N	0	0	0	0	0	0	f	f
6861	176	12	\N	0	0	0	0	0	0	f	f
6862	145	12	\N	0	0	0	0	0	0	f	f
6863	184	12	\N	0	0	0	0	0	0	f	f
6864	193	12	\N	0	0	0	0	0	0	f	f
6865	204	12	\N	0	0	0	0	0	0	f	f
6866	138	12	\N	0	0	0	0	0	0	f	f
6867	141	12	\N	0	0	0	0	0	0	f	f
6868	207	12	\N	0	0	0	0	0	0	f	f
6869	121	12	\N	0	0	0	0	0	0	f	f
6870	187	12	\N	0	0	0	0	0	0	f	f
6871	174	12	\N	0	0	0	0	0	0	f	f
6872	107	12	\N	0	0	0	0	0	0	f	f
6873	151	12	\N	0	0	0	0	0	0	f	f
6874	182	12	\N	0	0	0	0	0	0	f	f
6875	137	12	\N	0	0	0	0	0	0	f	f
6876	218	12	\N	0	0	0	0	0	0	f	f
6877	224	12	\N	0	0	0	0	0	0	f	f
6878	238	12	\N	0	0	0	0	0	0	f	f
6879	235	12	\N	0	0	0	0	0	0	f	f
6880	232	12	\N	0	0	0	0	0	0	f	f
6881	248	12	\N	0	0	0	0	0	0	f	f
6882	241	12	\N	0	0	0	0	0	0	f	f
6883	255	12	\N	0	0	0	0	0	0	f	f
6884	221	12	\N	0	0	0	0	0	0	f	f
6885	230	12	\N	0	0	0	0	0	0	f	f
6886	211	12	\N	0	0	0	0	0	0	f	f
6887	244	12	\N	0	0	0	0	0	0	f	f
6888	245	12	\N	0	0	0	0	0	0	f	f
6889	210	12	\N	0	0	0	0	0	0	f	f
6890	264	12	\N	0	0	0	0	0	0	f	f
6891	250	12	\N	0	0	0	0	0	0	f	f
6892	223	12	\N	0	0	0	0	0	0	f	f
6893	214	12	\N	0	0	0	0	0	0	f	f
6894	215	12	\N	0	0	0	0	0	0	f	f
6895	216	12	\N	0	0	0	0	0	0	f	f
6896	228	12	\N	0	0	0	0	0	0	f	f
6897	253	12	\N	0	0	0	0	0	0	f	f
6898	254	12	\N	0	0	0	0	0	0	f	f
6899	225	12	\N	0	0	0	0	0	0	f	f
6900	233	12	\N	0	0	0	0	0	0	f	f
6901	402	12	\N	0	0	0	0	0	0	f	f
6902	418	12	\N	0	0	0	0	0	0	f	f
6903	343	12	\N	0	0	0	0	0	0	f	f
6904	405	12	\N	0	0	0	0	0	0	f	f
6905	367	12	\N	0	0	0	0	0	0	f	f
6906	404	12	\N	0	0	0	0	0	0	f	f
6907	337	12	\N	0	0	0	0	0	0	f	f
6908	390	12	\N	0	0	0	0	0	0	f	f
6909	316	12	\N	0	0	0	0	0	0	f	f
6910	414	12	\N	0	0	0	0	0	0	f	f
6911	392	12	\N	0	0	0	0	0	0	f	f
6912	380	12	\N	0	0	0	0	0	0	f	f
6913	385	12	\N	0	0	0	0	0	0	f	f
6914	412	12	\N	0	0	0	0	0	0	f	f
6915	371	12	\N	0	0	0	0	0	0	f	f
6916	397	12	\N	0	0	0	0	0	0	f	f
6917	339	12	\N	0	0	0	0	0	0	f	f
6918	340	12	\N	0	0	0	0	0	0	f	f
6919	416	12	\N	0	0	0	0	0	0	f	f
6920	351	12	\N	0	0	0	0	0	0	f	f
6921	237	12	\N	0	0	0	0	0	0	f	f
6922	431	12	\N	0	0	0	0	0	0	f	f
6923	429	12	\N	0	0	0	0	0	0	f	f
6924	522	12	\N	0	0	0	0	0	0	f	f
6925	523	12	\N	0	0	0	0	0	0	f	f
6926	455	12	\N	0	0	0	0	0	0	f	f
6927	514	12	\N	0	0	0	0	0	0	f	f
6928	486	12	\N	0	0	0	0	0	0	f	f
6929	428	12	\N	0	0	0	0	0	0	f	f
6930	438	12	\N	0	0	0	0	0	0	f	f
6931	441	12	\N	0	0	0	0	0	0	f	f
6932	437	12	\N	0	0	0	0	0	0	f	f
6933	425	12	\N	0	0	0	0	0	0	f	f
6934	426	12	\N	0	0	0	0	0	0	f	f
6935	430	12	\N	0	0	0	0	0	0	f	f
6936	481	12	\N	0	0	0	0	0	0	f	f
6937	458	12	\N	0	0	0	0	0	0	f	f
6938	504	12	\N	0	0	0	0	0	0	f	f
6939	515	12	\N	0	0	0	0	0	0	f	f
6940	468	12	\N	0	0	0	0	0	0	f	f
6941	466	12	\N	0	0	0	0	0	0	f	f
6942	434	12	\N	0	0	0	0	0	0	f	f
6943	435	12	\N	0	0	0	0	0	0	f	f
6944	529	12	\N	0	0	0	0	0	0	f	f
6945	531	12	\N	0	0	0	0	0	0	f	f
6946	219	12	\N	0	0	0	0	0	0	f	f
6947	530	12	\N	0	0	0	0	0	0	f	f
6948	540	12	\N	0	0	0	0	0	0	f	f
6949	541	12	\N	0	0	0	0	0	0	f	f
6950	43	12	\N	0	0	0	0	0	0	f	f
6951	44	12	\N	0	0	0	0	0	0	f	f
6952	236	12	\N	0	0	0	0	0	0	f	f
6953	417	12	\N	0	0	0	0	0	0	f	f
6954	363	12	\N	0	0	0	0	0	0	f	f
6955	491	12	\N	0	0	0	0	0	0	f	f
6956	229	12	\N	0	0	0	0	0	0	f	f
6957	55	12	\N	0	0	0	0	0	0	f	f
6958	247	12	\N	0	0	0	0	0	0	f	f
6959	421	12	\N	0	0	0	0	0	0	f	f
6960	246	12	\N	0	0	0	0	0	0	f	f
6961	389	12	\N	0	0	0	0	0	0	f	f
6962	518	12	\N	0	0	0	0	0	0	f	f
6963	527	12	\N	0	0	0	0	0	0	f	f
6964	538	12	\N	0	0	0	0	0	0	f	f
6965	48	12	\N	0	0	0	0	0	0	f	f
6966	177	12	\N	0	0	0	0	0	0	f	f
6967	258	12	\N	0	0	0	0	0	0	f	f
6968	388	12	\N	0	0	0	0	0	0	f	f
6969	34	12	\N	0	0	0	0	0	0	f	f
6970	159	12	\N	0	0	0	0	0	0	f	f
6971	436	12	\N	0	0	0	0	0	0	f	f
6972	498	12	\N	0	0	0	0	0	0	f	f
6973	532	12	\N	0	0	0	0	0	0	f	f
6974	542	12	\N	0	0	0	0	0	0	f	f
6975	543	12	\N	0	0	0	0	0	0	f	f
6976	49	12	\N	0	0	0	0	0	0	f	f
6977	239	12	\N	0	0	0	0	0	0	f	f
6978	178	12	\N	0	0	0	0	0	0	f	f
6979	266	12	\N	0	0	0	0	0	0	f	f
6980	334	12	\N	0	0	0	0	0	0	f	f
6981	476	12	\N	0	0	0	0	0	0	f	f
6982	60	12	\N	0	0	0	0	0	0	f	f
6983	57	12	\N	0	0	0	0	0	0	f	f
6984	198	12	\N	0	0	0	0	0	0	f	f
6985	131	12	\N	0	0	0	0	0	0	f	f
6986	423	12	\N	0	0	0	0	0	0	f	f
6987	524	12	\N	0	0	0	0	0	0	f	f
6988	39	12	\N	0	0	0	0	0	0	f	f
6989	59	12	\N	0	0	0	0	0	0	f	f
6990	440	12	\N	0	0	0	0	0	0	f	f
6991	398	12	\N	0	0	0	0	0	0	f	f
6992	507	12	\N	0	0	0	0	0	0	f	f
6993	442	12	\N	0	0	0	0	0	0	f	f
6994	25	12	\N	0	0	0	0	0	0	f	f
6995	87	12	\N	0	0	0	0	0	0	f	f
6996	194	12	\N	0	0	0	0	0	0	f	f
6997	234	12	\N	0	0	0	0	0	0	f	f
6998	410	12	\N	0	0	0	0	0	0	f	f
6999	535	12	\N	0	0	0	0	0	0	f	f
7000	322	12	\N	0	0	0	0	0	0	f	f
7001	53	12	\N	0	0	0	0	0	0	f	f
7002	251	12	\N	0	0	0	0	0	0	f	f
7003	84	12	\N	0	0	0	0	0	0	f	f
7004	167	12	\N	0	0	0	0	0	0	f	f
7005	335	12	\N	0	0	0	0	0	0	f	f
7006	471	12	\N	0	0	0	0	0	0	f	f
7007	346	12	\N	0	0	0	0	0	0	f	f
7008	32	12	\N	0	0	0	0	0	0	f	f
7009	132	12	\N	0	0	0	0	0	0	f	f
7010	200	12	\N	0	0	0	0	0	0	f	f
7011	364	12	\N	0	0	0	0	0	0	f	f
7012	465	12	\N	0	0	0	0	0	0	f	f
7013	9	12	\N	0	0	0	0	0	0	f	f
7014	209	12	\N	0	0	0	0	0	0	f	f
7015	73	12	\N	0	0	0	0	0	0	f	f
7016	537	12	\N	0	0	0	0	0	0	f	f
7017	482	12	\N	0	0	0	0	0	0	f	f
7018	336	12	\N	0	0	0	0	0	0	f	f
7019	38	12	\N	0	0	0	0	0	0	f	f
7020	377	12	\N	0	0	0	0	0	0	f	f
7021	415	12	\N	0	0	0	0	0	0	f	f
7022	179	12	\N	0	0	0	0	0	0	f	f
7023	77	12	\N	0	0	0	0	0	0	f	f
7024	249	12	\N	0	0	0	0	0	0	f	f
7025	387	12	\N	0	0	0	0	0	0	f	f
7026	439	12	\N	0	0	0	0	0	0	f	f
7027	252	12	\N	0	0	0	0	0	0	f	f
7028	408	12	\N	0	0	0	0	0	0	f	f
7029	309	12	\N	0	0	0	0	0	0	f	f
7030	424	12	\N	0	0	0	0	0	0	f	f
7031	41	12	\N	0	0	0	0	0	0	f	f
7032	82	12	\N	0	0	0	0	0	0	f	f
7033	259	12	\N	0	0	0	0	0	0	f	f
7034	163	12	\N	0	0	0	0	0	0	f	f
7035	352	12	\N	0	0	0	0	0	0	f	f
7036	350	12	\N	0	0	0	0	0	0	f	f
7037	257	12	\N	0	0	0	0	0	0	f	f
7038	419	12	\N	0	0	0	0	0	0	f	f
7039	432	12	\N	0	0	0	0	0	0	f	f
7040	64	12	\N	0	0	0	0	0	0	f	f
7041	212	12	\N	0	0	0	0	0	0	f	f
7042	395	12	\N	0	0	0	0	0	0	f	f
7043	526	12	\N	0	0	0	0	0	0	f	f
7044	533	12	\N	0	0	0	0	0	0	f	f
7045	393	12	\N	0	0	0	0	0	0	f	f
7046	50	12	\N	0	0	0	0	0	0	f	f
7047	114	12	\N	0	0	0	0	0	0	f	f
7048	443	12	\N	0	0	0	0	0	0	f	f
7049	372	12	\N	0	0	0	0	0	0	f	f
7050	31	12	\N	0	0	0	0	0	0	f	f
7051	243	12	\N	0	0	0	0	0	0	f	f
7052	242	12	\N	0	0	0	0	0	0	f	f
7053	324	12	\N	0	0	0	0	0	0	f	f
7054	102	12	\N	0	0	0	0	0	0	f	f
7055	383	12	\N	0	0	0	0	0	0	f	f
7056	536	12	\N	0	0	0	0	0	0	f	f
7057	63	12	\N	0	0	0	0	0	0	f	f
7058	231	12	\N	0	0	0	0	0	0	f	f
7059	506	12	\N	0	0	0	0	0	0	f	f
7060	5	13	7.00	0	0	0	0	0	0	f	f
7061	120	13	6.50	0	0	0	0	0	0	f	f
7062	156	13	6.00	0	0	0	0	0	0	f	f
7063	207	13	6.00	0	0	0	0	0	0	f	f
7064	94	13	6.00	0	0	0	0	0	0	f	f
7065	93	13	7.00	1	0	0	0	0	0	f	f
7066	157	13	6.50	0	0	0	0	0	0	t	f
7067	338	13	6.50	0	0	0	0	0	0	f	f
7068	296	13	6.00	0	0	0	0	0	0	f	f
7069	312	13	6.00	0	0	0	0	0	0	f	f
7070	329	13	6.00	0	0	0	0	0	0	f	f
7071	454	13	6.00	0	0	0	0	0	0	f	f
7072	462	13	7.00	1	0	0	0	0	0	f	f
7073	482	13	6.00	0	0	0	0	0	0	f	f
7074	459	13	7.00	0	0	0	0	0	1	f	f
7075	465	13	6.00	0	0	0	0	0	0	f	f
7076	20	13	6.00	0	3	0	0	0	0	f	f
7077	123	13	5.50	0	0	0	0	0	0	f	f
7078	85	13	5.50	0	0	0	0	0	0	f	f
7079	208	13	4.50	0	0	0	0	0	0	f	f
7080	73	13	6.00	0	0	0	0	0	0	f	f
7081	121	13	5.00	0	0	0	0	0	0	f	f
7082	103	13	5.50	0	0	0	0	0	0	f	f
7083	341	13	6.00	0	0	0	0	0	0	f	f
7084	263	13	6.50	0	0	0	0	0	0	f	f
7085	269	13	5.00	0	0	0	0	0	0	f	f
7086	311	13	5.00	0	0	0	0	0	0	f	f
7087	323	13	5.50	0	0	0	0	0	0	f	f
7088	458	13	6.00	0	0	0	0	0	0	f	f
7089	451	13	5.50	0	0	0	0	0	0	f	f
7090	489	13	6.00	0	0	0	0	0	0	f	f
7091	519	13	5.50	0	0	0	0	0	0	f	f
7092	10	13	6.00	0	2	0	0	0	0	f	f
7093	96	13	5.50	0	0	0	0	0	0	f	f
7094	133	13	6.00	0	0	0	0	0	0	f	f
7095	159	13	5.50	0	0	0	0	0	0	t	f
7096	69	13	7.00	0	0	0	0	0	1	f	f
7097	122	13	5.50	0	0	0	0	0	0	f	f
7098	347	13	5.50	0	0	0	0	0	0	t	f
7099	304	13	6.00	0	0	0	0	0	0	f	f
7100	361	13	5.50	0	0	0	0	0	0	f	f
7101	330	13	5.50	0	0	0	0	0	0	t	f
7102	348	13	6.00	0	0	0	0	0	0	t	f
7103	289	13	6.00	0	0	0	0	0	0	t	f
7104	428	13	5.50	0	0	0	0	0	0	f	f
7105	470	13	7.00	1	0	0	0	0	0	f	f
7106	478	13	6.00	0	0	0	0	0	0	f	f
7107	529	13	6.00	0	0	0	0	0	0	f	f
7108	6	13	6.00	0	0	0	0	0	0	f	f
7109	119	13	6.00	0	0	0	0	0	0	f	f
7110	86	13	6.00	0	0	0	0	0	0	f	f
7111	171	13	7.00	1	0	0	0	0	0	f	f
7112	95	13	6.00	0	0	0	0	0	0	f	f
7113	117	13	6.00	0	0	0	0	0	0	t	f
7114	80	13	6.00	0	0	0	0	0	0	f	f
7115	316	13	6.50	0	0	0	0	0	0	t	f
7116	317	13	6.00	0	0	0	0	0	0	f	f
7117	290	13	6.50	0	0	0	0	0	0	f	f
7118	261	13	7.00	0	0	0	0	0	1	f	f
7119	331	13	6.00	0	0	0	0	0	0	f	f
7120	463	13	7.00	1	0	0	0	0	0	f	f
7121	479	13	5.50	0	0	0	0	0	0	f	f
7122	514	13	6.00	0	0	0	0	0	0	f	f
7123	499	13	5.50	0	0	0	0	0	0	f	f
7124	11	13	6.50	0	1	0	0	0	0	f	f
7125	134	13	6.00	0	0	0	0	0	1	f	f
7126	173	13	6.00	0	0	0	0	0	0	t	f
7127	75	13	6.00	0	0	0	0	0	0	t	f
7128	70	13	7.00	0	0	0	0	0	0	f	f
7129	106	13	7.00	0	0	0	0	0	1	f	f
7130	172	13	6.00	0	0	0	0	0	0	f	f
7131	375	13	6.00	0	0	0	0	0	0	f	f
7132	355	13	6.50	0	0	0	0	0	0	f	f
7133	343	13	6.00	0	0	0	0	0	0	f	f
7134	325	13	7.00	1	0	0	0	0	0	f	f
7135	283	13	6.50	0	0	0	0	0	0	f	f
7136	511	13	6.00	0	0	0	0	0	0	f	f
7137	464	13	6.50	0	0	0	0	0	1	f	f
7138	457	13	8.00	2	0	0	0	0	0	f	f
7139	17	13	6.50	0	2	0	0	0	0	f	f
7140	124	13	6.00	0	0	0	0	0	0	f	f
7141	190	13	5.50	0	0	0	0	0	0	t	f
7142	191	13	5.50	0	0	0	0	0	0	f	f
7143	175	13	5.00	0	0	0	0	0	0	t	f
7144	161	13	5.00	0	0	0	0	0	0	f	f
7145	174	13	6.00	0	0	0	0	0	0	f	f
7146	162	13	6.00	0	0	0	0	0	0	f	f
7147	274	13	5.50	0	0	0	0	0	0	t	f
7148	376	13	5.50	0	0	0	0	0	0	f	f
7149	366	13	5.00	0	0	0	0	0	0	f	f
7150	297	13	5.50	0	0	0	0	0	0	f	f
7151	396	13	6.00	0	0	0	0	0	0	f	f
7152	415	13	6.00	0	0	0	0	0	0	f	f
7153	460	13	5.50	0	0	0	0	0	0	f	f
7154	505	13	5.50	0	0	0	0	0	0	f	f
7155	18	13	6.50	0	1	0	0	0	0	f	f
7156	215	13	6.00	0	0	0	0	0	0	f	f
7157	74	13	6.50	0	0	0	0	0	0	f	f
7158	98	13	6.50	0	0	0	0	0	0	f	f
7159	92	13	5.50	0	0	0	0	0	0	f	f
7160	192	13	6.00	0	0	0	0	0	0	f	f
7161	298	13	7.00	1	0	0	0	0	0	t	f
7162	305	13	6.00	0	0	0	0	0	0	f	f
7163	342	13	6.50	0	0	0	0	0	0	f	f
7164	318	13	6.50	0	0	0	0	0	1	f	f
7165	379	13	6.00	0	0	0	0	0	0	f	f
7166	349	13	6.00	0	0	0	0	0	0	f	f
7167	508	13	7.00	1	0	0	0	0	0	f	f
7168	500	13	6.00	0	0	0	0	0	0	f	f
7169	490	13	6.50	0	0	0	0	0	1	f	f
7170	13	13	6.00	0	0	0	0	0	0	f	f
7171	66	13	6.00	0	0	0	0	0	0	f	f
7172	136	13	6.00	0	0	0	0	0	0	t	f
7173	67	13	6.00	0	0	0	0	0	0	f	f
7174	104	13	6.50	0	0	0	0	0	0	f	f
7175	81	13	6.00	0	0	0	0	0	0	f	f
7176	137	13	6.00	0	0	0	0	0	0	f	f
7177	300	13	6.50	0	0	0	0	0	0	f	f
7178	270	13	6.50	0	0	0	0	0	1	f	f
7179	262	13	6.50	0	0	0	0	0	0	f	f
7180	350	13	5.50	0	0	0	0	0	0	f	f
7181	411	13	6.50	0	0	0	0	0	0	f	f
7182	299	13	5.50	0	0	0	0	0	0	f	f
7183	444	13	7.50	2	0	0	0	0	0	f	f
7184	445	13	5.50	0	0	0	0	0	0	f	f
7185	475	13	7.00	0	0	0	0	0	1	f	f
7186	25	13	6.00	0	1	0	0	0	0	f	f
7187	88	13	6.50	0	0	0	0	0	1	f	f
7188	99	13	6.00	0	0	0	0	0	0	t	f
7189	109	13	6.00	0	0	0	0	0	0	f	f
7190	108	13	6.00	0	0	0	0	0	0	f	f
7191	307	13	6.00	0	0	0	0	0	0	f	f
7192	306	13	5.00	0	0	0	0	0	0	f	f
7193	332	13	6.50	0	0	0	0	0	0	f	f
7194	291	13	6.50	0	0	0	0	0	0	f	f
7195	353	13	6.00	0	0	0	0	0	0	f	f
7196	400	13	6.00	0	0	0	0	0	0	f	f
7197	278	13	6.50	0	0	0	0	0	0	f	f
7198	461	13	6.00	0	0	0	0	0	0	f	f
7199	480	13	5.50	0	0	0	0	0	0	f	f
7200	477	13	6.00	0	0	0	0	0	0	f	f
7201	446	13	7.50	2	0	0	0	0	0	f	f
7202	3	13	6.00	0	1	0	0	0	0	f	f
7203	126	13	6.00	0	0	0	0	0	0	t	f
7204	110	13	6.00	0	0	0	0	0	0	f	f
7205	144	13	5.50	0	0	0	0	0	0	t	f
7206	145	13	6.00	0	0	0	0	0	0	f	f
7207	125	13	5.50	0	0	0	0	0	0	f	f
7208	362	13	6.00	0	0	0	0	0	0	f	f
7209	267	13	6.00	0	0	0	0	0	0	t	f
7210	292	13	6.00	0	0	0	0	0	0	f	f
7211	284	13	6.00	0	0	0	0	0	0	f	f
7212	285	13	6.00	0	0	0	0	0	0	f	f
7213	363	13	5.50	0	0	0	0	0	0	f	f
7214	516	13	6.00	0	0	0	0	0	0	f	f
7215	494	13	5.50	0	0	0	0	0	0	f	f
7216	455	13	6.00	0	0	0	0	0	0	f	f
7217	492	13	6.00	0	0	0	0	0	0	f	f
7218	8	13	7.50	0	1	1	0	0	0	f	f
7219	127	13	6.50	0	0	0	0	0	0	f	f
7220	164	13	6.50	0	0	0	0	0	0	f	f
7221	89	13	6.00	0	0	0	0	0	0	f	f
7222	146	13	6.00	0	0	0	0	0	0	f	f
7223	219	13	6.00	0	0	0	0	0	0	f	f
7224	310	13	6.00	0	0	0	0	0	0	f	f
7225	293	13	7.00	1	0	0	0	0	0	t	f
7226	286	13	7.50	0	0	0	0	0	2	f	f
7227	354	13	5.50	0	0	0	0	0	0	t	f
7228	401	13	6.00	0	0	0	0	0	0	f	f
7229	333	13	5.50	0	0	0	0	0	0	f	f
7230	381	13	4.50	0	0	0	0	0	0	f	f
7231	501	13	7.00	1	0	0	0	0	0	f	f
7232	513	13	5.50	0	0	0	0	0	0	f	f
7233	1	13	7.00	0	0	0	0	0	0	f	f
7234	111	13	6.50	0	0	0	0	0	0	t	f
7235	139	13	6.50	0	0	0	0	0	1	t	f
7236	68	13	6.00	0	0	0	0	0	0	f	f
7237	90	13	6.50	0	0	0	0	0	0	f	f
7238	273	13	6.00	0	0	0	0	0	0	f	f
7239	268	13	6.00	0	0	0	0	0	0	f	f
7240	302	13	6.00	0	0	0	0	0	0	f	f
7241	313	13	6.00	0	0	0	0	0	0	f	f
7242	271	13	6.50	0	0	0	0	0	0	f	f
7243	294	13	6.00	0	0	0	0	0	0	t	f
7244	447	13	7.00	1	0	0	0	0	0	f	f
7245	485	13	5.00	0	0	0	0	0	0	f	f
7246	4	13	6.50	0	0	0	0	0	0	f	f
7247	83	13	6.50	0	0	0	0	0	0	f	f
7248	113	13	6.50	0	0	0	0	0	0	f	f
7249	140	13	7.00	0	0	0	0	0	0	f	f
7250	178	13	6.00	0	0	0	0	0	0	t	f
7251	112	13	6.00	0	0	0	0	0	0	t	f
7252	319	13	6.00	0	0	0	0	0	0	f	f
7253	356	13	6.00	0	0	0	0	0	0	t	f
7254	360	13	6.00	0	0	0	0	0	0	f	f
7255	265	13	6.50	0	0	0	0	0	0	f	f
7256	279	13	7.00	1	0	0	0	0	0	f	f
7257	450	13	6.50	0	0	0	0	0	1	f	f
7258	510	13	6.00	0	0	0	0	0	0	f	f
7259	483	13	6.00	0	0	0	0	0	0	f	f
7260	23	13	5.00	0	2	0	0	0	0	f	f
7261	147	13	5.00	0	0	0	0	0	0	f	f
7262	116	13	6.00	0	0	0	0	0	0	f	f
7263	115	13	5.50	0	0	0	0	0	0	f	f
7264	220	13	6.00	0	0	0	0	0	0	f	f
7265	226	13	4.50	0	0	0	0	0	0	f	t
7266	143	13	5.00	0	0	0	0	0	0	f	f
7267	405	13	5.50	0	0	0	0	0	0	f	f
7268	403	13	5.00	0	0	0	0	0	0	f	f
7269	280	13	5.50	0	0	0	0	0	0	f	f
7270	365	13	5.50	0	0	0	0	0	0	t	f
7271	367	13	5.50	0	0	0	0	0	0	f	f
7272	359	13	6.00	0	0	0	0	0	0	f	f
7273	493	13	5.50	0	0	0	0	0	0	f	f
7274	502	13	6.00	0	0	0	0	0	0	f	f
7275	456	13	6.00	0	0	0	0	0	0	f	f
7276	31	13	6.00	0	2	0	0	0	0	f	f
7277	185	13	5.50	0	0	0	0	0	0	t	f
7278	148	13	5.50	0	0	0	0	0	0	t	f
7279	165	13	5.50	0	0	0	0	0	0	f	f
7280	129	13	6.00	0	0	0	0	0	0	f	f
7281	344	13	5.50	0	0	0	0	0	0	f	f
7282	368	13	5.50	0	0	0	0	0	0	f	f
7283	373	13	5.00	0	0	0	0	0	0	f	f
7284	382	13	6.50	0	0	0	0	0	0	f	f
7285	320	13	6.00	0	0	0	0	0	0	f	f
7286	383	13	6.00	0	0	0	0	0	0	f	f
7287	337	13	6.00	0	0	0	0	0	0	f	f
7288	472	13	6.50	0	0	0	0	0	0	f	f
7289	487	13	6.00	0	0	0	0	0	0	f	f
7290	517	13	6.00	0	0	0	0	0	0	f	f
7291	536	13	6.00	0	0	0	0	0	0	f	f
7292	2	13	6.50	0	1	0	0	0	0	f	f
7293	100	13	6.00	0	0	0	0	0	0	f	f
7294	130	13	5.50	0	0	0	0	0	0	t	f
7295	76	13	6.00	0	0	0	0	0	0	f	f
7296	84	13	6.00	0	0	0	0	0	0	f	f
7297	72	13	5.50	0	0	0	0	0	0	f	f
7298	275	13	6.50	0	0	0	0	0	0	f	f
7299	295	13	5.00	0	0	0	0	0	0	t	f
7300	369	13	6.00	0	0	0	0	0	0	t	f
7301	335	13	6.00	0	0	0	0	0	0	f	f
7302	281	13	5.00	0	0	0	0	0	0	f	f
7303	384	13	6.00	0	0	0	0	0	0	t	f
7304	357	13	6.00	0	0	0	0	0	0	f	f
7305	481	13	6.00	0	0	0	0	0	0	f	f
7306	448	13	5.00	0	0	0	0	0	0	f	f
7307	484	13	5.50	0	0	0	0	0	0	f	f
7308	15	13	5.50	0	2	0	0	0	0	f	f
7309	142	13	6.00	0	0	0	0	0	0	f	f
7310	150	13	6.00	0	0	0	0	0	0	f	f
7311	118	13	5.00	0	0	0	0	0	0	f	f
7312	199	13	6.00	0	0	0	0	0	0	f	f
7313	149	13	5.00	0	0	0	0	0	0	f	f
7314	315	13	6.00	0	0	0	0	0	0	f	f
7315	303	13	5.50	0	0	0	0	0	0	f	f
7316	314	13	6.00	0	0	0	0	0	0	f	f
7317	287	13	5.00	0	0	0	0	0	0	t	f
7318	308	13	5.50	0	0	0	0	0	0	f	f
7319	385	13	6.00	0	0	0	0	0	0	f	f
7320	449	13	6.00	0	0	0	0	0	0	f	f
7321	467	13	5.00	0	0	0	0	0	0	f	f
7322	453	13	5.50	0	0	0	0	0	0	f	f
7323	537	13	5.50	0	0	0	0	0	0	f	f
7324	26	13	6.00	0	2	0	0	0	0	f	f
7325	222	13	6.00	0	0	0	0	0	0	f	f
7326	152	13	6.00	0	0	0	0	0	0	f	f
7327	91	13	5.50	0	0	0	0	0	0	f	f
7328	203	13	5.50	0	0	0	0	0	0	f	f
7329	168	13	5.50	0	0	0	0	0	0	f	f
7330	77	13	6.00	0	0	0	0	0	0	t	f
7331	370	13	5.00	0	0	0	0	0	0	f	f
7332	288	13	6.00	0	0	0	0	0	1	f	f
7333	399	13	4.50	0	0	0	1	0	0	f	f
7334	358	13	5.50	0	0	0	0	0	0	t	f
7335	386	13	5.00	0	0	0	0	0	0	f	f
7336	496	13	6.00	0	0	0	0	0	0	f	f
7337	488	13	5.50	0	0	0	0	0	0	t	f
7338	468	13	6.50	1	0	0	0	0	0	f	f
7339	528	13	5.50	0	0	0	0	0	0	f	f
7340	19	13	6.00	0	0	0	0	0	0	f	f
7341	78	13	6.50	0	0	0	0	0	0	f	f
7342	128	13	6.00	0	0	0	0	0	0	f	f
7343	153	13	7.00	0	0	0	0	0	1	f	f
7344	180	13	6.00	0	0	0	0	0	0	f	f
7345	197	13	6.00	0	0	0	0	0	0	f	f
7346	101	13	6.50	0	0	0	0	0	0	f	f
7347	272	13	7.00	1	0	0	0	0	0	f	f
7348	423	13	6.00	0	0	0	0	0	0	f	f
7349	321	13	7.00	0	0	0	0	0	0	f	f
7350	326	13	6.00	0	0	0	0	0	0	f	f
7351	282	13	6.00	0	0	0	0	0	0	t	f
7352	328	13	6.00	0	0	0	0	0	0	f	f
7353	452	13	7.50	0	0	0	0	0	0	t	f
7354	524	13	6.00	0	0	0	0	0	0	f	f
7355	497	13	6.00	0	0	0	0	0	0	f	f
7356	12	13	6.00	0	2	0	0	0	0	f	f
7357	155	13	6.00	0	0	0	0	0	0	f	f
7358	183	13	5.50	0	0	0	0	0	0	f	f
7359	181	13	6.00	0	0	0	0	0	0	t	f
7360	182	13	5.50	0	0	0	0	0	0	f	f
7361	254	13	6.00	0	0	0	0	0	0	f	f
7362	169	13	5.50	0	0	0	0	0	0	f	f
7363	79	13	6.50	1	0	0	0	0	0	f	f
7364	345	13	5.50	0	0	0	0	0	0	t	f
7365	408	13	5.50	0	0	0	0	0	0	f	f
7366	391	13	6.00	0	0	0	0	0	0	f	f
7367	327	13	5.50	0	0	0	0	0	0	f	f
7368	521	13	5.50	0	0	0	0	0	0	f	f
7369	473	13	5.50	0	0	0	0	0	0	f	f
7370	503	13	6.50	0	0	0	0	0	0	t	f
7371	469	13	6.00	0	0	0	0	0	0	f	f
7372	46	13	\N	0	0	0	0	0	0	f	f
7373	35	13	\N	0	0	0	0	0	0	f	f
7374	37	13	\N	0	0	0	0	0	0	f	f
7375	24	13	\N	0	0	0	0	0	0	f	f
7376	29	13	\N	0	0	0	0	0	0	f	f
7377	16	13	\N	0	0	0	0	0	0	f	f
7378	51	13	\N	0	0	0	0	0	0	f	f
7379	14	13	\N	0	0	0	0	0	0	f	f
7380	36	13	\N	0	0	0	0	0	0	f	f
7381	105	13	\N	0	0	0	0	0	0	f	f
7382	54	13	\N	0	0	0	0	0	0	f	f
7383	47	13	\N	0	0	0	0	0	0	f	f
7384	21	13	\N	0	0	0	0	0	0	f	f
7385	71	13	\N	0	0	0	0	0	0	f	f
7386	27	13	\N	0	0	0	0	0	0	f	f
7387	40	13	\N	0	0	0	0	0	0	f	f
7388	7	13	\N	0	0	0	0	0	0	f	f
7389	42	13	\N	0	0	0	0	0	0	f	f
7390	52	13	\N	0	0	0	0	0	0	f	f
7391	33	13	\N	0	0	0	0	0	0	f	f
7392	28	13	\N	0	0	0	0	0	0	f	f
7393	61	13	\N	0	0	0	0	0	0	f	f
7394	56	13	\N	0	0	0	0	0	0	f	f
7395	58	13	\N	0	0	0	0	0	0	f	f
7396	62	13	\N	0	0	0	0	0	0	f	f
7397	65	13	\N	0	0	0	0	0	0	f	f
7398	30	13	\N	0	0	0	0	0	0	f	f
7399	45	13	\N	0	0	0	0	0	0	f	f
7400	205	13	\N	0	0	0	0	0	0	f	f
7401	186	13	\N	0	0	0	0	0	0	f	f
7402	189	13	\N	0	0	0	0	0	0	f	f
7403	176	13	\N	0	0	0	0	0	0	f	f
7404	184	13	\N	0	0	0	0	0	0	f	f
7405	193	13	\N	0	0	0	0	0	0	f	f
7406	204	13	\N	0	0	0	0	0	0	f	f
7407	196	13	\N	0	0	0	0	0	0	f	f
7408	154	13	\N	0	0	0	0	0	0	f	f
7409	135	13	\N	0	0	0	0	0	0	f	f
7410	138	13	\N	0	0	0	0	0	0	f	f
7411	141	13	\N	0	0	0	0	0	0	f	f
7412	202	13	\N	0	0	0	0	0	0	f	f
7413	187	13	\N	0	0	0	0	0	0	f	f
7414	107	13	\N	0	0	0	0	0	0	f	f
7415	151	13	\N	0	0	0	0	0	0	f	f
7416	170	13	\N	0	0	0	0	0	0	f	f
7417	218	13	\N	0	0	0	0	0	0	f	f
7418	224	13	\N	0	0	0	0	0	0	f	f
7419	227	13	\N	0	0	0	0	0	0	f	f
7420	238	13	\N	0	0	0	0	0	0	f	f
7421	235	13	\N	0	0	0	0	0	0	f	f
7422	232	13	\N	0	0	0	0	0	0	f	f
7423	248	13	\N	0	0	0	0	0	0	f	f
7424	241	13	\N	0	0	0	0	0	0	f	f
7425	255	13	\N	0	0	0	0	0	0	f	f
7426	221	13	\N	0	0	0	0	0	0	f	f
7427	230	13	\N	0	0	0	0	0	0	f	f
7428	211	13	\N	0	0	0	0	0	0	f	f
7429	244	13	\N	0	0	0	0	0	0	f	f
7430	245	13	\N	0	0	0	0	0	0	f	f
7431	210	13	\N	0	0	0	0	0	0	f	f
7432	240	13	\N	0	0	0	0	0	0	f	f
7433	264	13	\N	0	0	0	0	0	0	f	f
7434	250	13	\N	0	0	0	0	0	0	f	f
7435	223	13	\N	0	0	0	0	0	0	f	f
7436	214	13	\N	0	0	0	0	0	0	f	f
7437	216	13	\N	0	0	0	0	0	0	f	f
7438	228	13	\N	0	0	0	0	0	0	f	f
7439	253	13	\N	0	0	0	0	0	0	f	f
7440	225	13	\N	0	0	0	0	0	0	f	f
7441	233	13	\N	0	0	0	0	0	0	f	f
7442	402	13	\N	0	0	0	0	0	0	f	f
7443	418	13	\N	0	0	0	0	0	0	f	f
7444	404	13	\N	0	0	0	0	0	0	f	f
7445	390	13	\N	0	0	0	0	0	0	f	f
7446	406	13	\N	0	0	0	0	0	0	f	f
7447	414	13	\N	0	0	0	0	0	0	f	f
7448	378	13	\N	0	0	0	0	0	0	f	f
7449	392	13	\N	0	0	0	0	0	0	f	f
7450	380	13	\N	0	0	0	0	0	0	f	f
7451	412	13	\N	0	0	0	0	0	0	f	f
7452	371	13	\N	0	0	0	0	0	0	f	f
7453	397	13	\N	0	0	0	0	0	0	f	f
7454	339	13	\N	0	0	0	0	0	0	f	f
7455	394	13	\N	0	0	0	0	0	0	f	f
7456	340	13	\N	0	0	0	0	0	0	f	f
7457	416	13	\N	0	0	0	0	0	0	f	f
7458	409	13	\N	0	0	0	0	0	0	f	f
7459	351	13	\N	0	0	0	0	0	0	f	f
7460	237	13	\N	0	0	0	0	0	0	f	f
7461	431	13	\N	0	0	0	0	0	0	f	f
7462	509	13	\N	0	0	0	0	0	0	f	f
7463	429	13	\N	0	0	0	0	0	0	f	f
7464	433	13	\N	0	0	0	0	0	0	f	f
7465	522	13	\N	0	0	0	0	0	0	f	f
7466	523	13	\N	0	0	0	0	0	0	f	f
7467	495	13	\N	0	0	0	0	0	0	f	f
7468	486	13	\N	0	0	0	0	0	0	f	f
7469	438	13	\N	0	0	0	0	0	0	f	f
7470	520	13	\N	0	0	0	0	0	0	f	f
7471	441	13	\N	0	0	0	0	0	0	f	f
7472	437	13	\N	0	0	0	0	0	0	f	f
7473	525	13	\N	0	0	0	0	0	0	f	f
7474	425	13	\N	0	0	0	0	0	0	f	f
7475	426	13	\N	0	0	0	0	0	0	f	f
7476	430	13	\N	0	0	0	0	0	0	f	f
7477	420	13	\N	0	0	0	0	0	0	f	f
7478	427	13	\N	0	0	0	0	0	0	f	f
7479	504	13	\N	0	0	0	0	0	0	f	f
7480	515	13	\N	0	0	0	0	0	0	f	f
7481	466	13	\N	0	0	0	0	0	0	f	f
7482	434	13	\N	0	0	0	0	0	0	f	f
7483	435	13	\N	0	0	0	0	0	0	f	f
7484	474	13	\N	0	0	0	0	0	0	f	f
7485	531	13	\N	0	0	0	0	0	0	f	f
7486	530	13	\N	0	0	0	0	0	0	f	f
7487	540	13	\N	0	0	0	0	0	0	f	f
7488	541	13	\N	0	0	0	0	0	0	f	f
7489	43	13	\N	0	0	0	0	0	0	f	f
7490	44	13	\N	0	0	0	0	0	0	f	f
7491	236	13	\N	0	0	0	0	0	0	f	f
7492	217	13	\N	0	0	0	0	0	0	f	f
7493	417	13	\N	0	0	0	0	0	0	f	f
7494	301	13	\N	0	0	0	0	0	0	f	f
7495	195	13	\N	0	0	0	0	0	0	f	f
7496	491	13	\N	0	0	0	0	0	0	f	f
7497	229	13	\N	0	0	0	0	0	0	f	f
7498	55	13	\N	0	0	0	0	0	0	f	f
7499	206	13	\N	0	0	0	0	0	0	f	f
7500	247	13	\N	0	0	0	0	0	0	f	f
7501	421	13	\N	0	0	0	0	0	0	f	f
7502	422	13	\N	0	0	0	0	0	0	f	f
7503	246	13	\N	0	0	0	0	0	0	f	f
7504	389	13	\N	0	0	0	0	0	0	f	f
7505	518	13	\N	0	0	0	0	0	0	f	f
7506	527	13	\N	0	0	0	0	0	0	f	f
7507	538	13	\N	0	0	0	0	0	0	f	f
7508	48	13	\N	0	0	0	0	0	0	f	f
7509	177	13	\N	0	0	0	0	0	0	f	f
7510	258	13	\N	0	0	0	0	0	0	f	f
7511	388	13	\N	0	0	0	0	0	0	f	f
7512	260	13	\N	0	0	0	0	0	0	f	f
7513	34	13	\N	0	0	0	0	0	0	f	f
7514	97	13	\N	0	0	0	0	0	0	f	f
7515	436	13	\N	0	0	0	0	0	0	f	f
7516	498	13	\N	0	0	0	0	0	0	f	f
7517	534	13	\N	0	0	0	0	0	0	f	f
7518	532	13	\N	0	0	0	0	0	0	f	f
7519	542	13	\N	0	0	0	0	0	0	f	f
7520	543	13	\N	0	0	0	0	0	0	f	f
7521	49	13	\N	0	0	0	0	0	0	f	f
7522	201	13	\N	0	0	0	0	0	0	f	f
7523	239	13	\N	0	0	0	0	0	0	f	f
7524	266	13	\N	0	0	0	0	0	0	f	f
7525	334	13	\N	0	0	0	0	0	0	f	f
7526	476	13	\N	0	0	0	0	0	0	f	f
7527	60	13	\N	0	0	0	0	0	0	f	f
7528	57	13	\N	0	0	0	0	0	0	f	f
7529	198	13	\N	0	0	0	0	0	0	f	f
7530	131	13	\N	0	0	0	0	0	0	f	f
7531	39	13	\N	0	0	0	0	0	0	f	f
7532	59	13	\N	0	0	0	0	0	0	f	f
7533	440	13	\N	0	0	0	0	0	0	f	f
7534	398	13	\N	0	0	0	0	0	0	f	f
7535	507	13	\N	0	0	0	0	0	0	f	f
7536	442	13	\N	0	0	0	0	0	0	f	f
7537	87	13	\N	0	0	0	0	0	0	f	f
7538	194	13	\N	0	0	0	0	0	0	f	f
7539	234	13	\N	0	0	0	0	0	0	f	f
7540	410	13	\N	0	0	0	0	0	0	f	f
7541	535	13	\N	0	0	0	0	0	0	f	f
7542	322	13	\N	0	0	0	0	0	0	f	f
7543	53	13	\N	0	0	0	0	0	0	f	f
7544	251	13	\N	0	0	0	0	0	0	f	f
7545	167	13	\N	0	0	0	0	0	0	f	f
7546	471	13	\N	0	0	0	0	0	0	f	f
7547	346	13	\N	0	0	0	0	0	0	f	f
7548	32	13	\N	0	0	0	0	0	0	f	f
7549	158	13	\N	0	0	0	0	0	0	f	f
7550	132	13	\N	0	0	0	0	0	0	f	f
7551	200	13	\N	0	0	0	0	0	0	f	f
7552	364	13	\N	0	0	0	0	0	0	f	f
7553	276	13	\N	0	0	0	0	0	0	f	f
7554	9	13	\N	0	0	0	0	0	0	f	f
7555	209	13	\N	0	0	0	0	0	0	f	f
7556	374	13	\N	0	0	0	0	0	0	f	f
7557	336	13	\N	0	0	0	0	0	0	f	f
7558	38	13	\N	0	0	0	0	0	0	f	f
7559	256	13	\N	0	0	0	0	0	0	f	f
7560	213	13	\N	0	0	0	0	0	0	f	f
7561	377	13	\N	0	0	0	0	0	0	f	f
7562	22	13	\N	0	0	0	0	0	0	f	f
7563	179	13	\N	0	0	0	0	0	0	f	f
7564	249	13	\N	0	0	0	0	0	0	f	f
7565	407	13	\N	0	0	0	0	0	0	f	f
7566	387	13	\N	0	0	0	0	0	0	f	f
7567	439	13	\N	0	0	0	0	0	0	f	f
7568	539	13	\N	0	0	0	0	0	0	f	f
7569	252	13	\N	0	0	0	0	0	0	f	f
7570	413	13	\N	0	0	0	0	0	0	f	f
7571	309	13	\N	0	0	0	0	0	0	f	f
7572	424	13	\N	0	0	0	0	0	0	f	f
7573	41	13	\N	0	0	0	0	0	0	f	f
7574	82	13	\N	0	0	0	0	0	0	f	f
7575	259	13	\N	0	0	0	0	0	0	f	f
7576	163	13	\N	0	0	0	0	0	0	f	f
7577	352	13	\N	0	0	0	0	0	0	f	f
7578	257	13	\N	0	0	0	0	0	0	f	f
7579	419	13	\N	0	0	0	0	0	0	f	f
7580	432	13	\N	0	0	0	0	0	0	f	f
7581	64	13	\N	0	0	0	0	0	0	f	f
7582	188	13	\N	0	0	0	0	0	0	f	f
7583	212	13	\N	0	0	0	0	0	0	f	f
7584	160	13	\N	0	0	0	0	0	0	f	f
7585	395	13	\N	0	0	0	0	0	0	f	f
7586	277	13	\N	0	0	0	0	0	0	f	f
7587	526	13	\N	0	0	0	0	0	0	f	f
7588	533	13	\N	0	0	0	0	0	0	f	f
7589	393	13	\N	0	0	0	0	0	0	f	f
7590	50	13	\N	0	0	0	0	0	0	f	f
7591	114	13	\N	0	0	0	0	0	0	f	f
7592	443	13	\N	0	0	0	0	0	0	f	f
7593	372	13	\N	0	0	0	0	0	0	f	f
7594	166	13	\N	0	0	0	0	0	0	f	f
7595	243	13	\N	0	0	0	0	0	0	f	f
7596	242	13	\N	0	0	0	0	0	0	f	f
7597	324	13	\N	0	0	0	0	0	0	f	f
7598	102	13	\N	0	0	0	0	0	0	f	f
7599	63	13	\N	0	0	0	0	0	0	f	f
7600	231	13	\N	0	0	0	0	0	0	f	f
7601	506	13	\N	0	0	0	0	0	0	f	f
7602	512	13	\N	0	0	0	0	0	0	f	f
7603	5	14	6.00	0	3	0	0	0	0	f	f
7604	120	14	5.50	0	0	0	0	0	0	f	f
7605	156	14	5.00	0	0	0	0	0	0	f	f
7606	207	14	5.50	0	0	0	0	0	0	f	f
7607	94	14	5.50	0	0	0	0	0	0	f	f
7608	93	14	5.50	0	0	0	0	0	0	f	f
7609	157	14	5.00	0	0	0	0	0	0	f	f
7610	338	14	5.00	0	0	0	0	0	0	t	f
7611	296	14	6.00	0	0	0	0	0	0	f	f
7612	276	14	6.00	0	0	0	0	0	0	f	f
7613	312	14	5.50	0	0	0	0	0	0	f	f
7614	329	14	5.50	0	0	0	0	0	0	f	f
7615	454	14	6.50	0	0	0	0	0	0	f	f
7616	462	14	5.00	0	0	0	0	0	0	f	f
7617	459	14	5.50	0	0	0	0	0	0	f	f
7618	465	14	5.00	0	0	0	0	0	0	f	f
7619	20	14	7.50	0	1	0	0	0	0	f	f
7620	188	14	6.50	0	0	0	0	0	0	f	f
7621	123	14	7.00	0	0	0	0	0	0	f	f
7622	85	14	6.00	0	0	0	0	0	0	t	f
7623	208	14	5.50	0	0	0	0	0	0	f	f
7624	103	14	5.50	0	0	0	0	0	0	f	f
7625	341	14	5.50	0	0	0	0	0	0	f	f
7626	263	14	6.00	0	0	0	0	0	0	f	f
7627	269	14	6.50	1	0	0	0	0	0	f	f
7628	311	14	6.50	0	0	0	0	0	0	f	f
7629	346	14	6.00	0	0	0	0	0	0	f	f
7630	323	14	6.00	0	0	0	0	0	0	t	f
7631	336	14	6.00	0	0	0	0	0	0	f	f
7632	458	14	5.50	0	0	0	0	0	0	t	f
7633	451	14	5.50	0	0	0	0	0	0	f	f
7634	489	14	6.00	0	0	0	0	0	0	f	f
7635	10	14	6.00	0	0	0	0	0	0	f	f
7636	96	14	6.50	0	0	0	0	0	0	f	f
7637	133	14	6.00	0	0	0	0	0	0	f	f
7638	210	14	6.00	0	0	0	0	0	0	f	f
7639	159	14	6.50	0	0	0	0	0	0	f	f
7640	69	14	7.00	0	0	0	0	0	0	f	f
7641	122	14	6.00	0	0	0	0	0	0	f	f
7642	204	14	6.50	0	0	0	0	0	0	f	f
7643	347	14	6.50	0	0	0	0	0	0	f	f
7644	304	14	7.00	1	0	0	0	0	0	t	f
7645	361	14	6.00	0	0	0	0	0	0	f	f
7646	330	14	7.00	0	0	0	0	0	0	t	f
7647	348	14	6.00	0	0	0	0	0	0	f	f
7648	470	14	7.00	0	0	0	0	0	1	f	f
7649	478	14	6.00	0	0	0	0	0	0	f	f
7650	529	14	6.00	0	0	0	0	0	0	f	f
7651	6	14	6.50	0	4	0	0	0	0	f	f
7652	119	14	5.00	0	0	0	0	0	0	t	f
7653	86	14	5.00	0	0	0	0	0	0	f	f
7654	95	14	5.50	0	0	0	0	0	0	f	f
7655	105	14	5.00	0	0	0	0	0	0	f	f
7656	117	14	5.50	0	0	0	0	0	0	f	f
7657	316	14	6.00	0	0	0	0	0	0	f	f
7658	317	14	5.00	0	0	0	0	0	0	f	f
7659	290	14	6.00	0	0	0	0	0	0	t	f
7660	261	14	5.50	0	0	0	0	0	0	f	f
7661	512	14	5.50	0	0	0	0	0	0	f	f
7662	506	14	6.00	0	0	0	0	0	0	f	f
7663	463	14	5.00	0	0	0	0	0	0	f	f
7664	479	14	5.50	0	0	0	0	0	0	f	f
7665	514	14	6.00	0	0	0	0	0	0	f	f
7666	499	14	6.00	0	0	0	0	0	0	f	f
7667	11	14	6.00	0	0	0	0	0	0	f	f
7668	134	14	6.50	0	0	0	0	0	0	t	f
7669	75	14	6.50	0	0	0	0	0	0	f	f
7670	70	14	7.00	0	0	0	0	0	0	f	f
7671	106	14	6.50	0	0	0	0	0	0	f	f
7672	172	14	6.00	0	0	0	0	0	0	f	f
7673	160	14	6.50	0	0	0	0	0	0	f	f
7674	375	14	6.00	0	0	0	0	0	0	f	f
7675	277	14	6.00	0	0	0	0	0	0	f	f
7676	355	14	6.00	0	0	0	0	0	0	f	f
7677	343	14	6.50	0	0	0	0	0	1	f	f
7678	325	14	7.00	0	0	0	0	0	0	f	f
7679	283	14	6.50	0	0	0	0	0	0	f	f
7680	511	14	7.00	1	0	0	0	0	0	f	f
7681	464	14	7.00	0	0	0	0	0	0	f	f
7682	457	14	6.00	0	0	0	0	0	0	f	f
7683	17	14	4.50	0	3	0	0	0	0	f	f
7684	124	14	5.50	0	0	0	0	0	0	f	f
7685	190	14	5.00	0	0	0	0	0	0	f	f
7686	191	14	5.50	0	0	0	0	0	0	f	f
7687	213	14	5.00	0	0	0	0	0	0	t	f
7688	161	14	5.00	0	0	0	0	0	0	f	f
7689	174	14	5.50	0	0	0	0	0	0	f	f
7690	162	14	5.50	0	0	0	0	0	0	f	f
7691	274	14	6.00	0	0	0	0	0	0	t	f
7692	376	14	5.50	0	0	0	0	0	0	f	f
7693	366	14	5.50	0	0	0	0	0	0	f	f
7694	297	14	5.00	0	0	0	0	0	0	f	f
7695	396	14	5.50	0	0	0	0	0	0	t	f
7696	460	14	5.00	0	0	0	0	0	0	f	f
7697	505	14	5.50	0	0	0	0	0	0	f	f
7698	18	14	6.00	0	1	0	0	0	0	f	f
7699	74	14	6.00	0	0	0	0	0	0	f	f
7700	98	14	6.50	0	0	0	0	0	0	f	f
7701	192	14	6.00	0	0	0	0	0	0	f	f
7702	135	14	7.00	1	0	0	0	0	0	f	f
7703	214	14	6.00	0	0	0	0	0	0	f	f
7704	298	14	6.00	0	0	0	0	0	0	f	f
7705	305	14	7.00	0	0	0	0	0	0	f	f
7706	397	14	6.00	0	0	0	0	0	0	f	f
7707	349	14	6.50	0	0	0	0	0	0	f	f
7708	508	14	6.50	0	0	0	0	0	0	f	f
7709	500	14	6.50	0	0	0	0	0	1	f	f
7710	490	14	5.50	0	0	0	0	0	0	f	f
7711	507	14	6.00	0	0	0	0	0	0	f	f
7712	13	14	6.00	0	0	0	0	0	0	f	f
7713	66	14	7.00	0	0	0	0	0	2	f	f
7714	136	14	6.50	0	0	0	0	0	0	f	f
7715	67	14	6.50	0	0	0	0	0	0	f	f
7716	104	14	6.00	0	0	0	0	0	0	t	f
7717	81	14	7.00	1	0	0	0	0	0	f	f
7718	300	14	6.00	0	0	0	0	0	0	f	f
7719	270	14	7.00	0	0	0	0	0	0	f	f
7720	262	14	7.00	1	0	0	0	0	0	f	f
7721	351	14	6.00	0	0	0	0	0	0	f	f
7722	350	14	7.00	0	0	0	0	0	1	f	f
7723	411	14	6.00	0	0	0	0	0	0	f	f
7724	299	14	6.00	0	0	0	0	0	0	f	f
7725	444	14	7.00	1	0	0	0	0	0	f	f
7726	445	14	7.00	1	0	0	0	0	0	f	f
7727	475	14	6.00	0	0	0	0	0	0	f	f
7728	7	14	6.50	0	2	0	0	0	0	f	f
7729	88	14	6.00	0	0	0	0	0	0	t	f
7730	99	14	5.50	0	0	0	0	0	0	f	f
7731	109	14	5.50	0	0	0	0	0	0	f	f
7732	108	14	5.00	0	0	0	0	0	0	f	f
7733	307	14	6.00	0	0	0	0	0	0	f	f
7734	306	14	5.50	0	0	0	0	0	0	f	f
7735	332	14	5.50	0	0	0	0	0	1	f	f
7736	291	14	6.00	0	0	0	0	0	0	f	f
7737	353	14	5.00	0	0	0	0	0	0	f	f
7738	322	14	6.00	0	0	0	0	0	0	f	f
7739	400	14	6.00	0	0	0	0	0	0	f	f
7740	278	14	5.50	0	0	0	0	0	0	f	f
7741	480	14	6.00	0	0	0	0	0	0	f	f
7742	477	14	6.00	0	0	0	0	0	0	f	f
7743	446	14	7.00	1	0	0	0	0	0	f	f
7744	3	14	6.50	0	1	0	0	0	0	f	f
7745	217	14	6.00	0	0	0	0	0	0	f	f
7746	126	14	6.50	0	0	0	0	0	0	f	f
7747	110	14	6.00	0	0	0	0	0	0	f	f
7748	195	14	6.00	0	0	0	0	0	0	t	f
7749	145	14	5.00	0	0	0	0	0	0	t	f
7750	125	14	5.00	0	0	0	0	0	0	f	t
7751	301	14	6.00	0	0	0	0	0	0	f	f
7752	267	14	6.50	0	0	0	0	0	0	f	f
7753	292	14	6.50	0	0	0	0	0	0	f	f
7754	284	14	6.50	0	0	0	0	0	0	f	f
7755	285	14	7.00	1	0	0	0	0	0	f	f
7756	363	14	6.00	0	0	0	0	0	0	f	f
7757	491	14	6.00	0	0	0	0	0	0	f	f
7758	455	14	5.50	0	0	0	0	0	0	f	f
7759	492	14	6.00	0	0	0	0	0	0	f	f
7760	8	14	6.00	0	2	0	0	0	0	f	f
7761	127	14	5.50	0	0	0	0	0	0	t	f
7762	164	14	5.50	0	0	0	0	0	0	f	f
7763	89	14	5.50	0	0	0	0	0	0	f	f
7764	146	14	5.00	0	0	0	0	0	0	f	f
7765	310	14	6.00	0	0	0	0	0	0	f	f
7766	293	14	5.50	0	0	0	0	0	0	f	f
7767	286	14	6.00	0	0	0	0	0	0	f	f
7768	354	14	5.00	0	0	0	0	0	0	f	f
7769	401	14	6.00	0	0	0	0	0	0	f	f
7770	333	14	5.50	0	0	0	0	0	0	f	f
7771	412	14	6.00	0	0	0	0	0	0	f	f
7772	501	14	5.50	0	0	0	0	0	0	t	f
7773	509	14	5.50	0	0	0	0	0	0	f	f
7774	495	14	5.50	0	0	0	0	0	0	f	f
7775	513	14	5.00	0	0	0	0	0	0	f	f
7776	1	14	6.00	0	2	0	0	0	0	t	f
7777	111	14	6.00	0	0	0	0	0	0	f	f
7778	139	14	5.50	0	0	0	0	0	0	f	f
7779	68	14	5.50	0	0	0	0	0	0	f	f
7780	177	14	6.00	0	0	0	0	0	0	f	f
7781	90	14	6.00	0	0	0	0	0	0	f	f
7782	273	14	7.00	1	0	0	0	0	0	f	f
7783	260	14	8.00	2	0	0	0	0	0	f	f
7784	268	14	6.50	0	0	0	0	0	0	f	f
7785	302	14	6.00	0	0	0	0	0	0	f	f
7786	271	14	6.50	0	0	0	0	0	1	f	f
7787	294	14	6.50	0	0	0	0	0	1	f	f
7788	447	14	5.50	0	0	0	0	0	0	f	f
7789	485	14	5.50	0	0	0	0	0	0	f	f
7790	4	14	6.00	0	1	0	0	0	0	f	f
7791	71	14	6.00	0	0	0	0	0	0	f	f
7792	83	14	6.50	0	0	0	0	0	0	t	f
7793	113	14	6.00	0	0	0	0	0	0	f	f
7794	140	14	6.50	0	0	0	0	0	0	f	f
7795	178	14	5.50	0	0	0	0	0	0	f	f
7796	112	14	6.00	0	0	0	0	0	0	t	f
7797	319	14	6.00	0	0	0	0	0	0	f	f
7798	360	14	5.50	0	0	0	0	0	0	f	f
7799	265	14	6.50	0	0	0	0	0	0	f	f
7800	279	14	7.50	0	0	0	0	0	1	f	f
7801	441	14	6.00	0	0	0	0	0	0	f	f
7802	450	14	8.00	2	0	0	0	0	0	f	f
7803	483	14	5.50	0	0	0	0	0	0	f	f
7804	23	14	6.00	0	0	0	0	0	0	f	f
7805	147	14	6.00	0	0	0	0	0	0	f	f
7806	116	14	6.00	0	0	0	0	0	0	t	f
7807	115	14	6.50	0	0	0	0	0	0	f	f
7808	220	14	6.00	0	0	0	0	0	0	f	f
7809	143	14	6.50	0	0	0	0	0	0	f	f
7810	403	14	6.00	0	0	0	0	0	0	f	f
7811	372	14	6.00	0	0	0	0	0	0	f	f
7812	280	14	6.00	0	0	0	0	0	0	f	f
7813	365	14	6.50	0	0	0	0	0	0	f	f
7814	367	14	6.00	0	0	0	0	0	0	f	f
7815	404	14	6.00	0	0	0	0	0	0	f	f
7816	359	14	6.00	0	0	0	0	0	0	f	f
7817	502	14	6.50	0	0	0	0	0	0	t	f
7818	456	14	5.50	0	0	0	0	0	0	f	f
7819	31	14	6.00	0	1	0	0	0	0	f	f
7820	148	14	5.50	0	0	0	0	0	0	f	f
7821	166	14	6.00	0	0	0	0	0	0	f	f
7822	165	14	6.00	0	0	0	0	0	0	f	f
7823	129	14	6.00	0	0	0	0	0	0	f	f
7824	344	14	5.50	0	0	0	0	0	0	f	f
7825	368	14	6.00	0	0	0	0	0	0	f	f
7826	373	14	6.00	0	0	0	0	0	0	t	f
7827	324	14	6.50	0	0	0	0	0	0	f	f
7828	382	14	6.00	0	0	0	0	0	0	f	f
7829	320	14	6.00	0	0	0	0	0	0	t	f
7830	383	14	5.50	0	0	0	0	0	0	f	f
7831	337	14	6.00	0	0	0	0	0	0	f	f
7832	472	14	4.50	0	0	0	0	0	0	f	t
7833	487	14	6.00	0	0	0	0	0	0	f	f
7834	517	14	5.50	0	0	0	0	0	0	f	f
7835	2	14	7.00	0	1	0	0	0	0	f	f
7836	100	14	5.00	0	0	0	0	0	0	f	f
7837	130	14	5.50	0	0	0	0	0	0	f	f
7838	76	14	4.50	0	0	0	0	0	0	f	t
7839	84	14	5.50	0	0	0	0	0	0	t	f
7840	202	14	5.50	0	0	0	0	0	0	f	f
7841	251	14	4.50	0	0	0	0	0	0	f	f
7842	167	14	5.50	0	0	0	0	0	0	f	f
7843	275	14	5.50	0	0	0	0	0	0	f	f
7844	295	14	5.50	0	0	0	0	0	0	f	f
7845	281	14	6.00	0	0	0	0	0	0	f	f
7846	384	14	5.50	0	0	0	0	0	0	f	f
7847	357	14	5.50	0	0	0	0	0	0	f	f
7848	481	14	5.50	0	0	0	0	0	0	f	f
7849	448	14	6.00	0	0	0	0	0	0	f	f
7850	484	14	5.50	0	0	0	0	0	0	f	f
7851	15	14	5.00	0	1	0	0	0	0	t	f
7852	142	14	6.00	0	0	0	0	0	0	f	f
7853	150	14	6.50	0	0	0	0	0	0	f	f
7854	206	14	6.00	0	0	0	0	0	0	f	f
7855	118	14	6.50	0	0	0	0	0	0	f	f
7856	149	14	7.50	1	0	0	0	0	0	f	f
7857	315	14	6.00	0	0	0	0	0	0	f	f
7858	303	14	7.50	1	0	0	0	0	1	f	f
7859	314	14	6.50	0	0	0	0	0	0	t	f
7860	287	14	7.00	1	0	0	0	0	0	f	f
7861	308	14	6.00	0	0	0	0	0	0	f	f
7862	527	14	6.00	0	0	0	0	0	0	f	f
7863	467	14	5.50	0	0	0	0	0	0	f	f
7864	453	14	6.50	0	0	0	0	0	1	f	f
7865	518	14	6.50	0	0	0	0	0	0	f	f
7866	26	14	6.00	0	3	0	0	0	0	f	f
7867	222	14	6.00	0	0	0	0	0	0	f	f
7868	152	14	6.00	0	0	0	0	0	0	t	f
7869	91	14	5.50	0	0	0	0	0	0	f	f
7870	203	14	6.00	0	0	0	0	0	0	f	f
7871	168	14	5.50	0	0	0	0	0	0	f	f
7872	77	14	5.00	0	0	0	0	0	0	f	f
7873	370	14	5.50	0	0	0	0	0	0	f	f
7874	288	14	7.00	0	0	0	0	0	1	f	f
7875	399	14	5.00	0	0	0	0	0	0	f	f
7876	358	14	5.50	0	0	0	0	0	0	f	f
7877	407	14	6.00	0	0	0	0	0	0	t	f
7878	496	14	6.50	1	0	0	0	0	0	f	f
7879	488	14	6.00	0	0	0	0	0	0	f	f
7880	468	14	6.00	0	0	0	0	0	0	f	f
7881	528	14	6.00	0	0	0	0	0	0	f	f
7882	19	14	5.50	0	2	0	0	0	0	f	f
7883	78	14	6.00	0	0	0	0	0	0	f	f
7884	128	14	6.00	0	0	0	0	0	0	f	f
7885	153	14	5.50	0	0	0	0	0	0	f	f
7886	180	14	6.00	0	0	0	0	0	0	f	f
7887	197	14	6.00	0	0	0	0	0	0	f	f
7888	223	14	6.00	0	0	0	0	0	1	f	f
7889	101	14	5.50	0	0	0	0	0	0	f	f
7890	272	14	6.00	0	0	0	0	0	0	f	f
7891	371	14	6.00	0	0	0	0	0	0	f	f
7892	321	14	5.50	0	0	0	0	0	0	t	f
7893	326	14	6.00	0	0	0	0	0	0	f	f
7894	328	14	7.00	1	0	0	0	0	0	f	f
7895	452	14	6.00	0	0	0	0	0	0	f	f
7896	524	14	6.00	0	0	0	0	0	0	f	f
7897	497	14	6.00	0	0	0	0	0	0	f	f
7898	12	14	7.00	0	1	0	0	0	0	f	f
7899	183	14	6.50	0	0	0	0	0	0	t	f
7900	181	14	6.50	0	0	0	0	0	0	f	f
7901	182	14	6.00	0	0	0	0	0	0	f	f
7902	254	14	6.00	0	0	0	0	0	0	f	f
7903	169	14	7.00	0	0	0	0	0	0	t	f
7904	79	14	7.00	1	0	0	0	0	0	f	f
7905	170	14	5.50	0	0	0	0	0	0	f	f
7906	435	14	6.00	0	0	0	0	0	0	f	f
7907	408	14	6.50	0	0	0	0	0	0	f	f
7908	409	14	6.00	0	0	0	0	0	0	f	f
7909	391	14	6.50	0	0	0	0	0	0	f	f
7910	327	14	7.50	1	0	0	0	0	0	f	f
7911	521	14	6.00	0	0	0	0	0	0	f	f
7912	503	14	7.00	0	0	0	0	0	1	f	f
7913	469	14	7.50	1	0	0	0	0	1	f	f
7914	46	14	\N	0	0	0	0	0	0	f	f
7915	35	14	\N	0	0	0	0	0	0	f	f
7916	37	14	\N	0	0	0	0	0	0	f	f
7917	24	14	\N	0	0	0	0	0	0	f	f
7918	29	14	\N	0	0	0	0	0	0	f	f
7919	16	14	\N	0	0	0	0	0	0	f	f
7920	51	14	\N	0	0	0	0	0	0	f	f
7921	14	14	\N	0	0	0	0	0	0	f	f
7922	36	14	\N	0	0	0	0	0	0	f	f
7923	80	14	\N	0	0	0	0	0	0	f	f
7924	92	14	\N	0	0	0	0	0	0	f	f
7925	54	14	\N	0	0	0	0	0	0	f	f
7926	47	14	\N	0	0	0	0	0	0	f	f
7927	21	14	\N	0	0	0	0	0	0	f	f
7928	27	14	\N	0	0	0	0	0	0	f	f
7929	40	14	\N	0	0	0	0	0	0	f	f
7930	42	14	\N	0	0	0	0	0	0	f	f
7931	52	14	\N	0	0	0	0	0	0	f	f
7932	33	14	\N	0	0	0	0	0	0	f	f
7933	28	14	\N	0	0	0	0	0	0	f	f
7934	61	14	\N	0	0	0	0	0	0	f	f
7935	56	14	\N	0	0	0	0	0	0	f	f
7936	58	14	\N	0	0	0	0	0	0	f	f
7937	62	14	\N	0	0	0	0	0	0	f	f
7938	65	14	\N	0	0	0	0	0	0	f	f
7939	30	14	\N	0	0	0	0	0	0	f	f
7940	45	14	\N	0	0	0	0	0	0	f	f
7941	205	14	\N	0	0	0	0	0	0	f	f
7942	186	14	\N	0	0	0	0	0	0	f	f
7943	189	14	\N	0	0	0	0	0	0	f	f
7944	171	14	\N	0	0	0	0	0	0	f	f
7945	173	14	\N	0	0	0	0	0	0	f	f
7946	144	14	\N	0	0	0	0	0	0	f	f
7947	176	14	\N	0	0	0	0	0	0	f	f
7948	199	14	\N	0	0	0	0	0	0	f	f
7949	184	14	\N	0	0	0	0	0	0	f	f
7950	193	14	\N	0	0	0	0	0	0	f	f
7951	196	14	\N	0	0	0	0	0	0	f	f
7952	154	14	\N	0	0	0	0	0	0	f	f
7953	138	14	\N	0	0	0	0	0	0	f	f
7954	141	14	\N	0	0	0	0	0	0	f	f
7955	121	14	\N	0	0	0	0	0	0	f	f
7956	187	14	\N	0	0	0	0	0	0	f	f
7957	175	14	\N	0	0	0	0	0	0	f	f
7958	107	14	\N	0	0	0	0	0	0	f	f
7959	151	14	\N	0	0	0	0	0	0	f	f
7960	155	14	\N	0	0	0	0	0	0	f	f
7961	137	14	\N	0	0	0	0	0	0	f	f
7962	218	14	\N	0	0	0	0	0	0	f	f
7963	224	14	\N	0	0	0	0	0	0	f	f
7964	227	14	\N	0	0	0	0	0	0	f	f
7965	238	14	\N	0	0	0	0	0	0	f	f
7966	235	14	\N	0	0	0	0	0	0	f	f
7967	232	14	\N	0	0	0	0	0	0	f	f
7968	226	14	\N	0	0	0	0	0	0	f	f
7969	248	14	\N	0	0	0	0	0	0	f	f
7970	241	14	\N	0	0	0	0	0	0	f	f
7971	255	14	\N	0	0	0	0	0	0	f	f
7972	221	14	\N	0	0	0	0	0	0	f	f
7973	230	14	\N	0	0	0	0	0	0	f	f
7974	211	14	\N	0	0	0	0	0	0	f	f
7975	244	14	\N	0	0	0	0	0	0	f	f
7976	245	14	\N	0	0	0	0	0	0	f	f
7977	313	14	\N	0	0	0	0	0	0	f	f
7978	240	14	\N	0	0	0	0	0	0	f	f
7979	264	14	\N	0	0	0	0	0	0	f	f
7980	250	14	\N	0	0	0	0	0	0	f	f
7981	215	14	\N	0	0	0	0	0	0	f	f
7982	216	14	\N	0	0	0	0	0	0	f	f
7983	228	14	\N	0	0	0	0	0	0	f	f
7984	253	14	\N	0	0	0	0	0	0	f	f
7985	225	14	\N	0	0	0	0	0	0	f	f
7986	233	14	\N	0	0	0	0	0	0	f	f
7987	402	14	\N	0	0	0	0	0	0	f	f
7988	418	14	\N	0	0	0	0	0	0	f	f
7989	405	14	\N	0	0	0	0	0	0	f	f
7990	390	14	\N	0	0	0	0	0	0	f	f
7991	406	14	\N	0	0	0	0	0	0	f	f
7992	414	14	\N	0	0	0	0	0	0	f	f
7993	378	14	\N	0	0	0	0	0	0	f	f
7994	392	14	\N	0	0	0	0	0	0	f	f
7995	380	14	\N	0	0	0	0	0	0	f	f
7996	385	14	\N	0	0	0	0	0	0	f	f
7997	356	14	\N	0	0	0	0	0	0	f	f
7998	379	14	\N	0	0	0	0	0	0	f	f
7999	318	14	\N	0	0	0	0	0	0	f	f
8000	369	14	\N	0	0	0	0	0	0	f	f
8001	339	14	\N	0	0	0	0	0	0	f	f
8002	394	14	\N	0	0	0	0	0	0	f	f
8003	340	14	\N	0	0	0	0	0	0	f	f
8004	416	14	\N	0	0	0	0	0	0	f	f
8005	386	14	\N	0	0	0	0	0	0	f	f
8006	345	14	\N	0	0	0	0	0	0	f	f
8007	237	14	\N	0	0	0	0	0	0	f	f
8008	431	14	\N	0	0	0	0	0	0	f	f
8009	429	14	\N	0	0	0	0	0	0	f	f
8010	433	14	\N	0	0	0	0	0	0	f	f
8011	522	14	\N	0	0	0	0	0	0	f	f
8012	523	14	\N	0	0	0	0	0	0	f	f
8013	449	14	\N	0	0	0	0	0	0	f	f
8014	486	14	\N	0	0	0	0	0	0	f	f
8015	428	14	\N	0	0	0	0	0	0	f	f
8016	438	14	\N	0	0	0	0	0	0	f	f
8017	520	14	\N	0	0	0	0	0	0	f	f
8018	510	14	\N	0	0	0	0	0	0	f	f
8019	437	14	\N	0	0	0	0	0	0	f	f
8020	525	14	\N	0	0	0	0	0	0	f	f
8021	425	14	\N	0	0	0	0	0	0	f	f
8022	426	14	\N	0	0	0	0	0	0	f	f
8023	430	14	\N	0	0	0	0	0	0	f	f
8024	420	14	\N	0	0	0	0	0	0	f	f
8025	427	14	\N	0	0	0	0	0	0	f	f
8026	504	14	\N	0	0	0	0	0	0	f	f
8027	515	14	\N	0	0	0	0	0	0	f	f
8028	466	14	\N	0	0	0	0	0	0	f	f
8029	434	14	\N	0	0	0	0	0	0	f	f
8030	473	14	\N	0	0	0	0	0	0	f	f
8031	474	14	\N	0	0	0	0	0	0	f	f
8032	531	14	\N	0	0	0	0	0	0	f	f
8033	219	14	\N	0	0	0	0	0	0	f	f
8034	530	14	\N	0	0	0	0	0	0	f	f
8035	540	14	\N	0	0	0	0	0	0	f	f
8036	541	14	\N	0	0	0	0	0	0	f	f
8037	43	14	\N	0	0	0	0	0	0	f	f
8038	44	14	\N	0	0	0	0	0	0	f	f
8039	236	14	\N	0	0	0	0	0	0	f	f
8040	417	14	\N	0	0	0	0	0	0	f	f
8041	362	14	\N	0	0	0	0	0	0	f	f
8042	494	14	\N	0	0	0	0	0	0	f	f
8043	229	14	\N	0	0	0	0	0	0	f	f
8044	55	14	\N	0	0	0	0	0	0	f	f
8045	247	14	\N	0	0	0	0	0	0	f	f
8046	421	14	\N	0	0	0	0	0	0	f	f
8047	422	14	\N	0	0	0	0	0	0	f	f
8048	246	14	\N	0	0	0	0	0	0	f	f
8049	389	14	\N	0	0	0	0	0	0	f	f
8050	538	14	\N	0	0	0	0	0	0	f	f
8051	48	14	\N	0	0	0	0	0	0	f	f
8052	258	14	\N	0	0	0	0	0	0	f	f
8053	388	14	\N	0	0	0	0	0	0	f	f
8054	34	14	\N	0	0	0	0	0	0	f	f
8055	97	14	\N	0	0	0	0	0	0	f	f
8056	516	14	\N	0	0	0	0	0	0	f	f
8057	289	14	\N	0	0	0	0	0	0	f	f
8058	436	14	\N	0	0	0	0	0	0	f	f
8059	498	14	\N	0	0	0	0	0	0	f	f
8060	534	14	\N	0	0	0	0	0	0	f	f
8061	532	14	\N	0	0	0	0	0	0	f	f
8062	542	14	\N	0	0	0	0	0	0	f	f
8063	543	14	\N	0	0	0	0	0	0	f	f
8064	49	14	\N	0	0	0	0	0	0	f	f
8065	201	14	\N	0	0	0	0	0	0	f	f
8066	239	14	\N	0	0	0	0	0	0	f	f
8067	266	14	\N	0	0	0	0	0	0	f	f
8068	334	14	\N	0	0	0	0	0	0	f	f
8069	476	14	\N	0	0	0	0	0	0	f	f
8070	60	14	\N	0	0	0	0	0	0	f	f
8071	57	14	\N	0	0	0	0	0	0	f	f
8072	198	14	\N	0	0	0	0	0	0	f	f
8073	131	14	\N	0	0	0	0	0	0	f	f
8074	282	14	\N	0	0	0	0	0	0	f	f
8075	423	14	\N	0	0	0	0	0	0	f	f
8076	39	14	\N	0	0	0	0	0	0	f	f
8077	59	14	\N	0	0	0	0	0	0	f	f
8078	440	14	\N	0	0	0	0	0	0	f	f
8079	342	14	\N	0	0	0	0	0	0	f	f
8080	398	14	\N	0	0	0	0	0	0	f	f
8081	442	14	\N	0	0	0	0	0	0	f	f
8082	25	14	\N	0	0	0	0	0	0	f	f
8083	87	14	\N	0	0	0	0	0	0	f	f
8084	194	14	\N	0	0	0	0	0	0	f	f
8085	234	14	\N	0	0	0	0	0	0	f	f
8086	410	14	\N	0	0	0	0	0	0	f	f
8087	535	14	\N	0	0	0	0	0	0	f	f
8088	461	14	\N	0	0	0	0	0	0	f	f
8089	53	14	\N	0	0	0	0	0	0	f	f
8090	72	14	\N	0	0	0	0	0	0	f	f
8091	335	14	\N	0	0	0	0	0	0	f	f
8092	471	14	\N	0	0	0	0	0	0	f	f
8093	32	14	\N	0	0	0	0	0	0	f	f
8094	158	14	\N	0	0	0	0	0	0	f	f
8095	132	14	\N	0	0	0	0	0	0	f	f
8096	200	14	\N	0	0	0	0	0	0	f	f
8097	364	14	\N	0	0	0	0	0	0	f	f
8098	9	14	\N	0	0	0	0	0	0	f	f
8099	209	14	\N	0	0	0	0	0	0	f	f
8100	374	14	\N	0	0	0	0	0	0	f	f
8101	73	14	\N	0	0	0	0	0	0	f	f
8102	537	14	\N	0	0	0	0	0	0	f	f
8103	482	14	\N	0	0	0	0	0	0	f	f
8104	519	14	\N	0	0	0	0	0	0	f	f
8105	38	14	\N	0	0	0	0	0	0	f	f
8106	256	14	\N	0	0	0	0	0	0	f	f
8107	377	14	\N	0	0	0	0	0	0	f	f
8108	415	14	\N	0	0	0	0	0	0	f	f
8109	22	14	\N	0	0	0	0	0	0	f	f
8110	179	14	\N	0	0	0	0	0	0	f	f
8111	249	14	\N	0	0	0	0	0	0	f	f
8112	387	14	\N	0	0	0	0	0	0	f	f
8113	439	14	\N	0	0	0	0	0	0	f	f
8114	539	14	\N	0	0	0	0	0	0	f	f
8115	252	14	\N	0	0	0	0	0	0	f	f
8116	413	14	\N	0	0	0	0	0	0	f	f
8117	309	14	\N	0	0	0	0	0	0	f	f
8118	424	14	\N	0	0	0	0	0	0	f	f
8119	41	14	\N	0	0	0	0	0	0	f	f
8120	82	14	\N	0	0	0	0	0	0	f	f
8121	259	14	\N	0	0	0	0	0	0	f	f
8122	163	14	\N	0	0	0	0	0	0	f	f
8123	352	14	\N	0	0	0	0	0	0	f	f
8124	257	14	\N	0	0	0	0	0	0	f	f
8125	419	14	\N	0	0	0	0	0	0	f	f
8126	432	14	\N	0	0	0	0	0	0	f	f
8127	381	14	\N	0	0	0	0	0	0	f	f
8128	64	14	\N	0	0	0	0	0	0	f	f
8129	212	14	\N	0	0	0	0	0	0	f	f
8130	395	14	\N	0	0	0	0	0	0	f	f
8131	526	14	\N	0	0	0	0	0	0	f	f
8132	533	14	\N	0	0	0	0	0	0	f	f
8133	393	14	\N	0	0	0	0	0	0	f	f
8134	50	14	\N	0	0	0	0	0	0	f	f
8135	114	14	\N	0	0	0	0	0	0	f	f
8136	443	14	\N	0	0	0	0	0	0	f	f
8137	493	14	\N	0	0	0	0	0	0	f	f
8138	185	14	\N	0	0	0	0	0	0	f	f
8139	243	14	\N	0	0	0	0	0	0	f	f
8140	242	14	\N	0	0	0	0	0	0	f	f
8141	102	14	\N	0	0	0	0	0	0	f	f
8142	536	14	\N	0	0	0	0	0	0	f	f
8143	63	14	\N	0	0	0	0	0	0	f	f
8144	231	14	\N	0	0	0	0	0	0	f	f
8145	331	14	\N	0	0	0	0	0	0	f	f
8146	5	15	6.00	0	1	0	0	0	0	f	f
8147	120	15	6.00	0	0	0	0	0	0	f	f
8148	156	15	6.00	0	0	0	0	0	0	f	f
8149	207	15	6.00	0	0	0	0	0	0	f	f
8150	93	15	6.50	0	0	0	0	0	0	f	f
8151	158	15	5.50	0	0	0	0	0	0	f	f
8152	200	15	6.00	0	0	0	0	0	0	t	f
8153	338	15	6.00	0	0	0	0	0	0	f	f
8154	296	15	6.00	0	0	0	0	0	0	f	f
8155	276	15	6.50	0	0	0	0	0	1	f	f
8156	364	15	6.00	0	0	0	0	0	0	f	f
8157	312	15	6.00	0	0	0	0	0	0	f	f
8158	329	15	6.50	0	0	0	0	0	0	f	f
8159	454	15	7.50	2	0	0	0	0	0	f	f
8160	462	15	5.50	0	0	0	0	0	0	f	f
8161	459	15	6.00	0	0	0	0	0	0	f	f
8162	20	15	6.50	0	1	0	0	0	0	f	f
8163	188	15	6.00	0	0	0	0	0	0	t	f
8164	123	15	5.50	0	0	0	0	0	0	f	f
8165	85	15	6.00	0	0	0	0	0	0	t	f
8166	73	15	5.50	0	0	0	0	0	0	f	f
8167	121	15	6.50	0	0	0	0	0	0	f	f
8168	103	15	4.50	0	0	0	0	0	0	f	t
8169	341	15	6.00	0	0	0	0	0	0	f	f
8170	263	15	6.00	0	0	0	0	0	0	f	f
8171	311	15	5.00	0	0	0	0	0	0	f	f
8172	346	15	5.50	0	0	0	0	0	0	f	f
8173	427	15	5.50	0	0	0	0	0	0	t	f
8174	323	15	6.00	0	0	0	0	0	0	f	f
8175	458	15	5.50	0	0	0	0	0	0	f	f
8176	451	15	5.50	0	0	0	0	0	0	f	f
8177	489	15	5.00	0	0	0	0	0	0	f	f
8178	10	15	7.00	0	2	0	0	0	0	f	f
8179	96	15	5.00	0	0	0	0	0	0	f	f
8180	133	15	6.00	0	0	0	0	0	0	f	f
8181	159	15	6.00	0	0	0	0	0	0	f	f
8182	69	15	6.50	0	0	0	0	0	0	f	f
8183	122	15	6.00	0	0	0	0	0	0	f	f
8184	204	15	5.50	0	0	0	0	0	0	t	f
8185	347	15	5.50	0	0	0	0	0	0	f	f
8186	304	15	7.00	1	0	0	0	0	0	t	f
8187	361	15	5.50	0	0	0	0	0	0	f	f
8188	330	15	6.00	0	0	0	0	0	0	f	f
8189	348	15	6.00	0	0	0	0	0	0	f	f
8190	534	15	6.00	0	0	0	0	0	0	f	f
8191	470	15	7.00	0	0	0	0	0	1	f	f
8192	520	15	6.00	0	0	0	0	0	0	f	f
8193	478	15	5.50	0	0	0	0	0	0	f	f
8194	6	15	6.00	0	1	0	0	0	0	f	f
8195	95	15	6.00	0	0	0	0	0	0	f	f
8196	105	15	5.00	0	0	0	0	0	0	f	f
8197	117	15	6.50	0	0	0	0	0	0	t	f
8198	80	15	6.50	0	0	0	0	0	0	f	f
8199	211	15	6.00	0	0	0	0	0	0	f	f
8200	189	15	6.00	0	0	0	0	0	0	f	f
8201	316	15	5.50	0	0	0	0	0	0	f	f
8202	317	15	5.00	0	0	0	0	0	0	f	f
8203	261	15	5.50	0	0	0	0	0	0	t	f
8204	331	15	5.50	0	0	0	0	0	0	f	f
8205	506	15	6.00	0	0	0	0	0	0	f	f
8206	463	15	5.50	0	0	0	0	0	0	f	f
8207	479	15	5.50	0	0	0	0	0	0	t	f
8208	514	15	6.00	0	0	0	0	0	0	f	f
8209	499	15	5.50	0	0	0	0	0	0	f	f
8210	11	15	6.00	0	1	0	0	0	0	f	f
8211	173	15	6.00	0	0	0	0	0	0	f	f
8212	212	15	5.50	0	0	0	0	0	0	f	f
8213	75	15	6.00	0	0	0	0	0	0	f	f
8214	70	15	5.00	0	0	0	0	0	0	f	f
8215	106	15	5.50	0	0	0	0	0	0	t	f
8216	160	15	6.00	0	0	0	0	0	0	f	f
8217	277	15	5.50	0	0	0	0	0	0	f	f
8218	355	15	5.50	0	0	0	0	0	0	f	f
8219	343	15	5.50	0	0	0	0	0	0	f	f
8220	325	15	6.00	0	0	0	0	0	0	t	f
8221	283	15	6.00	0	0	0	0	0	0	f	f
8222	511	15	5.50	0	0	0	0	0	0	f	f
8223	464	15	6.00	0	0	0	0	0	0	f	f
8224	457	15	5.50	0	0	0	0	0	0	f	f
8225	533	15	5.50	0	0	0	0	0	0	f	f
8226	17	15	5.50	0	2	0	0	0	0	f	f
8227	124	15	5.50	0	0	0	0	0	0	f	f
8228	191	15	6.00	0	0	0	0	0	0	f	f
8229	175	15	5.50	0	0	0	0	0	0	f	f
8230	213	15	6.00	0	0	0	0	0	0	f	f
8231	161	15	5.50	0	0	0	0	0	0	f	f
8232	174	15	5.50	0	0	0	0	0	0	f	f
8233	162	15	5.00	0	0	0	0	0	0	f	f
8234	274	15	6.00	0	0	0	0	0	0	f	f
8235	376	15	6.50	0	0	0	0	0	0	f	f
8236	366	15	5.00	0	0	0	0	0	0	f	f
8237	297	15	5.50	0	0	0	0	0	0	t	f
8238	396	15	6.00	0	0	0	0	0	0	f	f
8239	415	15	5.50	0	0	0	0	0	0	f	f
8240	515	15	5.50	0	0	0	0	0	0	f	f
8241	460	15	5.50	0	0	0	0	0	0	f	f
8242	18	15	5.00	0	2	0	0	0	0	f	f
8243	74	15	6.00	0	0	0	0	0	1	f	f
8244	98	15	6.00	0	0	0	0	0	0	f	f
8245	192	15	5.00	0	0	0	0	0	0	f	f
8246	135	15	5.50	0	0	0	0	0	0	f	f
8247	214	15	5.50	0	0	0	0	0	0	f	f
8248	305	15	6.00	0	0	0	0	0	0	f	f
8249	426	15	6.00	0	0	0	0	0	0	f	f
8250	342	15	5.50	0	0	0	0	0	0	f	f
8251	318	15	5.50	0	0	0	0	0	0	f	f
8252	379	15	6.00	0	0	0	0	0	0	f	f
8253	378	15	6.00	0	0	0	0	0	0	f	f
8254	508	15	5.00	0	0	0	0	0	0	f	f
8255	500	15	6.50	0	0	0	0	0	0	f	f
8256	490	15	6.50	1	0	0	0	0	0	f	f
8257	507	15	6.00	0	0	0	0	0	0	t	f
8258	13	15	6.00	0	1	0	0	0	0	f	f
8259	163	15	6.00	0	0	0	0	0	0	f	f
8260	67	15	6.50	0	0	0	0	0	0	f	f
8261	104	15	6.00	0	0	0	0	0	0	t	f
8262	81	15	6.00	0	0	0	0	0	0	f	f
8263	137	15	7.00	1	0	0	0	0	0	t	f
8264	300	15	6.50	0	0	0	0	0	0	f	f
8265	270	15	6.00	0	0	0	0	0	0	t	f
8266	351	15	6.00	0	0	0	0	0	0	f	f
8267	350	15	6.00	0	0	0	0	0	0	f	f
8268	411	15	6.00	0	0	0	0	0	0	f	f
8269	299	15	6.50	0	0	0	0	0	0	f	f
8270	444	15	7.50	1	0	0	0	0	1	f	f
8271	445	15	6.00	0	0	0	0	0	0	f	f
8272	475	15	6.50	0	0	0	0	0	0	f	f
8273	7	15	6.50	0	0	0	0	0	0	f	f
8274	87	15	6.00	0	0	0	0	0	0	f	f
8275	88	15	6.50	0	0	0	0	0	0	f	f
8276	99	15	6.00	0	0	0	0	0	0	f	f
8277	109	15	7.00	1	0	0	0	0	0	f	f
8278	108	15	7.00	0	0	0	0	0	0	f	f
8279	307	15	7.00	0	0	0	0	0	0	f	f
8280	332	15	6.50	0	0	0	0	0	0	f	f
8281	291	15	6.00	0	0	0	0	0	0	f	f
8282	353	15	5.50	0	0	0	0	0	0	t	f
8283	400	15	6.00	0	0	0	0	0	0	f	f
8284	278	15	6.00	0	0	0	0	0	0	f	f
8285	480	15	5.00	0	0	0	0	0	0	f	f
8286	477	15	6.50	0	0	0	0	0	0	f	f
8287	446	15	6.50	0	0	0	0	0	1	f	f
8288	3	15	7.00	0	0	0	0	0	0	f	f
8289	217	15	6.00	0	0	0	0	0	0	f	f
8290	126	15	6.50	0	0	0	0	0	0	f	f
8291	110	15	6.00	0	0	0	0	0	0	f	f
8292	144	15	6.50	0	0	0	0	0	0	f	f
8293	176	15	6.00	0	0	0	0	0	0	f	f
8294	362	15	6.00	0	0	0	0	0	0	f	f
8295	301	15	7.00	0	0	0	0	0	1	f	f
8296	267	15	4.50	0	0	0	0	0	0	f	t
8297	292	15	6.50	0	0	0	0	0	0	f	f
8298	284	15	5.00	0	0	0	0	0	0	f	t
8299	363	15	6.00	0	0	0	0	0	0	f	f
8300	491	15	6.00	0	0	0	0	0	0	t	f
8301	455	15	5.50	0	0	0	0	0	0	f	f
8302	492	15	7.00	1	0	0	0	0	0	f	f
8303	8	15	6.00	0	0	0	0	0	0	f	f
8304	127	15	6.00	0	0	0	0	0	0	f	f
8305	164	15	6.50	0	0	0	0	0	0	t	f
8306	89	15	6.00	0	0	0	0	0	0	f	f
8307	146	15	6.50	0	0	0	0	0	0	f	f
8308	219	15	6.00	0	0	0	0	0	0	f	f
8309	310	15	6.50	0	0	0	0	0	0	f	f
8310	293	15	6.00	0	0	0	0	0	0	f	f
8311	286	15	6.00	0	0	0	0	0	0	f	f
8312	354	15	6.50	0	0	0	0	0	0	f	f
8313	401	15	6.50	0	0	0	0	0	0	f	f
8314	333	15	6.00	0	0	0	0	0	0	f	f
8315	381	15	6.00	0	0	0	0	0	0	t	f
8316	501	15	6.50	0	0	0	0	0	1	f	f
8317	509	15	6.00	0	0	0	0	0	0	f	f
8318	513	15	7.00	1	0	0	0	0	0	f	f
8319	1	15	6.00	0	2	0	0	0	0	f	f
8320	111	15	5.50	0	0	0	0	0	0	f	f
8321	139	15	5.50	0	0	0	0	0	0	f	f
8322	68	15	6.50	0	0	0	0	0	0	f	f
8323	177	15	6.00	0	0	0	0	0	0	f	f
8324	193	15	5.50	0	0	0	0	0	0	f	f
8325	90	15	7.50	2	0	0	0	0	0	f	f
8326	184	15	6.00	0	0	0	0	0	0	f	f
8327	273	15	5.50	0	0	0	0	0	0	f	f
8328	260	15	6.00	0	0	0	0	0	0	f	f
8329	268	15	6.00	0	0	0	0	0	0	f	f
8330	302	15	6.50	0	0	0	0	0	1	t	f
8331	271	15	5.50	0	0	0	0	0	0	f	f
8332	294	15	6.00	0	0	0	0	0	0	f	f
8333	485	15	6.00	0	0	0	0	0	1	f	f
8334	4	15	6.50	0	1	0	0	0	0	f	f
8335	71	15	6.00	0	0	0	0	0	0	f	f
8336	83	15	6.00	0	0	0	0	0	0	f	f
8337	113	15	5.50	0	0	0	0	0	0	f	f
8338	140	15	5.00	0	0	0	0	0	0	f	f
8339	201	15	6.00	0	0	0	0	0	0	f	f
8340	178	15	5.50	0	0	0	0	0	0	f	f
8341	112	15	6.00	0	0	0	0	0	0	f	f
8342	319	15	5.50	0	0	0	0	0	0	f	f
8343	356	15	6.00	0	0	0	0	0	0	f	f
8344	360	15	5.50	0	0	0	0	0	0	f	f
8345	265	15	6.00	0	0	0	0	0	0	f	f
8346	279	15	5.00	0	0	0	0	0	0	f	f
8347	450	15	5.00	0	0	0	0	0	0	f	f
8348	510	15	6.00	0	0	0	0	0	0	f	f
8349	483	15	6.00	0	0	0	0	0	0	f	f
8350	23	15	6.00	0	1	0	0	0	0	f	f
8351	147	15	5.00	0	0	0	0	0	0	f	f
8352	116	15	6.00	0	0	0	0	0	0	t	f
8353	115	15	6.00	0	0	0	0	0	0	f	f
8354	226	15	5.50	0	0	0	0	0	0	f	f
8355	143	15	5.00	0	0	0	0	0	0	f	f
8356	403	15	6.00	0	0	0	0	0	0	t	f
8357	372	15	5.50	0	0	0	0	0	0	f	f
8358	280	15	6.00	0	0	0	0	0	0	f	f
8359	365	15	5.50	0	0	0	0	0	0	f	f
8360	367	15	5.50	0	0	0	0	0	0	f	f
8361	493	15	6.00	0	0	0	0	0	0	f	f
8362	531	15	6.00	0	0	0	0	0	0	f	f
8363	502	15	5.50	0	0	0	0	0	0	f	f
8364	456	15	6.00	0	0	0	0	0	0	f	f
8365	14	15	6.00	0	1	0	0	0	0	f	f
8366	185	15	5.50	0	0	0	0	0	0	f	f
8367	148	15	5.50	0	0	0	0	0	0	f	f
8368	166	15	5.50	0	0	0	0	0	0	t	f
8369	165	15	5.00	0	0	0	0	0	0	f	f
8370	129	15	6.00	0	0	0	0	0	0	f	f
8371	344	15	6.00	0	0	0	0	0	0	f	f
8372	368	15	5.50	0	0	0	0	0	0	f	f
8373	373	15	5.50	0	0	0	0	0	0	f	f
8374	324	15	5.00	0	0	0	0	0	0	f	f
8375	320	15	5.50	0	0	0	0	0	0	f	f
8376	406	15	5.00	0	0	0	0	0	0	f	f
8377	337	15	5.50	0	0	0	0	0	0	f	f
8378	487	15	5.50	0	0	0	0	0	0	f	f
8379	517	15	5.00	0	0	0	0	0	0	f	f
8380	536	15	6.00	0	0	0	0	0	0	f	f
8381	2	15	6.50	0	0	0	0	0	0	f	f
8382	100	15	6.50	0	0	0	0	0	0	t	f
8383	130	15	7.00	0	0	0	0	0	0	f	f
8384	84	15	6.50	0	0	0	0	0	0	f	f
8385	167	15	6.50	0	0	0	0	0	0	f	f
8386	72	15	7.50	1	0	0	0	0	0	t	f
8387	275	15	6.00	0	0	0	0	0	0	f	f
8388	295	15	6.50	0	0	0	0	0	0	f	f
8389	369	15	6.00	0	0	0	0	0	0	t	f
8390	335	15	6.00	0	0	0	0	0	0	f	f
8391	281	15	6.50	0	0	0	0	0	0	f	f
8392	448	15	6.50	0	0	0	0	0	1	f	f
8393	484	15	6.50	0	0	0	0	0	0	f	f
8394	15	15	6.00	0	2	0	0	0	0	f	f
8395	142	15	5.00	0	0	0	0	0	0	f	f
8396	150	15	6.00	0	0	0	0	0	0	f	f
8397	118	15	5.50	0	0	0	0	0	0	f	f
8398	199	15	5.50	0	0	0	0	0	0	f	f
8399	149	15	5.50	0	0	0	0	0	0	t	f
8400	315	15	6.50	0	0	0	0	0	0	f	f
8401	303	15	6.00	0	0	0	0	0	0	f	f
8402	314	15	5.50	0	0	0	0	0	0	t	f
8403	287	15	7.00	1	0	0	0	0	0	f	f
8404	308	15	5.50	0	0	0	0	0	0	t	f
8405	467	15	7.00	0	0	0	0	0	2	f	f
8406	453	15	7.50	1	0	0	0	0	0	f	f
8407	518	15	6.00	0	0	0	0	0	0	f	f
8408	537	15	6.00	0	0	0	0	0	0	f	f
8409	22	15	6.00	0	0	0	0	0	0	f	f
8410	179	15	6.00	0	0	0	0	0	0	f	f
8411	152	15	6.00	0	0	0	0	0	0	f	f
8412	91	15	6.50	0	0	0	0	0	0	f	f
8413	151	15	6.50	0	0	0	0	0	0	f	f
8414	168	15	6.00	0	0	0	0	0	0	t	f
8415	77	15	6.50	0	0	0	0	0	0	f	f
8416	288	15	7.00	1	0	0	0	0	0	f	f
8417	399	15	6.00	0	0	0	0	0	0	f	f
8418	358	15	6.00	0	0	0	0	0	0	f	f
8419	439	15	6.00	0	0	0	0	0	0	f	f
8420	386	15	6.50	0	0	0	0	0	0	f	f
8421	496	15	6.50	0	0	0	0	0	0	f	f
8422	466	15	5.50	0	0	0	0	0	0	f	f
8423	488	15	6.00	0	0	0	0	0	0	f	f
8424	468	15	6.00	0	0	0	0	0	0	f	f
8425	19	15	6.00	0	0	0	0	0	0	f	f
8426	78	15	7.00	0	0	0	0	0	0	f	f
8427	128	15	6.00	0	0	0	0	0	0	f	f
8428	153	15	6.50	0	0	0	0	0	0	f	f
8429	180	15	6.00	0	0	0	0	0	0	f	f
8430	131	15	6.50	0	0	0	0	0	0	f	f
8431	198	15	6.00	0	0	0	0	0	0	f	f
8432	101	15	6.50	0	0	0	0	0	0	f	f
8433	272	15	6.50	0	0	0	0	0	0	t	f
8434	423	15	6.00	0	0	0	0	0	0	f	f
8435	321	15	6.00	0	0	0	0	0	0	f	f
8436	326	15	7.50	1	0	0	0	0	0	f	f
8437	328	15	6.00	0	0	0	0	0	0	f	f
8438	452	15	6.50	0	0	0	0	0	1	f	f
8439	524	15	6.00	0	0	0	0	0	0	f	f
8440	497	15	6.00	0	0	0	0	0	0	f	f
8441	12	15	6.50	0	1	0	0	0	0	f	f
8442	183	15	5.50	0	0	0	0	0	0	t	f
8443	181	15	5.50	0	0	0	0	1	0	t	f
8444	182	15	6.00	0	0	0	0	0	0	f	f
8445	169	15	5.50	0	0	0	0	0	0	f	f
8446	79	15	6.00	0	0	0	0	0	0	t	f
8447	170	15	7.00	0	0	0	0	0	0	f	f
8448	345	15	6.00	0	0	0	0	0	0	f	f
8449	408	15	6.00	0	0	0	0	0	0	t	f
8450	309	15	6.00	0	0	0	0	0	0	f	f
8451	391	15	6.50	0	0	0	0	0	1	t	f
8452	327	15	7.00	0	0	0	0	0	1	f	f
8453	521	15	6.00	0	0	0	0	0	0	f	f
8454	473	15	7.50	2	0	0	0	0	0	f	f
8455	503	15	5.50	0	0	0	0	0	0	f	f
8456	469	15	5.50	0	0	0	0	0	0	f	f
8457	46	15	\N	0	0	0	0	0	0	f	f
8458	35	15	\N	0	0	0	0	0	0	f	f
8459	37	15	\N	0	0	0	0	0	0	f	f
8460	24	15	\N	0	0	0	0	0	0	f	f
8461	29	15	\N	0	0	0	0	0	0	f	f
8462	16	15	\N	0	0	0	0	0	0	f	f
8463	51	15	\N	0	0	0	0	0	0	f	f
8464	36	15	\N	0	0	0	0	0	0	f	f
8465	92	15	\N	0	0	0	0	0	0	f	f
8466	54	15	\N	0	0	0	0	0	0	f	f
8467	47	15	\N	0	0	0	0	0	0	f	f
8468	21	15	\N	0	0	0	0	0	0	f	f
8469	27	15	\N	0	0	0	0	0	0	f	f
8470	40	15	\N	0	0	0	0	0	0	f	f
8471	42	15	\N	0	0	0	0	0	0	f	f
8472	52	15	\N	0	0	0	0	0	0	f	f
8473	33	15	\N	0	0	0	0	0	0	f	f
8474	28	15	\N	0	0	0	0	0	0	f	f
8475	61	15	\N	0	0	0	0	0	0	f	f
8476	26	15	\N	0	0	0	0	0	0	f	f
8477	56	15	\N	0	0	0	0	0	0	f	f
8478	58	15	\N	0	0	0	0	0	0	f	f
8479	62	15	\N	0	0	0	0	0	0	f	f
8480	65	15	\N	0	0	0	0	0	0	f	f
8481	30	15	\N	0	0	0	0	0	0	f	f
8482	66	15	\N	0	0	0	0	0	0	f	f
8483	45	15	\N	0	0	0	0	0	0	f	f
8484	205	15	\N	0	0	0	0	0	0	f	f
8485	172	15	\N	0	0	0	0	0	0	f	f
8486	186	15	\N	0	0	0	0	0	0	f	f
8487	119	15	\N	0	0	0	0	0	0	f	f
8488	171	15	\N	0	0	0	0	0	0	f	f
8489	145	15	\N	0	0	0	0	0	0	f	f
8490	196	15	\N	0	0	0	0	0	0	f	f
8491	154	15	\N	0	0	0	0	0	0	f	f
8492	197	15	\N	0	0	0	0	0	0	f	f
8493	138	15	\N	0	0	0	0	0	0	f	f
8494	141	15	\N	0	0	0	0	0	0	f	f
8495	202	15	\N	0	0	0	0	0	0	f	f
8496	208	15	\N	0	0	0	0	0	0	f	f
8497	187	15	\N	0	0	0	0	0	0	f	f
8498	107	15	\N	0	0	0	0	0	0	f	f
8499	155	15	\N	0	0	0	0	0	0	f	f
8500	218	15	\N	0	0	0	0	0	0	f	f
8501	220	15	\N	0	0	0	0	0	0	f	f
8502	224	15	\N	0	0	0	0	0	0	f	f
8503	227	15	\N	0	0	0	0	0	0	f	f
8504	238	15	\N	0	0	0	0	0	0	f	f
8505	235	15	\N	0	0	0	0	0	0	f	f
8506	232	15	\N	0	0	0	0	0	0	f	f
8507	248	15	\N	0	0	0	0	0	0	f	f
8508	241	15	\N	0	0	0	0	0	0	f	f
8509	255	15	\N	0	0	0	0	0	0	f	f
8510	221	15	\N	0	0	0	0	0	0	f	f
8511	230	15	\N	0	0	0	0	0	0	f	f
8512	285	15	\N	0	0	0	0	0	0	f	f
8513	244	15	\N	0	0	0	0	0	0	f	f
8514	245	15	\N	0	0	0	0	0	0	f	f
8515	313	15	\N	0	0	0	0	0	0	f	f
8516	210	15	\N	0	0	0	0	0	0	f	f
8517	240	15	\N	0	0	0	0	0	0	f	f
8518	264	15	\N	0	0	0	0	0	0	f	f
8519	250	15	\N	0	0	0	0	0	0	f	f
8520	223	15	\N	0	0	0	0	0	0	f	f
8521	215	15	\N	0	0	0	0	0	0	f	f
8522	298	15	\N	0	0	0	0	0	0	f	f
8523	216	15	\N	0	0	0	0	0	0	f	f
8524	269	15	\N	0	0	0	0	0	0	f	f
8525	228	15	\N	0	0	0	0	0	0	f	f
8526	222	15	\N	0	0	0	0	0	0	f	f
8527	253	15	\N	0	0	0	0	0	0	f	f
8528	254	15	\N	0	0	0	0	0	0	f	f
8529	225	15	\N	0	0	0	0	0	0	f	f
8530	233	15	\N	0	0	0	0	0	0	f	f
8531	402	15	\N	0	0	0	0	0	0	f	f
8532	418	15	\N	0	0	0	0	0	0	f	f
8533	375	15	\N	0	0	0	0	0	0	f	f
8534	405	15	\N	0	0	0	0	0	0	f	f
8535	404	15	\N	0	0	0	0	0	0	f	f
8536	390	15	\N	0	0	0	0	0	0	f	f
8537	359	15	\N	0	0	0	0	0	0	f	f
8538	382	15	\N	0	0	0	0	0	0	f	f
8539	414	15	\N	0	0	0	0	0	0	f	f
8540	392	15	\N	0	0	0	0	0	0	f	f
8541	380	15	\N	0	0	0	0	0	0	f	f
8542	385	15	\N	0	0	0	0	0	0	f	f
8543	412	15	\N	0	0	0	0	0	0	f	f
8544	371	15	\N	0	0	0	0	0	0	f	f
8545	349	15	\N	0	0	0	0	0	0	f	f
8546	397	15	\N	0	0	0	0	0	0	f	f
8547	384	15	\N	0	0	0	0	0	0	f	f
8548	357	15	\N	0	0	0	0	0	0	f	f
8549	339	15	\N	0	0	0	0	0	0	f	f
8550	394	15	\N	0	0	0	0	0	0	f	f
8551	340	15	\N	0	0	0	0	0	0	f	f
8552	416	15	\N	0	0	0	0	0	0	f	f
8553	370	15	\N	0	0	0	0	0	0	f	f
8554	409	15	\N	0	0	0	0	0	0	f	f
8555	237	15	\N	0	0	0	0	0	0	f	f
8556	431	15	\N	0	0	0	0	0	0	f	f
8557	429	15	\N	0	0	0	0	0	0	f	f
8558	433	15	\N	0	0	0	0	0	0	f	f
8559	522	15	\N	0	0	0	0	0	0	f	f
8560	523	15	\N	0	0	0	0	0	0	f	f
8561	472	15	\N	0	0	0	0	0	0	f	f
8562	495	15	\N	0	0	0	0	0	0	f	f
8563	449	15	\N	0	0	0	0	0	0	f	f
8564	486	15	\N	0	0	0	0	0	0	f	f
8565	428	15	\N	0	0	0	0	0	0	f	f
8566	438	15	\N	0	0	0	0	0	0	f	f
8567	441	15	\N	0	0	0	0	0	0	f	f
8568	437	15	\N	0	0	0	0	0	0	f	f
8569	525	15	\N	0	0	0	0	0	0	f	f
8570	425	15	\N	0	0	0	0	0	0	f	f
8571	430	15	\N	0	0	0	0	0	0	f	f
8572	420	15	\N	0	0	0	0	0	0	f	f
8573	481	15	\N	0	0	0	0	0	0	f	f
8574	504	15	\N	0	0	0	0	0	0	f	f
8575	505	15	\N	0	0	0	0	0	0	f	f
8576	434	15	\N	0	0	0	0	0	0	f	f
8577	435	15	\N	0	0	0	0	0	0	f	f
8578	474	15	\N	0	0	0	0	0	0	f	f
8579	529	15	\N	0	0	0	0	0	0	f	f
8580	530	15	\N	0	0	0	0	0	0	f	f
8581	540	15	\N	0	0	0	0	0	0	f	f
8582	541	15	\N	0	0	0	0	0	0	f	f
8583	43	15	\N	0	0	0	0	0	0	f	f
8584	44	15	\N	0	0	0	0	0	0	f	f
8585	125	15	\N	0	0	0	0	0	0	f	f
8586	236	15	\N	0	0	0	0	0	0	f	f
8587	417	15	\N	0	0	0	0	0	0	f	f
8588	195	15	\N	0	0	0	0	0	0	f	f
8589	494	15	\N	0	0	0	0	0	0	f	f
8590	229	15	\N	0	0	0	0	0	0	f	f
8591	55	15	\N	0	0	0	0	0	0	f	f
8592	206	15	\N	0	0	0	0	0	0	f	f
8593	247	15	\N	0	0	0	0	0	0	f	f
8594	421	15	\N	0	0	0	0	0	0	f	f
8595	422	15	\N	0	0	0	0	0	0	f	f
8596	246	15	\N	0	0	0	0	0	0	f	f
8597	389	15	\N	0	0	0	0	0	0	f	f
8598	527	15	\N	0	0	0	0	0	0	f	f
8599	538	15	\N	0	0	0	0	0	0	f	f
8600	48	15	\N	0	0	0	0	0	0	f	f
8601	258	15	\N	0	0	0	0	0	0	f	f
8602	388	15	\N	0	0	0	0	0	0	f	f
8603	447	15	\N	0	0	0	0	0	0	f	f
8604	34	15	\N	0	0	0	0	0	0	f	f
8605	97	15	\N	0	0	0	0	0	0	f	f
8606	516	15	\N	0	0	0	0	0	0	f	f
8607	289	15	\N	0	0	0	0	0	0	f	f
8608	436	15	\N	0	0	0	0	0	0	f	f
8609	498	15	\N	0	0	0	0	0	0	f	f
8610	532	15	\N	0	0	0	0	0	0	f	f
8611	542	15	\N	0	0	0	0	0	0	f	f
8612	543	15	\N	0	0	0	0	0	0	f	f
8613	528	15	\N	0	0	0	0	0	0	f	f
8614	49	15	\N	0	0	0	0	0	0	f	f
8615	239	15	\N	0	0	0	0	0	0	f	f
8616	266	15	\N	0	0	0	0	0	0	f	f
8617	334	15	\N	0	0	0	0	0	0	f	f
8618	476	15	\N	0	0	0	0	0	0	f	f
8619	60	15	\N	0	0	0	0	0	0	f	f
8620	57	15	\N	0	0	0	0	0	0	f	f
8621	282	15	\N	0	0	0	0	0	0	f	f
8622	39	15	\N	0	0	0	0	0	0	f	f
8623	76	15	\N	0	0	0	0	0	0	f	f
8624	59	15	\N	0	0	0	0	0	0	f	f
8625	440	15	\N	0	0	0	0	0	0	f	f
8626	398	15	\N	0	0	0	0	0	0	f	f
8627	442	15	\N	0	0	0	0	0	0	f	f
8628	25	15	\N	0	0	0	0	0	0	f	f
8629	194	15	\N	0	0	0	0	0	0	f	f
8630	234	15	\N	0	0	0	0	0	0	f	f
8631	410	15	\N	0	0	0	0	0	0	f	f
8632	306	15	\N	0	0	0	0	0	0	f	f
8633	535	15	\N	0	0	0	0	0	0	f	f
8634	461	15	\N	0	0	0	0	0	0	f	f
8635	322	15	\N	0	0	0	0	0	0	f	f
8636	53	15	\N	0	0	0	0	0	0	f	f
8637	251	15	\N	0	0	0	0	0	0	f	f
8638	471	15	\N	0	0	0	0	0	0	f	f
8639	32	15	\N	0	0	0	0	0	0	f	f
8640	157	15	\N	0	0	0	0	0	0	f	f
8641	132	15	\N	0	0	0	0	0	0	f	f
8642	94	15	\N	0	0	0	0	0	0	f	f
8643	465	15	\N	0	0	0	0	0	0	f	f
8644	9	15	\N	0	0	0	0	0	0	f	f
8645	209	15	\N	0	0	0	0	0	0	f	f
8646	374	15	\N	0	0	0	0	0	0	f	f
8647	482	15	\N	0	0	0	0	0	0	f	f
8648	519	15	\N	0	0	0	0	0	0	f	f
8649	336	15	\N	0	0	0	0	0	0	f	f
8650	38	15	\N	0	0	0	0	0	0	f	f
8651	256	15	\N	0	0	0	0	0	0	f	f
8652	190	15	\N	0	0	0	0	0	0	f	f
8653	377	15	\N	0	0	0	0	0	0	f	f
8654	249	15	\N	0	0	0	0	0	0	f	f
8655	203	15	\N	0	0	0	0	0	0	f	f
8656	407	15	\N	0	0	0	0	0	0	f	f
8657	387	15	\N	0	0	0	0	0	0	f	f
8658	539	15	\N	0	0	0	0	0	0	f	f
8659	252	15	\N	0	0	0	0	0	0	f	f
8660	413	15	\N	0	0	0	0	0	0	f	f
8661	424	15	\N	0	0	0	0	0	0	f	f
8662	41	15	\N	0	0	0	0	0	0	f	f
8663	136	15	\N	0	0	0	0	0	0	f	f
8664	82	15	\N	0	0	0	0	0	0	f	f
8665	259	15	\N	0	0	0	0	0	0	f	f
8666	262	15	\N	0	0	0	0	0	0	f	f
8667	352	15	\N	0	0	0	0	0	0	f	f
8668	257	15	\N	0	0	0	0	0	0	f	f
8669	419	15	\N	0	0	0	0	0	0	f	f
8670	432	15	\N	0	0	0	0	0	0	f	f
8671	64	15	\N	0	0	0	0	0	0	f	f
8672	134	15	\N	0	0	0	0	0	0	f	f
8673	395	15	\N	0	0	0	0	0	0	f	f
8674	526	15	\N	0	0	0	0	0	0	f	f
8675	393	15	\N	0	0	0	0	0	0	f	f
8676	50	15	\N	0	0	0	0	0	0	f	f
8677	114	15	\N	0	0	0	0	0	0	f	f
8678	443	15	\N	0	0	0	0	0	0	f	f
8679	31	15	\N	0	0	0	0	0	0	f	f
8680	243	15	\N	0	0	0	0	0	0	f	f
8681	242	15	\N	0	0	0	0	0	0	f	f
8682	102	15	\N	0	0	0	0	0	0	f	f
8683	383	15	\N	0	0	0	0	0	0	f	f
8684	63	15	\N	0	0	0	0	0	0	f	f
8685	231	15	\N	0	0	0	0	0	0	f	f
8686	86	15	\N	0	0	0	0	0	0	f	f
8687	290	15	\N	0	0	0	0	0	0	f	f
8688	512	15	\N	0	0	0	0	0	0	f	f
8689	5	16	6.50	0	0	0	0	0	0	f	f
8690	120	16	6.00	0	0	0	0	0	0	f	f
8691	207	16	6.50	0	0	0	0	0	0	f	f
8692	157	16	7.00	1	0	0	0	0	0	f	f
8693	200	16	5.50	0	0	0	0	0	0	f	f
8694	338	16	6.00	0	0	0	0	0	0	f	f
8695	394	16	6.50	0	0	0	0	0	0	f	f
8696	339	16	6.00	0	0	0	0	0	0	f	f
8697	276	16	5.00	0	0	0	0	0	0	t	f
8698	364	16	6.00	0	0	0	0	0	0	f	f
8699	312	16	6.50	0	0	0	0	0	1	t	f
8700	329	16	6.00	0	0	0	0	0	0	f	f
8701	454	16	5.50	0	0	0	0	0	0	f	f
8702	482	16	6.00	0	0	0	0	0	0	f	f
8703	459	16	5.00	0	0	0	0	0	0	f	f
8704	465	16	6.00	0	0	0	0	0	0	f	f
8705	20	16	6.50	0	2	0	0	0	0	f	f
8706	123	16	6.00	0	0	0	0	0	0	f	f
8707	85	16	6.00	0	0	0	0	0	0	f	f
8708	73	16	5.50	0	0	0	0	0	0	f	f
8709	187	16	6.50	0	0	0	0	0	0	t	f
8710	103	16	7.00	0	0	0	0	0	0	f	f
8711	340	16	6.00	0	0	0	0	1	1	f	f
8712	263	16	7.00	1	0	0	0	0	0	t	f
8713	269	16	6.50	1	0	0	0	0	0	f	f
8714	311	16	6.50	0	0	0	0	0	1	f	f
8715	346	16	6.00	0	0	0	0	0	0	f	f
8716	323	16	5.50	0	0	0	0	0	0	f	f
8717	374	16	6.00	0	0	0	0	0	0	f	f
8718	504	16	5.50	0	0	0	0	0	0	f	f
8719	451	16	7.00	1	0	0	0	0	0	f	f
8720	519	16	6.50	0	0	0	0	0	1	f	f
8721	10	16	6.00	0	2	0	0	0	0	f	f
8722	97	16	5.50	0	0	0	0	0	0	t	f
8723	133	16	6.50	0	0	0	0	0	1	f	f
8724	159	16	6.00	0	0	0	0	0	0	f	f
8725	69	16	6.00	0	0	0	0	0	0	f	f
8726	122	16	5.50	0	0	0	0	0	0	f	f
8727	204	16	6.00	0	0	0	0	0	0	f	f
8728	347	16	6.00	0	0	0	0	0	0	f	f
8729	436	16	6.00	0	0	0	0	0	0	f	f
8730	304	16	6.50	0	0	0	0	0	1	f	f
8731	361	16	5.00	0	0	0	0	0	0	t	f
8732	330	16	7.00	1	0	0	0	0	0	f	f
8733	470	16	5.50	0	0	0	0	0	0	t	f
8734	478	16	6.00	0	0	0	0	0	0	f	f
8735	529	16	7.00	1	0	0	0	0	0	f	f
8736	6	16	5.50	0	3	0	0	0	0	f	f
8737	119	16	5.50	0	0	0	0	0	0	f	f
8738	86	16	6.00	0	0	0	0	0	0	f	f
8739	171	16	5.50	0	0	0	0	0	0	f	f
8740	117	16	5.50	0	0	0	0	0	0	t	f
8741	80	16	6.50	1	0	0	0	0	0	f	f
8742	211	16	5.50	0	0	0	0	0	0	f	f
8743	414	16	6.00	0	0	0	0	0	0	f	f
8744	316	16	6.00	0	0	0	0	0	0	f	f
8745	317	16	6.00	0	0	0	0	0	0	f	f
8746	290	16	5.50	0	0	0	0	0	0	f	f
8747	261	16	6.50	0	0	0	0	0	0	f	f
8748	331	16	6.50	0	0	0	0	0	1	f	f
8749	463	16	5.50	0	0	0	0	0	0	f	f
8750	514	16	5.50	0	0	0	0	0	0	f	f
8751	499	16	6.50	0	0	0	0	0	0	f	f
8752	11	16	6.00	0	0	0	0	0	0	f	f
8753	173	16	6.00	0	0	0	0	0	0	t	f
8754	212	16	5.00	0	0	0	0	0	0	f	t
8755	75	16	6.50	0	0	0	0	0	0	f	f
8756	70	16	6.50	0	0	0	0	0	0	f	f
8757	106	16	6.50	0	0	0	0	0	0	t	f
8758	172	16	6.00	0	0	0	0	0	0	f	f
8759	160	16	6.00	0	0	0	0	0	0	f	f
8760	375	16	6.00	0	0	0	0	0	0	t	f
8761	355	16	6.50	0	0	0	0	0	0	f	f
8762	343	16	5.50	0	0	0	0	0	0	f	f
8763	283	16	6.50	0	0	0	0	0	0	f	f
8764	511	16	6.00	0	0	0	0	0	0	f	f
8765	464	16	6.50	0	0	0	0	0	0	f	f
8766	457	16	5.50	0	0	0	0	0	0	f	f
8767	526	16	5.50	0	0	0	0	0	0	f	f
8768	17	16	6.00	0	1	0	0	0	0	f	f
8769	124	16	6.00	0	0	0	0	0	0	t	f
8770	191	16	7.50	0	0	0	0	0	1	t	f
8771	175	16	6.50	0	0	0	0	0	0	f	f
8772	213	16	6.00	0	0	0	0	0	0	f	f
8773	161	16	7.00	0	0	0	0	0	1	f	f
8774	174	16	6.50	0	0	0	0	0	0	f	f
8775	162	16	6.50	0	0	0	0	0	0	f	f
8776	274	16	7.00	1	0	0	0	0	0	f	f
8777	392	16	6.00	0	0	0	0	0	0	t	f
8778	376	16	7.00	0	0	0	0	0	2	f	f
8779	297	16	7.50	1	0	0	0	0	0	f	f
8780	396	16	7.00	1	0	0	0	0	0	f	f
8781	460	16	7.50	2	0	0	0	0	0	f	f
8782	505	16	6.00	0	0	0	0	0	0	f	f
8783	18	16	4.50	0	0	0	0	0	0	f	t
8784	40	16	5.00	0	1	0	0	0	0	f	f
8785	74	16	6.00	0	0	0	0	0	0	f	f
8786	98	16	6.50	0	0	0	0	0	0	f	f
8787	192	16	6.50	0	0	0	0	0	0	f	f
8788	135	16	5.00	0	0	0	0	0	0	f	f
8789	214	16	6.50	0	0	0	0	0	0	f	f
8790	298	16	6.00	0	0	0	0	0	0	t	f
8791	305	16	6.00	0	0	0	0	0	0	f	f
8792	342	16	7.00	0	0	0	0	0	0	f	f
8793	318	16	6.50	0	0	0	0	0	0	f	f
8794	349	16	6.00	0	0	0	0	0	0	f	f
8795	508	16	6.00	0	0	0	0	0	0	f	f
8796	500	16	6.50	0	0	0	0	0	0	f	f
8797	490	16	6.00	0	0	0	0	0	0	f	f
8798	13	16	6.50	0	0	0	0	0	0	f	f
8799	136	16	6.00	0	0	0	0	0	0	f	f
8800	67	16	6.50	0	0	0	0	0	0	f	f
8801	104	16	6.00	0	0	0	0	0	0	f	f
8802	81	16	6.50	0	0	0	0	0	0	f	f
8803	300	16	6.00	0	0	0	0	0	0	f	f
8804	270	16	6.00	0	0	0	0	0	0	f	f
8805	351	16	6.00	0	0	0	0	0	0	f	f
8806	352	16	6.00	0	0	0	0	0	0	f	f
8807	350	16	6.00	0	0	0	0	0	0	t	f
8808	411	16	5.00	0	0	0	0	0	0	f	f
8809	299	16	6.00	0	0	0	0	0	0	f	f
8810	444	16	6.50	0	0	0	0	0	0	f	f
8811	445	16	5.50	0	0	0	0	0	0	t	f
8812	474	16	5.50	0	0	0	0	0	0	f	f
8813	475	16	7.00	1	0	0	0	0	0	f	f
8814	7	16	6.00	0	1	0	0	0	0	f	f
8815	216	16	6.00	0	0	0	0	0	0	f	f
8816	87	16	6.50	0	0	0	0	0	0	f	f
8817	88	16	6.00	0	0	0	0	0	0	f	f
8818	99	16	6.50	0	0	0	0	0	1	f	f
8819	108	16	6.00	0	0	0	0	0	0	f	f
8820	307	16	6.50	0	0	0	0	0	0	f	f
8821	306	16	6.00	0	0	0	0	0	0	f	f
8822	332	16	6.50	0	0	0	0	0	1	t	f
8823	291	16	6.50	0	0	0	0	0	0	f	f
8824	322	16	6.00	0	0	0	0	0	0	f	f
8825	400	16	6.00	0	0	0	0	0	0	f	f
8826	278	16	7.00	1	0	0	0	0	0	t	f
8827	480	16	6.00	0	0	0	0	0	0	f	f
8828	477	16	7.00	1	0	0	0	0	0	f	f
8829	446	16	7.00	0	0	0	0	0	0	f	f
8830	3	16	6.00	0	0	0	0	0	0	f	f
8831	126	16	6.00	0	0	0	0	0	0	t	f
8832	110	16	6.00	0	0	0	0	0	0	f	f
8833	195	16	6.00	0	0	0	0	0	0	f	f
8834	144	16	6.00	0	0	0	0	0	0	f	f
8835	125	16	6.50	0	0	0	0	0	0	t	f
8836	362	16	5.50	0	0	0	0	0	0	f	f
8837	301	16	5.50	0	0	0	0	0	0	f	f
8838	292	16	6.00	0	0	0	0	0	0	t	f
8839	417	16	6.00	0	0	0	0	0	0	f	f
8840	516	16	5.50	0	0	0	0	0	0	t	f
8841	491	16	5.50	0	0	0	0	0	0	f	f
8842	455	16	5.00	0	0	0	0	0	0	f	f
8843	492	16	5.50	0	0	0	0	0	0	f	f
8844	8	16	7.00	0	1	0	0	0	0	f	f
8845	127	16	6.00	0	0	0	0	0	0	f	f
8846	89	16	6.00	0	0	0	0	0	0	f	f
8847	146	16	6.50	0	0	0	0	0	0	t	f
8848	257	16	6.50	0	0	0	0	0	0	f	f
8849	310	16	6.50	0	0	0	0	0	0	f	f
8850	402	16	6.00	0	0	0	0	0	0	f	f
8851	293	16	6.50	0	0	0	0	0	0	f	f
8852	401	16	6.00	0	0	0	0	0	0	f	f
8853	333	16	6.00	0	0	0	0	0	0	f	f
8854	381	16	5.50	0	0	0	0	0	0	f	f
8855	412	16	6.00	0	0	0	0	0	0	f	f
8856	495	16	6.00	0	0	0	0	0	0	f	f
8857	513	16	6.00	0	0	0	0	0	0	f	f
8858	1	16	8.00	0	1	0	0	0	0	f	f
8859	111	16	5.50	0	0	0	0	0	0	f	f
8860	139	16	5.50	0	0	0	0	0	0	f	f
8861	193	16	6.00	0	0	0	0	0	0	f	f
8862	90	16	5.50	0	0	0	0	0	0	f	f
8863	184	16	6.00	0	0	0	0	0	0	f	f
8864	273	16	8.00	2	0	0	0	0	0	f	f
8865	268	16	6.00	0	0	0	0	0	0	f	f
8866	302	16	6.00	0	0	0	0	0	0	f	f
8867	313	16	5.50	0	0	0	0	0	0	f	f
8868	271	16	6.00	0	0	0	0	0	0	f	f
8869	294	16	6.00	0	0	0	0	0	0	f	f
8870	388	16	6.00	0	0	0	0	0	0	f	f
8871	447	16	6.00	0	0	0	0	0	1	f	f
8872	485	16	6.50	0	0	0	0	0	0	f	f
8873	4	16	6.00	0	0	0	0	0	0	f	f
8874	71	16	6.00	0	0	0	0	0	0	f	f
8875	83	16	6.00	0	0	0	0	0	0	f	f
8876	113	16	6.50	0	0	0	0	0	0	f	f
8877	140	16	6.50	0	0	0	0	0	0	f	f
8878	240	16	6.00	0	0	0	0	0	0	f	f
8879	178	16	5.50	0	0	0	0	0	0	f	f
8880	319	16	5.50	0	0	0	0	0	0	f	f
8881	356	16	6.00	0	0	0	0	0	0	f	f
8882	360	16	5.50	0	0	0	0	0	0	f	f
8883	265	16	6.00	0	0	0	0	0	0	f	f
8884	279	16	5.50	0	0	0	0	0	0	t	f
8885	441	16	6.00	0	0	0	0	0	0	f	f
8886	450	16	5.00	0	0	0	0	0	0	f	f
8887	510	16	6.00	0	0	0	0	0	0	f	f
8888	483	16	5.50	0	0	0	0	0	0	f	f
8889	50	16	7.00	0	0	0	0	0	0	t	f
8890	147	16	7.00	0	0	0	0	0	0	f	f
8891	116	16	6.00	0	0	0	0	0	0	f	f
8892	114	16	6.50	0	0	0	0	0	0	f	f
8893	115	16	6.50	0	0	0	0	0	0	f	f
8894	226	16	6.50	0	0	0	0	0	0	t	f
8895	143	16	6.00	0	0	0	0	0	0	t	f
8896	403	16	6.50	0	0	0	0	0	0	f	f
8897	280	16	6.00	0	0	0	0	0	0	f	f
8898	365	16	7.00	0	0	0	0	0	0	f	f
8899	367	16	5.50	0	0	0	0	0	0	f	f
8900	404	16	6.00	0	0	0	0	0	0	f	f
8901	359	16	6.00	0	0	0	0	0	0	f	f
8902	493	16	5.50	0	0	0	0	0	0	f	f
8903	502	16	6.00	0	0	0	0	0	0	f	f
8904	456	16	5.50	0	0	0	0	0	0	f	f
8905	14	16	6.00	0	2	0	0	0	0	f	f
8906	148	16	6.00	0	0	0	0	0	0	f	f
8907	166	16	6.00	0	0	0	0	0	0	t	f
8908	186	16	5.00	0	0	0	0	0	0	t	f
8909	165	16	5.50	0	0	0	0	0	0	f	f
8910	129	16	6.50	0	0	0	0	0	0	f	f
8911	344	16	7.00	0	0	0	0	0	1	f	f
8912	368	16	6.50	0	0	0	0	0	0	f	f
8913	373	16	6.00	0	0	0	0	0	0	f	f
8914	382	16	5.50	0	0	0	0	0	0	f	f
8915	320	16	6.00	0	0	0	0	0	0	f	f
8916	433	16	5.00	0	0	0	0	0	0	f	f
8917	406	16	6.00	0	0	0	0	0	0	f	f
8918	337	16	6.00	0	0	0	0	0	0	f	f
8919	487	16	7.00	1	0	0	0	0	0	f	f
8920	517	16	5.50	0	0	0	0	0	0	f	f
8921	2	16	7.00	0	2	0	0	0	0	f	f
8922	100	16	5.50	0	0	0	0	0	0	f	f
8923	76	16	6.00	0	0	0	0	0	0	f	f
8924	167	16	6.50	0	0	0	0	0	0	f	f
8925	72	16	6.50	0	0	0	0	0	0	f	f
8926	227	16	6.00	0	0	0	0	0	0	f	f
8927	275	16	5.50	0	0	0	0	0	0	f	f
8928	295	16	5.00	0	0	0	0	0	0	t	f
8929	369	16	6.00	0	0	0	0	0	0	f	f
8930	335	16	5.50	0	0	0	0	0	0	f	f
8931	281	16	6.00	0	0	0	0	0	0	t	f
8932	384	16	7.00	1	0	0	0	0	0	f	f
8933	481	16	5.00	0	0	0	0	0	0	f	f
8934	448	16	5.50	0	0	0	0	0	0	t	f
8935	484	16	6.00	0	0	0	0	0	0	f	f
8936	15	16	6.50	0	1	0	0	0	0	f	f
8937	142	16	5.50	0	0	0	0	0	0	t	f
8938	150	16	5.00	0	0	0	0	0	0	f	f
8939	118	16	5.50	0	0	0	0	0	0	t	f
8940	199	16	6.00	0	0	0	0	0	0	f	f
8941	149	16	6.00	0	0	0	0	0	0	f	f
8942	315	16	5.50	0	0	0	0	0	0	t	f
8943	389	16	5.50	0	0	0	0	0	0	f	f
8944	303	16	6.50	0	0	0	0	0	0	f	f
8945	422	16	5.50	0	0	0	0	0	0	f	f
8946	287	16	6.00	0	0	0	0	0	0	f	f
8947	308	16	6.00	0	0	0	0	0	0	f	f
8948	527	16	6.00	0	0	0	0	0	0	f	f
8949	453	16	5.50	0	0	0	0	0	0	f	f
8950	518	16	5.50	0	0	0	0	0	0	f	f
8951	537	16	5.50	0	0	0	0	0	0	f	f
8952	22	16	6.00	0	0	0	0	0	0	f	f
8953	179	16	6.00	0	0	0	0	0	0	f	f
8954	152	16	6.00	0	0	0	0	0	0	f	f
8955	91	16	7.00	0	0	0	0	0	0	f	f
8956	151	16	6.00	0	0	0	0	0	0	f	f
8957	168	16	6.50	0	0	0	0	0	0	f	f
8958	370	16	7.00	0	0	0	0	0	0	f	f
8959	387	16	6.00	0	0	0	0	0	0	t	f
8960	288	16	7.00	0	0	0	0	0	0	f	f
8961	399	16	6.00	0	0	0	0	0	0	f	f
8962	358	16	6.00	0	0	0	0	0	0	f	f
8963	386	16	6.00	0	0	0	0	0	0	f	f
8964	496	16	5.00	0	0	0	0	0	0	f	f
8965	466	16	6.50	0	0	0	0	0	0	f	f
8966	488	16	6.00	0	0	0	0	0	0	f	f
8967	468	16	6.00	0	0	0	0	0	0	f	f
8968	19	16	4.50	0	0	0	0	0	0	f	t
8969	27	16	5.00	0	5	0	0	0	0	f	f
8970	78	16	5.50	0	0	0	0	0	0	f	f
8971	128	16	5.50	0	0	0	0	0	0	t	f
8972	154	16	6.00	0	0	0	0	0	0	f	f
8973	153	16	5.00	0	0	0	0	0	0	f	f
8974	131	16	4.50	0	0	0	0	0	0	f	f
8975	101	16	6.00	1	0	0	0	0	0	f	f
8976	272	16	6.00	0	0	0	0	0	0	f	f
8977	371	16	5.00	0	0	0	0	0	0	f	f
8978	321	16	5.50	0	0	0	0	0	0	f	f
8979	326	16	5.00	0	0	0	0	0	0	f	f
8980	328	16	5.00	0	0	0	0	0	0	f	f
8981	452	16	5.00	0	0	0	0	0	0	f	f
8982	497	16	5.50	0	0	0	0	0	0	f	f
8983	542	16	5.50	0	0	0	0	0	0	f	f
8984	12	16	6.00	0	3	0	0	0	0	f	f
8985	155	16	6.00	0	0	0	0	0	0	f	f
8986	181	16	5.00	0	0	0	0	0	0	t	f
8987	182	16	5.00	0	0	0	0	0	0	f	f
8988	252	16	6.00	0	0	0	0	0	0	f	f
8989	169	16	5.50	0	0	0	0	0	0	f	f
8990	225	16	6.00	0	0	0	0	0	0	f	f
8991	345	16	6.50	0	0	0	0	0	0	f	f
8992	408	16	5.50	0	0	0	0	0	0	f	f
8993	309	16	5.50	0	0	0	0	0	0	f	f
8994	391	16	5.00	0	0	0	0	0	0	f	f
8995	327	16	6.50	0	0	0	0	0	1	f	f
8996	521	16	6.00	0	0	0	0	0	0	f	f
8997	473	16	7.00	1	0	0	0	0	0	f	f
8998	503	16	6.00	0	0	0	0	0	0	f	f
8999	469	16	5.50	0	0	0	0	0	0	f	f
9000	46	16	\N	0	0	0	0	0	0	f	f
9001	35	16	\N	0	0	0	0	0	0	f	f
9002	37	16	\N	0	0	0	0	0	0	f	f
9003	24	16	\N	0	0	0	0	0	0	f	f
9004	29	16	\N	0	0	0	0	0	0	f	f
9005	16	16	\N	0	0	0	0	0	0	f	f
9006	51	16	\N	0	0	0	0	0	0	f	f
9007	36	16	\N	0	0	0	0	0	0	f	f
9008	105	16	\N	0	0	0	0	0	0	f	f
9009	92	16	\N	0	0	0	0	0	0	f	f
9010	54	16	\N	0	0	0	0	0	0	f	f
9011	47	16	\N	0	0	0	0	0	0	f	f
9012	96	16	\N	0	0	0	0	0	0	f	f
9013	21	16	\N	0	0	0	0	0	0	f	f
9014	42	16	\N	0	0	0	0	0	0	f	f
9015	52	16	\N	0	0	0	0	0	0	f	f
9016	33	16	\N	0	0	0	0	0	0	f	f
9017	93	16	\N	0	0	0	0	0	0	f	f
9018	28	16	\N	0	0	0	0	0	0	f	f
9019	61	16	\N	0	0	0	0	0	0	f	f
9020	26	16	\N	0	0	0	0	0	0	f	f
9021	56	16	\N	0	0	0	0	0	0	f	f
9022	58	16	\N	0	0	0	0	0	0	f	f
9023	62	16	\N	0	0	0	0	0	0	f	f
9024	65	16	\N	0	0	0	0	0	0	f	f
9025	30	16	\N	0	0	0	0	0	0	f	f
9026	66	16	\N	0	0	0	0	0	0	f	f
9027	45	16	\N	0	0	0	0	0	0	f	f
9028	205	16	\N	0	0	0	0	0	0	f	f
9029	130	16	\N	0	0	0	0	0	0	f	f
9030	189	16	\N	0	0	0	0	0	0	f	f
9031	176	16	\N	0	0	0	0	0	0	f	f
9032	145	16	\N	0	0	0	0	0	0	f	f
9033	112	16	\N	0	0	0	0	0	0	f	f
9034	196	16	\N	0	0	0	0	0	0	f	f
9035	180	16	\N	0	0	0	0	0	0	f	f
9036	197	16	\N	0	0	0	0	0	0	f	f
9037	138	16	\N	0	0	0	0	0	0	f	f
9038	141	16	\N	0	0	0	0	0	0	f	f
9039	202	16	\N	0	0	0	0	0	0	f	f
9040	156	16	\N	0	0	0	0	0	0	f	f
9041	208	16	\N	0	0	0	0	0	0	f	f
9042	121	16	\N	0	0	0	0	0	0	f	f
9043	107	16	\N	0	0	0	0	0	0	f	f
9044	170	16	\N	0	0	0	0	0	0	f	f
9045	137	16	\N	0	0	0	0	0	0	f	f
9046	218	16	\N	0	0	0	0	0	0	f	f
9047	220	16	\N	0	0	0	0	0	0	f	f
9048	224	16	\N	0	0	0	0	0	0	f	f
9049	238	16	\N	0	0	0	0	0	0	f	f
9050	286	16	\N	0	0	0	0	0	0	f	f
9051	235	16	\N	0	0	0	0	0	0	f	f
9052	232	16	\N	0	0	0	0	0	0	f	f
9053	248	16	\N	0	0	0	0	0	0	f	f
9054	241	16	\N	0	0	0	0	0	0	f	f
9055	255	16	\N	0	0	0	0	0	0	f	f
9056	221	16	\N	0	0	0	0	0	0	f	f
9057	230	16	\N	0	0	0	0	0	0	f	f
9058	284	16	\N	0	0	0	0	0	0	f	f
9059	285	16	\N	0	0	0	0	0	0	f	f
9060	244	16	\N	0	0	0	0	0	0	f	f
9061	245	16	\N	0	0	0	0	0	0	f	f
9062	314	16	\N	0	0	0	0	0	0	f	f
9063	210	16	\N	0	0	0	0	0	0	f	f
9064	264	16	\N	0	0	0	0	0	0	f	f
9065	250	16	\N	0	0	0	0	0	0	f	f
9066	223	16	\N	0	0	0	0	0	0	f	f
9067	215	16	\N	0	0	0	0	0	0	f	f
9068	296	16	\N	0	0	0	0	0	0	f	f
9069	228	16	\N	0	0	0	0	0	0	f	f
9070	222	16	\N	0	0	0	0	0	0	f	f
9071	253	16	\N	0	0	0	0	0	0	f	f
9072	254	16	\N	0	0	0	0	0	0	f	f
9073	233	16	\N	0	0	0	0	0	0	f	f
9074	164	16	\N	0	0	0	0	0	0	f	f
9075	418	16	\N	0	0	0	0	0	0	f	f
9076	325	16	\N	0	0	0	0	0	0	f	f
9077	405	16	\N	0	0	0	0	0	0	f	f
9078	390	16	\N	0	0	0	0	0	0	f	f
9079	378	16	\N	0	0	0	0	0	0	f	f
9080	380	16	\N	0	0	0	0	0	0	f	f
9081	385	16	\N	0	0	0	0	0	0	f	f
9082	348	16	\N	0	0	0	0	0	0	f	f
9083	379	16	\N	0	0	0	0	0	0	f	f
9084	397	16	\N	0	0	0	0	0	0	f	f
9085	353	16	\N	0	0	0	0	0	0	f	f
9086	357	16	\N	0	0	0	0	0	0	f	f
9087	341	16	\N	0	0	0	0	0	0	f	f
9088	416	16	\N	0	0	0	0	0	0	f	f
9089	366	16	\N	0	0	0	0	0	0	f	f
9090	409	16	\N	0	0	0	0	0	0	f	f
9091	237	16	\N	0	0	0	0	0	0	f	f
9092	431	16	\N	0	0	0	0	0	0	f	f
9093	509	16	\N	0	0	0	0	0	0	f	f
9094	429	16	\N	0	0	0	0	0	0	f	f
9095	522	16	\N	0	0	0	0	0	0	f	f
9096	523	16	\N	0	0	0	0	0	0	f	f
9097	472	16	\N	0	0	0	0	0	0	f	f
9098	479	16	\N	0	0	0	0	0	0	f	f
9099	449	16	\N	0	0	0	0	0	0	f	f
9100	467	16	\N	0	0	0	0	0	0	f	f
9101	486	16	\N	0	0	0	0	0	0	f	f
9102	428	16	\N	0	0	0	0	0	0	f	f
9103	438	16	\N	0	0	0	0	0	0	f	f
9104	520	16	\N	0	0	0	0	0	0	f	f
9105	437	16	\N	0	0	0	0	0	0	f	f
9106	525	16	\N	0	0	0	0	0	0	f	f
9107	425	16	\N	0	0	0	0	0	0	f	f
9108	426	16	\N	0	0	0	0	0	0	f	f
9109	430	16	\N	0	0	0	0	0	0	f	f
9110	420	16	\N	0	0	0	0	0	0	f	f
9111	462	16	\N	0	0	0	0	0	0	f	f
9112	427	16	\N	0	0	0	0	0	0	f	f
9113	458	16	\N	0	0	0	0	0	0	f	f
9114	489	16	\N	0	0	0	0	0	0	f	f
9115	515	16	\N	0	0	0	0	0	0	f	f
9116	434	16	\N	0	0	0	0	0	0	f	f
9117	435	16	\N	0	0	0	0	0	0	f	f
9118	531	16	\N	0	0	0	0	0	0	f	f
9119	219	16	\N	0	0	0	0	0	0	f	f
9120	530	16	\N	0	0	0	0	0	0	f	f
9121	540	16	\N	0	0	0	0	0	0	f	f
9122	541	16	\N	0	0	0	0	0	0	f	f
9123	43	16	\N	0	0	0	0	0	0	f	f
9124	44	16	\N	0	0	0	0	0	0	f	f
9125	236	16	\N	0	0	0	0	0	0	f	f
9126	217	16	\N	0	0	0	0	0	0	f	f
9127	363	16	\N	0	0	0	0	0	0	f	f
9128	267	16	\N	0	0	0	0	0	0	f	f
9129	494	16	\N	0	0	0	0	0	0	f	f
9130	229	16	\N	0	0	0	0	0	0	f	f
9131	55	16	\N	0	0	0	0	0	0	f	f
9132	206	16	\N	0	0	0	0	0	0	f	f
9133	247	16	\N	0	0	0	0	0	0	f	f
9134	421	16	\N	0	0	0	0	0	0	f	f
9135	246	16	\N	0	0	0	0	0	0	f	f
9136	538	16	\N	0	0	0	0	0	0	f	f
9137	48	16	\N	0	0	0	0	0	0	f	f
9138	177	16	\N	0	0	0	0	0	0	f	f
9139	258	16	\N	0	0	0	0	0	0	f	f
9140	68	16	\N	0	0	0	0	0	0	f	f
9141	260	16	\N	0	0	0	0	0	0	f	f
9142	34	16	\N	0	0	0	0	0	0	f	f
9143	289	16	\N	0	0	0	0	0	0	f	f
9144	498	16	\N	0	0	0	0	0	0	f	f
9145	534	16	\N	0	0	0	0	0	0	f	f
9146	532	16	\N	0	0	0	0	0	0	f	f
9147	543	16	\N	0	0	0	0	0	0	f	f
9148	528	16	\N	0	0	0	0	0	0	f	f
9149	49	16	\N	0	0	0	0	0	0	f	f
9150	201	16	\N	0	0	0	0	0	0	f	f
9151	239	16	\N	0	0	0	0	0	0	f	f
9152	266	16	\N	0	0	0	0	0	0	f	f
9153	334	16	\N	0	0	0	0	0	0	f	f
9154	476	16	\N	0	0	0	0	0	0	f	f
9155	60	16	\N	0	0	0	0	0	0	f	f
9156	57	16	\N	0	0	0	0	0	0	f	f
9157	198	16	\N	0	0	0	0	0	0	f	f
9158	282	16	\N	0	0	0	0	0	0	f	f
9159	423	16	\N	0	0	0	0	0	0	f	f
9160	524	16	\N	0	0	0	0	0	0	f	f
9161	39	16	\N	0	0	0	0	0	0	f	f
9162	59	16	\N	0	0	0	0	0	0	f	f
9163	440	16	\N	0	0	0	0	0	0	f	f
9164	398	16	\N	0	0	0	0	0	0	f	f
9165	507	16	\N	0	0	0	0	0	0	f	f
9166	442	16	\N	0	0	0	0	0	0	f	f
9167	25	16	\N	0	0	0	0	0	0	f	f
9168	109	16	\N	0	0	0	0	0	0	f	f
9169	194	16	\N	0	0	0	0	0	0	f	f
9170	234	16	\N	0	0	0	0	0	0	f	f
9171	410	16	\N	0	0	0	0	0	0	f	f
9172	535	16	\N	0	0	0	0	0	0	f	f
9173	461	16	\N	0	0	0	0	0	0	f	f
9174	53	16	\N	0	0	0	0	0	0	f	f
9175	251	16	\N	0	0	0	0	0	0	f	f
9176	84	16	\N	0	0	0	0	0	0	f	f
9177	471	16	\N	0	0	0	0	0	0	f	f
9178	32	16	\N	0	0	0	0	0	0	f	f
9179	158	16	\N	0	0	0	0	0	0	f	f
9180	132	16	\N	0	0	0	0	0	0	f	f
9181	94	16	\N	0	0	0	0	0	0	f	f
9182	9	16	\N	0	0	0	0	0	0	f	f
9183	209	16	\N	0	0	0	0	0	0	f	f
9184	336	16	\N	0	0	0	0	0	0	f	f
9185	38	16	\N	0	0	0	0	0	0	f	f
9186	256	16	\N	0	0	0	0	0	0	f	f
9187	190	16	\N	0	0	0	0	0	0	f	f
9188	377	16	\N	0	0	0	0	0	0	f	f
9189	415	16	\N	0	0	0	0	0	0	f	f
9190	77	16	\N	0	0	0	0	0	0	f	f
9191	249	16	\N	0	0	0	0	0	0	f	f
9192	203	16	\N	0	0	0	0	0	0	f	f
9193	407	16	\N	0	0	0	0	0	0	f	f
9194	439	16	\N	0	0	0	0	0	0	f	f
9195	539	16	\N	0	0	0	0	0	0	f	f
9196	79	16	\N	0	0	0	0	0	0	f	f
9197	183	16	\N	0	0	0	0	0	0	f	f
9198	413	16	\N	0	0	0	0	0	0	f	f
9199	424	16	\N	0	0	0	0	0	0	f	f
9200	41	16	\N	0	0	0	0	0	0	f	f
9201	82	16	\N	0	0	0	0	0	0	f	f
9202	259	16	\N	0	0	0	0	0	0	f	f
9203	163	16	\N	0	0	0	0	0	0	f	f
9204	262	16	\N	0	0	0	0	0	0	f	f
9205	419	16	\N	0	0	0	0	0	0	f	f
9206	432	16	\N	0	0	0	0	0	0	f	f
9207	354	16	\N	0	0	0	0	0	0	f	f
9208	501	16	\N	0	0	0	0	0	0	f	f
9209	64	16	\N	0	0	0	0	0	0	f	f
9210	188	16	\N	0	0	0	0	0	0	f	f
9211	134	16	\N	0	0	0	0	0	0	f	f
9212	395	16	\N	0	0	0	0	0	0	f	f
9213	277	16	\N	0	0	0	0	0	0	f	f
9214	533	16	\N	0	0	0	0	0	0	f	f
9215	393	16	\N	0	0	0	0	0	0	f	f
9216	23	16	\N	0	0	0	0	0	0	f	f
9217	443	16	\N	0	0	0	0	0	0	f	f
9218	372	16	\N	0	0	0	0	0	0	f	f
9219	31	16	\N	0	0	0	0	0	0	f	f
9220	185	16	\N	0	0	0	0	0	0	f	f
9221	243	16	\N	0	0	0	0	0	0	f	f
9222	242	16	\N	0	0	0	0	0	0	f	f
9223	324	16	\N	0	0	0	0	0	0	f	f
9224	102	16	\N	0	0	0	0	0	0	f	f
9225	383	16	\N	0	0	0	0	0	0	f	f
9226	536	16	\N	0	0	0	0	0	0	f	f
9227	63	16	\N	0	0	0	0	0	0	f	f
9228	231	16	\N	0	0	0	0	0	0	f	f
9229	95	16	\N	0	0	0	0	0	0	f	f
9230	506	16	\N	0	0	0	0	0	0	f	f
9231	512	16	\N	0	0	0	0	0	0	f	f
9232	5	17	6.50	0	1	0	0	0	0	f	f
9233	120	17	5.50	0	0	0	0	0	0	f	f
9234	156	17	4.00	0	0	0	0	0	0	f	f
9235	207	17	7.00	0	0	0	0	0	0	t	f
9236	157	17	6.00	0	0	0	0	0	0	f	f
9237	200	17	6.00	0	0	0	0	0	0	f	f
9238	338	17	6.00	0	0	0	0	0	0	f	f
9239	296	17	5.50	0	0	0	0	0	0	f	f
9240	276	17	5.00	0	0	0	0	0	0	f	f
9241	364	17	5.50	0	0	0	0	0	0	f	f
9242	312	17	6.50	0	0	0	0	0	0	f	f
9243	329	17	6.50	0	0	0	0	0	0	f	f
9244	454	17	5.50	0	0	0	0	0	0	f	f
9245	482	17	5.50	0	0	0	0	0	0	t	f
9246	459	17	6.00	0	0	0	0	0	0	f	f
9247	20	17	5.50	0	1	0	0	0	0	t	f
9248	123	17	6.50	0	0	0	0	0	1	f	f
9249	85	17	6.00	0	0	0	0	0	0	f	f
9250	73	17	6.00	0	0	0	0	0	0	f	f
9251	121	17	5.00	0	0	0	0	0	0	f	f
9252	187	17	6.00	0	0	0	0	0	0	f	f
9253	263	17	5.50	0	0	0	0	0	0	f	f
9254	269	17	6.00	0	0	0	0	0	0	f	f
9255	311	17	6.00	0	0	0	0	0	0	f	f
9256	323	17	6.00	0	0	0	0	0	0	f	f
9257	374	17	7.00	1	0	0	0	0	0	f	f
9258	336	17	6.00	0	0	0	0	0	0	f	f
9259	504	17	5.50	0	0	0	0	0	0	f	f
9260	451	17	5.50	0	0	0	0	0	0	f	f
9261	489	17	5.50	0	0	0	0	0	0	f	f
9262	519	17	5.50	0	0	0	0	0	0	t	f
9263	10	17	6.50	0	1	0	0	0	0	f	f
9264	96	17	6.50	0	0	0	0	0	0	f	f
9265	133	17	6.00	0	0	0	0	0	0	f	f
9266	159	17	6.00	0	0	0	0	0	0	f	f
9267	69	17	7.00	0	0	0	0	0	0	f	f
9268	122	17	6.50	0	0	0	0	0	0	f	f
9269	347	17	6.50	0	0	0	0	0	0	f	f
9270	436	17	6.50	0	0	0	0	0	1	f	f
9271	304	17	6.00	0	0	0	0	0	0	f	f
9272	361	17	6.00	0	0	0	0	0	0	f	f
9273	348	17	7.00	1	0	0	0	0	0	f	f
9274	470	17	5.50	0	0	0	0	0	0	f	f
9275	478	17	6.00	0	0	0	0	0	0	f	f
9276	529	17	7.50	1	0	0	0	0	0	f	f
9277	6	17	6.50	0	0	0	0	0	0	t	f
9278	119	17	6.50	0	0	0	0	0	0	t	f
9279	86	17	7.00	0	0	0	0	0	1	f	f
9280	171	17	6.50	0	0	0	0	0	0	f	f
9281	117	17	7.00	1	0	0	0	0	0	f	f
9282	80	17	6.00	0	0	0	0	0	0	f	f
9283	211	17	7.00	0	0	0	0	0	0	f	f
9284	189	17	5.50	0	0	0	0	0	0	t	f
9285	317	17	6.50	0	0	0	0	0	0	f	f
9286	290	17	6.50	0	0	0	0	0	0	t	f
9287	261	17	7.50	1	0	0	0	0	1	f	f
9288	331	17	6.00	0	0	0	0	0	0	f	f
9289	463	17	7.00	1	0	0	0	0	0	f	f
9290	514	17	6.00	0	0	0	0	0	0	f	f
9291	499	17	6.50	0	0	0	0	0	0	f	f
9292	11	17	6.50	0	2	0	0	0	0	f	f
9293	134	17	5.00	0	0	0	0	0	0	f	f
9294	173	17	5.50	0	0	0	0	0	0	f	f
9295	75	17	5.50	0	0	0	0	0	0	f	f
9296	70	17	5.00	0	0	0	0	0	0	f	f
9297	106	17	5.50	0	0	0	0	0	0	t	f
9298	160	17	6.00	0	0	0	0	0	0	f	f
9299	375	17	5.50	0	0	0	0	0	0	f	f
9300	355	17	6.00	0	0	0	0	0	0	f	f
9301	343	17	5.50	0	0	0	0	0	0	f	f
9302	325	17	6.00	0	0	0	0	0	0	f	f
9303	511	17	5.50	0	0	0	0	0	0	f	f
9304	464	17	6.00	0	0	0	0	0	0	t	f
9305	457	17	5.50	0	0	0	0	0	0	f	f
9306	526	17	6.00	0	0	0	0	0	0	f	f
9307	533	17	6.00	0	0	0	0	0	0	f	f
9308	17	17	6.00	0	1	0	0	0	0	f	f
9309	107	17	6.00	0	0	0	0	0	0	f	f
9310	191	17	6.00	0	0	0	0	0	0	f	f
9311	175	17	6.00	0	0	0	0	0	0	t	f
9312	213	17	5.50	0	0	0	0	0	0	f	f
9313	161	17	5.50	0	0	0	0	0	0	f	f
9314	174	17	6.00	0	0	0	0	0	0	f	f
9315	162	17	5.50	0	0	0	0	0	0	f	f
9316	256	17	6.00	0	0	0	0	0	0	f	f
9317	274	17	5.50	0	0	0	0	0	0	t	f
9318	376	17	6.00	0	0	0	0	0	0	f	f
9319	366	17	5.50	0	0	0	0	0	0	f	f
9320	297	17	6.00	0	0	0	0	0	0	f	f
9321	396	17	5.50	0	0	0	0	0	0	f	f
9322	460	17	5.00	0	0	0	0	0	0	f	f
9323	505	17	5.00	0	0	0	0	0	0	f	f
9324	40	17	6.50	0	3	0	0	0	0	f	f
9325	74	17	5.50	0	0	0	0	0	0	f	f
9326	98	17	5.00	0	0	0	0	0	0	f	f
9327	92	17	5.00	0	0	0	0	0	0	f	f
9328	192	17	6.00	0	0	0	0	0	0	f	f
9329	135	17	5.50	0	0	0	0	0	0	f	f
9330	214	17	5.00	0	0	0	0	0	0	f	f
9331	305	17	5.00	0	0	0	0	0	0	f	f
9332	342	17	5.50	0	0	0	0	0	0	t	f
9333	318	17	5.50	0	0	0	0	0	0	f	f
9334	442	17	5.50	0	0	0	0	0	0	f	f
9335	349	17	6.00	0	0	0	0	0	0	f	f
9336	508	17	6.00	0	0	0	0	0	0	f	f
9337	500	17	5.00	0	0	0	0	0	0	f	f
9338	490	17	5.50	0	0	0	0	0	0	f	f
9339	507	17	6.50	1	0	0	0	0	0	f	f
9340	13	17	6.00	0	0	0	0	0	0	f	f
9341	66	17	6.50	0	0	0	0	0	0	f	f
9342	67	17	6.00	0	0	0	0	0	0	t	f
9343	104	17	7.00	0	0	0	0	0	0	f	f
9344	81	17	6.00	0	0	0	0	0	0	f	f
9345	137	17	6.50	0	0	0	0	0	0	f	f
9346	300	17	6.50	0	0	0	0	0	0	f	f
9347	270	17	5.50	0	0	0	0	0	0	f	f
9348	262	17	6.50	0	0	0	0	0	0	f	f
9349	351	17	6.00	0	0	0	0	0	0	f	f
9350	352	17	6.00	0	0	0	0	0	0	f	f
9351	350	17	5.50	0	0	0	0	0	0	f	f
9352	411	17	6.00	0	0	0	0	0	0	f	f
9353	444	17	7.00	1	0	0	0	0	0	f	f
9354	445	17	5.50	0	0	0	0	0	0	f	f
9355	475	17	6.50	0	0	0	0	0	1	f	f
9356	7	17	6.00	0	0	0	0	0	0	f	f
9357	87	17	6.00	0	0	0	0	0	0	f	f
9358	88	17	7.00	1	0	0	0	0	0	f	f
9359	99	17	6.00	0	0	0	0	0	0	f	f
9360	108	17	6.50	0	0	0	0	0	0	f	f
9361	194	17	6.00	0	0	0	0	0	0	f	f
9362	307	17	6.50	0	0	0	0	0	0	t	f
9363	306	17	6.00	0	0	0	0	0	0	f	f
9364	332	17	6.50	0	0	0	0	0	0	f	f
9365	291	17	5.50	0	0	0	0	0	0	f	f
9366	353	17	5.50	0	0	0	0	0	0	f	f
9367	322	17	6.50	0	0	0	0	0	0	f	f
9368	400	17	6.50	0	0	0	0	0	0	f	f
9369	480	17	6.00	0	0	0	0	0	0	f	f
9370	477	17	5.00	0	0	0	0	0	0	f	f
9371	446	17	6.50	1	0	0	0	0	0	f	f
9372	3	17	6.00	0	1	0	0	0	0	f	f
9373	126	17	6.50	0	0	0	0	0	0	f	f
9374	110	17	6.00	0	0	0	0	0	0	f	f
9375	195	17	6.00	0	0	0	0	0	0	f	f
9376	144	17	6.00	0	0	0	0	0	0	t	f
9377	125	17	5.50	0	0	0	0	0	0	f	f
9378	176	17	6.00	0	0	0	0	0	0	f	f
9379	362	17	6.50	0	0	0	0	0	0	t	f
9380	301	17	6.50	0	0	0	0	0	0	t	f
9381	267	17	5.50	0	0	0	0	0	0	f	f
9382	417	17	6.00	0	0	0	0	0	0	f	f
9383	285	17	6.00	0	0	0	0	0	0	f	f
9384	491	17	6.50	0	0	0	0	0	0	t	f
9385	455	17	6.00	0	0	0	0	0	0	f	f
9386	492	17	6.00	0	0	0	0	0	0	f	f
9387	8	17	5.50	0	3	0	0	0	0	f	f
9388	127	17	5.50	0	0	0	0	0	0	f	f
9389	89	17	5.50	0	0	0	0	0	0	f	f
9390	146	17	5.00	0	0	0	0	0	0	f	f
9391	257	17	5.00	0	0	0	0	0	0	f	f
9392	310	17	6.00	0	0	0	0	0	0	t	f
9393	402	17	6.00	0	0	0	0	0	0	f	f
9394	419	17	6.00	0	0	0	0	0	0	f	f
9395	354	17	5.00	0	0	0	0	0	0	t	f
9396	401	17	5.00	0	0	0	0	0	0	f	f
9397	333	17	5.50	0	0	0	0	0	0	f	f
9398	412	17	6.00	0	0	0	0	0	0	f	f
9399	509	17	5.50	0	0	0	0	0	0	f	f
9400	495	17	5.50	0	0	0	0	0	0	f	f
9401	513	17	5.50	0	0	0	0	0	0	f	f
9402	1	17	6.00	0	0	0	0	0	0	f	f
9403	139	17	6.50	0	0	0	0	0	0	f	f
9404	68	17	6.50	0	0	0	0	0	0	f	f
9405	193	17	6.00	0	0	0	0	0	0	f	f
9406	90	17	6.50	0	0	0	0	0	0	f	f
9407	184	17	6.00	0	0	0	0	0	0	f	f
9408	258	17	6.00	0	0	0	0	0	0	f	f
9409	273	17	7.00	0	0	0	0	0	1	f	f
9410	260	17	7.00	1	0	0	0	0	0	f	f
9411	268	17	7.00	0	0	0	0	0	0	f	f
9412	302	17	6.50	0	0	0	0	0	0	f	f
9413	313	17	6.00	0	0	0	0	0	0	f	f
9414	271	17	6.00	0	0	0	0	0	0	f	f
9415	294	17	6.00	0	0	0	0	0	0	f	f
9416	388	17	6.00	0	0	0	0	0	0	f	f
9417	485	17	7.50	1	0	0	0	0	0	f	f
9418	4	17	6.00	0	0	0	0	0	0	f	f
9419	196	17	6.00	0	0	0	0	0	0	t	f
9420	71	17	7.00	0	0	0	0	0	0	f	f
9421	83	17	6.00	0	0	0	0	0	0	f	f
9422	113	17	6.50	0	0	0	0	0	0	f	f
9423	140	17	6.00	0	0	0	0	0	0	f	f
9424	201	17	6.00	0	0	0	0	0	0	f	f
9425	240	17	6.00	0	0	0	0	0	0	f	f
9426	319	17	6.50	0	0	0	0	0	0	f	f
9427	356	17	6.50	0	0	0	0	0	0	f	f
9428	360	17	5.50	0	0	0	0	0	0	f	f
9429	265	17	6.50	0	0	0	0	0	0	t	f
9430	279	17	6.00	0	0	0	0	0	0	f	f
9431	450	17	8.00	2	0	0	0	0	0	f	f
9432	510	17	6.00	0	0	0	0	0	0	f	f
9433	483	17	6.00	0	0	0	0	0	0	f	f
9434	23	17	7.00	0	0	0	0	0	0	t	f
9435	147	17	6.50	0	0	0	0	0	0	f	f
9436	116	17	6.00	0	0	0	0	0	0	f	f
9437	114	17	6.50	0	0	0	0	0	0	t	f
9438	143	17	6.50	0	0	0	0	0	0	f	f
9439	403	17	6.00	0	0	0	0	0	0	f	f
9440	372	17	6.00	0	0	0	0	0	0	f	f
9441	280	17	6.50	0	0	0	0	0	0	f	f
9442	365	17	6.50	0	0	0	0	0	0	f	f
9443	367	17	5.50	0	0	0	0	0	0	f	f
9444	404	17	6.00	0	0	0	0	0	0	f	f
9445	359	17	7.00	1	0	0	0	0	0	f	f
9446	443	17	6.00	0	0	0	0	0	0	f	f
9447	531	17	6.00	0	0	0	0	0	0	f	f
9448	502	17	5.50	0	0	0	0	0	0	f	f
9449	456	17	6.50	0	0	0	0	0	0	f	f
9450	14	17	6.00	0	2	0	0	0	0	f	f
9451	148	17	6.50	0	0	0	0	0	0	t	f
9452	166	17	5.50	0	0	0	0	0	0	f	f
9453	186	17	5.50	0	0	0	0	0	0	f	f
9454	165	17	6.00	0	0	0	0	0	0	f	f
9455	129	17	6.00	0	0	0	0	0	0	t	f
9456	344	17	6.50	0	0	0	0	0	0	f	f
9457	368	17	5.50	0	0	0	0	0	0	t	f
9458	373	17	6.00	0	0	0	0	0	0	f	f
9459	320	17	5.50	0	0	0	0	0	0	f	f
9460	433	17	6.00	0	0	0	0	0	0	f	f
9461	383	17	6.00	0	0	0	0	0	0	f	f
9462	406	17	5.50	0	0	0	0	0	0	t	f
9463	337	17	6.00	0	0	0	0	0	0	f	f
9464	487	17	5.50	0	0	0	0	0	0	f	f
9465	536	17	6.00	0	0	0	0	0	0	f	f
9466	2	17	6.00	0	1	0	0	0	0	f	f
9467	100	17	6.50	0	0	0	0	0	0	f	f
9468	76	17	6.00	0	0	0	0	0	0	f	f
9469	84	17	6.50	0	0	0	0	0	0	f	f
9470	251	17	6.00	0	0	0	0	0	0	f	f
9471	167	17	6.00	0	0	0	0	0	0	f	f
9472	72	17	6.00	0	0	0	0	0	0	f	f
9473	227	17	6.50	0	0	0	0	0	0	f	f
9474	295	17	6.50	0	0	0	0	0	0	f	f
9475	369	17	6.00	0	0	0	0	0	0	f	f
9476	281	17	7.50	1	0	0	0	0	0	f	f
9477	420	17	6.00	0	0	0	0	0	0	f	f
9478	481	17	6.50	0	0	0	0	0	0	f	f
9479	448	17	7.50	1	0	0	0	0	0	f	f
9480	484	17	7.00	1	0	0	0	0	1	f	f
9481	471	17	6.00	0	0	0	0	0	0	f	f
9482	15	17	6.00	0	1	0	0	0	0	f	f
9483	142	17	5.50	0	0	0	0	0	0	f	f
9484	150	17	6.00	0	0	0	0	0	0	f	f
9485	118	17	6.50	0	0	0	0	0	0	f	f
9486	199	17	6.00	0	0	0	0	0	0	t	f
9487	149	17	7.00	1	0	0	0	0	0	f	f
9488	315	17	6.50	0	0	0	0	0	0	f	f
9489	303	17	6.00	0	0	0	0	0	0	f	f
9490	314	17	5.50	0	0	0	0	0	0	f	f
9491	287	17	6.00	0	0	0	0	0	0	f	f
9492	308	17	5.00	0	0	0	0	0	0	t	f
9493	467	17	5.50	0	0	0	0	0	0	f	f
9494	453	17	6.00	0	0	0	0	0	1	t	f
9495	518	17	6.00	0	0	0	0	0	0	f	f
9496	22	17	6.00	0	2	0	0	0	0	f	f
9497	152	17	5.50	0	0	0	0	0	0	f	f
9498	91	17	5.50	0	0	0	0	0	0	f	f
9499	151	17	5.00	0	0	0	0	0	0	f	f
9500	203	17	5.50	0	0	0	0	0	0	t	f
9501	168	17	5.50	0	0	0	0	0	0	f	f
9502	370	17	5.50	0	0	0	0	0	0	f	f
9503	288	17	7.00	1	0	0	0	0	0	t	f
9504	399	17	5.50	0	0	0	0	0	0	f	f
9505	439	17	6.00	0	0	0	0	0	0	f	f
9506	386	17	6.00	0	0	0	0	0	0	f	f
9507	496	17	5.50	0	0	0	0	0	0	f	f
9508	466	17	5.50	0	0	0	0	0	0	f	f
9509	488	17	6.00	0	0	0	0	0	0	f	f
9510	468	17	6.50	0	0	0	0	0	1	f	f
9511	528	17	6.00	0	0	0	0	0	0	t	f
9512	57	17	6.50	0	1	0	0	0	0	f	f
9513	78	17	6.00	0	0	0	0	0	0	t	f
9514	128	17	6.00	0	0	0	0	0	0	f	f
9515	154	17	6.00	0	0	0	0	0	0	f	f
9516	153	17	5.50	0	0	0	0	0	0	f	f
9517	131	17	5.50	0	0	0	0	0	0	f	f
9518	250	17	6.00	0	0	0	0	0	0	f	f
9519	101	17	5.50	0	0	0	0	1	0	f	f
9520	272	17	6.50	0	0	0	0	0	0	t	f
9521	321	17	6.00	0	0	0	0	0	0	t	f
9522	326	17	6.00	0	0	0	0	0	0	f	f
9523	328	17	6.00	0	0	0	0	0	0	f	f
9524	437	17	6.00	0	0	0	0	0	0	f	f
9525	452	17	7.00	1	0	0	0	0	0	f	f
9526	497	17	6.00	0	0	0	0	0	0	f	f
9527	12	17	6.00	0	3	0	0	0	0	f	f
9528	155	17	5.50	0	0	0	0	0	0	f	f
9529	181	17	5.50	0	0	0	0	0	0	f	f
9530	182	17	5.50	0	0	0	0	0	0	f	f
9531	254	17	5.00	0	0	0	0	0	0	f	f
9532	169	17	4.50	0	0	0	0	0	0	f	f
9533	170	17	5.00	0	0	0	0	0	0	f	f
9534	408	17	6.00	0	0	0	0	0	0	f	f
9535	409	17	6.00	0	0	0	0	0	0	f	f
9536	309	17	6.00	0	0	0	0	0	0	f	f
9537	391	17	5.00	0	0	0	0	0	0	t	f
9538	327	17	5.50	0	0	0	0	0	0	f	f
9539	521	17	5.50	0	0	0	0	0	0	f	f
9540	473	17	5.50	0	0	0	0	0	0	f	f
9541	503	17	5.50	0	0	0	0	0	0	f	f
9542	469	17	6.00	0	0	0	0	0	0	f	f
9543	46	17	\N	0	0	0	0	0	0	f	f
9544	35	17	\N	0	0	0	0	0	0	f	f
9545	37	17	\N	0	0	0	0	0	0	f	f
9546	24	17	\N	0	0	0	0	0	0	f	f
9547	29	17	\N	0	0	0	0	0	0	f	f
9548	16	17	\N	0	0	0	0	0	0	f	f
9549	51	17	\N	0	0	0	0	0	0	f	f
9550	36	17	\N	0	0	0	0	0	0	f	f
9551	105	17	\N	0	0	0	0	0	0	f	f
9552	54	17	\N	0	0	0	0	0	0	f	f
9553	47	17	\N	0	0	0	0	0	0	f	f
9554	21	17	\N	0	0	0	0	0	0	f	f
9555	19	17	\N	0	0	0	0	0	0	f	f
9556	27	17	\N	0	0	0	0	0	0	f	f
9557	18	17	\N	0	0	0	0	0	0	f	f
9558	42	17	\N	0	0	0	0	0	0	f	f
9559	52	17	\N	0	0	0	0	0	0	f	f
9560	33	17	\N	0	0	0	0	0	0	f	f
9561	93	17	\N	0	0	0	0	0	0	f	f
9562	28	17	\N	0	0	0	0	0	0	f	f
9563	61	17	\N	0	0	0	0	0	0	f	f
9564	26	17	\N	0	0	0	0	0	0	f	f
9565	56	17	\N	0	0	0	0	0	0	f	f
9566	58	17	\N	0	0	0	0	0	0	f	f
9567	62	17	\N	0	0	0	0	0	0	f	f
9568	65	17	\N	0	0	0	0	0	0	f	f
9569	30	17	\N	0	0	0	0	0	0	f	f
9570	45	17	\N	0	0	0	0	0	0	f	f
9571	115	17	\N	0	0	0	0	0	0	f	f
9572	205	17	\N	0	0	0	0	0	0	f	f
9573	172	17	\N	0	0	0	0	0	0	f	f
9574	130	17	\N	0	0	0	0	0	0	f	f
9575	145	17	\N	0	0	0	0	0	0	f	f
9576	111	17	\N	0	0	0	0	0	0	f	f
9577	204	17	\N	0	0	0	0	0	0	f	f
9578	112	17	\N	0	0	0	0	0	0	f	f
9579	180	17	\N	0	0	0	0	0	0	f	f
9580	197	17	\N	0	0	0	0	0	0	f	f
9581	138	17	\N	0	0	0	0	0	0	f	f
9582	141	17	\N	0	0	0	0	0	0	f	f
9583	202	17	\N	0	0	0	0	0	0	f	f
9584	208	17	\N	0	0	0	0	0	0	f	f
9585	218	17	\N	0	0	0	0	0	0	f	f
9586	220	17	\N	0	0	0	0	0	0	f	f
9587	224	17	\N	0	0	0	0	0	0	f	f
9588	238	17	\N	0	0	0	0	0	0	f	f
9589	286	17	\N	0	0	0	0	0	0	f	f
9590	235	17	\N	0	0	0	0	0	0	f	f
9591	232	17	\N	0	0	0	0	0	0	f	f
9592	283	17	\N	0	0	0	0	0	0	f	f
9593	226	17	\N	0	0	0	0	0	0	f	f
9594	248	17	\N	0	0	0	0	0	0	f	f
9595	241	17	\N	0	0	0	0	0	0	f	f
9596	255	17	\N	0	0	0	0	0	0	f	f
9597	221	17	\N	0	0	0	0	0	0	f	f
9598	230	17	\N	0	0	0	0	0	0	f	f
9599	284	17	\N	0	0	0	0	0	0	f	f
9600	292	17	\N	0	0	0	0	0	0	f	f
9601	244	17	\N	0	0	0	0	0	0	f	f
9602	245	17	\N	0	0	0	0	0	0	f	f
9603	210	17	\N	0	0	0	0	0	0	f	f
9604	264	17	\N	0	0	0	0	0	0	f	f
9605	223	17	\N	0	0	0	0	0	0	f	f
9606	215	17	\N	0	0	0	0	0	0	f	f
9607	298	17	\N	0	0	0	0	0	0	f	f
9608	216	17	\N	0	0	0	0	0	0	f	f
9609	278	17	\N	0	0	0	0	0	0	f	f
9610	228	17	\N	0	0	0	0	0	0	f	f
9611	222	17	\N	0	0	0	0	0	0	f	f
9612	253	17	\N	0	0	0	0	0	0	f	f
9613	225	17	\N	0	0	0	0	0	0	f	f
9614	233	17	\N	0	0	0	0	0	0	f	f
9615	299	17	\N	0	0	0	0	0	0	f	f
9616	164	17	\N	0	0	0	0	0	0	f	f
9617	418	17	\N	0	0	0	0	0	0	f	f
9618	405	17	\N	0	0	0	0	0	0	f	f
9619	390	17	\N	0	0	0	0	0	0	f	f
9620	382	17	\N	0	0	0	0	0	0	f	f
9621	316	17	\N	0	0	0	0	0	0	f	f
9622	414	17	\N	0	0	0	0	0	0	f	f
9623	378	17	\N	0	0	0	0	0	0	f	f
9624	392	17	\N	0	0	0	0	0	0	f	f
9625	380	17	\N	0	0	0	0	0	0	f	f
9626	385	17	\N	0	0	0	0	0	0	f	f
9627	371	17	\N	0	0	0	0	0	0	f	f
9628	379	17	\N	0	0	0	0	0	0	f	f
9629	397	17	\N	0	0	0	0	0	0	f	f
9630	384	17	\N	0	0	0	0	0	0	f	f
9631	357	17	\N	0	0	0	0	0	0	f	f
9632	339	17	\N	0	0	0	0	0	0	f	f
9633	394	17	\N	0	0	0	0	0	0	f	f
9634	340	17	\N	0	0	0	0	0	0	f	f
9635	341	17	\N	0	0	0	0	0	0	f	f
9636	416	17	\N	0	0	0	0	0	0	f	f
9637	345	17	\N	0	0	0	0	0	0	f	f
9638	237	17	\N	0	0	0	0	0	0	f	f
9639	431	17	\N	0	0	0	0	0	0	f	f
9640	429	17	\N	0	0	0	0	0	0	f	f
9641	522	17	\N	0	0	0	0	0	0	f	f
9642	523	17	\N	0	0	0	0	0	0	f	f
9643	517	17	\N	0	0	0	0	0	0	f	f
9644	472	17	\N	0	0	0	0	0	0	f	f
9645	479	17	\N	0	0	0	0	0	0	f	f
9646	449	17	\N	0	0	0	0	0	0	f	f
9647	486	17	\N	0	0	0	0	0	0	f	f
9648	428	17	\N	0	0	0	0	0	0	f	f
9649	438	17	\N	0	0	0	0	0	0	f	f
9650	520	17	\N	0	0	0	0	0	0	f	f
9651	441	17	\N	0	0	0	0	0	0	f	f
9652	525	17	\N	0	0	0	0	0	0	f	f
9653	425	17	\N	0	0	0	0	0	0	f	f
9654	426	17	\N	0	0	0	0	0	0	f	f
9655	430	17	\N	0	0	0	0	0	0	f	f
9656	462	17	\N	0	0	0	0	0	0	f	f
9657	427	17	\N	0	0	0	0	0	0	f	f
9658	458	17	\N	0	0	0	0	0	0	f	f
9659	515	17	\N	0	0	0	0	0	0	f	f
9660	434	17	\N	0	0	0	0	0	0	f	f
9661	435	17	\N	0	0	0	0	0	0	f	f
9662	474	17	\N	0	0	0	0	0	0	f	f
9663	219	17	\N	0	0	0	0	0	0	f	f
9664	530	17	\N	0	0	0	0	0	0	f	f
9665	540	17	\N	0	0	0	0	0	0	f	f
9666	541	17	\N	0	0	0	0	0	0	f	f
9667	43	17	\N	0	0	0	0	0	0	f	f
9668	44	17	\N	0	0	0	0	0	0	f	f
9669	236	17	\N	0	0	0	0	0	0	f	f
9670	217	17	\N	0	0	0	0	0	0	f	f
9671	363	17	\N	0	0	0	0	0	0	f	f
9672	494	17	\N	0	0	0	0	0	0	f	f
9673	229	17	\N	0	0	0	0	0	0	f	f
9674	55	17	\N	0	0	0	0	0	0	f	f
9675	206	17	\N	0	0	0	0	0	0	f	f
9676	247	17	\N	0	0	0	0	0	0	f	f
9677	421	17	\N	0	0	0	0	0	0	f	f
9678	422	17	\N	0	0	0	0	0	0	f	f
9679	246	17	\N	0	0	0	0	0	0	f	f
9680	389	17	\N	0	0	0	0	0	0	f	f
9681	527	17	\N	0	0	0	0	0	0	f	f
9682	538	17	\N	0	0	0	0	0	0	f	f
9683	48	17	\N	0	0	0	0	0	0	f	f
9684	177	17	\N	0	0	0	0	0	0	f	f
9685	447	17	\N	0	0	0	0	0	0	f	f
9686	34	17	\N	0	0	0	0	0	0	f	f
9687	97	17	\N	0	0	0	0	0	0	f	f
9688	516	17	\N	0	0	0	0	0	0	f	f
9689	289	17	\N	0	0	0	0	0	0	f	f
9690	330	17	\N	0	0	0	0	0	0	f	f
9691	498	17	\N	0	0	0	0	0	0	f	f
9692	534	17	\N	0	0	0	0	0	0	f	f
9693	532	17	\N	0	0	0	0	0	0	f	f
9694	542	17	\N	0	0	0	0	0	0	f	f
9695	543	17	\N	0	0	0	0	0	0	f	f
9696	49	17	\N	0	0	0	0	0	0	f	f
9697	239	17	\N	0	0	0	0	0	0	f	f
9698	178	17	\N	0	0	0	0	0	0	f	f
9699	266	17	\N	0	0	0	0	0	0	f	f
9700	334	17	\N	0	0	0	0	0	0	f	f
9701	476	17	\N	0	0	0	0	0	0	f	f
9702	60	17	\N	0	0	0	0	0	0	f	f
9703	198	17	\N	0	0	0	0	0	0	f	f
9704	282	17	\N	0	0	0	0	0	0	f	f
9705	423	17	\N	0	0	0	0	0	0	f	f
9706	524	17	\N	0	0	0	0	0	0	f	f
9707	39	17	\N	0	0	0	0	0	0	f	f
9708	59	17	\N	0	0	0	0	0	0	f	f
9709	440	17	\N	0	0	0	0	0	0	f	f
9710	398	17	\N	0	0	0	0	0	0	f	f
9711	25	17	\N	0	0	0	0	0	0	f	f
9712	109	17	\N	0	0	0	0	0	0	f	f
9713	234	17	\N	0	0	0	0	0	0	f	f
9714	410	17	\N	0	0	0	0	0	0	f	f
9715	535	17	\N	0	0	0	0	0	0	f	f
9716	461	17	\N	0	0	0	0	0	0	f	f
9717	53	17	\N	0	0	0	0	0	0	f	f
9718	275	17	\N	0	0	0	0	0	0	f	f
9719	335	17	\N	0	0	0	0	0	0	f	f
9720	346	17	\N	0	0	0	0	0	0	f	f
9721	32	17	\N	0	0	0	0	0	0	f	f
9722	158	17	\N	0	0	0	0	0	0	f	f
9723	132	17	\N	0	0	0	0	0	0	f	f
9724	94	17	\N	0	0	0	0	0	0	f	f
9725	465	17	\N	0	0	0	0	0	0	f	f
9726	9	17	\N	0	0	0	0	0	0	f	f
9727	209	17	\N	0	0	0	0	0	0	f	f
9728	103	17	\N	0	0	0	0	0	0	f	f
9729	537	17	\N	0	0	0	0	0	0	f	f
9730	38	17	\N	0	0	0	0	0	0	f	f
9731	190	17	\N	0	0	0	0	0	0	f	f
9732	124	17	\N	0	0	0	0	0	0	f	f
9733	377	17	\N	0	0	0	0	0	0	f	f
9734	415	17	\N	0	0	0	0	0	0	f	f
9735	179	17	\N	0	0	0	0	0	0	f	f
9736	77	17	\N	0	0	0	0	0	0	f	f
9737	249	17	\N	0	0	0	0	0	0	f	f
9738	407	17	\N	0	0	0	0	0	0	f	f
9739	358	17	\N	0	0	0	0	0	0	f	f
9740	387	17	\N	0	0	0	0	0	0	f	f
9741	539	17	\N	0	0	0	0	0	0	f	f
9742	79	17	\N	0	0	0	0	0	0	f	f
9743	183	17	\N	0	0	0	0	0	0	f	f
9744	252	17	\N	0	0	0	0	0	0	f	f
9745	413	17	\N	0	0	0	0	0	0	f	f
9746	424	17	\N	0	0	0	0	0	0	f	f
9747	41	17	\N	0	0	0	0	0	0	f	f
9748	136	17	\N	0	0	0	0	0	0	f	f
9749	82	17	\N	0	0	0	0	0	0	f	f
9750	259	17	\N	0	0	0	0	0	0	f	f
9751	163	17	\N	0	0	0	0	0	0	f	f
9752	293	17	\N	0	0	0	0	0	0	f	f
9753	432	17	\N	0	0	0	0	0	0	f	f
9754	501	17	\N	0	0	0	0	0	0	f	f
9755	381	17	\N	0	0	0	0	0	0	f	f
9756	64	17	\N	0	0	0	0	0	0	f	f
9757	188	17	\N	0	0	0	0	0	0	f	f
9758	212	17	\N	0	0	0	0	0	0	f	f
9759	395	17	\N	0	0	0	0	0	0	f	f
9760	277	17	\N	0	0	0	0	0	0	f	f
9761	393	17	\N	0	0	0	0	0	0	f	f
9762	50	17	\N	0	0	0	0	0	0	f	f
9763	493	17	\N	0	0	0	0	0	0	f	f
9764	31	17	\N	0	0	0	0	0	0	f	f
9765	185	17	\N	0	0	0	0	0	0	f	f
9766	243	17	\N	0	0	0	0	0	0	f	f
9767	242	17	\N	0	0	0	0	0	0	f	f
9768	324	17	\N	0	0	0	0	0	0	f	f
9769	102	17	\N	0	0	0	0	0	0	f	f
9770	63	17	\N	0	0	0	0	0	0	f	f
9771	231	17	\N	0	0	0	0	0	0	f	f
9772	95	17	\N	0	0	0	0	0	0	f	f
9773	506	17	\N	0	0	0	0	0	0	f	f
9774	512	17	\N	0	0	0	0	0	0	f	f
9775	5	18	6.50	0	0	0	0	0	0	f	f
9776	120	18	6.00	0	0	0	0	0	0	f	f
9777	156	18	7.00	0	0	0	0	0	0	f	f
9778	207	18	6.00	0	0	0	0	0	0	f	f
9779	132	18	7.00	1	0	0	0	0	0	f	f
9780	157	18	6.00	0	0	0	0	0	0	f	f
9781	158	18	6.50	0	0	0	0	0	0	f	f
9782	200	18	6.50	0	0	0	0	0	0	f	f
9783	338	18	6.50	0	0	0	0	0	0	t	f
9784	394	18	6.00	0	0	0	0	0	0	f	f
9785	364	18	6.00	0	0	0	0	0	0	f	f
9786	312	18	6.00	0	0	0	0	0	1	f	f
9787	329	18	6.00	0	0	0	0	0	0	f	f
9788	454	18	6.00	0	0	0	0	0	0	f	f
9789	459	18	6.00	0	0	0	0	0	0	f	f
9790	465	18	6.00	0	0	0	0	0	0	f	f
9791	20	18	7.00	0	3	0	0	0	0	f	f
9792	209	18	6.00	0	0	0	0	0	1	t	f
9793	123	18	5.50	0	0	0	0	0	0	f	f
9794	73	18	5.50	0	0	0	0	0	0	f	f
9795	121	18	5.00	0	0	0	0	0	0	f	f
9796	187	18	5.50	0	0	0	0	0	0	t	f
9797	103	18	5.50	0	0	0	0	0	0	f	f
9798	340	18	6.00	0	0	0	0	0	0	f	f
9799	263	18	6.00	0	0	0	0	0	0	f	f
9800	269	18	5.50	0	0	0	0	0	0	f	f
9801	311	18	5.00	0	0	0	0	0	0	f	f
9802	346	18	5.50	0	0	0	0	0	0	f	f
9803	323	18	6.00	0	0	0	0	0	0	f	f
9804	336	18	5.00	0	0	0	0	0	0	t	f
9805	458	18	5.00	0	0	0	0	0	0	f	f
9806	451	18	6.50	1	0	0	0	0	0	f	f
9807	10	18	6.00	0	1	0	0	0	0	f	f
9808	96	18	5.50	0	0	0	0	0	0	f	f
9809	133	18	5.50	0	0	0	0	0	0	f	f
9810	159	18	6.00	0	0	0	0	0	0	f	f
9811	69	18	6.00	0	0	0	0	0	0	t	f
9812	122	18	6.00	0	0	0	0	0	0	t	f
9813	204	18	6.00	0	0	0	0	0	0	f	f
9814	436	18	5.50	0	0	0	0	0	0	f	f
9815	304	18	6.00	0	0	0	0	0	0	f	f
9816	361	18	5.50	0	0	0	0	0	0	f	f
9817	348	18	5.50	0	0	0	0	0	0	f	f
9818	534	18	6.00	0	0	0	0	0	0	f	f
9819	470	18	6.00	0	0	0	0	0	0	f	f
9820	478	18	5.50	0	0	0	0	0	0	f	f
9821	529	18	5.50	0	0	0	0	0	0	f	f
9822	6	18	6.00	0	0	0	0	0	0	f	f
9823	86	18	6.00	0	0	0	0	0	0	f	f
9824	171	18	6.00	0	0	0	0	0	0	f	f
9825	95	18	6.00	0	0	0	0	0	0	f	f
9826	105	18	6.00	0	0	0	0	0	0	f	f
9827	117	18	6.50	0	0	0	0	0	0	f	f
9828	80	18	6.00	0	0	0	0	0	0	f	f
9829	211	18	6.00	0	0	0	0	0	0	f	f
9830	189	18	6.00	0	0	0	0	0	0	f	f
9831	316	18	6.00	0	0	0	0	0	0	f	f
9832	317	18	7.00	0	0	0	0	0	0	f	f
9833	290	18	6.50	0	0	0	0	0	0	f	f
9834	261	18	6.00	0	0	0	0	0	0	f	f
9835	463	18	6.00	0	0	0	0	0	0	f	f
9836	514	18	6.00	0	0	0	0	0	0	f	f
9837	499	18	6.50	0	0	0	0	0	0	t	f
9838	11	18	6.50	0	1	0	0	0	0	f	f
9839	173	18	5.50	0	0	0	0	0	0	f	f
9840	75	18	6.50	0	0	0	0	0	0	f	f
9841	70	18	6.00	0	0	0	0	0	0	f	f
9842	106	18	6.00	0	0	0	0	0	0	f	f
9843	172	18	5.50	0	0	0	0	0	0	f	f
9844	375	18	6.00	0	0	0	0	0	0	f	f
9845	277	18	6.00	0	0	0	0	0	0	f	f
9846	355	18	5.50	0	0	0	0	0	0	t	f
9847	343	18	6.00	0	0	0	0	0	0	f	f
9848	325	18	6.00	0	0	0	0	0	0	t	f
9849	283	18	5.50	0	0	0	0	0	0	f	f
9850	511	18	6.00	0	0	0	0	0	0	f	f
9851	464	18	5.50	0	0	0	0	0	0	f	f
9852	457	18	5.50	0	0	0	0	0	0	f	f
9853	533	18	5.50	0	0	0	0	0	0	f	f
9854	17	18	6.50	0	0	0	0	0	0	f	f
9855	107	18	6.00	0	0	0	0	0	0	f	f
9856	124	18	5.50	0	0	0	0	0	0	f	f
9857	191	18	6.00	0	0	0	0	0	0	f	f
9858	175	18	6.00	0	0	0	0	0	0	f	f
9859	161	18	6.00	0	0	0	0	0	0	t	f
9860	174	18	6.50	0	0	0	0	0	0	f	f
9861	162	18	6.00	0	0	0	0	0	0	f	f
9862	274	18	6.00	0	0	0	0	0	0	f	f
9863	392	18	6.00	0	0	0	0	0	0	f	f
9864	376	18	6.50	0	0	0	0	0	0	f	f
9865	297	18	6.00	0	0	0	0	0	0	f	f
9866	396	18	5.50	0	0	0	0	0	0	f	f
9867	460	18	7.00	1	0	0	0	0	0	f	f
9868	505	18	5.50	0	0	0	0	0	0	f	f
9869	18	18	5.00	0	1	0	0	0	0	f	f
9870	74	18	6.00	0	0	0	0	0	0	f	f
9871	98	18	5.50	0	0	0	0	0	0	f	f
9872	92	18	6.50	0	0	0	0	0	0	f	f
9873	192	18	6.00	0	0	0	0	0	0	f	f
9874	135	18	6.00	0	0	0	0	0	0	f	f
9875	214	18	6.00	0	0	0	0	0	0	f	f
9876	298	18	6.50	0	0	0	0	0	0	f	f
9877	305	18	6.00	0	0	0	0	0	0	t	f
9878	342	18	6.00	0	0	0	0	0	0	f	f
9879	318	18	6.00	0	0	0	0	0	0	f	f
9880	508	18	7.00	1	0	0	0	0	0	f	f
9881	500	18	6.00	0	0	0	0	0	0	f	f
9882	490	18	6.00	0	0	0	0	0	0	f	f
9883	507	18	5.50	0	0	0	0	0	0	f	f
9884	13	18	6.00	0	1	0	0	0	0	f	f
9885	66	18	6.50	0	0	0	0	0	1	f	f
9886	67	18	6.00	0	0	0	0	0	0	t	f
9887	104	18	6.50	0	0	0	0	0	0	f	f
9888	81	18	6.00	0	0	0	0	0	0	f	f
9889	137	18	6.00	0	0	0	0	0	0	f	f
9890	300	18	7.00	1	0	0	0	0	0	f	f
9891	270	18	6.00	0	0	0	0	0	0	t	f
9892	262	18	6.50	0	0	0	0	0	1	t	f
9893	351	18	6.00	0	0	0	0	0	0	f	f
9894	350	18	6.00	0	0	0	0	0	0	f	f
9895	299	18	6.00	0	0	0	0	0	0	f	f
9896	444	18	7.00	1	0	0	0	0	1	f	f
9897	445	18	7.00	1	0	0	0	0	0	f	f
9898	475	18	6.00	0	0	0	0	0	0	f	f
9899	7	18	6.00	0	1	0	0	0	0	f	f
9900	87	18	5.50	0	0	0	0	0	0	f	f
9901	88	18	5.50	0	0	0	0	0	0	f	f
9902	99	18	5.00	0	0	0	0	0	0	f	f
9903	108	18	6.00	0	0	0	0	0	0	f	f
9904	307	18	6.50	0	0	0	0	0	0	f	f
9905	306	18	6.00	0	0	0	0	0	0	f	f
9906	332	18	7.00	1	0	0	0	0	0	f	f
9907	291	18	6.00	0	0	0	0	0	0	f	f
9908	353	18	5.50	0	0	0	0	0	0	f	f
9909	322	18	6.00	0	0	0	0	0	0	f	f
9910	410	18	6.00	0	0	0	0	0	0	f	f
9911	278	18	5.50	0	0	0	0	0	0	f	f
9912	480	18	4.50	0	0	0	1	0	0	f	f
9913	477	18	5.00	0	0	0	0	0	0	f	f
9914	446	18	7.00	0	0	0	0	0	0	f	f
9915	3	18	6.00	0	2	0	0	0	0	f	f
9916	126	18	6.00	0	0	0	0	0	0	f	f
9917	110	18	4.00	0	0	0	0	0	0	f	t
9918	195	18	5.50	0	0	0	0	0	0	f	f
9919	144	18	5.00	0	0	0	0	0	0	f	f
9920	125	18	5.50	0	0	0	0	0	0	f	f
9921	301	18	5.00	0	0	0	0	0	0	t	f
9922	267	18	5.50	0	0	0	0	0	0	t	f
9923	292	18	6.00	0	0	0	0	0	0	f	f
9924	284	18	5.50	0	0	0	0	0	0	f	f
9925	417	18	6.00	0	0	0	0	0	0	f	f
9926	285	18	5.50	0	0	0	0	0	0	f	f
9927	516	18	6.00	0	0	0	0	0	0	f	f
9928	491	18	5.50	0	0	0	0	0	0	f	f
9929	492	18	4.50	0	0	0	0	0	0	f	t
9930	8	18	8.00	0	1	1	0	0	0	t	f
9931	127	18	6.00	0	0	0	0	0	0	f	f
9932	164	18	7.00	0	0	0	0	0	0	f	f
9933	89	18	5.50	0	0	0	0	0	0	f	f
9934	146	18	5.50	0	0	0	0	0	0	t	f
9935	238	18	5.00	0	0	0	0	0	0	f	f
9936	219	18	6.00	0	0	0	0	0	0	f	f
9937	402	18	5.50	0	0	0	0	0	0	t	f
9938	419	18	6.00	0	0	0	0	0	0	f	f
9939	354	18	5.50	0	0	0	0	0	0	f	f
9940	401	18	5.00	0	0	0	0	0	0	f	f
9941	333	18	5.50	0	0	0	0	0	0	f	f
9942	501	18	7.00	1	0	0	0	0	0	f	f
9943	509	18	5.00	0	0	0	0	0	0	f	f
9944	513	18	6.00	0	0	0	0	0	0	f	f
9945	1	18	6.00	0	0	0	0	0	0	f	f
9946	111	18	6.00	0	0	0	0	0	0	f	f
9947	139	18	6.00	0	0	0	0	0	0	f	f
9948	177	18	5.50	0	0	0	0	0	0	f	f
9949	193	18	6.50	0	0	0	0	0	0	f	f
9950	90	18	6.50	0	0	0	0	0	0	f	f
9951	273	18	6.50	0	0	0	0	0	1	f	f
9952	260	18	6.00	0	0	0	0	0	0	f	f
9953	268	18	7.00	0	0	0	0	0	0	f	f
9954	302	18	6.00	0	0	0	0	0	0	f	f
9955	313	18	6.00	0	0	0	0	0	0	f	f
9956	271	18	6.00	0	0	0	0	0	0	t	f
9957	294	18	6.00	0	0	0	0	0	0	f	f
9958	447	18	7.00	1	0	0	0	0	0	f	f
9959	4	18	6.00	0	0	0	0	0	0	f	f
9960	196	18	6.50	0	0	0	0	0	0	f	f
9961	71	18	7.00	1	0	0	0	0	0	f	f
9962	83	18	6.00	0	0	0	0	0	0	f	f
9963	113	18	6.50	0	0	0	0	0	0	f	f
9964	140	18	7.50	1	0	0	0	0	0	t	f
9965	201	18	6.00	0	0	0	0	0	0	f	f
9966	240	18	5.00	0	0	0	0	0	0	f	t
9967	319	18	7.50	0	0	0	0	0	2	f	f
9968	356	18	7.00	0	0	0	0	0	0	f	f
9969	360	18	5.50	0	0	0	0	0	0	f	f
9970	265	18	6.50	0	0	0	0	0	0	f	f
9971	279	18	6.50	0	0	0	0	0	0	f	f
9972	450	18	6.00	0	0	0	0	0	0	f	f
9973	483	18	6.00	0	0	0	0	0	0	f	f
9974	532	18	6.00	0	0	0	0	0	0	f	f
9975	23	18	5.50	0	1	0	0	0	0	f	f
9976	147	18	5.00	0	0	0	0	0	0	f	f
9977	116	18	6.00	0	0	0	0	0	0	f	f
9978	114	18	6.00	0	0	0	0	0	0	t	f
9979	115	18	6.00	0	0	0	0	0	0	f	f
9980	143	18	6.00	0	0	0	0	0	0	f	f
9981	403	18	6.00	0	0	0	0	0	0	f	f
9982	372	18	6.00	0	0	0	0	0	0	f	f
9983	280	18	6.50	0	0	0	0	0	0	f	f
9984	365	18	7.00	0	0	0	0	0	0	f	f
9985	367	18	6.00	0	0	0	0	0	0	f	f
9986	359	18	5.50	0	0	0	0	0	0	f	f
9987	523	18	6.00	0	0	0	0	0	0	f	f
9988	456	18	7.00	1	0	0	0	0	0	f	f
9989	14	18	6.50	0	1	0	0	0	0	f	f
9990	185	18	5.50	0	0	0	0	0	0	f	f
9991	148	18	6.00	0	0	0	0	0	0	f	f
9992	166	18	5.50	0	0	0	0	0	0	t	f
9993	186	18	5.50	0	0	0	0	0	0	f	f
9994	165	18	6.00	0	0	0	0	0	0	t	f
9995	129	18	6.50	0	0	0	0	0	0	f	f
9996	344	18	7.00	1	0	0	0	0	0	t	f
9997	373	18	6.00	0	0	0	0	0	0	f	f
9998	382	18	5.50	0	0	0	0	0	0	f	f
9999	320	18	6.00	0	0	0	0	0	0	f	f
10000	433	18	5.50	0	0	0	0	0	0	f	f
10001	383	18	6.00	0	0	0	0	0	0	f	f
10002	472	18	6.00	0	0	0	0	0	0	f	f
10003	487	18	5.50	0	0	0	0	0	0	f	f
10004	517	18	5.50	0	0	0	0	0	0	f	f
10005	2	18	5.00	0	1	0	0	0	0	f	f
10006	100	18	6.00	0	0	0	0	0	0	t	f
10007	76	18	5.50	0	0	0	0	0	0	f	f
10008	84	18	5.50	0	0	0	0	0	0	t	f
10009	202	18	6.00	0	0	0	0	0	0	f	f
10010	167	18	5.50	0	0	0	0	0	0	f	f
10011	72	18	6.00	0	0	0	0	0	0	f	f
10012	227	18	5.50	0	0	0	0	0	0	f	f
10013	295	18	5.50	0	0	0	0	0	0	f	f
10014	369	18	5.50	0	0	0	0	0	0	f	f
10015	281	18	5.50	0	0	0	0	0	0	f	f
10016	420	18	6.00	0	0	0	0	0	0	f	f
10017	481	18	5.00	0	0	0	0	0	0	f	f
10018	448	18	5.50	0	0	0	0	0	0	f	f
10019	484	18	5.00	0	0	0	0	0	0	f	f
10020	471	18	5.50	0	0	0	0	0	0	f	f
10021	15	18	6.00	0	1	0	0	0	0	f	f
10022	142	18	6.50	0	0	0	0	0	1	t	f
10023	150	18	6.50	0	0	0	0	0	0	f	f
10024	118	18	5.50	0	0	0	0	0	0	f	f
10025	199	18	6.00	0	0	0	0	0	0	f	f
10026	149	18	6.00	0	0	0	0	0	0	f	f
10027	315	18	5.50	0	0	0	0	0	0	t	f
10028	314	18	7.00	1	0	0	0	0	0	f	f
10029	422	18	6.00	0	0	0	0	0	0	f	f
10030	287	18	6.00	0	0	0	0	0	0	f	f
10031	308	18	5.50	0	0	0	0	0	0	f	f
10032	527	18	6.00	0	0	0	0	0	0	f	f
10033	467	18	5.00	0	0	0	0	0	0	f	f
10034	453	18	6.00	0	0	0	0	0	0	f	f
10035	518	18	6.00	0	0	0	0	0	0	f	f
10036	537	18	6.00	0	0	0	0	0	0	f	f
10037	22	18	6.00	0	0	0	0	0	0	t	f
10038	152	18	6.50	0	0	0	0	0	0	f	f
10039	91	18	7.50	0	0	0	0	0	0	f	f
10040	151	18	7.00	0	0	0	0	0	1	f	f
10041	77	18	7.00	0	0	0	0	0	0	f	f
10042	249	18	6.00	0	0	0	0	0	0	f	f
10043	370	18	6.50	0	0	0	0	0	0	f	f
10044	288	18	6.50	0	0	0	0	0	0	f	f
10045	358	18	7.00	1	0	0	0	0	0	f	f
10046	439	18	6.00	0	0	0	0	0	0	f	f
10047	386	18	6.00	0	0	0	0	0	0	f	f
10048	496	18	6.00	0	0	0	0	0	0	f	f
10049	466	18	7.00	1	0	0	0	0	0	f	f
10050	468	18	6.00	0	0	0	0	0	0	f	f
10051	539	18	7.00	1	0	0	0	0	1	f	f
10052	528	18	6.00	0	0	0	0	0	0	t	f
10053	57	18	6.00	0	1	0	0	0	0	f	f
10054	78	18	5.50	0	0	0	0	0	0	t	f
10055	128	18	6.00	0	0	0	0	0	0	f	f
10056	154	18	5.50	0	0	0	0	0	0	t	f
10057	153	18	5.00	0	0	0	0	0	0	f	f
10058	180	18	6.00	0	0	0	0	0	0	t	f
10059	131	18	6.50	0	0	0	0	0	0	f	f
10060	101	18	6.00	0	0	0	0	0	0	f	f
10061	272	18	6.00	0	0	0	0	0	0	f	f
10062	321	18	6.00	0	0	0	0	0	0	f	f
10063	326	18	5.50	0	0	0	0	0	0	f	f
10064	328	18	5.00	0	0	0	0	0	0	f	f
10065	437	18	6.00	0	0	0	0	0	0	f	f
10066	452	18	5.50	0	0	0	0	0	0	f	f
10067	524	18	6.00	0	0	0	0	0	0	f	f
10068	542	18	6.00	0	0	0	0	0	0	f	f
10069	12	18	6.00	0	3	0	0	0	0	f	f
10070	183	18	5.00	0	0	0	0	0	0	f	f
10071	181	18	5.00	0	0	0	0	0	0	f	f
10072	254	18	5.00	0	0	0	0	0	0	f	f
10073	169	18	5.00	0	0	0	0	0	0	f	f
10074	170	18	5.50	0	0	0	0	0	0	f	f
10075	345	18	5.50	0	0	0	0	0	0	f	f
10076	435	18	6.00	0	0	0	0	0	0	f	f
10077	409	18	5.50	0	0	0	0	0	0	f	f
10078	309	18	6.00	0	0	0	0	0	0	f	f
10079	391	18	6.50	0	0	0	0	0	0	f	f
10080	327	18	5.00	0	0	0	0	0	0	f	f
10081	521	18	5.50	0	0	0	0	0	0	f	f
10082	473	18	6.00	0	0	0	0	0	0	f	f
10083	503	18	5.00	0	0	0	0	0	0	f	f
10084	469	18	6.00	0	0	0	0	0	0	f	f
10085	46	18	\N	0	0	0	0	0	0	f	f
10086	35	18	\N	0	0	0	0	0	0	f	f
10087	37	18	\N	0	0	0	0	0	0	f	f
10088	24	18	\N	0	0	0	0	0	0	f	f
10089	29	18	\N	0	0	0	0	0	0	f	f
10090	16	18	\N	0	0	0	0	0	0	f	f
10091	51	18	\N	0	0	0	0	0	0	f	f
10092	36	18	\N	0	0	0	0	0	0	f	f
10093	54	18	\N	0	0	0	0	0	0	f	f
10094	47	18	\N	0	0	0	0	0	0	f	f
10095	21	18	\N	0	0	0	0	0	0	f	f
10096	19	18	\N	0	0	0	0	0	0	f	f
10097	27	18	\N	0	0	0	0	0	0	f	f
10098	40	18	\N	0	0	0	0	0	0	f	f
10099	42	18	\N	0	0	0	0	0	0	f	f
10100	52	18	\N	0	0	0	0	0	0	f	f
10101	33	18	\N	0	0	0	0	0	0	f	f
10102	93	18	\N	0	0	0	0	0	0	f	f
10103	28	18	\N	0	0	0	0	0	0	f	f
10104	85	18	\N	0	0	0	0	0	0	f	f
10105	61	18	\N	0	0	0	0	0	0	f	f
10106	26	18	\N	0	0	0	0	0	0	f	f
10107	56	18	\N	0	0	0	0	0	0	f	f
10108	58	18	\N	0	0	0	0	0	0	f	f
10109	62	18	\N	0	0	0	0	0	0	f	f
10110	65	18	\N	0	0	0	0	0	0	f	f
10111	30	18	\N	0	0	0	0	0	0	f	f
10112	45	18	\N	0	0	0	0	0	0	f	f
10113	205	18	\N	0	0	0	0	0	0	f	f
10114	130	18	\N	0	0	0	0	0	0	f	f
10115	119	18	\N	0	0	0	0	0	0	f	f
10116	176	18	\N	0	0	0	0	0	0	f	f
10117	145	18	\N	0	0	0	0	0	0	f	f
10118	184	18	\N	0	0	0	0	0	0	f	f
10119	112	18	\N	0	0	0	0	0	0	f	f
10120	197	18	\N	0	0	0	0	0	0	f	f
10121	138	18	\N	0	0	0	0	0	0	f	f
10122	141	18	\N	0	0	0	0	0	0	f	f
10123	208	18	\N	0	0	0	0	0	0	f	f
10124	168	18	\N	0	0	0	0	0	0	f	f
10125	155	18	\N	0	0	0	0	0	0	f	f
10126	182	18	\N	0	0	0	0	0	0	f	f
10127	218	18	\N	0	0	0	0	0	0	f	f
10128	220	18	\N	0	0	0	0	0	0	f	f
10129	224	18	\N	0	0	0	0	0	0	f	f
10130	286	18	\N	0	0	0	0	0	0	f	f
10131	235	18	\N	0	0	0	0	0	0	f	f
10132	310	18	\N	0	0	0	0	0	0	f	f
10133	232	18	\N	0	0	0	0	0	0	f	f
10134	226	18	\N	0	0	0	0	0	0	f	f
10135	248	18	\N	0	0	0	0	0	0	f	f
10136	241	18	\N	0	0	0	0	0	0	f	f
10137	255	18	\N	0	0	0	0	0	0	f	f
10138	221	18	\N	0	0	0	0	0	0	f	f
10139	230	18	\N	0	0	0	0	0	0	f	f
10140	244	18	\N	0	0	0	0	0	0	f	f
10141	245	18	\N	0	0	0	0	0	0	f	f
10142	210	18	\N	0	0	0	0	0	0	f	f
10143	264	18	\N	0	0	0	0	0	0	f	f
10144	250	18	\N	0	0	0	0	0	0	f	f
10145	223	18	\N	0	0	0	0	0	0	f	f
10146	215	18	\N	0	0	0	0	0	0	f	f
10147	216	18	\N	0	0	0	0	0	0	f	f
10148	296	18	\N	0	0	0	0	0	0	f	f
10149	228	18	\N	0	0	0	0	0	0	f	f
10150	222	18	\N	0	0	0	0	0	0	f	f
10151	253	18	\N	0	0	0	0	0	0	f	f
10152	225	18	\N	0	0	0	0	0	0	f	f
10153	233	18	\N	0	0	0	0	0	0	f	f
10154	418	18	\N	0	0	0	0	0	0	f	f
10155	405	18	\N	0	0	0	0	0	0	f	f
10156	404	18	\N	0	0	0	0	0	0	f	f
10157	337	18	\N	0	0	0	0	0	0	f	f
10158	390	18	\N	0	0	0	0	0	0	f	f
10159	406	18	\N	0	0	0	0	0	0	f	f
10160	414	18	\N	0	0	0	0	0	0	f	f
10161	378	18	\N	0	0	0	0	0	0	f	f
10162	380	18	\N	0	0	0	0	0	0	f	f
10163	385	18	\N	0	0	0	0	0	0	f	f
10164	412	18	\N	0	0	0	0	0	0	f	f
10165	347	18	\N	0	0	0	0	0	0	f	f
10166	371	18	\N	0	0	0	0	0	0	f	f
10167	379	18	\N	0	0	0	0	0	0	f	f
10168	349	18	\N	0	0	0	0	0	0	f	f
10169	397	18	\N	0	0	0	0	0	0	f	f
10170	400	18	\N	0	0	0	0	0	0	f	f
10171	384	18	\N	0	0	0	0	0	0	f	f
10172	357	18	\N	0	0	0	0	0	0	f	f
10173	339	18	\N	0	0	0	0	0	0	f	f
10174	341	18	\N	0	0	0	0	0	0	f	f
10175	416	18	\N	0	0	0	0	0	0	f	f
10176	366	18	\N	0	0	0	0	0	0	f	f
10177	399	18	\N	0	0	0	0	0	0	f	f
10178	411	18	\N	0	0	0	0	0	0	f	f
10179	237	18	\N	0	0	0	0	0	0	f	f
10180	431	18	\N	0	0	0	0	0	0	f	f
10181	429	18	\N	0	0	0	0	0	0	f	f
10182	522	18	\N	0	0	0	0	0	0	f	f
10183	502	18	\N	0	0	0	0	0	0	f	f
10184	479	18	\N	0	0	0	0	0	0	f	f
10185	455	18	\N	0	0	0	0	0	0	f	f
10186	495	18	\N	0	0	0	0	0	0	f	f
10187	449	18	\N	0	0	0	0	0	0	f	f
10188	486	18	\N	0	0	0	0	0	0	f	f
10189	485	18	\N	0	0	0	0	0	0	f	f
10190	428	18	\N	0	0	0	0	0	0	f	f
10191	438	18	\N	0	0	0	0	0	0	f	f
10192	520	18	\N	0	0	0	0	0	0	f	f
10193	441	18	\N	0	0	0	0	0	0	f	f
10194	510	18	\N	0	0	0	0	0	0	f	f
10195	525	18	\N	0	0	0	0	0	0	f	f
10196	497	18	\N	0	0	0	0	0	0	f	f
10197	425	18	\N	0	0	0	0	0	0	f	f
10198	426	18	\N	0	0	0	0	0	0	f	f
10199	430	18	\N	0	0	0	0	0	0	f	f
10200	462	18	\N	0	0	0	0	0	0	f	f
10201	427	18	\N	0	0	0	0	0	0	f	f
10202	489	18	\N	0	0	0	0	0	0	f	f
10203	504	18	\N	0	0	0	0	0	0	f	f
10204	515	18	\N	0	0	0	0	0	0	f	f
10205	434	18	\N	0	0	0	0	0	0	f	f
10206	474	18	\N	0	0	0	0	0	0	f	f
10207	531	18	\N	0	0	0	0	0	0	f	f
10208	530	18	\N	0	0	0	0	0	0	f	f
10209	540	18	\N	0	0	0	0	0	0	f	f
10210	541	18	\N	0	0	0	0	0	0	f	f
10211	43	18	\N	0	0	0	0	0	0	f	f
10212	44	18	\N	0	0	0	0	0	0	f	f
10213	236	18	\N	0	0	0	0	0	0	f	f
10214	217	18	\N	0	0	0	0	0	0	f	f
10215	363	18	\N	0	0	0	0	0	0	f	f
10216	362	18	\N	0	0	0	0	0	0	f	f
10217	494	18	\N	0	0	0	0	0	0	f	f
10218	229	18	\N	0	0	0	0	0	0	f	f
10219	55	18	\N	0	0	0	0	0	0	f	f
10220	206	18	\N	0	0	0	0	0	0	f	f
10221	247	18	\N	0	0	0	0	0	0	f	f
10222	421	18	\N	0	0	0	0	0	0	f	f
10223	246	18	\N	0	0	0	0	0	0	f	f
10224	303	18	\N	0	0	0	0	0	0	f	f
10225	389	18	\N	0	0	0	0	0	0	f	f
10226	538	18	\N	0	0	0	0	0	0	f	f
10227	48	18	\N	0	0	0	0	0	0	f	f
10228	258	18	\N	0	0	0	0	0	0	f	f
10229	68	18	\N	0	0	0	0	0	0	f	f
10230	388	18	\N	0	0	0	0	0	0	f	f
10231	34	18	\N	0	0	0	0	0	0	f	f
10232	97	18	\N	0	0	0	0	0	0	f	f
10233	289	18	\N	0	0	0	0	0	0	f	f
10234	330	18	\N	0	0	0	0	0	0	f	f
10235	498	18	\N	0	0	0	0	0	0	f	f
10236	543	18	\N	0	0	0	0	0	0	f	f
10237	49	18	\N	0	0	0	0	0	0	f	f
10238	239	18	\N	0	0	0	0	0	0	f	f
10239	178	18	\N	0	0	0	0	0	0	f	f
10240	266	18	\N	0	0	0	0	0	0	f	f
10241	334	18	\N	0	0	0	0	0	0	f	f
10242	476	18	\N	0	0	0	0	0	0	f	f
10243	60	18	\N	0	0	0	0	0	0	f	f
10244	198	18	\N	0	0	0	0	0	0	f	f
10245	282	18	\N	0	0	0	0	0	0	f	f
10246	423	18	\N	0	0	0	0	0	0	f	f
10247	39	18	\N	0	0	0	0	0	0	f	f
10248	59	18	\N	0	0	0	0	0	0	f	f
10249	440	18	\N	0	0	0	0	0	0	f	f
10250	398	18	\N	0	0	0	0	0	0	f	f
10251	442	18	\N	0	0	0	0	0	0	f	f
10252	25	18	\N	0	0	0	0	0	0	f	f
10253	109	18	\N	0	0	0	0	0	0	f	f
10254	194	18	\N	0	0	0	0	0	0	f	f
10255	234	18	\N	0	0	0	0	0	0	f	f
10256	535	18	\N	0	0	0	0	0	0	f	f
10257	461	18	\N	0	0	0	0	0	0	f	f
10258	53	18	\N	0	0	0	0	0	0	f	f
10259	251	18	\N	0	0	0	0	0	0	f	f
10260	275	18	\N	0	0	0	0	0	0	f	f
10261	335	18	\N	0	0	0	0	0	0	f	f
10262	32	18	\N	0	0	0	0	0	0	f	f
10263	94	18	\N	0	0	0	0	0	0	f	f
10264	276	18	\N	0	0	0	0	0	0	f	f
10265	9	18	\N	0	0	0	0	0	0	f	f
10266	374	18	\N	0	0	0	0	0	0	f	f
10267	482	18	\N	0	0	0	0	0	0	f	f
10268	519	18	\N	0	0	0	0	0	0	f	f
10269	38	18	\N	0	0	0	0	0	0	f	f
10270	256	18	\N	0	0	0	0	0	0	f	f
10271	190	18	\N	0	0	0	0	0	0	f	f
10272	213	18	\N	0	0	0	0	0	0	f	f
10273	377	18	\N	0	0	0	0	0	0	f	f
10274	415	18	\N	0	0	0	0	0	0	f	f
10275	179	18	\N	0	0	0	0	0	0	f	f
10276	203	18	\N	0	0	0	0	0	0	f	f
10277	407	18	\N	0	0	0	0	0	0	f	f
10278	387	18	\N	0	0	0	0	0	0	f	f
10279	488	18	\N	0	0	0	0	0	0	f	f
10280	79	18	\N	0	0	0	0	0	0	f	f
10281	252	18	\N	0	0	0	0	0	0	f	f
10282	413	18	\N	0	0	0	0	0	0	f	f
10283	408	18	\N	0	0	0	0	0	0	f	f
10284	424	18	\N	0	0	0	0	0	0	f	f
10285	41	18	\N	0	0	0	0	0	0	f	f
10286	136	18	\N	0	0	0	0	0	0	f	f
10287	82	18	\N	0	0	0	0	0	0	f	f
10288	259	18	\N	0	0	0	0	0	0	f	f
10289	163	18	\N	0	0	0	0	0	0	f	f
10290	352	18	\N	0	0	0	0	0	0	f	f
10291	257	18	\N	0	0	0	0	0	0	f	f
10292	293	18	\N	0	0	0	0	0	0	f	f
10293	432	18	\N	0	0	0	0	0	0	f	f
10294	381	18	\N	0	0	0	0	0	0	f	f
10295	64	18	\N	0	0	0	0	0	0	f	f
10296	188	18	\N	0	0	0	0	0	0	f	f
10297	134	18	\N	0	0	0	0	0	0	f	f
10298	212	18	\N	0	0	0	0	0	0	f	f
10299	160	18	\N	0	0	0	0	0	0	f	f
10300	395	18	\N	0	0	0	0	0	0	f	f
10301	526	18	\N	0	0	0	0	0	0	f	f
10302	393	18	\N	0	0	0	0	0	0	f	f
10303	50	18	\N	0	0	0	0	0	0	f	f
10304	443	18	\N	0	0	0	0	0	0	f	f
10305	493	18	\N	0	0	0	0	0	0	f	f
10306	31	18	\N	0	0	0	0	0	0	f	f
10307	243	18	\N	0	0	0	0	0	0	f	f
10308	242	18	\N	0	0	0	0	0	0	f	f
10309	324	18	\N	0	0	0	0	0	0	f	f
10310	102	18	\N	0	0	0	0	0	0	f	f
10311	368	18	\N	0	0	0	0	0	0	f	f
10312	536	18	\N	0	0	0	0	0	0	f	f
10313	63	18	\N	0	0	0	0	0	0	f	f
10314	231	18	\N	0	0	0	0	0	0	f	f
10315	331	18	\N	0	0	0	0	0	0	f	f
10316	506	18	\N	0	0	0	0	0	0	f	f
10317	512	18	\N	0	0	0	0	0	0	f	f
10318	5	19	6.50	0	0	0	0	0	0	f	f
10319	120	19	6.00	0	0	0	0	0	0	f	f
10320	156	19	7.00	0	0	0	0	0	0	f	f
10321	132	19	6.50	0	0	0	0	0	0	f	f
10322	157	19	6.00	0	0	0	0	0	0	f	f
10323	158	19	6.50	0	0	0	0	0	0	f	f
10324	200	19	6.50	0	0	0	0	0	0	f	f
10325	338	19	6.50	0	0	0	0	0	1	f	f
10326	339	19	6.00	0	0	0	0	0	0	f	f
10327	276	19	6.00	0	0	0	0	0	0	f	f
10328	364	19	6.00	0	0	0	0	0	0	f	f
10329	312	19	6.50	0	0	0	0	0	0	f	f
10330	329	19	6.50	0	0	0	0	0	0	f	f
10331	482	19	6.00	0	0	0	0	0	0	f	f
10332	459	19	7.50	0	0	0	0	0	1	f	f
10333	465	19	7.50	2	0	0	0	0	0	f	f
10334	20	19	6.00	0	2	0	0	0	0	f	f
10335	123	19	5.50	0	0	0	0	0	0	f	f
10336	85	19	6.00	0	0	0	0	0	0	f	f
10337	187	19	5.00	0	0	0	0	0	0	f	f
10338	103	19	5.00	0	0	0	0	0	0	f	f
10339	340	19	5.50	0	0	0	0	0	0	f	f
10340	263	19	5.00	0	0	0	0	0	0	f	f
10341	346	19	5.50	0	0	0	0	0	0	f	f
10342	323	19	6.00	0	0	0	0	0	0	f	f
10343	374	19	5.50	0	0	0	0	0	0	f	f
10344	336	19	6.00	0	0	0	0	0	0	f	f
10345	504	19	5.50	0	0	0	0	0	0	f	f
10346	458	19	6.00	0	0	0	0	0	0	f	f
10347	451	19	5.50	0	0	0	0	0	0	f	f
10348	489	19	4.50	0	0	0	0	0	0	f	f
10349	519	19	6.00	0	0	0	0	0	0	f	f
10350	10	19	5.50	0	2	0	0	0	0	f	f
10351	96	19	5.00	0	0	0	0	0	0	t	f
10352	97	19	4.50	0	0	0	0	0	0	f	f
10353	133	19	5.50	0	0	0	0	0	0	f	f
10354	159	19	6.00	0	0	0	0	0	0	f	f
10355	69	19	6.50	0	0	0	0	0	0	f	f
10356	204	19	4.50	0	0	0	0	0	0	f	f
10357	436	19	6.50	0	0	0	0	0	1	f	f
10358	304	19	5.50	0	0	0	0	0	0	f	f
10359	361	19	6.50	1	0	0	0	0	0	f	f
10360	348	19	5.50	0	0	0	0	0	0	f	f
10361	470	19	6.00	0	0	0	0	0	0	f	f
10362	520	19	6.00	0	0	0	0	0	0	f	f
10363	478	19	6.50	0	0	0	0	0	1	t	f
10364	529	19	6.50	0	0	0	0	0	0	f	f
10365	6	19	7.00	0	0	1	0	0	0	f	f
10366	86	19	6.50	0	0	0	0	0	0	f	f
10367	95	19	6.00	0	0	0	0	0	0	f	f
10368	105	19	6.00	0	0	0	0	0	0	f	f
10369	117	19	6.50	0	0	0	0	0	0	t	f
10370	80	19	6.00	0	0	0	0	0	0	f	f
10371	189	19	6.50	0	0	0	0	0	0	f	f
10372	414	19	6.00	0	0	0	0	0	0	f	f
10373	316	19	6.00	0	0	0	0	0	1	f	f
10374	317	19	5.50	0	0	0	0	0	0	t	f
10375	290	19	7.00	1	0	0	0	0	0	f	f
10376	261	19	6.00	0	0	0	0	0	0	f	f
10377	331	19	6.00	0	0	0	0	0	0	f	f
10378	463	19	7.50	1	0	0	0	0	0	f	f
10379	514	19	6.00	0	0	0	0	0	0	f	f
10380	499	19	6.50	0	0	0	0	0	1	f	f
10381	11	19	7.00	0	2	0	0	0	0	f	f
10382	134	19	5.50	0	0	0	0	0	0	f	f
10383	173	19	6.00	0	0	0	0	0	0	f	f
10384	75	19	6.00	0	0	0	0	0	0	f	f
10385	70	19	5.50	0	0	0	0	0	0	f	f
10386	106	19	5.50	0	0	0	0	0	0	f	f
10387	160	19	5.00	0	0	0	0	0	0	f	f
10388	375	19	6.00	0	0	0	0	0	0	f	f
10389	355	19	6.00	0	0	0	0	0	0	t	f
10390	343	19	6.00	0	0	0	0	0	0	f	f
10391	325	19	5.50	0	0	0	0	0	0	f	f
10392	283	19	5.50	0	0	0	0	0	0	f	f
10393	511	19	6.00	0	0	0	0	0	0	f	f
10394	464	19	7.00	0	0	0	0	0	1	t	f
10395	457	19	7.50	1	0	0	0	0	0	f	f
10396	526	19	7.00	1	0	0	0	0	0	f	f
10397	17	19	7.00	0	2	0	0	0	0	f	f
10398	107	19	7.00	1	0	0	0	0	0	t	f
10399	124	19	6.00	0	0	0	0	0	0	f	f
10400	190	19	6.00	0	0	0	0	0	0	f	f
10401	191	19	6.50	0	0	0	0	0	0	t	f
10402	175	19	5.00	0	0	0	0	0	0	t	f
10403	161	19	6.00	0	0	0	0	0	0	f	f
10404	174	19	4.00	0	0	0	0	0	0	f	f
10405	274	19	6.50	0	0	0	0	0	0	f	f
10406	392	19	6.00	0	0	0	0	0	0	t	f
10407	376	19	7.50	0	0	0	0	0	1	t	f
10408	297	19	7.00	0	0	0	0	0	0	f	f
10409	396	19	5.50	0	0	0	0	0	0	f	f
10410	460	19	5.50	0	0	0	0	0	0	f	f
10411	505	19	6.00	0	0	0	0	0	0	f	f
10412	18	19	7.00	0	1	0	0	0	0	t	f
10413	74	19	6.00	0	0	0	0	0	0	f	f
10414	98	19	6.50	0	0	0	0	0	0	f	f
10415	92	19	6.50	0	0	0	0	0	0	f	f
10416	192	19	6.50	0	0	0	0	0	0	f	f
10417	135	19	6.00	0	0	0	0	0	0	f	f
10418	214	19	6.00	0	0	0	0	0	0	f	f
10419	298	19	6.00	0	0	0	0	0	0	f	f
10420	305	19	6.50	0	0	0	0	0	1	f	f
10421	342	19	6.00	0	0	0	0	0	0	f	f
10422	318	19	6.00	0	0	0	0	0	0	f	f
10423	349	19	6.00	0	0	0	0	0	0	f	f
10424	398	19	4.50	0	0	0	1	0	0	f	f
10425	508	19	7.00	1	0	0	0	0	0	f	f
10426	490	19	6.50	0	0	0	0	0	0	f	f
10427	507	19	6.50	0	0	0	0	0	0	f	f
10428	13	19	6.00	0	0	0	0	0	0	f	f
10429	66	19	7.50	1	0	0	0	0	0	f	f
10430	136	19	6.00	0	0	0	0	0	0	f	f
10431	104	19	7.00	0	0	0	0	0	0	f	f
10432	81	19	6.50	0	0	0	0	0	0	t	f
10433	137	19	7.00	0	0	0	0	0	0	f	f
10434	300	19	6.00	0	0	0	0	0	0	f	f
10435	270	19	6.50	0	0	0	0	0	1	f	f
10436	262	19	6.50	0	0	0	0	0	0	t	f
10437	351	19	6.00	0	0	0	0	0	0	f	f
10438	350	19	6.00	0	0	0	0	0	0	f	f
10439	299	19	5.50	0	0	0	0	0	0	f	f
10440	444	19	5.50	0	0	0	0	0	0	f	f
10441	445	19	7.00	1	0	0	0	0	0	t	f
10442	474	19	6.00	0	0	0	0	0	0	f	f
10443	475	19	6.50	0	0	0	0	0	0	f	f
10444	7	19	6.00	0	0	0	0	0	0	f	f
10445	87	19	6.50	0	0	0	0	0	0	f	f
10446	88	19	6.50	0	0	0	0	0	0	f	f
10447	99	19	6.50	0	0	0	0	0	0	f	f
10448	109	19	6.00	0	0	0	0	0	0	f	f
10449	194	19	6.00	0	0	0	0	0	0	f	f
10450	307	19	7.00	0	0	0	0	0	0	f	f
10451	332	19	6.50	0	0	0	0	0	0	f	f
10452	291	19	6.50	0	0	0	0	0	0	f	f
10453	353	19	6.00	0	0	0	0	0	0	f	f
10454	322	19	6.00	0	0	0	0	0	0	f	f
10455	400	19	7.00	1	0	0	0	0	0	f	f
10456	410	19	6.00	0	0	0	0	0	0	f	f
10457	480	19	7.50	1	0	0	0	0	1	f	f
10458	477	19	6.00	0	0	0	0	0	0	f	f
10459	446	19	6.50	0	0	0	0	0	0	f	f
10460	3	19	6.00	0	2	0	0	0	0	f	f
10461	236	19	6.00	0	0	0	0	0	0	f	f
10462	126	19	6.50	0	0	0	0	0	0	f	f
10463	195	19	5.50	0	0	0	0	0	0	f	f
10464	144	19	6.00	0	0	0	0	0	0	t	f
10465	125	19	6.00	0	0	0	0	0	0	f	f
10466	362	19	6.50	0	0	0	0	0	1	f	f
10467	301	19	7.00	1	0	0	0	0	0	f	f
10468	267	19	6.00	0	0	0	0	0	0	t	f
10469	292	19	5.50	0	0	0	0	0	0	f	f
10470	284	19	6.50	0	0	0	0	0	0	f	f
10471	285	19	5.50	0	0	0	0	0	0	f	f
10472	516	19	7.00	0	0	0	0	0	0	f	f
10473	491	19	6.00	0	0	0	0	0	0	t	f
10474	8	19	6.00	0	2	0	0	0	0	f	f
10475	127	19	5.50	0	0	0	0	0	0	f	f
10476	164	19	5.00	0	0	0	0	0	0	t	f
10477	89	19	5.50	0	0	0	0	0	0	f	f
10478	146	19	5.50	0	0	0	0	0	0	f	f
10479	310	19	5.50	0	0	0	0	0	0	f	f
10480	402	19	5.50	0	0	0	0	0	0	t	f
10481	419	19	5.50	0	0	0	0	0	0	f	f
10482	354	19	5.50	0	0	0	0	0	0	f	f
10483	401	19	5.50	0	0	0	0	0	0	f	f
10484	333	19	5.00	0	0	0	0	0	0	f	f
10485	501	19	5.50	0	0	0	0	0	0	t	f
10486	509	19	5.50	0	0	0	0	0	0	f	f
10487	495	19	6.00	0	0	0	0	0	0	f	f
10488	513	19	5.50	0	0	0	0	0	0	f	f
10489	1	19	6.00	0	1	0	0	0	0	t	f
10490	111	19	5.00	0	0	0	0	0	0	t	f
10491	139	19	6.00	0	0	0	0	0	0	t	f
10492	68	19	6.00	0	0	0	0	0	0	t	f
10493	90	19	5.00	0	0	0	0	0	0	f	f
10494	184	19	6.00	0	0	0	0	0	0	f	f
10495	273	19	6.50	0	0	0	0	0	0	f	f
10496	260	19	6.00	0	0	0	0	0	0	f	f
10497	268	19	6.00	0	0	0	0	0	0	f	f
10498	302	19	6.00	0	0	0	0	0	0	f	f
10499	313	19	5.00	0	0	0	0	0	0	f	f
10500	271	19	6.00	0	0	0	0	0	0	f	f
10501	447	19	7.00	1	0	0	0	0	0	f	f
10502	4	19	6.00	0	2	0	0	0	0	f	f
10503	71	19	6.00	0	0	0	0	0	0	f	f
10504	83	19	5.00	0	0	0	0	0	0	f	f
10505	113	19	6.50	1	0	0	0	0	0	f	f
10506	140	19	6.00	0	0	0	0	0	0	f	f
10507	201	19	5.50	0	0	0	0	0	0	f	f
10508	239	19	6.50	0	0	0	0	0	1	f	f
10509	319	19	5.50	0	0	0	0	0	0	f	f
10510	356	19	6.00	0	0	0	0	0	0	f	f
10511	360	19	5.50	0	0	0	0	0	0	f	f
10512	265	19	6.50	1	0	0	0	0	0	f	f
10513	450	19	5.50	0	0	0	0	0	0	f	f
10514	510	19	5.50	0	0	0	0	0	0	f	f
10515	483	19	6.50	0	0	0	0	0	1	f	f
10516	23	19	6.00	0	2	0	0	0	0	f	f
10517	116	19	6.00	0	0	0	0	0	0	f	f
10518	114	19	5.00	0	0	0	0	0	0	f	f
10519	115	19	5.00	0	0	0	0	0	0	f	f
10520	143	19	5.50	0	0	0	0	0	0	f	f
10521	403	19	5.50	0	0	0	0	0	0	f	f
10522	372	19	5.00	0	0	0	0	0	0	f	f
10523	280	19	5.50	0	0	0	0	0	0	f	f
10524	365	19	6.00	0	0	0	0	0	0	f	f
10525	367	19	6.50	0	0	0	0	0	0	f	f
10526	404	19	6.00	0	0	0	0	0	0	f	f
10527	359	19	5.50	0	0	0	0	0	0	f	f
10528	443	19	6.00	0	0	0	0	0	0	f	f
10529	493	19	5.50	0	0	0	0	0	0	f	f
10530	523	19	5.50	0	0	0	0	0	0	f	f
10531	456	19	5.50	0	0	0	0	0	0	f	f
10532	14	19	6.00	0	3	0	0	0	0	f	f
10533	148	19	5.50	0	0	0	0	0	0	f	f
10534	165	19	5.50	0	0	0	0	0	0	f	f
10535	241	19	4.50	0	0	0	0	0	0	t	f
10536	243	19	6.00	0	0	0	0	0	0	f	f
10537	129	19	6.00	0	0	0	0	0	0	f	f
10538	344	19	6.50	0	0	0	0	0	0	f	f
10539	368	19	6.50	0	0	0	0	0	0	f	f
10540	373	19	6.00	0	0	0	0	0	0	t	f
10541	382	19	5.50	0	0	0	0	0	0	f	f
10542	320	19	5.50	0	0	0	0	0	0	f	f
10543	433	19	6.00	0	0	0	0	0	0	f	f
10544	383	19	6.00	0	0	0	0	0	0	f	f
10545	337	19	6.00	0	0	0	0	0	0	f	f
10546	472	19	4.50	0	0	0	1	0	0	f	f
10547	487	19	5.50	0	0	0	0	0	0	f	f
10548	2	19	6.00	0	0	0	0	0	0	f	f
10549	76	19	6.50	0	0	0	0	0	0	f	f
10550	202	19	6.00	0	0	0	0	0	0	f	f
10551	251	19	6.50	0	0	0	0	0	0	f	f
10552	72	19	6.00	0	0	0	0	0	0	f	f
10553	227	19	7.00	0	0	0	0	0	0	f	f
10554	295	19	6.50	0	0	0	0	0	0	t	f
10555	369	19	6.00	0	0	0	0	0	0	f	f
10556	281	19	6.00	0	0	0	0	0	0	f	f
10557	420	19	6.50	0	0	0	0	0	1	f	f
10558	481	19	6.50	0	0	0	0	0	1	f	f
10559	448	19	6.00	0	0	0	0	0	0	f	f
10560	484	19	7.00	1	0	0	0	0	0	f	f
10561	471	19	7.00	1	0	0	0	0	0	f	f
10562	15	19	6.50	0	3	0	0	0	0	f	f
10563	142	19	5.50	0	0	0	0	0	0	f	f
10564	150	19	5.00	0	0	0	0	0	0	f	f
10565	118	19	5.00	0	0	0	0	0	0	f	f
10566	244	19	6.00	0	0	0	0	0	0	f	f
10567	149	19	4.50	0	0	0	0	1	0	f	f
10568	315	19	6.00	0	0	0	0	0	0	f	f
10569	389	19	6.00	0	0	0	0	0	0	f	f
10570	314	19	6.00	0	0	0	0	0	0	f	f
10571	422	19	6.00	0	0	0	0	0	0	f	f
10572	287	19	5.00	0	0	0	0	0	0	f	f
10573	308	19	5.50	0	0	0	0	0	0	f	f
10574	385	19	5.50	0	0	0	0	0	0	f	f
10575	527	19	6.00	0	0	0	0	0	0	f	f
10576	467	19	5.00	0	0	0	0	0	0	f	f
10577	453	19	5.00	0	0	0	0	0	0	f	f
10578	22	19	5.50	0	2	0	0	0	0	f	f
10579	152	19	6.00	0	0	0	0	0	1	f	f
10580	91	19	5.00	0	0	0	0	0	0	f	f
10581	151	19	5.50	0	0	0	0	0	0	f	f
10582	77	19	6.50	0	0	0	0	0	0	t	f
10583	370	19	6.00	0	0	0	0	0	0	f	f
10584	288	19	5.00	0	0	0	0	0	0	f	f
10585	358	19	6.50	1	0	0	0	0	0	t	f
10586	439	19	5.50	0	0	0	0	0	0	f	f
10587	407	19	6.00	0	0	0	0	0	0	f	f
10588	496	19	6.00	0	0	0	0	0	0	f	f
10589	466	19	5.00	0	0	0	0	0	0	f	f
10590	488	19	6.00	0	0	0	0	0	0	f	f
10591	468	19	5.50	0	0	0	0	0	0	f	f
10592	539	19	5.50	0	0	0	0	0	0	f	f
10593	528	19	5.50	0	0	0	0	0	0	f	f
10594	19	19	6.50	0	1	0	0	0	0	f	f
10595	78	19	6.50	0	0	0	0	0	0	f	f
10596	128	19	7.00	0	0	0	0	0	1	f	f
10597	154	19	6.00	0	0	0	0	0	0	f	f
10598	153	19	6.00	0	0	0	0	0	0	f	f
10599	180	19	5.50	0	0	0	0	0	0	f	f
10600	131	19	5.50	0	0	0	0	0	0	t	f
10601	101	19	6.00	0	0	0	0	0	0	f	f
10602	272	19	7.00	1	0	0	0	0	0	f	f
10603	423	19	6.00	0	0	0	0	0	0	f	f
10604	321	19	5.50	0	0	0	0	0	0	f	f
10605	326	19	7.50	1	0	0	0	0	0	f	f
10606	282	19	6.50	0	0	0	0	0	0	f	f
10607	328	19	6.00	0	0	0	0	0	0	f	f
10608	437	19	6.50	0	0	0	0	0	0	f	f
10609	452	19	7.00	0	0	0	0	0	1	f	f
10610	12	19	5.00	0	2	0	0	0	0	f	f
10611	155	19	6.00	0	0	0	0	0	0	t	f
10612	183	19	7.00	1	0	0	0	0	0	f	f
10613	181	19	6.50	0	0	0	0	0	0	f	f
10614	182	19	5.50	0	0	0	0	0	0	f	f
10615	169	19	6.00	0	0	0	0	0	0	f	f
10616	170	19	5.50	0	0	0	0	0	0	t	f
10617	345	19	6.50	0	0	0	0	0	0	f	f
10618	408	19	6.50	0	0	0	0	0	1	f	f
10619	309	19	6.00	0	0	0	0	0	0	f	f
10620	327	19	6.50	0	0	0	0	0	0	f	f
10621	521	19	5.50	0	0	0	0	0	0	f	f
10622	473	19	7.00	0	0	0	0	0	0	t	f
10623	503	19	6.00	0	0	0	0	0	0	f	f
10624	469	19	5.50	0	0	0	0	0	0	f	f
10625	46	19	\N	0	0	0	0	0	0	f	f
10626	35	19	\N	0	0	0	0	0	0	f	f
10627	37	19	\N	0	0	0	0	0	0	f	f
10628	24	19	\N	0	0	0	0	0	0	f	f
10629	29	19	\N	0	0	0	0	0	0	f	f
10630	16	19	\N	0	0	0	0	0	0	f	f
10631	51	19	\N	0	0	0	0	0	0	f	f
10632	36	19	\N	0	0	0	0	0	0	f	f
10633	54	19	\N	0	0	0	0	0	0	f	f
10634	47	19	\N	0	0	0	0	0	0	f	f
10635	21	19	\N	0	0	0	0	0	0	f	f
10636	27	19	\N	0	0	0	0	0	0	f	f
10637	40	19	\N	0	0	0	0	0	0	f	f
10638	42	19	\N	0	0	0	0	0	0	f	f
10639	52	19	\N	0	0	0	0	0	0	f	f
10640	100	19	\N	0	0	0	0	0	0	f	f
10641	33	19	\N	0	0	0	0	0	0	f	f
10642	93	19	\N	0	0	0	0	0	0	f	f
10643	28	19	\N	0	0	0	0	0	0	f	f
10644	61	19	\N	0	0	0	0	0	0	f	f
10645	26	19	\N	0	0	0	0	0	0	f	f
10646	56	19	\N	0	0	0	0	0	0	f	f
10647	58	19	\N	0	0	0	0	0	0	f	f
10648	62	19	\N	0	0	0	0	0	0	f	f
10649	65	19	\N	0	0	0	0	0	0	f	f
10650	30	19	\N	0	0	0	0	0	0	f	f
10651	45	19	\N	0	0	0	0	0	0	f	f
10652	147	19	\N	0	0	0	0	0	0	f	f
10653	205	19	\N	0	0	0	0	0	0	f	f
10654	172	19	\N	0	0	0	0	0	0	f	f
10655	130	19	\N	0	0	0	0	0	0	f	f
10656	186	19	\N	0	0	0	0	0	0	f	f
10657	119	19	\N	0	0	0	0	0	0	f	f
10658	171	19	\N	0	0	0	0	0	0	f	f
10659	176	19	\N	0	0	0	0	0	0	f	f
10660	145	19	\N	0	0	0	0	0	0	f	f
10661	199	19	\N	0	0	0	0	0	0	f	f
10662	193	19	\N	0	0	0	0	0	0	f	f
10663	122	19	\N	0	0	0	0	0	0	f	f
10664	112	19	\N	0	0	0	0	0	0	f	f
10665	196	19	\N	0	0	0	0	0	0	f	f
10666	197	19	\N	0	0	0	0	0	0	f	f
10667	138	19	\N	0	0	0	0	0	0	f	f
10668	108	19	\N	0	0	0	0	0	0	f	f
10669	141	19	\N	0	0	0	0	0	0	f	f
10670	207	19	\N	0	0	0	0	0	0	f	f
10671	208	19	\N	0	0	0	0	0	0	f	f
10672	121	19	\N	0	0	0	0	0	0	f	f
10673	162	19	\N	0	0	0	0	0	0	f	f
10674	168	19	\N	0	0	0	0	0	0	f	f
10675	218	19	\N	0	0	0	0	0	0	f	f
10676	220	19	\N	0	0	0	0	0	0	f	f
10677	224	19	\N	0	0	0	0	0	0	f	f
10678	238	19	\N	0	0	0	0	0	0	f	f
10679	286	19	\N	0	0	0	0	0	0	f	f
10680	235	19	\N	0	0	0	0	0	0	f	f
10681	232	19	\N	0	0	0	0	0	0	f	f
10682	226	19	\N	0	0	0	0	0	0	f	f
10683	248	19	\N	0	0	0	0	0	0	f	f
10684	255	19	\N	0	0	0	0	0	0	f	f
10685	221	19	\N	0	0	0	0	0	0	f	f
10686	230	19	\N	0	0	0	0	0	0	f	f
10687	211	19	\N	0	0	0	0	0	0	f	f
10688	245	19	\N	0	0	0	0	0	0	f	f
10689	210	19	\N	0	0	0	0	0	0	f	f
10690	240	19	\N	0	0	0	0	0	0	f	f
10691	264	19	\N	0	0	0	0	0	0	f	f
10692	250	19	\N	0	0	0	0	0	0	f	f
10693	223	19	\N	0	0	0	0	0	0	f	f
10694	215	19	\N	0	0	0	0	0	0	f	f
10695	216	19	\N	0	0	0	0	0	0	f	f
10696	278	19	\N	0	0	0	0	0	0	f	f
10697	296	19	\N	0	0	0	0	0	0	f	f
10698	269	19	\N	0	0	0	0	0	0	f	f
10699	228	19	\N	0	0	0	0	0	0	f	f
10700	222	19	\N	0	0	0	0	0	0	f	f
10701	253	19	\N	0	0	0	0	0	0	f	f
10702	254	19	\N	0	0	0	0	0	0	f	f
10703	225	19	\N	0	0	0	0	0	0	f	f
10704	233	19	\N	0	0	0	0	0	0	f	f
10705	418	19	\N	0	0	0	0	0	0	f	f
10706	405	19	\N	0	0	0	0	0	0	f	f
10707	390	19	\N	0	0	0	0	0	0	f	f
10708	406	19	\N	0	0	0	0	0	0	f	f
10709	378	19	\N	0	0	0	0	0	0	f	f
10710	380	19	\N	0	0	0	0	0	0	f	f
10711	412	19	\N	0	0	0	0	0	0	f	f
10712	347	19	\N	0	0	0	0	0	0	f	f
10713	371	19	\N	0	0	0	0	0	0	f	f
10714	379	19	\N	0	0	0	0	0	0	f	f
10715	397	19	\N	0	0	0	0	0	0	f	f
10716	384	19	\N	0	0	0	0	0	0	f	f
10717	357	19	\N	0	0	0	0	0	0	f	f
10718	394	19	\N	0	0	0	0	0	0	f	f
10719	341	19	\N	0	0	0	0	0	0	f	f
10720	416	19	\N	0	0	0	0	0	0	f	f
10721	366	19	\N	0	0	0	0	0	0	f	f
10722	399	19	\N	0	0	0	0	0	0	f	f
10723	386	19	\N	0	0	0	0	0	0	f	f
10724	391	19	\N	0	0	0	0	0	0	f	f
10725	409	19	\N	0	0	0	0	0	0	f	f
10726	411	19	\N	0	0	0	0	0	0	f	f
10727	237	19	\N	0	0	0	0	0	0	f	f
10728	431	19	\N	0	0	0	0	0	0	f	f
10729	429	19	\N	0	0	0	0	0	0	f	f
10730	522	19	\N	0	0	0	0	0	0	f	f
10731	502	19	\N	0	0	0	0	0	0	f	f
10732	517	19	\N	0	0	0	0	0	0	f	f
10733	479	19	\N	0	0	0	0	0	0	f	f
10734	455	19	\N	0	0	0	0	0	0	f	f
10735	492	19	\N	0	0	0	0	0	0	f	f
10736	449	19	\N	0	0	0	0	0	0	f	f
10737	486	19	\N	0	0	0	0	0	0	f	f
10738	485	19	\N	0	0	0	0	0	0	f	f
10739	428	19	\N	0	0	0	0	0	0	f	f
10740	438	19	\N	0	0	0	0	0	0	f	f
10741	441	19	\N	0	0	0	0	0	0	f	f
10742	525	19	\N	0	0	0	0	0	0	f	f
10743	497	19	\N	0	0	0	0	0	0	f	f
10744	425	19	\N	0	0	0	0	0	0	f	f
10745	426	19	\N	0	0	0	0	0	0	f	f
10746	500	19	\N	0	0	0	0	0	0	f	f
10747	430	19	\N	0	0	0	0	0	0	f	f
10748	462	19	\N	0	0	0	0	0	0	f	f
10749	427	19	\N	0	0	0	0	0	0	f	f
10750	515	19	\N	0	0	0	0	0	0	f	f
10751	434	19	\N	0	0	0	0	0	0	f	f
10752	435	19	\N	0	0	0	0	0	0	f	f
10753	531	19	\N	0	0	0	0	0	0	f	f
10754	219	19	\N	0	0	0	0	0	0	f	f
10755	530	19	\N	0	0	0	0	0	0	f	f
10756	540	19	\N	0	0	0	0	0	0	f	f
10757	541	19	\N	0	0	0	0	0	0	f	f
10758	43	19	\N	0	0	0	0	0	0	f	f
10759	44	19	\N	0	0	0	0	0	0	f	f
10760	110	19	\N	0	0	0	0	0	0	f	f
10761	217	19	\N	0	0	0	0	0	0	f	f
10762	417	19	\N	0	0	0	0	0	0	f	f
10763	363	19	\N	0	0	0	0	0	0	f	f
10764	494	19	\N	0	0	0	0	0	0	f	f
10765	229	19	\N	0	0	0	0	0	0	f	f
10766	55	19	\N	0	0	0	0	0	0	f	f
10767	206	19	\N	0	0	0	0	0	0	f	f
10768	247	19	\N	0	0	0	0	0	0	f	f
10769	421	19	\N	0	0	0	0	0	0	f	f
10770	246	19	\N	0	0	0	0	0	0	f	f
10771	303	19	\N	0	0	0	0	0	0	f	f
10772	518	19	\N	0	0	0	0	0	0	f	f
10773	538	19	\N	0	0	0	0	0	0	f	f
10774	48	19	\N	0	0	0	0	0	0	f	f
10775	177	19	\N	0	0	0	0	0	0	f	f
10776	258	19	\N	0	0	0	0	0	0	f	f
10777	388	19	\N	0	0	0	0	0	0	f	f
10778	294	19	\N	0	0	0	0	0	0	f	f
10779	34	19	\N	0	0	0	0	0	0	f	f
10780	289	19	\N	0	0	0	0	0	0	f	f
10781	330	19	\N	0	0	0	0	0	0	f	f
10782	498	19	\N	0	0	0	0	0	0	f	f
10783	534	19	\N	0	0	0	0	0	0	f	f
10784	532	19	\N	0	0	0	0	0	0	f	f
10785	542	19	\N	0	0	0	0	0	0	f	f
10786	543	19	\N	0	0	0	0	0	0	f	f
10787	49	19	\N	0	0	0	0	0	0	f	f
10788	178	19	\N	0	0	0	0	0	0	f	f
10789	266	19	\N	0	0	0	0	0	0	f	f
10790	334	19	\N	0	0	0	0	0	0	f	f
10791	279	19	\N	0	0	0	0	0	0	f	f
10792	476	19	\N	0	0	0	0	0	0	f	f
10793	60	19	\N	0	0	0	0	0	0	f	f
10794	57	19	\N	0	0	0	0	0	0	f	f
10795	198	19	\N	0	0	0	0	0	0	f	f
10796	524	19	\N	0	0	0	0	0	0	f	f
10797	39	19	\N	0	0	0	0	0	0	f	f
10798	59	19	\N	0	0	0	0	0	0	f	f
10799	440	19	\N	0	0	0	0	0	0	f	f
10800	442	19	\N	0	0	0	0	0	0	f	f
10801	25	19	\N	0	0	0	0	0	0	f	f
10802	234	19	\N	0	0	0	0	0	0	f	f
10803	306	19	\N	0	0	0	0	0	0	f	f
10804	535	19	\N	0	0	0	0	0	0	f	f
10805	461	19	\N	0	0	0	0	0	0	f	f
10806	53	19	\N	0	0	0	0	0	0	f	f
10807	84	19	\N	0	0	0	0	0	0	f	f
10808	167	19	\N	0	0	0	0	0	0	f	f
10809	275	19	\N	0	0	0	0	0	0	f	f
10810	335	19	\N	0	0	0	0	0	0	f	f
10811	32	19	\N	0	0	0	0	0	0	f	f
10812	94	19	\N	0	0	0	0	0	0	f	f
10813	454	19	\N	0	0	0	0	0	0	f	f
10814	9	19	\N	0	0	0	0	0	0	f	f
10815	209	19	\N	0	0	0	0	0	0	f	f
10816	73	19	\N	0	0	0	0	0	0	f	f
10817	537	19	\N	0	0	0	0	0	0	f	f
10818	311	19	\N	0	0	0	0	0	0	f	f
10819	38	19	\N	0	0	0	0	0	0	f	f
10820	256	19	\N	0	0	0	0	0	0	f	f
10821	213	19	\N	0	0	0	0	0	0	f	f
10822	377	19	\N	0	0	0	0	0	0	f	f
10823	415	19	\N	0	0	0	0	0	0	f	f
10824	179	19	\N	0	0	0	0	0	0	f	f
10825	249	19	\N	0	0	0	0	0	0	f	f
10826	203	19	\N	0	0	0	0	0	0	f	f
10827	387	19	\N	0	0	0	0	0	0	f	f
10828	79	19	\N	0	0	0	0	0	0	f	f
10829	252	19	\N	0	0	0	0	0	0	f	f
10830	413	19	\N	0	0	0	0	0	0	f	f
10831	424	19	\N	0	0	0	0	0	0	f	f
10832	41	19	\N	0	0	0	0	0	0	f	f
10833	67	19	\N	0	0	0	0	0	0	f	f
10834	82	19	\N	0	0	0	0	0	0	f	f
10835	259	19	\N	0	0	0	0	0	0	f	f
10836	163	19	\N	0	0	0	0	0	0	f	f
10837	352	19	\N	0	0	0	0	0	0	f	f
10838	257	19	\N	0	0	0	0	0	0	f	f
10839	293	19	\N	0	0	0	0	0	0	f	f
10840	432	19	\N	0	0	0	0	0	0	f	f
10841	381	19	\N	0	0	0	0	0	0	f	f
10842	64	19	\N	0	0	0	0	0	0	f	f
10843	188	19	\N	0	0	0	0	0	0	f	f
10844	212	19	\N	0	0	0	0	0	0	f	f
10845	395	19	\N	0	0	0	0	0	0	f	f
10846	277	19	\N	0	0	0	0	0	0	f	f
10847	533	19	\N	0	0	0	0	0	0	f	f
10848	393	19	\N	0	0	0	0	0	0	f	f
10849	50	19	\N	0	0	0	0	0	0	f	f
10850	31	19	\N	0	0	0	0	0	0	f	f
10851	185	19	\N	0	0	0	0	0	0	f	f
10852	166	19	\N	0	0	0	0	0	0	f	f
10853	242	19	\N	0	0	0	0	0	0	f	f
10854	324	19	\N	0	0	0	0	0	0	f	f
10855	102	19	\N	0	0	0	0	0	0	f	f
10856	536	19	\N	0	0	0	0	0	0	f	f
10857	63	19	\N	0	0	0	0	0	0	f	f
10858	231	19	\N	0	0	0	0	0	0	f	f
10859	506	19	\N	0	0	0	0	0	0	f	f
10860	512	19	\N	0	0	0	0	0	0	f	f
10861	5	20	7.00	0	0	0	0	0	0	f	f
10862	120	20	6.00	0	0	0	0	0	0	f	f
10863	156	20	6.00	0	0	0	0	0	0	f	f
10864	132	20	6.50	0	0	0	0	0	0	f	f
10865	157	20	6.00	0	0	0	0	0	0	f	f
10866	158	20	6.00	0	0	0	0	0	0	f	f
10867	200	20	6.50	0	0	0	0	0	1	f	f
10868	338	20	6.00	0	0	0	0	0	0	f	f
10869	296	20	7.00	1	0	0	0	0	0	f	f
10870	276	20	6.00	0	0	0	0	0	0	f	f
10871	364	20	6.00	0	0	0	0	0	0	t	f
10872	312	20	6.50	0	0	0	0	0	0	f	f
10873	329	20	6.50	0	0	0	0	0	0	f	f
10874	454	20	6.50	0	0	0	0	0	1	f	f
10875	459	20	7.50	1	0	0	0	0	0	f	f
10876	465	20	6.00	0	0	0	0	0	0	f	f
10877	20	20	6.00	0	1	0	0	0	0	f	f
10878	123	20	5.50	0	0	0	0	0	0	t	f
10879	85	20	6.50	0	0	0	0	0	0	f	f
10880	208	20	6.50	0	0	0	0	0	0	f	f
10881	121	20	5.50	0	0	0	0	0	0	f	f
10882	187	20	6.50	0	0	0	0	0	0	f	f
10883	103	20	6.50	0	0	0	0	0	0	f	f
10884	340	20	6.50	0	0	0	0	0	0	t	f
10885	311	20	5.50	0	0	0	0	0	0	f	f
10886	346	20	6.00	0	0	0	0	0	0	t	f
10887	427	20	5.50	0	0	0	0	0	0	f	f
10888	374	20	6.00	0	0	0	0	0	0	f	f
10889	336	20	5.50	0	0	0	0	0	0	f	f
10890	504	20	5.50	0	0	0	0	0	0	f	f
10891	458	20	6.00	1	0	0	0	0	0	f	t
10892	451	20	6.50	0	0	0	0	0	0	f	f
10893	10	20	5.50	0	3	0	0	0	0	f	f
10894	96	20	5.00	0	0	0	0	0	0	t	f
10895	133	20	5.50	0	0	0	0	0	0	f	f
10896	159	20	5.00	0	0	0	0	0	0	t	f
10897	69	20	5.50	0	0	0	0	0	0	f	f
10898	122	20	5.00	0	0	0	0	0	0	f	f
10899	204	20	5.00	0	0	0	0	0	0	t	f
10900	436	20	6.00	0	0	0	0	0	0	t	f
10901	304	20	5.50	0	0	0	0	0	0	f	f
10902	361	20	5.00	0	0	0	0	0	0	t	f
10903	348	20	5.50	0	0	0	0	0	0	f	f
10904	470	20	6.50	0	0	0	0	0	0	f	f
10905	520	20	5.00	0	0	0	0	0	0	f	f
10906	478	20	5.50	0	0	0	0	0	0	f	f
10907	529	20	5.00	0	0	0	0	0	0	f	f
10908	6	20	6.00	0	1	0	0	0	0	f	f
10909	119	20	5.50	0	0	0	0	0	0	f	f
10910	86	20	5.00	0	0	0	0	0	0	f	f
10911	171	20	6.00	0	0	0	0	0	0	f	f
10912	95	20	6.00	0	0	0	0	0	0	f	f
10913	80	20	6.00	0	0	0	0	0	0	f	f
10914	211	20	5.50	0	0	0	0	0	0	t	f
10915	316	20	5.50	0	0	0	0	0	0	f	f
10916	317	20	5.50	0	0	0	0	0	0	t	f
10917	290	20	6.50	0	0	0	0	0	0	f	f
10918	261	20	6.50	0	0	0	0	0	0	t	f
10919	331	20	7.00	1	0	0	0	0	0	f	f
10920	463	20	5.50	0	0	0	0	0	0	f	f
10921	514	20	6.00	0	0	0	0	0	0	f	f
10922	499	20	7.00	0	0	0	0	0	0	f	f
10923	11	20	6.50	0	5	1	0	0	0	f	f
10924	134	20	4.50	0	0	0	0	0	0	f	f
10925	173	20	5.00	0	0	0	0	0	0	t	f
10926	75	20	4.00	0	0	0	0	1	0	f	f
10927	70	20	4.00	0	0	0	0	0	0	f	f
10928	160	20	5.00	0	0	0	0	0	0	f	f
10929	375	20	5.50	0	0	0	0	0	0	f	f
10930	277	20	5.50	0	0	0	0	0	0	f	f
10931	355	20	5.00	0	0	0	0	0	0	f	f
10932	343	20	4.50	0	0	0	0	0	0	f	f
10933	283	20	6.00	0	0	0	0	0	0	f	f
10934	511	20	6.00	0	0	0	0	0	0	f	f
10935	464	20	5.50	0	0	0	0	0	0	f	f
10936	457	20	5.00	0	0	0	0	0	0	f	f
10937	526	20	5.00	0	0	0	0	0	0	f	f
10938	17	20	6.50	0	1	0	0	0	0	f	f
10939	107	20	6.50	0	0	0	0	0	0	f	f
10940	124	20	6.00	0	0	0	0	0	0	f	f
10941	191	20	6.00	0	0	0	0	0	0	f	f
10942	175	20	6.00	0	0	0	0	0	0	f	f
10943	161	20	6.50	0	0	0	0	0	0	f	f
10944	174	20	6.50	1	0	0	0	0	0	f	f
10945	162	20	6.00	0	0	0	0	0	0	f	f
10946	274	20	6.00	0	0	0	0	0	0	f	f
10947	376	20	6.00	0	0	0	0	0	0	t	f
10948	339	20	5.50	0	0	0	0	0	0	f	f
10949	366	20	6.00	0	0	0	0	0	0	f	f
10950	297	20	6.50	0	0	0	0	0	1	f	f
10951	396	20	6.00	0	0	0	0	0	0	f	f
10952	460	20	5.50	0	0	0	0	0	0	t	f
10953	18	20	7.00	0	0	0	0	0	0	f	f
10954	215	20	6.00	0	0	0	0	0	0	f	f
10955	74	20	7.00	0	0	0	0	0	1	f	f
10956	98	20	6.50	0	0	0	0	0	0	f	f
10957	92	20	7.50	1	0	0	0	0	0	f	f
10958	192	20	6.50	0	0	0	0	0	0	f	f
10959	135	20	6.00	0	0	0	0	0	0	f	f
10960	298	20	6.00	0	0	0	0	0	0	f	f
10961	305	20	6.50	0	0	0	0	0	1	f	f
10962	397	20	6.00	0	0	0	0	0	0	f	f
10963	342	20	7.00	1	0	0	0	0	0	t	f
10964	318	20	6.50	0	0	0	0	0	0	f	f
10965	349	20	6.50	0	0	0	0	0	0	t	f
10966	508	20	7.00	1	0	0	0	0	0	f	f
10967	490	20	6.50	0	0	0	0	0	0	f	f
10968	507	20	6.00	0	0	0	0	0	0	f	f
10969	13	20	6.00	0	2	0	0	0	0	f	f
10970	66	20	7.00	1	0	0	0	0	0	f	f
10971	67	20	6.00	0	0	0	0	0	0	f	f
10972	104	20	5.50	0	0	0	0	0	0	f	f
10973	81	20	6.00	0	0	0	0	0	0	f	f
10974	137	20	5.50	0	0	0	0	0	0	f	f
10975	300	20	6.50	0	0	0	0	0	0	f	f
10976	270	20	5.50	0	0	0	0	0	0	f	f
10977	262	20	6.50	0	0	0	0	0	0	f	f
10978	351	20	6.50	0	0	0	0	0	0	f	f
10979	350	20	5.50	0	0	0	0	0	0	f	f
10980	299	20	6.00	0	0	0	0	0	0	f	f
10981	444	20	5.50	0	0	0	0	0	0	f	f
10982	445	20	6.50	0	0	0	0	0	1	f	f
10983	474	20	6.00	0	0	0	0	0	0	f	f
10984	475	20	6.00	0	0	0	0	0	0	f	f
10985	7	20	6.50	0	0	0	0	0	0	f	f
10986	87	20	7.00	1	0	0	0	0	0	f	f
10987	88	20	6.50	0	0	0	0	0	1	f	f
10988	99	20	6.00	0	0	0	0	0	0	f	f
10989	109	20	6.00	0	0	0	0	0	0	f	f
10990	108	20	6.50	0	0	0	0	0	0	f	f
10991	307	20	6.50	0	0	0	0	0	0	f	f
10992	332	20	7.50	1	0	0	0	0	0	f	f
10993	291	20	7.00	0	0	0	0	0	1	f	f
10994	353	20	6.00	0	0	0	0	0	0	f	f
10995	322	20	6.00	0	0	0	0	0	0	f	f
10996	400	20	7.00	0	0	0	0	0	0	f	f
10997	410	20	6.00	0	0	0	0	0	0	f	f
10998	480	20	7.00	1	0	0	0	0	0	f	f
10999	477	20	6.00	0	0	0	0	0	0	f	f
11000	446	20	7.00	1	0	0	1	0	0	f	f
11001	3	20	6.50	0	0	0	0	0	0	f	f
11002	126	20	6.00	0	0	0	0	0	0	f	f
11003	110	20	6.00	0	0	0	0	0	0	f	f
11004	195	20	7.00	0	0	0	0	0	0	f	f
11005	144	20	5.50	0	0	0	0	0	0	f	f
11006	125	20	6.50	0	0	0	0	0	0	f	f
11007	362	20	5.50	0	0	0	0	0	0	f	f
11008	301	20	6.00	0	0	0	0	0	0	f	f
11009	380	20	5.50	0	0	0	0	0	0	f	f
11010	417	20	6.00	0	0	0	0	0	0	f	f
11011	285	20	6.00	0	0	0	0	0	0	f	f
11012	516	20	6.00	0	0	0	0	0	0	f	f
11013	491	20	6.50	0	0	0	0	0	0	t	f
11014	492	20	5.00	0	0	0	0	0	0	f	f
11015	8	20	6.00	0	2	0	0	0	0	f	f
11016	127	20	6.00	0	0	0	0	0	0	f	f
11017	164	20	5.00	0	0	0	0	0	0	f	t
11018	89	20	5.00	0	0	0	0	1	0	f	f
11019	146	20	6.00	0	0	0	0	0	0	f	f
11020	219	20	5.50	0	0	0	0	0	0	f	f
11021	310	20	5.50	0	0	0	0	0	0	f	f
11022	402	20	6.00	0	0	0	0	0	0	f	f
11023	293	20	5.50	0	0	0	0	0	0	f	f
11024	354	20	6.00	0	0	0	0	0	0	t	f
11025	401	20	6.00	0	0	0	0	0	0	t	f
11026	333	20	5.50	0	0	0	0	0	0	t	f
11027	501	20	5.50	0	0	0	0	0	1	f	t
11028	495	20	6.00	0	0	0	0	0	0	f	f
11029	513	20	7.00	1	0	0	0	0	0	f	f
11030	1	20	6.50	0	1	0	0	0	0	f	f
11031	111	20	6.00	0	0	0	0	0	0	f	f
11032	68	20	6.00	0	0	0	0	0	0	f	f
11033	177	20	5.00	0	0	0	0	0	0	t	f
11034	193	20	5.50	0	0	0	0	0	0	f	f
11035	90	20	5.00	0	0	0	0	0	0	f	f
11036	273	20	5.50	0	0	0	0	0	0	t	f
11037	260	20	6.00	0	0	0	0	0	0	f	f
11038	302	20	5.50	0	0	0	0	0	0	f	f
11039	313	20	6.50	0	0	0	0	0	1	t	f
11040	271	20	6.50	0	0	0	0	0	0	f	f
11041	294	20	6.00	0	0	0	0	0	0	f	f
11042	388	20	5.50	0	0	0	0	0	0	f	f
11043	447	20	5.50	0	0	0	0	0	0	f	f
11044	485	20	7.00	1	0	0	0	0	0	f	f
11045	4	20	6.00	0	2	0	0	0	0	f	f
11046	196	20	5.50	0	0	0	0	0	0	t	f
11047	71	20	6.50	0	0	0	0	0	0	f	f
11048	113	20	6.50	0	0	0	0	0	0	f	f
11049	140	20	6.00	0	0	0	0	0	0	t	f
11050	240	20	6.00	0	0	0	0	0	0	f	f
11051	112	20	5.00	0	0	0	0	0	0	f	f
11052	319	20	6.00	0	0	0	0	0	0	f	f
11053	356	20	6.00	0	0	0	0	0	0	f	f
11054	360	20	6.50	0	0	0	0	0	1	f	f
11055	265	20	7.50	2	0	0	0	0	0	f	f
11056	450	20	6.50	0	0	0	0	0	0	f	f
11057	483	20	6.50	0	0	0	0	0	1	f	f
11058	23	20	6.00	0	1	0	0	0	0	f	f
11059	147	20	5.50	0	0	0	0	0	0	f	f
11060	116	20	6.00	0	0	0	0	0	0	f	f
11061	114	20	6.50	0	0	0	0	0	0	f	f
11062	115	20	6.00	0	0	0	0	0	0	t	f
11063	143	20	6.00	0	0	0	0	0	0	f	f
11064	403	20	6.00	0	0	0	0	0	0	f	f
11065	372	20	6.00	0	0	0	0	0	0	f	f
11066	280	20	7.50	0	0	0	0	0	1	f	f
11067	365	20	5.50	0	0	0	0	0	0	f	f
11068	367	20	6.00	0	0	0	0	0	0	f	f
11069	404	20	6.00	0	0	0	0	0	0	f	f
11070	359	20	5.50	0	0	0	0	0	0	f	f
11071	502	20	6.00	0	0	0	0	0	0	f	f
11072	456	20	7.00	1	0	0	0	0	0	f	f
11073	31	20	6.00	0	2	0	0	0	0	f	f
11074	148	20	5.50	0	0	0	0	0	0	t	f
11075	166	20	6.00	0	0	0	0	0	0	f	f
11076	165	20	5.50	0	0	0	0	0	0	f	f
11077	241	20	6.00	0	0	0	0	0	0	t	f
11078	129	20	6.50	0	0	0	0	0	0	f	f
11079	344	20	5.00	0	0	0	0	0	0	f	f
11080	368	20	7.50	1	0	0	0	0	0	f	f
11081	373	20	5.50	0	0	0	0	0	0	f	f
11082	382	20	6.50	0	0	0	0	0	0	f	f
11083	320	20	6.00	0	0	0	0	0	0	f	f
11084	433	20	6.00	0	0	0	0	0	0	f	f
11085	383	20	5.50	0	0	0	0	0	0	t	f
11086	487	20	6.00	0	0	0	0	0	0	t	f
11087	517	20	7.00	1	0	0	0	0	0	f	f
11088	2	20	6.50	0	0	0	0	0	0	f	f
11089	100	20	6.50	0	0	0	0	0	0	f	f
11090	76	20	6.50	0	0	0	0	0	0	f	f
11091	84	20	6.00	0	0	0	0	0	0	t	f
11092	202	20	5.00	0	0	0	0	0	0	f	f
11093	251	20	6.00	0	0	0	0	0	0	f	f
11094	167	20	6.00	0	0	0	0	0	0	f	f
11095	72	20	6.50	0	0	0	0	0	0	f	f
11096	227	20	6.00	0	0	0	0	0	0	f	f
11097	369	20	7.00	0	0	0	0	0	1	f	f
11098	281	20	7.00	1	0	0	0	0	0	t	f
11099	420	20	6.50	0	0	0	0	0	0	f	f
11100	481	20	6.50	0	0	0	0	0	0	f	f
11101	448	20	7.50	1	0	0	0	0	1	f	f
11102	484	20	5.50	0	0	0	0	0	0	f	f
11103	15	20	6.00	0	2	0	0	0	0	t	f
11104	142	20	5.50	0	0	0	0	0	0	f	f
11105	150	20	5.50	0	0	0	0	0	0	f	f
11106	118	20	6.00	0	0	0	0	0	0	f	f
11107	149	20	6.00	0	0	0	0	0	0	f	f
11108	315	20	6.00	0	0	0	0	0	0	t	f
11109	389	20	5.50	0	0	0	0	0	0	f	f
11110	422	20	6.00	0	0	0	0	0	0	f	f
11111	287	20	6.50	0	0	0	0	0	0	f	f
11112	308	20	6.50	0	0	0	0	0	0	f	f
11113	385	20	6.00	0	0	0	0	0	0	f	f
11114	527	20	6.00	0	0	0	0	0	0	f	f
11115	467	20	5.50	0	0	0	0	0	0	f	f
11116	453	20	6.00	0	0	0	0	0	0	f	f
11117	518	20	5.50	0	0	0	0	0	0	f	f
11118	537	20	6.00	0	0	0	0	0	0	f	f
11119	22	20	6.50	0	2	0	0	0	0	f	f
11120	179	20	5.00	0	0	0	0	0	0	f	f
11121	152	20	5.50	0	0	0	0	0	0	f	f
11122	91	20	6.50	0	0	0	0	0	0	f	f
11123	151	20	6.00	0	0	0	0	0	0	f	f
11124	77	20	5.50	0	0	0	0	0	0	f	f
11125	370	20	5.00	0	0	0	0	0	0	t	f
11126	288	20	5.50	0	0	0	0	0	0	f	f
11127	439	20	6.50	0	0	0	0	0	0	t	f
11128	386	20	6.00	0	0	0	0	0	0	f	f
11129	496	20	5.00	0	0	0	0	0	0	f	f
11130	466	20	5.50	0	0	0	0	0	0	f	f
11131	488	20	5.50	0	0	0	0	0	0	f	f
11132	468	20	6.00	0	0	0	0	0	0	f	f
11133	539	20	6.00	0	0	0	0	0	0	f	f
11134	528	20	5.50	0	0	0	0	0	0	f	f
11135	19	20	6.00	0	2	0	0	0	0	f	f
11136	78	20	6.50	1	0	0	0	0	0	f	f
11137	128	20	6.50	0	0	0	0	0	0	f	f
11138	154	20	5.50	0	0	0	0	0	0	f	f
11139	153	20	6.00	0	0	0	0	0	0	f	f
11140	250	20	5.50	0	0	0	0	0	0	f	f
11141	101	20	6.00	0	0	0	0	0	0	f	f
11142	272	20	6.50	0	0	0	0	0	1	t	f
11143	321	20	6.50	0	0	0	0	0	0	f	f
11144	326	20	6.50	0	0	0	0	0	0	f	f
11145	282	20	6.50	0	0	0	0	0	0	f	f
11146	328	20	5.50	0	0	0	0	0	0	f	f
11147	437	20	5.50	0	0	0	0	0	0	f	f
11148	452	20	6.50	0	0	0	0	0	0	f	f
11149	524	20	5.50	0	0	0	0	0	0	f	f
11150	542	20	5.50	0	0	0	0	0	0	f	f
11151	12	20	6.00	0	1	0	0	0	0	f	f
11152	155	20	5.50	0	0	0	0	0	0	f	f
11153	183	20	6.50	0	0	0	0	0	0	f	f
11154	181	20	6.00	0	0	0	0	0	0	f	f
11155	182	20	6.00	0	0	0	0	0	0	t	f
11156	169	20	5.50	0	0	0	0	1	0	f	f
11157	170	20	7.00	0	0	0	0	0	0	t	f
11158	345	20	5.50	0	0	0	0	0	0	f	f
11159	408	20	5.50	0	0	0	0	0	0	f	f
11160	309	20	5.50	0	0	0	0	0	0	f	f
11161	391	20	6.00	0	0	0	0	0	0	f	f
11162	327	20	5.50	0	0	0	0	0	0	f	f
11163	521	20	6.00	0	0	0	0	0	0	f	f
11164	473	20	5.50	0	0	0	0	0	0	f	f
11165	503	20	5.50	0	0	0	0	0	0	f	f
11166	469	20	6.00	0	0	0	0	0	0	f	f
11167	46	20	\N	0	0	0	0	0	0	f	f
11168	35	20	\N	0	0	0	0	0	0	f	f
11169	37	20	\N	0	0	0	0	0	0	f	f
11170	24	20	\N	0	0	0	0	0	0	f	f
11171	29	20	\N	0	0	0	0	0	0	f	f
11172	16	20	\N	0	0	0	0	0	0	f	f
11173	51	20	\N	0	0	0	0	0	0	f	f
11174	14	20	\N	0	0	0	0	0	0	f	f
11175	36	20	\N	0	0	0	0	0	0	f	f
11176	105	20	\N	0	0	0	0	0	0	f	f
11177	54	20	\N	0	0	0	0	0	0	f	f
11178	47	20	\N	0	0	0	0	0	0	f	f
11179	21	20	\N	0	0	0	0	0	0	f	f
11180	83	20	\N	0	0	0	0	0	0	f	f
11181	27	20	\N	0	0	0	0	0	0	f	f
11182	40	20	\N	0	0	0	0	0	0	f	f
11183	42	20	\N	0	0	0	0	0	0	f	f
11184	52	20	\N	0	0	0	0	0	0	f	f
11185	33	20	\N	0	0	0	0	0	0	f	f
11186	93	20	\N	0	0	0	0	0	0	f	f
11187	28	20	\N	0	0	0	0	0	0	f	f
11188	61	20	\N	0	0	0	0	0	0	f	f
11189	26	20	\N	0	0	0	0	0	0	f	f
11190	56	20	\N	0	0	0	0	0	0	f	f
11191	58	20	\N	0	0	0	0	0	0	f	f
11192	62	20	\N	0	0	0	0	0	0	f	f
11193	65	20	\N	0	0	0	0	0	0	f	f
11194	30	20	\N	0	0	0	0	0	0	f	f
11195	45	20	\N	0	0	0	0	0	0	f	f
11196	106	20	\N	0	0	0	0	0	0	f	f
11197	205	20	\N	0	0	0	0	0	0	f	f
11198	172	20	\N	0	0	0	0	0	0	f	f
11199	130	20	\N	0	0	0	0	0	0	f	f
11200	186	20	\N	0	0	0	0	0	0	f	f
11201	189	20	\N	0	0	0	0	0	0	f	f
11202	176	20	\N	0	0	0	0	0	0	f	f
11203	145	20	\N	0	0	0	0	0	0	f	f
11204	199	20	\N	0	0	0	0	0	0	f	f
11205	184	20	\N	0	0	0	0	0	0	f	f
11206	180	20	\N	0	0	0	0	0	0	f	f
11207	197	20	\N	0	0	0	0	0	0	f	f
11208	138	20	\N	0	0	0	0	0	0	f	f
11209	141	20	\N	0	0	0	0	0	0	f	f
11210	207	20	\N	0	0	0	0	0	0	f	f
11211	168	20	\N	0	0	0	0	0	0	f	f
11212	218	20	\N	0	0	0	0	0	0	f	f
11213	220	20	\N	0	0	0	0	0	0	f	f
11214	224	20	\N	0	0	0	0	0	0	f	f
11215	238	20	\N	0	0	0	0	0	0	f	f
11216	286	20	\N	0	0	0	0	0	0	f	f
11217	235	20	\N	0	0	0	0	0	0	f	f
11218	232	20	\N	0	0	0	0	0	0	f	f
11219	226	20	\N	0	0	0	0	0	0	f	f
11220	248	20	\N	0	0	0	0	0	0	f	f
11221	255	20	\N	0	0	0	0	0	0	f	f
11222	221	20	\N	0	0	0	0	0	0	f	f
11223	230	20	\N	0	0	0	0	0	0	f	f
11224	284	20	\N	0	0	0	0	0	0	f	f
11225	292	20	\N	0	0	0	0	0	0	f	f
11226	244	20	\N	0	0	0	0	0	0	f	f
11227	245	20	\N	0	0	0	0	0	0	f	f
11228	314	20	\N	0	0	0	0	0	0	f	f
11229	268	20	\N	0	0	0	0	0	0	f	f
11230	210	20	\N	0	0	0	0	0	0	f	f
11231	264	20	\N	0	0	0	0	0	0	f	f
11232	223	20	\N	0	0	0	0	0	0	f	f
11233	214	20	\N	0	0	0	0	0	0	f	f
11234	216	20	\N	0	0	0	0	0	0	f	f
11235	278	20	\N	0	0	0	0	0	0	f	f
11236	295	20	\N	0	0	0	0	0	0	f	f
11237	269	20	\N	0	0	0	0	0	0	f	f
11238	263	20	\N	0	0	0	0	0	0	f	f
11239	228	20	\N	0	0	0	0	0	0	f	f
11240	222	20	\N	0	0	0	0	0	0	f	f
11241	253	20	\N	0	0	0	0	0	0	f	f
11242	254	20	\N	0	0	0	0	0	0	f	f
11243	225	20	\N	0	0	0	0	0	0	f	f
11244	233	20	\N	0	0	0	0	0	0	f	f
11245	418	20	\N	0	0	0	0	0	0	f	f
11246	325	20	\N	0	0	0	0	0	0	f	f
11247	405	20	\N	0	0	0	0	0	0	f	f
11248	337	20	\N	0	0	0	0	0	0	f	f
11249	390	20	\N	0	0	0	0	0	0	f	f
11250	406	20	\N	0	0	0	0	0	0	f	f
11251	414	20	\N	0	0	0	0	0	0	f	f
11252	378	20	\N	0	0	0	0	0	0	f	f
11253	392	20	\N	0	0	0	0	0	0	f	f
11254	323	20	\N	0	0	0	0	0	0	f	f
11255	412	20	\N	0	0	0	0	0	0	f	f
11256	347	20	\N	0	0	0	0	0	0	f	f
11257	371	20	\N	0	0	0	0	0	0	f	f
11258	379	20	\N	0	0	0	0	0	0	f	f
11259	384	20	\N	0	0	0	0	0	0	f	f
11260	357	20	\N	0	0	0	0	0	0	f	f
11261	394	20	\N	0	0	0	0	0	0	f	f
11262	341	20	\N	0	0	0	0	0	0	f	f
11263	416	20	\N	0	0	0	0	0	0	f	f
11264	399	20	\N	0	0	0	0	0	0	f	f
11265	409	20	\N	0	0	0	0	0	0	f	f
11266	411	20	\N	0	0	0	0	0	0	f	f
11267	237	20	\N	0	0	0	0	0	0	f	f
11268	431	20	\N	0	0	0	0	0	0	f	f
11269	509	20	\N	0	0	0	0	0	0	f	f
11270	429	20	\N	0	0	0	0	0	0	f	f
11271	522	20	\N	0	0	0	0	0	0	f	f
11272	523	20	\N	0	0	0	0	0	0	f	f
11273	472	20	\N	0	0	0	0	0	0	f	f
11274	479	20	\N	0	0	0	0	0	0	f	f
11275	455	20	\N	0	0	0	0	0	0	f	f
11276	449	20	\N	0	0	0	0	0	0	f	f
11277	486	20	\N	0	0	0	0	0	0	f	f
11278	428	20	\N	0	0	0	0	0	0	f	f
11279	438	20	\N	0	0	0	0	0	0	f	f
11280	441	20	\N	0	0	0	0	0	0	f	f
11281	510	20	\N	0	0	0	0	0	0	f	f
11282	525	20	\N	0	0	0	0	0	0	f	f
11283	497	20	\N	0	0	0	0	0	0	f	f
11284	425	20	\N	0	0	0	0	0	0	f	f
11285	426	20	\N	0	0	0	0	0	0	f	f
11286	500	20	\N	0	0	0	0	0	0	f	f
11287	430	20	\N	0	0	0	0	0	0	f	f
11288	462	20	\N	0	0	0	0	0	0	f	f
11289	489	20	\N	0	0	0	0	0	0	f	f
11290	515	20	\N	0	0	0	0	0	0	f	f
11291	505	20	\N	0	0	0	0	0	0	f	f
11292	434	20	\N	0	0	0	0	0	0	f	f
11293	435	20	\N	0	0	0	0	0	0	f	f
11294	531	20	\N	0	0	0	0	0	0	f	f
11295	530	20	\N	0	0	0	0	0	0	f	f
11296	540	20	\N	0	0	0	0	0	0	f	f
11297	541	20	\N	0	0	0	0	0	0	f	f
11298	43	20	\N	0	0	0	0	0	0	f	f
11299	44	20	\N	0	0	0	0	0	0	f	f
11300	236	20	\N	0	0	0	0	0	0	f	f
11301	217	20	\N	0	0	0	0	0	0	f	f
11302	363	20	\N	0	0	0	0	0	0	f	f
11303	267	20	\N	0	0	0	0	0	0	f	f
11304	494	20	\N	0	0	0	0	0	0	f	f
11305	229	20	\N	0	0	0	0	0	0	f	f
11306	55	20	\N	0	0	0	0	0	0	f	f
11307	206	20	\N	0	0	0	0	0	0	f	f
11308	247	20	\N	0	0	0	0	0	0	f	f
11309	421	20	\N	0	0	0	0	0	0	f	f
11310	246	20	\N	0	0	0	0	0	0	f	f
11311	303	20	\N	0	0	0	0	0	0	f	f
11312	538	20	\N	0	0	0	0	0	0	f	f
11313	48	20	\N	0	0	0	0	0	0	f	f
11314	258	20	\N	0	0	0	0	0	0	f	f
11315	139	20	\N	0	0	0	0	0	0	f	f
11316	34	20	\N	0	0	0	0	0	0	f	f
11317	97	20	\N	0	0	0	0	0	0	f	f
11318	289	20	\N	0	0	0	0	0	0	f	f
11319	330	20	\N	0	0	0	0	0	0	f	f
11320	498	20	\N	0	0	0	0	0	0	f	f
11321	534	20	\N	0	0	0	0	0	0	f	f
11322	532	20	\N	0	0	0	0	0	0	f	f
11323	543	20	\N	0	0	0	0	0	0	f	f
11324	49	20	\N	0	0	0	0	0	0	f	f
11325	201	20	\N	0	0	0	0	0	0	f	f
11326	239	20	\N	0	0	0	0	0	0	f	f
11327	178	20	\N	0	0	0	0	0	0	f	f
11328	266	20	\N	0	0	0	0	0	0	f	f
11329	334	20	\N	0	0	0	0	0	0	f	f
11330	279	20	\N	0	0	0	0	0	0	f	f
11331	476	20	\N	0	0	0	0	0	0	f	f
11332	60	20	\N	0	0	0	0	0	0	f	f
11333	57	20	\N	0	0	0	0	0	0	f	f
11334	198	20	\N	0	0	0	0	0	0	f	f
11335	131	20	\N	0	0	0	0	0	0	f	f
11336	423	20	\N	0	0	0	0	0	0	f	f
11337	39	20	\N	0	0	0	0	0	0	f	f
11338	59	20	\N	0	0	0	0	0	0	f	f
11339	440	20	\N	0	0	0	0	0	0	f	f
11340	398	20	\N	0	0	0	0	0	0	f	f
11341	442	20	\N	0	0	0	0	0	0	f	f
11342	25	20	\N	0	0	0	0	0	0	f	f
11343	194	20	\N	0	0	0	0	0	0	f	f
11344	234	20	\N	0	0	0	0	0	0	f	f
11345	306	20	\N	0	0	0	0	0	0	f	f
11346	535	20	\N	0	0	0	0	0	0	f	f
11347	461	20	\N	0	0	0	0	0	0	f	f
11348	53	20	\N	0	0	0	0	0	0	f	f
11349	275	20	\N	0	0	0	0	0	0	f	f
11350	335	20	\N	0	0	0	0	0	0	f	f
11351	471	20	\N	0	0	0	0	0	0	f	f
11352	32	20	\N	0	0	0	0	0	0	f	f
11353	94	20	\N	0	0	0	0	0	0	f	f
11354	9	20	\N	0	0	0	0	0	0	f	f
11355	209	20	\N	0	0	0	0	0	0	f	f
11356	73	20	\N	0	0	0	0	0	0	f	f
11357	482	20	\N	0	0	0	0	0	0	f	f
11358	519	20	\N	0	0	0	0	0	0	f	f
11359	38	20	\N	0	0	0	0	0	0	f	f
11360	256	20	\N	0	0	0	0	0	0	f	f
11361	190	20	\N	0	0	0	0	0	0	f	f
11362	213	20	\N	0	0	0	0	0	0	f	f
11363	377	20	\N	0	0	0	0	0	0	f	f
11364	415	20	\N	0	0	0	0	0	0	f	f
11365	249	20	\N	0	0	0	0	0	0	f	f
11366	203	20	\N	0	0	0	0	0	0	f	f
11367	407	20	\N	0	0	0	0	0	0	f	f
11368	358	20	\N	0	0	0	0	0	0	f	f
11369	387	20	\N	0	0	0	0	0	0	f	f
11370	79	20	\N	0	0	0	0	0	0	f	f
11371	252	20	\N	0	0	0	0	0	0	f	f
11372	413	20	\N	0	0	0	0	0	0	f	f
11373	424	20	\N	0	0	0	0	0	0	f	f
11374	41	20	\N	0	0	0	0	0	0	f	f
11375	136	20	\N	0	0	0	0	0	0	f	f
11376	82	20	\N	0	0	0	0	0	0	f	f
11377	259	20	\N	0	0	0	0	0	0	f	f
11378	163	20	\N	0	0	0	0	0	0	f	f
11379	352	20	\N	0	0	0	0	0	0	f	f
11380	257	20	\N	0	0	0	0	0	0	f	f
11381	419	20	\N	0	0	0	0	0	0	f	f
11382	432	20	\N	0	0	0	0	0	0	f	f
11383	381	20	\N	0	0	0	0	0	0	f	f
11384	64	20	\N	0	0	0	0	0	0	f	f
11385	188	20	\N	0	0	0	0	0	0	f	f
11386	212	20	\N	0	0	0	0	0	0	f	f
11387	395	20	\N	0	0	0	0	0	0	f	f
11388	533	20	\N	0	0	0	0	0	0	f	f
11389	393	20	\N	0	0	0	0	0	0	f	f
11390	50	20	\N	0	0	0	0	0	0	f	f
11391	443	20	\N	0	0	0	0	0	0	f	f
11392	493	20	\N	0	0	0	0	0	0	f	f
11393	185	20	\N	0	0	0	0	0	0	f	f
11394	243	20	\N	0	0	0	0	0	0	f	f
11395	242	20	\N	0	0	0	0	0	0	f	f
11396	324	20	\N	0	0	0	0	0	0	f	f
11397	102	20	\N	0	0	0	0	0	0	f	f
11398	536	20	\N	0	0	0	0	0	0	f	f
11399	63	20	\N	0	0	0	0	0	0	f	f
11400	231	20	\N	0	0	0	0	0	0	f	f
11401	117	20	\N	0	0	0	0	0	0	f	f
11402	506	20	\N	0	0	0	0	0	0	f	f
11403	512	20	\N	0	0	0	0	0	0	f	f
\.


--
-- TOC entry 5068 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: utenti; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utenti (id, nome, cognome, email, password, ruolo, squadra_preferita) FROM stdin;
8	admin	admin	admin@admin.com	$2a$10$DQF/2vnE9SPKEt.NaXMlteieygu41XQg2pforPpztPa31utwGhpl2	ADMIN	\N
\.


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 231
-- Name: acquisti_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.acquisti_id_seq', 84, true);


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 221
-- Name: calciatori_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.calciatori_id_seq', 543, true);


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 235
-- Name: calendario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.calendario_id_seq', 142, true);


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 229
-- Name: fantasquadra_id_fantasquadra_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fantasquadra_id_fantasquadra_seq', 13, true);


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 239
-- Name: formazioni_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formazioni_id_seq', 15, true);


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 227
-- Name: impostazioni_lega_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.impostazioni_lega_id_seq', 8, true);


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 225
-- Name: lega_id_lega_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lega_id_lega_seq', 8, true);


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 237
-- Name: punteggi_giornata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.punteggi_giornata_id_seq', 48, true);


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 233
-- Name: scambi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scambi_id_seq', 15, true);


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 241
-- Name: schieramento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.schieramento_id_seq', 330, true);


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 223
-- Name: statistiche_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statistiche_id_seq', 11403, true);


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 219
-- Name: utenti_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.utenti_id_seq', 8, true);


--
-- TOC entry 4889 (class 2606 OID 16530)
-- Name: acquisti acquisti_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acquisti
    ADD CONSTRAINT acquisti_pkey PRIMARY KEY (id);


--
-- TOC entry 4869 (class 2606 OID 16420)
-- Name: calciatori calciatori_codice_api_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calciatori
    ADD CONSTRAINT calciatori_codice_api_key UNIQUE (codice_api);


--
-- TOC entry 4871 (class 2606 OID 16418)
-- Name: calciatori calciatori_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calciatori
    ADD CONSTRAINT calciatori_pkey PRIMARY KEY (id);


--
-- TOC entry 4895 (class 2606 OID 16598)
-- Name: calendario calendario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendario
    ADD CONSTRAINT calendario_pkey PRIMARY KEY (id);


--
-- TOC entry 4885 (class 2606 OID 16506)
-- Name: fantasquadra fantasquadra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fantasquadra
    ADD CONSTRAINT fantasquadra_pkey PRIMARY KEY (id_fantasquadra);


--
-- TOC entry 4899 (class 2606 OID 16633)
-- Name: formazioni formazioni_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formazioni
    ADD CONSTRAINT formazioni_pkey PRIMARY KEY (id);


--
-- TOC entry 4881 (class 2606 OID 16483)
-- Name: impostazioni_lega impostazioni_lega_id_lega_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impostazioni_lega
    ADD CONSTRAINT impostazioni_lega_id_lega_key UNIQUE (id_lega);


--
-- TOC entry 4883 (class 2606 OID 16481)
-- Name: impostazioni_lega impostazioni_lega_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impostazioni_lega
    ADD CONSTRAINT impostazioni_lega_pkey PRIMARY KEY (id);


--
-- TOC entry 4877 (class 2606 OID 16456)
-- Name: lega lega_codice_invito_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lega
    ADD CONSTRAINT lega_codice_invito_key UNIQUE (codice_invito);


--
-- TOC entry 4879 (class 2606 OID 16454)
-- Name: lega lega_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lega
    ADD CONSTRAINT lega_pkey PRIMARY KEY (id_lega);


--
-- TOC entry 4897 (class 2606 OID 16617)
-- Name: punteggi_giornata punteggi_giornata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.punteggi_giornata
    ADD CONSTRAINT punteggi_giornata_pkey PRIMARY KEY (id);


--
-- TOC entry 4893 (class 2606 OID 16562)
-- Name: scambi scambi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scambi
    ADD CONSTRAINT scambi_pkey PRIMARY KEY (id);


--
-- TOC entry 4903 (class 2606 OID 16651)
-- Name: schieramento schieramento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schieramento
    ADD CONSTRAINT schieramento_pkey PRIMARY KEY (id);


--
-- TOC entry 4873 (class 2606 OID 16437)
-- Name: statistiche statistiche_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statistiche
    ADD CONSTRAINT statistiche_pkey PRIMARY KEY (id);


--
-- TOC entry 4901 (class 2606 OID 16635)
-- Name: formazioni unique_formazione_giornata; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formazioni
    ADD CONSTRAINT unique_formazione_giornata UNIQUE (id_fantasquadra, giornata);


--
-- TOC entry 4891 (class 2606 OID 16532)
-- Name: acquisti unique_giocatore_squadra; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acquisti
    ADD CONSTRAINT unique_giocatore_squadra UNIQUE (id_fantasquadra, id_calciatore);


--
-- TOC entry 4875 (class 2606 OID 16439)
-- Name: statistiche unique_voto_giornata; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statistiche
    ADD CONSTRAINT unique_voto_giornata UNIQUE (id_calciatore, giornata);


--
-- TOC entry 4887 (class 2606 OID 16508)
-- Name: fantasquadra unq_utente_lega; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fantasquadra
    ADD CONSTRAINT unq_utente_lega UNIQUE (id_utente, id_lega);


--
-- TOC entry 4865 (class 2606 OID 16404)
-- Name: utenti utenti_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utenti
    ADD CONSTRAINT utenti_email_key UNIQUE (email);


--
-- TOC entry 4867 (class 2606 OID 16402)
-- Name: utenti utenti_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utenti
    ADD CONSTRAINT utenti_pkey PRIMARY KEY (id);


--
-- TOC entry 4914 (class 2606 OID 16599)
-- Name: calendario calendario_id_squadra_casa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendario
    ADD CONSTRAINT calendario_id_squadra_casa_fkey FOREIGN KEY (id_squadra_casa) REFERENCES public.fantasquadra(id_fantasquadra);


--
-- TOC entry 4915 (class 2606 OID 16604)
-- Name: calendario calendario_id_squadra_trasferta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendario
    ADD CONSTRAINT calendario_id_squadra_trasferta_fkey FOREIGN KEY (id_squadra_trasferta) REFERENCES public.fantasquadra(id_fantasquadra);


--
-- TOC entry 4908 (class 2606 OID 16538)
-- Name: acquisti fk_acquisti_calciatore; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acquisti
    ADD CONSTRAINT fk_acquisti_calciatore FOREIGN KEY (id_calciatore) REFERENCES public.calciatori(id) ON DELETE CASCADE;


--
-- TOC entry 4909 (class 2606 OID 16533)
-- Name: acquisti fk_acquisti_fantasquadra; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acquisti
    ADD CONSTRAINT fk_acquisti_fantasquadra FOREIGN KEY (id_fantasquadra) REFERENCES public.fantasquadra(id_fantasquadra) ON DELETE CASCADE;


--
-- TOC entry 4904 (class 2606 OID 16440)
-- Name: statistiche fk_calciatore; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statistiche
    ADD CONSTRAINT fk_calciatore FOREIGN KEY (id_calciatore) REFERENCES public.calciatori(id) ON DELETE CASCADE;


--
-- TOC entry 4906 (class 2606 OID 16514)
-- Name: fantasquadra fk_fantasquadra_lega; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fantasquadra
    ADD CONSTRAINT fk_fantasquadra_lega FOREIGN KEY (id_lega) REFERENCES public.lega(id_lega) ON DELETE CASCADE;


--
-- TOC entry 4907 (class 2606 OID 16509)
-- Name: fantasquadra fk_fantasquadra_utente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fantasquadra
    ADD CONSTRAINT fk_fantasquadra_utente FOREIGN KEY (id_utente) REFERENCES public.utenti(id) ON DELETE CASCADE;


--
-- TOC entry 4910 (class 2606 OID 16573)
-- Name: scambi fk_scambi_calc_prop; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scambi
    ADD CONSTRAINT fk_scambi_calc_prop FOREIGN KEY (id_calciatore_proposto) REFERENCES public.calciatori(id) ON DELETE CASCADE;


--
-- TOC entry 4911 (class 2606 OID 16578)
-- Name: scambi fk_scambi_calc_ric; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scambi
    ADD CONSTRAINT fk_scambi_calc_ric FOREIGN KEY (id_calciatore_richiesto) REFERENCES public.calciatori(id) ON DELETE CASCADE;


--
-- TOC entry 4912 (class 2606 OID 16563)
-- Name: scambi fk_scambi_prop; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scambi
    ADD CONSTRAINT fk_scambi_prop FOREIGN KEY (id_fantasquadra_proponente) REFERENCES public.fantasquadra(id_fantasquadra) ON DELETE CASCADE;


--
-- TOC entry 4913 (class 2606 OID 16568)
-- Name: scambi fk_scambi_ric; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scambi
    ADD CONSTRAINT fk_scambi_ric FOREIGN KEY (id_fantasquadra_ricevente) REFERENCES public.fantasquadra(id_fantasquadra) ON DELETE CASCADE;


--
-- TOC entry 4917 (class 2606 OID 16636)
-- Name: formazioni formazioni_id_fantasquadra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formazioni
    ADD CONSTRAINT formazioni_id_fantasquadra_fkey FOREIGN KEY (id_fantasquadra) REFERENCES public.fantasquadra(id_fantasquadra) ON DELETE CASCADE;


--
-- TOC entry 4905 (class 2606 OID 16484)
-- Name: impostazioni_lega impostazioni_lega_id_lega_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impostazioni_lega
    ADD CONSTRAINT impostazioni_lega_id_lega_fkey FOREIGN KEY (id_lega) REFERENCES public.lega(id_lega) ON DELETE CASCADE;


--
-- TOC entry 4916 (class 2606 OID 16618)
-- Name: punteggi_giornata punteggi_giornata_id_fantasquadra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.punteggi_giornata
    ADD CONSTRAINT punteggi_giornata_id_fantasquadra_fkey FOREIGN KEY (id_fantasquadra) REFERENCES public.fantasquadra(id_fantasquadra);


--
-- TOC entry 4918 (class 2606 OID 16657)
-- Name: schieramento schieramento_id_calciatore_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schieramento
    ADD CONSTRAINT schieramento_id_calciatore_fkey FOREIGN KEY (id_calciatore) REFERENCES public.calciatori(id) ON DELETE CASCADE;


--
-- TOC entry 4919 (class 2606 OID 16652)
-- Name: schieramento schieramento_id_formazione_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schieramento
    ADD CONSTRAINT schieramento_id_formazione_fkey FOREIGN KEY (id_formazione) REFERENCES public.formazioni(id) ON DELETE CASCADE;


-- Completed on 2026-01-16 18:35:43

--
-- PostgreSQL database dump complete
--

\unrestrict mgOJYc1KZMnF3bWLgyt008xsI2svOmUXZg87zApc4qcp80chuGXTZJao0GTOUhe

