-- CRIANDO DATA BASE sprint1
CREATE DATABASE sprint1;

USE sprint1;

CREATE TABLE musica (
idMusica INT PRIMARY KEY AUTO_INCREMENT,
titulo VARCHAR(40),
artista VARCHAR(40),
genero VARCHAR(40));

-- ADICIONANDO MUSICAS NA TABELA
INSERT INTO Musica (idMusica, titulo, artista, genero)
	VALUE (1, 'Rise Up', 'Jomie', 'Emo Rap'),
    (2, 'Blasphemy', 'Kid E$s', 'Emo Rap'),
    (3, 'Ray Gun', 'Ouse Powfu', 'Lo-Fi Hip-Hop'),
    (4, 'Jane!', 'The Long Faces', 'Indie Rock'),
    (5, 'From The Start', 'Laufey', 'Bossa-Nova'),
    (6, 'Brighter Days', 'Jomie', 'Emo Rap'),
    (7, 'Troubles of Today', 'Kid E$s, Powfu', 'Sad Song'),
    (8, 'Falling Behind', 'Laufey', 'Bossa-Nova'),
    (9, 'Numb', 'Linkin Park', 'Rock'),
    (10, 'In the End', 'Linkin Park', 'Rock');
    
SELECT * FROM musica;

ALTER TABLE musica ADD COLUMN curtidas INT AFTER artista;

UPDATE musica SET curtidas = 999
	WHERE idMusica = 1;
UPDATE musica SET curtidas = 862
	WHERE idMusica = 2;
UPDATE musica SET curtidas = 945
	WHERE idMusica = 3;
UPDATE musica SET curtidas = 1313
	WHERE idMusica = 4;
UPDATE musica SET curtidas = 468
	WHERE idMusica = 5;
UPDATE musica SET curtidas = 569
	WHERE idMusica = 6;
UPDATE musica SET curtidas = 2658
	WHERE idMusica = 7;
UPDATE musica SET curtidas = 5964
	WHERE idMusica = 8;
UPDATE musica SET curtidas = 8951
	WHERE idMusica = 9;
UPDATE musica SET curtidas = 9567
	WHERE idMusica = 10;
    
ALTER TABLE musica MODIFY COLUMN artista VARCHAR(80);

UPDATE musica SET curtidas = 921211
	WHERE idMusica = 1;
    
UPDATE musica SET curtidas = 9
	WHERE idMusica IN (2,3);

UPDATE musica SET titulo = 'Abobra'
	WHERE idMusica = 5;
    
DELETE FROM musica WHERE idMusica = 4;

SELECT * FROM musica
	WHERE genero != 'Emo Rap';
    
SELECT * FROM musica
	WHERE curtidas >= 20;

DESCRIBE musica;

TRUNCATE TABLE musica;

DROP TABLE musica;