USE sprint1;

CREATE TABLE professor (
idProfessor INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50),
especialidade VARCHAR(40),
dtNasc DATE);

SELECT * FROM professor;

ALTER TABLE professor MODIFY COLUMN funcao VARCHAR(50)
	CHECK(LOWER(funcao) = 'monitor' OR LOWER(funcao) = 'assistente' OR LOWER(funcao) = 'titular');
    
INSERT INTO professor VALUES
(default, 'Manuh', 'Algoritmo', '2006-11-22', 'Titular'),
(default, 'Kevin', 'Banco de Dados', '2006-09-29', 'Assistente'),
(default, 'Abner', 'Culinária', '2007-04-27', 'Monitor'),
(default, 'Vitor', 'TI', '2008-06-26', 'Monitor'),
(default, 'Vitor', 'Arq Comp', '2000-07-14', 'Titular'),
(default, 'Giovanna', 'Matemática', '2007-11-29', 'Assistente');

ALTER TABLE professor AUTO_INCREMENT = 6;

INSERT INTO professor VALUES
(default, 'Gustavo', 'Ed Fisica', '2004-09-29', 'Assistente');

DELETE FROM professor WHERE idProfessor = 5;

SELECT * FROM professor
	WHERE funcao = 'titular';
    
SELECT especialidade, dtNasc FROM professor
	WHERE funcao = 'monitor';
    
UPDATE professor SET dtNasc = '2000-01-31'
	WHERE idProfessor = 3;
    
TRUNCATE TABLE professor;