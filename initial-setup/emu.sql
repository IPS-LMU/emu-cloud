--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Debian 10.4-2.pgdg90+1)
-- Dumped by pg_dump version 10.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: emu; Type: SCHEMA; Schema: -; Owner: database-user
--

CREATE SCHEMA emu;


ALTER SCHEMA emu OWNER TO "database-user";

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: permission; Type: TYPE; Schema: emu; Owner: database-user
--

CREATE TYPE emu.permission AS ENUM (
    'read',
    'write',
    'admin'
);


ALTER TYPE emu.permission OWNER TO "database-user";

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: permissions; Type: TABLE; Schema: emu; Owner: database-user
--

CREATE TABLE emu.permissions (
    project integer,
    username character varying(1024),
    permission emu.permission
);


ALTER TABLE emu.permissions OWNER TO "database-user";

--
-- Name: projects; Type: TABLE; Schema: emu; Owner: database-user
--

CREATE TABLE emu.projects (
    id integer NOT NULL,
    name character varying(1024),
    description character varying(1024)
);


ALTER TABLE emu.projects OWNER TO "database-user";

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: emu; Owner: database-user
--

CREATE SEQUENCE emu.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE emu.projects_id_seq OWNER TO "database-user";

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: emu; Owner: database-user
--

ALTER SEQUENCE emu.projects_id_seq OWNED BY emu.projects.id;


--
-- Name: projects id; Type: DEFAULT; Schema: emu; Owner: database-user
--

ALTER TABLE ONLY emu.projects ALTER COLUMN id SET DEFAULT nextval('emu.projects_id_seq'::regclass);


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: emu; Owner: database-user
--

COPY emu.permissions (project, username, permission) FROM stdin;
1	scientist1	admin
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: emu; Owner: database-user
--

COPY emu.projects (id, name, description) FROM stdin;
1	test-project	Description in a single sentence
\.


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: emu; Owner: database-user
--

SELECT pg_catalog.setval('emu.projects_id_seq', 1, true);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: emu; Owner: database-user
--

ALTER TABLE ONLY emu.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_project_fkey; Type: FK CONSTRAINT; Schema: emu; Owner: database-user
--

ALTER TABLE ONLY emu.permissions
    ADD CONSTRAINT permissions_project_fkey FOREIGN KEY (project) REFERENCES emu.projects(id);


--
-- PostgreSQL database dump complete
--

