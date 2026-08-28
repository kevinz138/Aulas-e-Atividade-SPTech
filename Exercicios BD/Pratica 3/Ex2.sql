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