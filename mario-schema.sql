--
-- PostgreSQL database dump
--

\restrict 1DRfBMK5sWNKVEc5GVSeqCDPGXqNv2zTkX9477dDX0fzei5hBgtDTkUo4KVaPro

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

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
-- Name: achievements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.achievements (
    id character varying(255) CONSTRAINT "achievementsConfig_id_not_null" NOT NULL,
    title character varying(255),
    description text,
    requirement_type character varying(255),
    requirement_value integer
);


ALTER TABLE public.achievements OWNER TO postgres;

--
-- Name: levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.levels (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    difficulty character varying(100) NOT NULL,
    stars integer,
    locked boolean DEFAULT true NOT NULL,
    colorclass character varying(255)
);


ALTER TABLE public.levels OWNER TO postgres;

--
-- Name: levels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.levels_id_seq OWNER TO postgres;

--
-- Name: levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.levels_id_seq OWNED BY public.levels.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer CONSTRAINT "users_ID_not_null" NOT NULL,
    fullname character varying(100) CONSTRAINT users_full_name_not_null NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(200) NOT NULL,
    coincollected integer DEFAULT 0,
    currentlevel integer DEFAULT 1,
    completedlevel integer DEFAULT 0
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."users_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."users_ID_seq" OWNER TO postgres;

--
-- Name: users_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."users_ID_seq" OWNED BY public.users.id;


--
-- Name: levels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.levels ALTER COLUMN id SET DEFAULT nextval('public.levels_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public."users_ID_seq"'::regclass);


--
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.achievements VALUES ('first_steps', 'First Steps', 'Complete Level 1', 'completedlevel', 1);
INSERT INTO public.achievements VALUES ('coin_collector', 'Coin Collector', 'Collect 100 coins', 'coincollected', 100);
INSERT INTO public.achievements VALUES ('explorer', 'Explorer', 'Complete 3 levels', 'completedlevel', 3);
INSERT INTO public.achievements VALUES ('champion', 'Champion', 'Reach Level 5', 'currentlevel', 5);
INSERT INTO public.achievements VALUES ('master', 'Master', 'Complete all levels', 'completedlevel', 6);
INSERT INTO public.achievements VALUES ('wealthy', 'Wealthy', 'Collect 500 coins', 'coincollected', 500);


--
-- Data for Name: levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.levels VALUES (1, 'Mushroom Kingdom', 'Easy', 100, false, 'bg-green');
INSERT INTO public.levels VALUES (2, 'Desert Land', 'Easy', 150, true, 'bg-orange');
INSERT INTO public.levels VALUES (3, 'Water World', 'Medium', 200, true, 'bg-blue');
INSERT INTO public.levels VALUES (4, 'Giant Land', 'Medium', 250, true, 'bg-purple');
INSERT INTO public.levels VALUES (5, 'Sky World', 'Hard', 300, true, 'bg-light-blue');
INSERT INTO public.levels VALUES (6, 'Ice Land', 'Hard', 350, true, 'bg-indigo');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (6, 'OO', 'o@gmail.com', '1234', 0, 1, 0);
INSERT INTO public.users VALUES (5, 'mario joud', 'mariojoud@gmail.com', '1234', 462, 3, 2);
INSERT INTO public.users VALUES (7, 'yara', 'yara@gmail.com', '1234', 112, 2, 1);


--
-- Name: levels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.levels_id_seq', 1, false);


--
-- Name: users_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."users_ID_seq"', 7, true);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict 1DRfBMK5sWNKVEc5GVSeqCDPGXqNv2zTkX9477dDX0fzei5hBgtDTkUo4KVaPro

