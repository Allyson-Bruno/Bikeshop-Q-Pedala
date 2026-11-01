--
-- PostgreSQL database dump
--

\restrict gnIwtypkEb1gJ1EhIoCIsODniu5DucO45kcbD3WjbMbj6q89v3Y0HQj7OxjrcbT

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-11-01 12:37:40

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
-- TOC entry 220 (class 1259 OID 24785)
-- Name: administrador; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.administrador (
    id bigint NOT NULL,
    usuario character varying(70) NOT NULL,
    senha character varying(255) NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 24784)
-- Name: administrador_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.administrador ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.administrador_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 24824)
-- Name: bicicleta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bicicleta (
    id bigint NOT NULL,
    marca character varying(60) NOT NULL,
    modelo character varying(100) NOT NULL,
    tipo character varying(50) NOT NULL,
    tamanho_quadro character varying(30) NOT NULL,
    numero_serie character varying(50) NOT NULL,
    ano_fabricacao smallint NOT NULL,
    id_proprietario bigint,
    CONSTRAINT bicicleta_ano_fabricacao_check CHECK (((ano_fabricacao >= 1800) AND ((ano_fabricacao)::numeric <= EXTRACT(year FROM CURRENT_DATE))))
);


--
-- TOC entry 225 (class 1259 OID 24823)
-- Name: bicicleta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.bicicleta ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.bicicleta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 24796)
-- Name: cliente; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cliente (
    id bigint NOT NULL,
    cpf character varying(11) NOT NULL,
    nome character varying(120) NOT NULL,
    data_nascimento date NOT NULL,
    email character varying(254) NOT NULL,
    telefone character varying(20) NOT NULL,
    CONSTRAINT cliente_cpf_check CHECK (((cpf)::text ~ '^[0-9]{11}$'::text)),
    CONSTRAINT cliente_data_nascimento_check CHECK ((data_nascimento <= CURRENT_DATE))
);


--
-- TOC entry 221 (class 1259 OID 24795)
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.cliente ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.cliente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 24873)
-- Name: item_ordem_servico; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_ordem_servico (
    id bigint NOT NULL,
    id_ordem_servico bigint NOT NULL,
    id_servico bigint NOT NULL,
    valor numeric(10,2),
    executado boolean DEFAULT false NOT NULL,
    CONSTRAINT item_ordem_servico_check CHECK ((((executado = false) AND (valor IS NULL)) OR ((executado = true) AND (valor IS NOT NULL) AND (valor >= (0)::numeric))))
);


--
-- TOC entry 229 (class 1259 OID 24872)
-- Name: item_ordem_servico_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.item_ordem_servico ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.item_ordem_servico_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 24845)
-- Name: ordem_servico; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ordem_servico (
    id bigint NOT NULL,
    id_bicicleta bigint NOT NULL,
    id_cliente bigint NOT NULL,
    data_agendamento date NOT NULL,
    data_execucao date,
    status character varying(20) NOT NULL,
    desconto numeric(10,2) DEFAULT 0 NOT NULL,
    valor_total numeric(10,2) DEFAULT 0 NOT NULL,
    CONSTRAINT ordem_servico_desconto_check CHECK ((desconto >= (0)::numeric)),
    CONSTRAINT ordem_servico_status_check CHECK (((status)::text = ANY ((ARRAY['AGENDADA'::character varying, 'EXECUTADA'::character varying, 'PAGA'::character varying, 'CANCELADA'::character varying])::text[]))),
    CONSTRAINT ordem_servico_valor_total_check CHECK ((valor_total >= (0)::numeric))
);


--
-- TOC entry 227 (class 1259 OID 24844)
-- Name: ordem_servico_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.ordem_servico ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ordem_servico_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 24812)
-- Name: servico; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.servico (
    id bigint NOT NULL,
    nome character varying(120) NOT NULL,
    valor numeric(10,2) NOT NULL,
    CONSTRAINT servico_valor_check CHECK ((valor >= (0)::numeric))
);


--
-- TOC entry 223 (class 1259 OID 24811)
-- Name: servico_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.servico ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.servico_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 5068 (class 0 OID 24785)
-- Dependencies: 220
-- Data for Name: administrador; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.administrador (id, usuario, senha) OVERRIDING SYSTEM VALUE VALUES (2, 'all', '$2a$12$iT1bunquplWaXJazVczMtOBDiKhAacU63o2IpI0xxyH1kOKV6w9cG');


