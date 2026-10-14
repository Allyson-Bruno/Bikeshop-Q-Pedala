CREATE TABLE administrador (

	-- Dessa forma já cria a sequência e atribui na coluna.
 	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 	usuario VARCHAR (70) NOT NULL,
 	senha VARCHAR(255) NOT NULL,

	-- Falta: verificar se isso está correto.
	-- No caso se deixasse da outra maneira, o próprio SGBD nomearia a constraint.
	 CONSTRAINT uc_usario UNIQUE (usuario)
);

CREATE TABLE cliente (

 	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 	cpf VARCHAR(11) NOT NULL CHECK (cpf ~'^[0-9]{11}$'),
 	nome VARCHAR (120) NOT NULL,
 	data_nascimento DATE NOT NULL CHECK (data_nascimento <= CURRENT_DATE),
 	email VARCHAR(254) NOT NULL,
 	telefone VARCHAR(20) NOT NULL,

	CONSTRAINT uc_cpf UNIQUE (cpf)
	 
);

CREATE TABLE servico (

	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nome VARCHAR(120) NOT NULL,
	-- 10 dígitos, sendo 2 casas decimais.
	valor NUMERIC (10,2) NOT NULL CHECK (valor >= 0),

	CONSTRAINT uc_nome_servico UNIQUE (nome)
);

CREATE TABLE bicicleta (

	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	marca VARCHAR(60) NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,                 
    tamanho_quadro VARCHAR(30) NOT NULL, 
	numero_serie VARCHAR(50) NOT NULL,
    ano_fabricacao SMALLINT NOT NULL 
		CHECK (ano_fabricacao BETWEEN 1800 AND EXTRACT (YEAR FROM CURRENT_DATE)), 
	id_proprietario BIGINT,

 	FOREIGN KEY (id_proprietario) REFERENCES cliente (id),
	CONSTRAINT uc_numero_serie UNIQUE (numero_serie)
);

CREATE TABLE ordem_servico (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_bicicleta BIGINT NOT NULL,
    id_cliente BIGINT NOT NULL,
    data_agendamento DATE NOT NULL,
    data_execucao DATE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('AGENDADA', 'EXECUTADA', 'PAGA', 'CANCELADA')),
    desconto NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (desconto >= 0),
    valor_total NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (valor_total >= 0),

    FOREIGN KEY (id_bicicleta) REFERENCES bicicleta(id),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)
);

CREATE TABLE item_ordem_servico (
	
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	id_ordem_servico BIGINT NOT NULL,
	id_servico BIGINT NOT NULL,
	-- Se não foi executado, não pode ter valor. Se foi executado, obrigatoriamente deve ter um valor válido.
	valor NUMERIC(10,2),
	executado BOOLEAN NOT NULL DEFAULT FALSE, 
	
	CHECK ((executado = FALSE AND valor IS NULL) OR
    (executado = TRUE AND valor IS NOT NULL AND valor >= 0)),
	
	FOREIGN KEY (id_ordem_servico) REFERENCES ordem_servico (id),
	FOREIGN KEY (id_servico) REFERENCES servico(id),

	CONSTRAINT uc_ordem_servico UNIQUE (id_ordem_servico, id_servico)

);

--Índice responsável por implementar "Uma bicicleta não pode possuir mais de uma OS agendada para a mesma data."
CREATE UNIQUE INDEX uq_bicicleta_agendamento ON ordem_servico (id_bicicleta, data_agendamento)
	WHERE status = 'AGENDADA';



