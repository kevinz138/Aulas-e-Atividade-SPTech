-- EX1
CREATE DATABASE sprint2;

USE SPRINT2;

CREATE TABLE atleta (
idAtleta INT PRIMARY KEY,
nome VARCHAR(40),
modalidade VARCHAR(40),
qtdMedalha INT
);

INSERT INTO atleta VALUES
(1, 'Kevin', 'Natação', 14),
(2, 'Alexandriny', 'Futebol', 0),
(3, 'Gustavo', 'Musculação', 3),
(4, 'Gabriel', 'Beach Tenis', 22),
(5, 'Kaik', 'Tenis de Mesa', 2),
(6, 'Nicolas', 'Futebol', 0),
(7, 'Rafael', 'Musculação', 6),
(8, 'Davidy', 'Tenis de Mesa', 100),
(9, 'Pedro', 'Beach Tenis', 300),
(10, 'Paulo', 'Natação', 1);

CREATE TABLE pais (
idPais INT PRIMARY KEY,
nome VARCHAR(30),
capital VARCHAR(40)
);

INSERT INTO pais VALUES
(1, 'Angola', 'Luanda'),
(2, 'Brasil', 'Brasilia'),
(3, 'Chile', 'Pimenta'),
(4, 'México', 'Guacamole');

ALTER TABLE atleta ADD COLUMN fkPais INT;

ALTER TABLE atleta ADD CONSTRAINT fkPais
	FOREIGN KEY (fkPais)
		REFERENCES pais(idPais);
        
UPDATE atleta SET fkPais = 1
	WHERE idAtleta IN (1,4);
    
UPDATE atleta SET fkPais = 2
	WHERE idAtleta IN (2,3,7);
    
UPDATE atleta SET fkPais = 3
	WHERE idAtleta IN (5,9);
    
UPDATE atleta SET fkPais = 4
	WHERE idAtleta IN (6,8,10);

SELECT * FROM atleta
	JOIN pais ON fkPais = idPais;
    
SELECT a.nome AS Nome,
	p.nome AS Pais FROM atleta AS a
	JOIN pais AS p ON fkPais = idPais;
    
SELECT a.*,
	p.* FROM atleta AS a
	JOIN pais AS p ON fkPais = idPais
    WHERE p.capital = 'Brasilia';
    
    
-- EX2
CREATE TABLE musica (
idMusica INT PRIMARY KEY AUTO_INCREMENT,
titulo VARCHAR(40),
genero VARCHAR(40)
);

INSERT INTO musica (titulo, genero) VALUES
('Rise UP', 'Sad'),
('Jane!', 'Rock'),
('500 Miles', 'Bossa Nova'),
('Steven Universe', 'Lo-fi');

CREATE TABLE album (
idAlbum INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(40),
tipo VARCHAR(10),
CONSTRAINT chkTipo CHECK(tipo IN ('Digital','Físico')),
dtLancamento DATE
);

INSERT INTO album (nome, tipo, dtLancamento) VALUES
('Ale Pop', 'Físico', '2026-09-29'),
('GustRock', 'Digital', '2008-02-05');

SELECT * FROM musica;
SELECT * FROM album;

ALTER TABLE musica ADD COLUMN fkAlbum INT;
ALTER TABLE musica ADD CONSTRAINT fkAlbum
	FOREIGN KEY (fkAlbum)
		REFERENCES album(idAlbum);
        
UPDATE musica SET fkAlbum = 1
	WHERE idMusica IN (2,3);
    
UPDATE musica SET fkAlbum = 2
	WHERE idMusica = 1;
    
SELECT m.*,
	a.* FROM musica AS m
		JOIN album AS a ON fkAlbum = idAlbum;
        
SELECT musica.titulo AS Titulo,
	album.nome AS Album FROM musica
    JOIN album ON fkAlbum = idAlbum;
    
SELECT musica.titulo AS Titulo,
	album.nome AS Album FROM musica
    JOIN album ON fkAlbum = idAlbum
    WHERE nome = 'Ale Pop';
    

