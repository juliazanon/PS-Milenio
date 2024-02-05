--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Ubuntu 16.1-1.pgdg23.10+1)
-- Dumped by pg_dump version 16.1 (Ubuntu 16.1-1.pgdg23.10+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: migration_versions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migration_versions (
    id integer NOT NULL,
    version character varying(17) NOT NULL
);


ALTER TABLE public.migration_versions OWNER TO postgres;

--
-- Name: migration_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migration_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migration_versions_id_seq OWNER TO postgres;

--
-- Name: migration_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migration_versions_id_seq OWNED BY public.migration_versions.id;


--
-- Name: travel_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.travel_plans (
    id integer NOT NULL,
    travel_stops integer[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.travel_plans OWNER TO postgres;

--
-- Name: travel_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.travel_plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.travel_plans_id_seq OWNER TO postgres;

--
-- Name: travel_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.travel_plans_id_seq OWNED BY public.travel_plans.id;


--
-- Name: travel_plans_travel_stops; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.travel_plans_travel_stops (
    id integer NOT NULL,
    travel_plan_id integer,
    travel_stop_id integer
);


ALTER TABLE public.travel_plans_travel_stops OWNER TO postgres;

--
-- Name: travel_plans_travel_stops_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.travel_plans_travel_stops_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.travel_plans_travel_stops_id_seq OWNER TO postgres;

--
-- Name: travel_plans_travel_stops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.travel_plans_travel_stops_id_seq OWNED BY public.travel_plans_travel_stops.id;


--
-- Name: travel_stops; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.travel_stops (
    id integer NOT NULL,
    name character varying(254) NOT NULL,
    type character varying(254) NOT NULL,
    dimension character varying(254) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.travel_stops OWNER TO postgres;

--
-- Name: travel_stops_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.travel_stops_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.travel_stops_id_seq OWNER TO postgres;

--
-- Name: travel_stops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.travel_stops_id_seq OWNED BY public.travel_stops.id;


--
-- Name: migration_versions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migration_versions ALTER COLUMN id SET DEFAULT nextval('public.migration_versions_id_seq'::regclass);


--
-- Name: travel_plans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_plans ALTER COLUMN id SET DEFAULT nextval('public.travel_plans_id_seq'::regclass);


--
-- Name: travel_plans_travel_stops id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_plans_travel_stops ALTER COLUMN id SET DEFAULT nextval('public.travel_plans_travel_stops_id_seq'::regclass);


--
-- Name: travel_stops id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_stops ALTER COLUMN id SET DEFAULT nextval('public.travel_stops_id_seq'::regclass);


--
-- Name: migration_versions migration_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migration_versions
    ADD CONSTRAINT migration_versions_pkey PRIMARY KEY (id);


--
-- Name: travel_plans travel_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_plans
    ADD CONSTRAINT travel_plans_pkey PRIMARY KEY (id);


--
-- Name: travel_plans_travel_stops travel_plans_travel_stops_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_plans_travel_stops
    ADD CONSTRAINT travel_plans_travel_stops_pkey PRIMARY KEY (id);


--
-- Name: travel_stops travel_stops_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_stops
    ADD CONSTRAINT travel_stops_pkey PRIMARY KEY (id);


--
-- Name: travel_plans_travel_stops fk_cr_3a22f54713; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_plans_travel_stops
    ADD CONSTRAINT fk_cr_3a22f54713 FOREIGN KEY (travel_stop_id) REFERENCES public.travel_stops(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: travel_plans_travel_stops fk_cr_cdb51117f7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_plans_travel_stops
    ADD CONSTRAINT fk_cr_cdb51117f7 FOREIGN KEY (travel_plan_id) REFERENCES public.travel_plans(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

