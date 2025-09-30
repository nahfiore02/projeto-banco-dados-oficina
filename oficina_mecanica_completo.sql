-- CONFIGURAÇÃO INICIAL
CREATE SCHEMA IF NOT EXISTS OficinaMecanica;
USE OficinaMecanica;

-- PARTE 1: CRIAÇÃO DO ESQUEMA (DDL)

-- 1. CLIENTE
CREATE TABLE CLIENTE (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(14) UNIQUE NOT NULL,
    endereco VARCHAR(255),
    telefone VARCHAR(15)
);

-- 2. VEICULO
CREATE TABLE VEICULO (
    placa CHAR(7) PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    ano YEAR,
    cor VARCHAR(20),
    id_cliente INT NOT NULL,
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);

-- 3. MECANICO
CREATE TABLE MECANICO (
    cod_mecanico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255),
    especialidade VARCHAR(50)
);

-- 4. EQUIPE
CREATE TABLE EQUIPE (
    id_equipe INT AUTO_INCREMENT PRIMARY KEY,
    nome_equipe VARCHAR(50) UNIQUE NOT NULL
);

-- 5. MECANICO_EQUIPE (N:N entre Mecanico e Equipe)
CREATE TABLE MECANICO_EQUIPE (
    cod_mecanico INT NOT NULL,
    id_equipe INT NOT NULL,
    PRIMARY KEY (cod_mecanico, id_equipe),
    CONSTRAINT fk_me_mecanico FOREIGN KEY (cod_mecanico) REFERENCES MECANICO(cod_mecanico),
    CONSTRAINT fk_me_equipe FOREIGN KEY (id_equipe) REFERENCES EQUIPE(id_equipe)
);

-- 6. OS (Ordem de Serviço)
CREATE TABLE OS (
    num_os INT AUTO_INCREMENT PRIMARY KEY,
    data_emissao DATE NOT NULL,
    valor_total DECIMAL(10, 2) DEFAULT 0.00,
    status ENUM('Em análise', 'Autorizada', 'Em execução', 'Concluída') DEFAULT 'Em análise',
    data_conclusao_prevista DATE,
    placa_veiculo CHAR(7) NOT NULL,
    id_equipe INT NOT NULL,
    CONSTRAINT fk_os_veiculo FOREIGN KEY (placa_veiculo) REFERENCES VEICULO(placa),
    CONSTRAINT fk_os_equipe FOREIGN KEY (id_equipe) REFERENCES EQUIPE(id_equipe)
);

-- 7. SERVICO (Tabela de Mão de Obra)
CREATE TABLE SERVICO (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    preco_mao_de_obra DECIMAL(10, 2) NOT NULL
);

-- 8. PECA
CREATE TABLE PECA (
    cod_peca INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL
);

-- 9. ITENS_SERVICO (N:N entre OS e Servico)
CREATE TABLE ITENS_SERVICO (
    num_os INT NOT NULL,
    id_servico INT NOT NULL,
    PRIMARY KEY (num_os, id_servico),
    CONSTRAINT fk_is_os FOREIGN KEY (num_os) REFERENCES OS(num_os),
    CONSTRAINT fk_is_servico FOREIGN KEY (id_servico) REFERENCES SERVICO(id_servico)
);

-- 10. ITENS_PECA (N:N entre OS e Peça)
CREATE TABLE ITENS_PECA (
    num_os INT NOT NULL,
    cod_peca INT NOT NULL,
    quantidade_utilizada INT NOT NULL,
    valor_total_peca DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (num_os, cod_peca),
    CONSTRAINT fk_ip_os FOREIGN KEY (num_os) REFERENCES OS(num_os),
    CONSTRAINT fk_ip_peca FOREIGN KEY (cod_peca) REFERENCES PECA(cod_peca)
);

-- FIM DO DDL
----------------------------------------------------------------------

-- PARTE 2: INSERÇÃO DE DADOS DE TESTE (DML)

-- Insere Clientes
INSERT INTO CLIENTE (nome, cpf_cnpj, endereco, telefone) VALUES
('João da Silva', '11122233344', 'Rua A, 100', '11987654321'),
('Maria Souza', '22233344455', 'Av B, 50', '21998765432'),
('Auto Express LTDA', '00012345678912', 'Rua C, 200', '3132109876');

-- Insere Veículos
INSERT INTO VEICULO (placa, modelo, marca, ano, cor, id_cliente) VALUES
('ABC1234', 'Gol', 'Volkswagen', 2018, 'Prata', 1),
('XYZ9876', 'Corolla', 'Toyota', 2021, 'Preto', 2),
('PQR5678', 'Cargo 816', 'Ford', 2015, 'Branco', 3);

-- Insere Mecânicos
INSERT INTO MECANICO (nome, endereco, especialidade) VALUES
('Pedro Alvares', 'Rua D, 10', 'Motor/Injeção'),
('Ana Paula', 'Av E, 20', 'Suspensão/Freios'),
('Carlos Rocha', 'Rua F, 30', 'Eletricista');

-- Insere Equipes
INSERT INTO EQUIPE (nome_equipe) VALUES
('Equipe Alpha'),
('Equipe Beta');

-- Associa Mecânicos às Equipes
INSERT INTO MECANICO_EQUIPE (cod_mecanico, id_equipe) VALUES
(1, 1),
(2, 1),
(3, 2);

-- Insere Serviços (Mão de Obra de Referência)
INSERT INTO SERVICO (descricao, preco_mao_de_obra) VALUES
('Troca de Óleo e Filtros', 80.00),
('Revisão Completa de Freios', 150.00),
('Diagnóstico Elétrico', 120.00),
('Substituição de Amortecedores', 200.00);

-- Insere Peças
INSERT INTO PECA (nome, valor_unitario) VALUES
('Filtro de Óleo', 35.50),
('Pastilha de Freio', 90.00),
('Amortecedor Dianteiro', 350.00);

-- Insere Ordens de Serviço (OS)
INSERT INTO OS (data_emissao, status, data_conclusao_prevista, placa_veiculo, id_equipe) VALUES
('2025-09-28', 'Autorizada', '2025-09-30', 'ABC1234', 1), -- OS 1: Gol (Equipe Alpha)
('2025-09-29', 'Em execução', '2025-10-02', 'XYZ9876', 2); -- OS 2: Corolla (Equipe Beta)

-- Detalha os Serviços e Peças da OS 1
INSERT INTO ITENS_SERVICO (num_os, id_servico) VALUES (1, 1), (1, 2);
INSERT INTO ITENS_PECA (num_os, cod_peca, quantidade_utilizada, valor_total_peca) VALUES
(1, 1, 1, 35.50),
(1, 2, 1, 90.00);

-- Detalha os Serviços e Peças da OS 2
INSERT INTO ITENS_SERVICO (num_os, id_servico) VALUES (2, 4), (2, 3);
INSERT INTO ITENS_PECA (num_os, cod_peca, quantidade_utilizada, valor_total_peca) VALUES
(2, 3, 2, 700.00);
