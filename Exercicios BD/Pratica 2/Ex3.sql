CREATE TABLE filme(
idFilme INT PRIMARY KEY AUTO_INCREMENT,
titulo VARCHAR(50),
genero VARCHAR(40),
diretor VARCHAR(40));

INSERT INTO filme VALUES
(default, 'Spider-Man', 'Acao', 'Kevin'),
(default, 'Coraline', 'Animacao', 'Davi'),
(default, 'Babadook', 'Terror', 'Manuh'),
(default, 'Superman', 'Ação', 'Abner'),
(default, 'Paranorman', 'Animacao', 'Matheus'),
(default, 'Obssecao', 'Terror', 'Alexandriny'),
(default, 'JJK', 'Animacao', 'Patricia');

SELECT * FROM filme;

ALTER TABLE filme ADD COLUMN protagonista VARCHAR(50);

UPDATE filme SET protagonista = 'Peter-Parker'
	WHERE idFilme = 1;
UPDATE filme SET protagonista = 'Coraline'
	WHERE idFilme = 2;
UPDATE filme SET protagonista = 'Babadook'
	WHERE idFilme = 3;
UPDATE filme SET protagonista = 'Superman'
	WHERE idFilme = 4;
UPDATE filme SET protagonista = 'Norman'
	WHERE idFilme = 5;
UPDATE filme SET protagonista = 'Pedro'
	WHERE idFilme = 6;
UPDATE filme SET protagonista = 'Itadori'
	WHERE idFilme = 7;
    
ALTER TABLE filme MODIFY COLUMN diretor VARCHAR(150);

UPDATE filme SET diretor = 'Kaik'
	WHERE idFilme = 5;
    
UPDATE filme SET diretor = 'Gustavo'
	WHERE idFilme IN (2,7);
    
UPDATE filme SET titulo = 'Pecadores'
	WHERE idFilme = 3;
    
SELECT * FROM filme 
	WHERE genero != 'Acao';
    
SELECT * FROM filme
	WHERE genero = 'suspense';
    
DESCRIBE filme;

TRUNCATE TABLE filme;

DROP TABLE filme;