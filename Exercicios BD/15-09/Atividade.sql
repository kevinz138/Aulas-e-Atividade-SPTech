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
('Giovanna', '98765432109'),
('Ana', '01234567890');

INSERT INTO reserva VALUES
(default, '2026-09-10 15:'),