--
-- TOC entry 5074 (class 0 OID 24824)
-- Dependencies: 226
-- Data for Name: bicicleta; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.bicicleta (id, marca, modelo, tipo, tamanho_quadro, numero_serie, ano_fabricacao, id_proprietario) OVERRIDING SYSTEM VALUE VALUES (1, 'Caloi', 'Explorer', 'MTB', '17', 'TESTE-BIKE-001', 2022, 2);
INSERT INTO public.bicicleta (id, marca, modelo, tipo, tamanho_quadro, numero_serie, ano_fabricacao, id_proprietario) OVERRIDING SYSTEM VALUE VALUES (2, 'Sense', 'Impact', 'MTB', 'M', 'TESTE-BIKE-002', 2024, NULL);
INSERT INTO public.bicicleta (id, marca, modelo, tipo, tamanho_quadro, numero_serie, ano_fabricacao, id_proprietario) OVERRIDING SYSTEM VALUE VALUES (3, 'Specialized', 'Allez', 'Road', '54', 'TESTE-BIKE-003', 2020, 1);
INSERT INTO public.bicicleta (id, marca, modelo, tipo, tamanho_quadro, numero_serie, ano_fabricacao, id_proprietario) OVERRIDING SYSTEM VALUE VALUES (5, 'Trek', 'Marlin 5', 'MTB', 'M', 'TESTE-BIKE-004', 2023, NULL);


--
-- TOC entry 5070 (class 0 OID 24796)
-- Dependencies: 222
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.cliente (id, cpf, nome, data_nascimento, email, telefone) OVERRIDING SYSTEM VALUE VALUES (1, '15041909636', 'Cris Alvez', '2026-10-11', 'cris19@gmail.com', '3288114535');
INSERT INTO public.cliente (id, cpf, nome, data_nascimento, email, telefone) OVERRIDING SYSTEM VALUE VALUES (2, '52998224725', 'Mariana Teste', '2026-09-15', 'mari@gmail.com', '328845679');
INSERT INTO public.cliente (id, cpf, nome, data_nascimento, email, telefone) OVERRIDING SYSTEM VALUE VALUES (6, '16899535009', 'Ravi Garcia', '2025-10-28', 'ravi@gmail.com', '(32) 9 8811-4534');


