USE sprint1;

CREATE TABLE revista (
idRevista INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(40),
categoria VARCHAR(30));

INSERT INTO revista VALUES
(default, 'Avon',''),
(default, 'Vogue',''),
(default, 'Quadrinho',''),
(default, 'Mônica','');

SELECT * FROM revista;

UPDATE revista SET categoria = 'Kits'
	WHERE idRevista = 1;
    
UPDATE revista SET categoria = 'Moda'
	WHERE idRevista = 2;
    
UPDATE revista SET categoria = 'Gibi'
	WHERE idRevista = 3;
    
UPDATE revista SET categoria = 'Gibi'
	WHERE idRevista = 4;
    
INSERT INTO revista VALUES 
(default, 'Kenner', 'Chinelo'),
(default, 'ELLE', 'Moda'),
(default, 'Nature', 'Bolsas');

SELECT * FROM revista;

DESCRIBE revista;

ALTER TABLE revista MODIFY COLUMN categoria VARCHAR(40);

DESCRIBE revista;

ALTER TABLE revista ADD COLUMN periodicidade VARCHAR(15);

SELECT * FROM revista;

ALTER TABLE revista DROP COLUMN periodicidade;

DROP TABLE revista;