-- EXERCICIO 1
CREATE DATABASE game_store;

CREATE TABLE jogo (
idJogo INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(30),
diretor VARCHAR(30),
genero VARCHAR(30),
dataLanca DATE,
nota INT,
quant INT,
CONSTRAINT chkNota CHECK(nota >= 0 AND nota <= 10));

INSERT INTO jogo (nome, diretor, genero, dataLanca, nota, quant) VALUES
('Hollow Knight', 'Team Cherry', 'Indie', '2017-02-24', 10, 176),
('Silk Song', 'Team Cherry', 'Indie', '2025-09-04', 10, 250),
('Minecraft', 'Mojang', 'Aventura', '2009-05-17', 10, 360),
('Stardew Valley', '2D', 'Simulator', '2016-02-26', 8, 80),
('COD', 'Battle Royal', 'Tiro', '2016-02-26', 4, 30);

ALTER TABLE jogo ADD COLUMN midia VARCHAR(10);

ALTER TABLE jogo ADD CONSTRAINT chkMidia CHECK(midia IN ('Física', 'Digital'));

UPDATE jogo SET midia = 'Física'
	WHERE idJogo = 1;
UPDATE jogo SET midia = 'Física'
	WHERE idJogo = 2;
UPDATE jogo SET midia = 'Digital'
	WHERE idJogo = 3;
UPDATE jogo SET midia = 'Física'
	WHERE idJogo = 4;
UPDATE jogo SET midia = 'Digital'
	WHERE idJogo = 5;
    
SELECT * FROM jogo
	WHERE YEAR(dataLanca) > 2015;
    
SELECT * FROM jogo
	WHERE nome LIKE '%a%' AND midia = 'Física';
    
SELECT * FROM jogo
	WHERE NOT diretor LIKE '%e%';
    
ALTER TABLE jogo ADD CONSTRAINT chkNota CHECK(nota >= 0 AND nota <= 10);
    
SELECT * FROM jogo
	WHERE genero = 'Indie' AND quant != 0;
 
ALTER TABLE jogo RENAME COLUMN diretor TO criador;

DELETE FROM jogo WHERE quant = 0;
 
DESCRIBE jogo;

-- EXERCICIO 2
CREATE DATABASE olimpiadas;

CREATE TABLE esporte (
idEsport INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(40),
categoria VARCHAR(20),
CONSTRAINT chkCategori CHECK(categoria IN ('Individual','Coletivo')),
numJogador INT,
estreia DATE,
pais VARCHAR(30));

INSERT INTO esporte (nome, categoria, numjogador, estreia, pais) VALUES 
('Futebol', 'Coletivo', 11, '1900-05-14', 'Inglaterra'),
('Basquete', 'Coletivo', 5, '1936-08-07', 'Estados Unidos'),
('Vôlei', 'Coletivo', 6, '1964-10-11', 'Estados Unidos'),
('Natação', 'Individual', 1, '1896-04-06', 'Grécia'),
('Judô', 'Individual', 1, '1964-10-11', 'Japão');

ALTER TABLE esporte ADD COLUMN popularidade INT;

ALTER TABLE esporte ADD CONSTRAINT chkPopu CHECK(popularidade >= 0 AND popularidade <= 10);

UPDATE esporte SET popularidade = 8
	WHERE idEsport = 1;
UPDATE esporte SET popularidade = 7
	WHERE idEsport = 2;
UPDATE esporte SET popularidade = 9
	WHERE idEsport = 3;
UPDATE esporte SET popularidade = 10
	WHERE idEsport = 4;
UPDATE esporte SET estreia = 3
	WHERE idEsport = 5;
    
SELECT * FROM esporte ORDER BY popularidade;

SELECT * FROM esporte
	WHERE YEAR(estreia) >= 2000;
    
ALTER TABLE esporte ADD CONSTRAINT chkEstre CHECK(estreia >= '1896-04-06');

ALTER TABLE esporte DROP CONSTRAINT chkCategori;

SELECT * FROM esporte
	WHERE nome LIKE '%a%';
    
SELECT * FROM esporte
	WHERE numJogador BETWEEN 4 AND 11;
    
DELETE FROM esporte WHERE idEsport IN (1,3,5);

-- EXERCICIO 3
CREATE DATABASE desenho;

USE desenho;

CREATE TABLE artes (
idArte INT PRIMARY KEY AUTO_INCREMENT,
titulo VARCHAR(50),
dtLanca DATE,
emissoOrigin VARCHAR(50),
Classi INT,
statuss VARCHAR(15),
nota INT)AUTO_INCREMENT = 10;

INSERT INTO artes (titulo, dtLanca, emissoOrigin, Classi, statuss, nota) VALUES
('Tom e Jerry', '1940-02-10', 'Cartoon Network', 18, 'Finalizado', 9),
('O Laboratorio de Dexter', '1996-04-28', 'Cartoon Network', 16, 'Cancelado', 9),
('As Meninas Superpoderosas', '1998-11-18', 'Cartoon Network', 14, 'Finalizado', 8),
('Ben 10', '2005-12-27', 'Cartoon Network', 10, 'Exibindo', 9),
('Bob Esponja', '1999-05-01', 'Nickelodeon', 16, 'Exibindo', 10),
('Os Padrinhos Magicos', '2001-03-30', 'Nickelodeon', 12, 'Exibindo', 9),
('Jimmy Neutron', '2002-09-06', 'Nickelodeon', 18, 'Cancelado', 8),
('Pica-Pau', '1940-11-25', 'Record TV', 14, 'Exibindo', 9),
('Irmão do Jorel', '2014-09-22', 'Cartoon Network', 10, 'Exibindo', 10),
('O Show de Truman', '1998-06-05', 'Globo', 12, 'Cancelado', 8);