-- EX3
CREATE TABLE pessoa (
idPessoa INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45),
cpf CHAR(11)
);

CREATE TABLE reserva (
idReserva INT PRIMARY KEY AUTO_INCREMENT,
dtReserva DATETIME,
dtRetirada DATETIME,
dtDevolucao DATETIME,
fkPessoa INT,
CONSTRAINT fkPessoaReserva 
	FOREIGN KEY (fkPessoa)
		REFERENCES pessoa(idPessoa)
);

INSERT INTO pessoa (nome, cpf) VALUES
('Kevin', '41039647820'),
('Gustavo', '99988877765'),
('Alexandriny', '99887766554'),
('Giovanna', '98741032109'),
('Ana', '01234567890');

INSERT INTO reserva VALUES
(default, '2026-09-10 15:49:34', '2026-09-15 11:30:00', '2026-09-18 14:00:00', 1),
(default, '2026-09-11 10:15:20', '2026-09-20 14:00:00', '2026-09-25 10:00:00', 2),
(default, '2026-09-12 18:30:45', '2026-10-01 12:00:00', '2026-10-05 11:00:00', 3),
(default, '2026-09-13 09:05:12', '2026-10-10 15:00:00', '2026-10-12 12:00:00', 4),
(default, '2026-09-14 21:40:00', '2026-10-15 08:30:00', '2026-10-20 18:00:00', 5);

SELECT * FROM pessoa;
SELECT * FROM reserva;

SELECT p.* ,
	r.* FROM pessoa AS p
		JOIN reserva AS r ON fkPessoa = idPessoa
        WHERE idPessoa = 5;
        
SELECT *,
	CASE
		WHEN cpf LIKE '%410%' THEN 'RICO'
        ELSE 'POBRE'
	END AS Statuss
FROM pessoa JOIN reserva
	ON fkPessoa = idPessoa;
    
-- EX4
CREATE TABLE pessoa1 (
    idPessoa1 INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    dtNascimento DATE
);

CREATE TABLE pessoa2 (
    idPessoa2 INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    dtNascimento DATE,
    fkPessoa1 INT,
    CONSTRAINT fkPessoa2Pessoa1 FOREIGN KEY (fkPessoa1) REFERENCES pessoa1(idPessoa1)
);

INSERT INTO pessoa1 (nome, dtNascimento) VALUES
('Adriana', '2005-03-15'),
('Bernardo', '2002-07-22'),
('Caio', '1998-11-05'),
('Daniela', '2001-01-30'),
('Eduardo', '1995-09-12');

INSERT INTO pessoa2 (nome, dtNascimento, fkPessoa1) VALUES
('Marcos', '1985-04-10', 1),
('Patricia', '1992-08-19', 2),
('Thiago', '1999-12-01', 3),
('Vanessa', '1978-02-14', 4),
('Ronaldo', '2003-06-25', 5);

SELECT * FROM pessoa1;
SELECT * FROM pessoa2;

SELECT p1.idPessoa1 AS pessoa1, p2.nome AS pessoa2 
FROM pessoa1 AS p1 
JOIN pessoa2 AS p2 ON p1.idPessoa1 = p2.fkPessoa1;

SELECT nome,
CASE
    WHEN dtNascimento < '2000-01-01' THEN 'Alfa'
    ELSE 'Beta'
END AS Dinossauros
FROM pessoa2;

SELECT nome, IFNULL(nome, 'Sem nome') AS ConsultNomes FROM pessoa1;


-- EX5
CREATE TABLE candidato (
    idCandidato INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE
);

CREATE TABLE processo_cnh (
    idProcesso INT PRIMARY KEY AUTO_INCREMENT,
    categoriaPretendida VARCHAR(10) NOT NULL,
    CONSTRAINT chk_categoriaP CHECK (categoriaPretendida IN ('A','B','AB')),
    validadeAnos INT DEFAULT 1,
    dtSolicitacao DATE NOT NULL,
    fkCandidato INT UNIQUE,
    CONSTRAINT fkProcessoCandidato FOREIGN KEY (fkCandidato) REFERENCES candidato(idCandidato)
);