--
-- TOC entry 5078 (class 0 OID 24873)
-- Dependencies: 230
-- Data for Name: item_ordem_servico; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (1, 1, 8, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (2, 1, 10, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (3, 1, 3, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (4, 2, 8, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (5, 2, 2, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (6, 5, 3, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (7, 5, 4, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (8, 5, 1, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (9, 7, 8, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (10, 7, 10, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (11, 7, 2, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (12, 7, 5, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (18, 9, 1, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (19, 10, 8, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (20, 10, 5, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (21, 10, 7, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (22, 10, 6, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (23, 10, 9, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (24, 11, 5, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (26, 11, 6, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (13, 8, 1, 150.00, true);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (25, 11, 7, 50.00, true);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (27, 12, 1, 175.00, true);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (28, 12, 7, 50.00, true);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (29, 13, 2, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (30, 13, 5, NULL, false);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (31, 14, 1, 175.00, true);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (32, 14, 2, 250.00, true);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (33, 14, 5, 80.00, true);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (14, 9, 8, 60.00, true);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (15, 9, 10, 50.00, true);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (16, 9, 3, 50.00, true);
INSERT INTO public.item_ordem_servico (id, id_ordem_servico, id_servico, valor, executado) OVERRIDING SYSTEM VALUE VALUES (17, 9, 4, 40.00, true);


--
-- TOC entry 5076 (class 0 OID 24845)
-- Dependencies: 228
-- Data for Name: ordem_servico; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.ordem_servico (id, id_bicicleta, id_cliente, data_agendamento, data_execucao, status, desconto, valor_total) OVERRIDING SYSTEM VALUE VALUES (1, 1, 2, '2026-10-24', NULL, 'CANCELADA', 0.00, 0.00);
INSERT INTO public.ordem_servico (id, id_bicicleta, id_cliente, data_agendamento, data_execucao, status, desconto, valor_total) OVERRIDING SYSTEM VALUE VALUES (5, 1, 2, '2026-10-30', NULL, 'CANCELADA', 0.00, 0.00);
INSERT INTO public.ordem_servico (id, id_bicicleta, id_cliente, data_agendamento, data_execucao, status, desconto, valor_total) OVERRIDING SYSTEM VALUE VALUES (7, 1, 2, '2026-10-31', NULL, 'CANCELADA', 0.00, 0.00);
INSERT INTO public.ordem_servico (id, id_bicicleta, id_cliente, data_agendamento, data_execucao, status, desconto, valor_total) OVERRIDING SYSTEM VALUE VALUES (2, 3, 1, '2026-10-24', NULL, 'CANCELADA', 0.00, 0.00);
INSERT INTO public.ordem_servico (id, id_bicicleta, id_cliente, data_agendamento, data_execucao, status, desconto, valor_total) OVERRIDING SYSTEM VALUE VALUES (10, 3, 1, '2026-10-24', NULL, 'AGENDADA', 0.00, 0.00);
INSERT INTO public.ordem_servico (id, id_bicicleta, id_cliente, data_agendamento, data_execucao, status, desconto, valor_total) OVERRIDING SYSTEM VALUE VALUES (8, 1, 2, '2026-11-20', '2026-10-04', 'EXECUTADA', 0.00, 150.00);
INSERT INTO public.ordem_servico (id, id_bicicleta, id_cliente, data_agendamento, data_execucao, status, desconto, valor_total) OVERRIDING SYSTEM VALUE VALUES (13, 1, 2, '2026-10-30', NULL, 'AGENDADA', 0.00, 0.00);
INSERT INTO public.ordem_servico (id, id_bicicleta, id_cliente, data_agendamento, data_execucao, status, desconto, valor_total) OVERRIDING SYSTEM VALUE VALUES (12, 1, 2, '2026-10-30', '2026-10-28', 'PAGA', 0.00, 225.00);
INSERT INTO public.ordem_servico (id, id_bicicleta, id_cliente, data_agendamento, data_execucao, status, desconto, valor_total) OVERRIDING SYSTEM VALUE VALUES (9, 3, 1, '2026-11-21', '2026-10-26', 'PAGA', 20.00, 200.00);
INSERT INTO public.ordem_servico (id, id_bicicleta, id_cliente, data_agendamento, data_execucao, status, desconto, valor_total) OVERRIDING SYSTEM VALUE VALUES (14, 1, 2, '2026-12-25', '2026-10-28', 'PAGA', 0.00, 505.00);
INSERT INTO public.ordem_servico (id, id_bicicleta, id_cliente, data_agendamento, data_execucao, status, desconto, valor_total) OVERRIDING SYSTEM VALUE VALUES (11, 3, 1, '2026-12-18', '2026-10-19', 'PAGA', 0.00, 50.00);


--
-- TOC entry 5072 (class 0 OID 24812)
-- Dependencies: 224
-- Data for Name: servico; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.servico (id, nome, valor) OVERRIDING SYSTEM VALUE VALUES (2, 'Revisão completa', 250.00);
INSERT INTO public.servico (id, nome, valor) OVERRIDING SYSTEM VALUE VALUES (3, 'Regulagem do câmbio', 50.00);
INSERT INTO public.servico (id, nome, valor) OVERRIDING SYSTEM VALUE VALUES (4, 'Regulagem dos freios', 40.00);
INSERT INTO public.servico (id, nome, valor) OVERRIDING SYSTEM VALUE VALUES (5, 'Sangria de freio hidráulico', 80.00);
INSERT INTO public.servico (id, nome, valor) OVERRIDING SYSTEM VALUE VALUES (6, 'Troca de corrente', 40.00);
INSERT INTO public.servico (id, nome, valor) OVERRIDING SYSTEM VALUE VALUES (7, 'Troca de cassete', 50.00);
INSERT INTO public.servico (id, nome, valor) OVERRIDING SYSTEM VALUE VALUES (9, 'Troca de pneu', 30.00);
INSERT INTO public.servico (id, nome, valor) OVERRIDING SYSTEM VALUE VALUES (10, 'Limpeza e lubrificação', 50.00);
INSERT INTO public.servico (id, nome, valor) OVERRIDING SYSTEM VALUE VALUES (8, 'Alinhamento de roda', 60.00);
INSERT INTO public.servico (id, nome, valor) OVERRIDING SYSTEM VALUE VALUES (1, 'Revisão básica', 175.00);


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 219
-- Name: administrador_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.administrador_id_seq', 3, true);


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 225
-- Name: bicicleta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bicicleta_id_seq', 5, true);


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 221
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cliente_id_seq', 6, true);


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 229
-- Name: item_ordem_servico_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.item_ordem_servico_id_seq', 33, true);


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 227
-- Name: ordem_servico_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ordem_servico_id_seq', 14, true);


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 223
-- Name: servico_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.servico_id_seq', 11, true);


--
-- TOC entry 4893 (class 2606 OID 24792)
-- Name: administrador administrador_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.administrador
    ADD CONSTRAINT administrador_pkey PRIMARY KEY (id);


--
-- TOC entry 4905 (class 2606 OID 24836)
-- Name: bicicleta bicicleta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bicicleta
    ADD CONSTRAINT bicicleta_pkey PRIMARY KEY (id);


--
-- TOC entry 4897 (class 2606 OID 24808)
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id);


--
-- TOC entry 4912 (class 2606 OID 24883)
-- Name: item_ordem_servico item_ordem_servico_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_ordem_servico
    ADD CONSTRAINT item_ordem_servico_pkey PRIMARY KEY (id);


--
-- TOC entry 4909 (class 2606 OID 24861)
-- Name: ordem_servico ordem_servico_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordem_servico
    ADD CONSTRAINT ordem_servico_pkey PRIMARY KEY (id);


--
-- TOC entry 4901 (class 2606 OID 24820)
-- Name: servico servico_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servico
    ADD CONSTRAINT servico_pkey PRIMARY KEY (id);


--
-- TOC entry 4899 (class 2606 OID 24810)
-- Name: cliente uc_cpf; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT uc_cpf UNIQUE (cpf);


--
-- TOC entry 4903 (class 2606 OID 24822)
-- Name: servico uc_nome_servico; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servico
    ADD CONSTRAINT uc_nome_servico UNIQUE (nome);


--
-- TOC entry 4907 (class 2606 OID 24838)
-- Name: bicicleta uc_numero_serie; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bicicleta
    ADD CONSTRAINT uc_numero_serie UNIQUE (numero_serie);


--
-- TOC entry 4914 (class 2606 OID 24885)
-- Name: item_ordem_servico uc_ordem_servico; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_ordem_servico
    ADD CONSTRAINT uc_ordem_servico UNIQUE (id_ordem_servico, id_servico);


--
-- TOC entry 4895 (class 2606 OID 24794)
-- Name: administrador uc_usario; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.administrador
    ADD CONSTRAINT uc_usario UNIQUE (usuario);


--
-- TOC entry 4910 (class 1259 OID 24896)
-- Name: uq_bicicleta_agendamento; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_bicicleta_agendamento ON public.ordem_servico USING btree (id_bicicleta, data_agendamento) WHERE ((status)::text = 'AGENDADA'::text);


--
-- TOC entry 4915 (class 2606 OID 24839)
-- Name: bicicleta bicicleta_id_proprietario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bicicleta
    ADD CONSTRAINT bicicleta_id_proprietario_fkey FOREIGN KEY (id_proprietario) REFERENCES public.cliente(id);


--
-- TOC entry 4918 (class 2606 OID 24886)
-- Name: item_ordem_servico item_ordem_servico_id_ordem_servico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_ordem_servico
    ADD CONSTRAINT item_ordem_servico_id_ordem_servico_fkey FOREIGN KEY (id_ordem_servico) REFERENCES public.ordem_servico(id);


--
-- TOC entry 4919 (class 2606 OID 24891)
-- Name: item_ordem_servico item_ordem_servico_id_servico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_ordem_servico
    ADD CONSTRAINT item_ordem_servico_id_servico_fkey FOREIGN KEY (id_servico) REFERENCES public.servico(id);


--
-- TOC entry 4916 (class 2606 OID 24862)
-- Name: ordem_servico ordem_servico_id_bicicleta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordem_servico
    ADD CONSTRAINT ordem_servico_id_bicicleta_fkey FOREIGN KEY (id_bicicleta) REFERENCES public.bicicleta(id);


--
-- TOC entry 4917 (class 2606 OID 24867)
-- Name: ordem_servico ordem_servico_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordem_servico
    ADD CONSTRAINT ordem_servico_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.cliente(id);


-- Completed on 2026-11-01 12:37:41

--
-- PostgreSQL database dump complete
--

\unrestrict gnIwtypkEb1gJ1EhIoCIsODniu5DucO45kcbD3WjbMbj6q89v3Y0HQj7OxjrcbT