SELECT * FROM artes;

SELECT * FROM artes
	WHERE Classi >= 14;
    
SELECT * FROM artes
	WHERE emissoOrigin = 'Cartoon Network';
    
ALTER TABLE artes ADD CONSTRAINT chkStatus CHECK(statuss IN ('exibindo','finalizado','cancelado'));

INSERT INTO artes (titulo, dtLanca, emissoOrigin, Classi, statuss, nota) VALUES
('Tom e Jerry', '1940-02-10', 'Cartoon Network', 18, 'Continuado', 9);

UPDATE artes SET statuss = 'Finalizado'
	WHERE idArte IN (12,15);
    
SELECT * FROM artes
	WHERE titulo LIKE 'O%';
    
ALTER TABLE artes RENAME COLUMN Classi TO classificacaoIndicativa;

UPDATE artes SET dtLanca = '2000-05-19'
	WHERE idArte = 11;
    
TRUNCATE TABLE artes;

ALTER TABLE artes DROP CONSTRAINT chkStatus;

-- EXERCICIO 4
CREATE DATABASE estoque;

USE estoque;

CREATE TABLE MisteriosSA (
idMist INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(30),
dtCompra DATE,
preco DECIMAL(10,2),
peso INT,
dtRetirada DATE);

INSERT INTO MisteriosSA (nome, dtCompra, preco, peso, dtRetirada) VALUES
('Biscoito Scooby', '2026-08-01', 14.50, 250, '2026-08-05'),
('Biscoito Scooby', '2026-08-02', 28.90, 450, '2026-08-02'),
('Cachorro-quente', '2026-08-05', 45.00, 150, '2026-08-10'),
('Biscoito Scooby', '2026-08-07', 35.99, 320, NULL),
('Cachorro-quente', '2026-08-10', 22.00, 180, NULL),
('Biscoito Scooby', '2026-08-12', 79.90, 850, '2026-08-18'),
('Cachorro-quente', '2026-08-15', 18.75, 120, '2026-08-16');

SELECT * FROM MisteriosSA;

SELECT nome, dtCompra, dtRetirada, idMist FROM MisteriosSA;

UPDATE MisteriosSA SET dtRetirada = '2026-08-07'
	WHERE idMist = 1;
    
ALTER TABLE MisteriosSA RENAME COLUMN idMist TO idComida;

ALTER TABLE MisteriosSA ADD CONSTRAINT chkComida CHECK(nome IN ('biscoito scooby','cachorro-quente'));

SELECT nome, dtCompra AS 'data da compra', dtRetirada AS 'data da retirada' FROM MisteriosSA
	WHERE nome = 'Biscoito Scooby';
    
SELECT * FROM MisteriosSA
	WHERE YEAR(dtCompra) < '2024-06-14';
    
SELECT * FROM MisteriosSA
	WHERE preco >= 30.50;
    
TRUNCATE TABLE MisteriosSA;

-- EXERCICIO 5
CREATE DATABASE vingadores;

USE vingadores;

CREATE TABLE heroi (
idHeroi INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45),
versao varchar(45),
habilidade varchar(50),
altura INT);

INSERT INTO heroi (nome, versao, habilidade, altura) VALUES
('Homem-Aranha', 'Peter Parker', 'Agilidade e sentido aranha', 178),
('Homem de Ferro', 'Mark 85', 'Armadura tecnológica', 185),
('Capitão América', 'Steve Rogers', 'Superforça e resistência', 188),
('Thor', 'Thor Odinson', 'Superforça e controle de raios', 198),
('Hulk', 'Bruce Banner', 'Superforça e regeneração', 244);

SELECT * FROM heroi;

ALTER TABLE heroi ADD COLUMN regeneracao BOOLEAN;

UPDATE heroi SET regeneracao = FALSE
	WHERE idHeroi = 1;
UPDATE heroi SET regeneracao = FALSE
	WHERE idHeroi = 2;
UPDATE heroi SET regeneracao = FALSE
	WHERE idHeroi = 3;
UPDATE heroi SET regeneracao = FALSE
	WHERE idHeroi = 4;
UPDATE heroi SET regeneracao = TRUE
	WHERE idHeroi = 5;
    
ALTER TABLE heroi MODIFY COLUMN versao VARCHAR(100);

DELETE FROM heroi WHERE idHeroi = 3;

INSERT INTO heroi (nome, versao, habilidade, altura) VALUES
('Deadpool', 'Wade Wilson', 'Agilidade e imortalidade', 190);


UPDATE heroi SET regeneracao = TRUE
	WHERE idHeroi = 6;
    
SELECT * FROM heroi
	WHERE nome LIKE 'C%' OR 'H%';
    
SELECT * FROM heroi
	WHERE NOT nome LIKE '%a%';
    
SELECT * FROM heroi
	WHERE altura > 190;
    
SELECT * FROM heroi
	WHERE altura > 180 ORDER BY nome DESC;
    
TRUNCATE TABLE heroi;