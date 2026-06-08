--
-- PostgreSQL database dump
--

\restrict XbE8fQQal7Q7jHa5LfOeBAQCe07MRoD0KF7Vqp8fovbxQmZbKmw2bDG2agtEi22

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-06-08 20:26:00

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
-- TOC entry 223 (class 1259 OID 16446)
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
-- TOC entry 221 (class 1259 OID 16430)
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
-- TOC entry 222 (class 1259 OID 16433)
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
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 222
-- Name: levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.levels_id_seq OWNED BY public.levels.id;


--
-- TOC entry 220 (class 1259 OID 16416)
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
-- TOC entry 219 (class 1259 OID 16415)
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
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."users_ID_seq" OWNED BY public.users.id;


--
-- TOC entry 4869 (class 2604 OID 16434)
-- Name: levels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.levels ALTER COLUMN id SET DEFAULT nextval('public.levels_id_seq'::regclass);


--
-- TOC entry 4865 (class 2604 OID 16419)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public."users_ID_seq"'::regclass);


--
-- TOC entry 4872 (class 2606 OID 16427)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


-- Completed on 2026-06-08 20:26:00

--
-- PostgreSQL database dump complete
--

\unrestrict XbE8fQQal7Q7jHa5LfOeBAQCe07MRoD0KF7Vqp8fovbxQmZbKmw2bDG2agtEi22

