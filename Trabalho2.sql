DROP DATABASE IF EXISTS garagem_coletiva;

CREATE DATABASE garagem_coletiva;

\c garagem_coletiva;

CREATE TABLE Cliente (
    cpf CHAR(11) PRIMARY KEY NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    endereco_rua VARCHAR(100),
    endereco_bairro VARCHAR(50),
    endereco_complemento VARCHAR(50),
    endereco_numero VARCHAR(10)
);

CREATE TABLE Modelo (
    id SERIAL PRIMARY KEY,
    descricao TEXT,
    ano_lancamento INTEGER CHECK (ano_lancamento > 1900)
);

CREATE TABLE Veiculo (
    placa CHAR(7) PRIMARY KEY NOT NULL,
    chassi CHAR(17) NOT NULL,
    cor VARCHAR(20),
    ano INT,
    cpf_cliente CHAR(11) REFERENCES Cliente(cpf),
    id_modelo INT REFERENCES Modelo(id)
);

CREATE TABLE Vaga (
    numero VARCHAR(2) PRIMARY KEY NOT NULL,
    andar VARCHAR(1)
);

CREATE TABLE Ocupacao (
    id SERIAL PRIMARY KEY,
    data_hora_entrada TIMESTAMP NOT NULL,
    data_hora_saida TIMESTAMP,
    valor_pago DECIMAL(10, 2),
    placa_veiculo CHAR(7) REFERENCES Veiculo(placa),
    id_vaga VARCHAR(2) REFERENCES Vaga(numero)
);

INSERT INTO Cliente
    (cpf, nome, data_nascimento, endereco_rua, endereco_bairro, endereco_complemento, endereco_numero) VALUES
        ('11111111111', 'Godofredo', '2006-06-14', 'Aquidaban', 'Centro', '', '420'),
        ('22222222222', 'Patrick', '1995-01-26', '24 de Maior', 'Centro', '', '120'),
        ('33333333333', 'Ronaldo Fenômeno', '1968-04-07', 'Bento Gonçalves', 'Cidade Nova', 'Apartamento 301', '154');

INSERT INTO Modelo (descricao, ano_lancamento) VALUES
('Toyota Ethios', 2012),
('Toyota Corolla', 1966),
('Toyota Hilux', 1968);

INSERT INTO Veiculo (chassi, placa, cor, ano, id_modelo, cpf_cliente) VALUES
('1234567890', 'ABC1020', 'preto', 2016, 1, '11111111111'),
('1234567891', 'DEF1021', 'cinza', 2020, 1, '11111111111'),
('1234567892', 'GHI1232', 'vermelho', 2015, 3, '22222222222'),
('0987654321', 'JKL1234', 'branco', 2003, 2, '33333333333');

INSERT INTO Vaga (numero, andar) VALUES
('1', '1'),
('2', '1'),
('3', '1'),
('4', '1'),
('5', '1'),
('6', '2'),
('7', '2'),
('8', '2'),
('9', '2'),
('10', '2');

INSERT INTO Ocupacao (id_vaga, placa_veiculo, data_hora_entrada, data_hora_saida, valor_pago) VALUES
('3', 'ABC1020', '2023-09-12 11:00:00', '2023-09-12 12:00:00', '2'),
('1', 'DEF1021', '2023-09-12 15:00:00', '2023-09-12 16:00:00', '2'),
('10', 'GHI1232', '2023-09-12 06:00:00', '2023-09-12 07:00:00', '2'),
('6', 'ABC1020', '2023-09-13 16:00:00', '2023-09-13 17:00:00', '2'),
('10', 'DEF1021', '2023-09-13 15:00:00', '2023-09-13 18:00:00', '6'),
('3', 'JKL1234', '2023-09-13 19:00:00', '2023-09-13 20:00:00', '2'),
('5', 'ABC1020', '2023-09-14 10:00:00', '2023-09-14 11:00:00', '2'),
('9', 'DEF1021', '2023-09-14 12:00:00', '2023-09-14 13:00:00', '2'),
('4', 'GHI1232', '2023-09-14 08:00:00', '2023-09-14 09:00:00', '2'),
('4', 'JKL1234', '2023-09-14 08:00:00', '2023-09-14 10:00:00', '4');

-- Exiba a placa e o ano do veículo de um determinado veículo
SELECT placa, ano FROM Veiculo WHERE cpf_cliente = '11111111111';

-- Exiba a placa, o ano do veículo do veículo, se ele possuir ano a partir de 2000
SELECT placa, ano FROM Veiculo WHERE ano > 2000;

-- Liste todos os carros do modelo 1
SELECT * FROM Veiculo WHERE id_modelo = 1;

-- Liste todos os estacionamentos de um veículo
SELECT * FROM Ocupacao WHERE placa_veiculo = 'ABC1020';

-- Quanto tempo um veículo ficou em uma determinada vaga?
SELECT id_vaga, placa_veiculo, 
    ROUND(EXTRACT(EPOCH FROM (data_hora_saida - data_hora_entrada)) / 3600) AS horas_ocupacao
FROM Ocupacao 
WHERE placa_veiculo = 'ABC1020' AND id_vaga = '3';

-- Quantidade de veículos de um determinado modelo
SELECT MIN(id_modelo) AS modelo, COUNT(*) AS quantidade
    FROM Veiculo WHERE id_modelo = 3;
    
-- Média de idade dos clientes
SELECT AVG(FLOOR((CURRENT_DATE - data_nascimento)/365.25)) AS media_idade FROM Cliente;

-- Se cada hora custa 2 reais, quanto cada veículo pagou? Obs: Somente horas inteiras valem para o cálculo
SELECT placa_veiculo, SUM(EXTRACT(HOUR FROM(data_hora_saida - data_hora_entrada)) * 2)
    AS valor_pago FROM Ocupacao GROUP BY placa_veiculo;