INSERT INTO candidato (nome, cpf) VALUES
('Amanda', '10120230340'),
('Bruno', '20230340450'),
('Carla', '30340450560'),
('Daniel', '40450560670'),
('Elena', '50560670780');

INSERT INTO processo_cnh (categoriaPretendida, validadeAnos, dtSolicitacao, fkCandidato) VALUES
('B', 1, '2026-01-15', 1),
('A', 1, '2026-02-20', 2),
('AB', 1, '2026-03-10', 3),
('A', 1, '2026-04-05', 4),
('B', 1, '2026-05-12', 5);

SELECT * FROM processo_cnh;
SELECT * FROM candidato;

SELECT c.nome AS Nome,
       c.cpf AS CPF,
       p.categoriaPretendida AS Categoria,
       p.validadeAnos AS ValidadeCNH,
       p.dtSolicitacao AS Solicitacao
FROM candidato AS c 
JOIN processo_cnh AS p ON c.idCandidato = p.fkCandidato;

SELECT nome,
CASE 
    WHEN nome LIKE 'A%' THEN 'Seu nome começa com A'
    ELSE 'Seu nome não começa com a letra A'
END AS Inicial
FROM candidato;

SELECT categoriaPretendida,
IFNULL(categoriaPretendida, 'Vai escolher não?') AS categoria
FROM processo_cnh;


-- EX6
CREATE TABLE endereco (
    idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    logradouro VARCHAR(40),
    CEP CHAR(9)
);

CREATE TABLE farmacia (
    idFarmacia INT PRIMARY KEY AUTO_INCREMENT,
    nomeFarmacia VARCHAR(45),
    fkEndereco INT UNIQUE,
    CONSTRAINT fkFarmaciaEndereco FOREIGN KEY (fkEndereco) REFERENCES endereco(idEndereco)
);

CREATE TABLE farmaceutico (
    idFarmaceutico INT PRIMARY KEY AUTO_INCREMENT,
    nomeFarmaceutico VARCHAR(25),
    dtNascimento DATE,
    fkFarmacia INT,
    CONSTRAINT fkFarmaceuticoFarmacia FOREIGN KEY (fkFarmacia) REFERENCES farmacia(idFarmacia)
);

INSERT INTO endereco (logradouro, CEP) VALUES
('Avenida Paulista', '01310-100'),
('Rua Augusta', '01305-000'),
('Rua Oscar Freire', '01426-001'),
('Avenida Faria Lima', '01452-000'),
('Rua da Consolação', '01301-000');

INSERT INTO farmacia (nomeFarmacia, fkEndereco) VALUES
('Drogaria Vida', 1),
('Farmácia Central', 2),
('Drogaria São João', 3),
('Farmácia Popular', 4),
('Drogaria Saúde Total', 5);

INSERT INTO farmaceutico (nomeFarmaceutico, dtNascimento, fkFarmacia) VALUES
('Julio', '1995-04-12', 1),
('Isabela', '2001-08-23', 2),
('Rodrigo', '1988-12-05', 3),
('Camila', '1999-03-17', 4),
('Alisson', '1983-09-30', 5);

SELECT * FROM farmaceutico;
SELECT * FROM farmacia;
SELECT * FROM endereco;

SELECT f.nomeFarmacia AS NomeFarmacia,
       c.nomeFarmaceutico AS NomeFarmaceutico,
       c.dtNascimento AS dtNascimento,
       e.logradouro AS logradouro,
       e.CEP AS CEP
FROM farmacia AS f
JOIN farmaceutico AS c ON f.idFarmacia = c.fkFarmacia
JOIN endereco AS e ON f.fkEndereco = e.idEndereco;

SELECT nomeFarmaceutico,
       dtNascimento,
       CASE
           WHEN dtNascimento < '2000-01-01' THEN 'Mais velho'
           ELSE 'Mais novo'
       END AS Faixa
FROM farmaceutico;

SELECT logradouro, IFNULL(CEP, 'Sem CEP') AS CEP FROM endereco;