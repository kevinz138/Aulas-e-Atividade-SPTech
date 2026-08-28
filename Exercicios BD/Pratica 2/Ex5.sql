USE sprint1;

CREATE TABLE curso (
idCurso INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50),
sigla CHAR(3),
coordenador VARCHAR(40));

INSERT INTO curso VALUE
(default, 'Analise e Desenvolvimento de Sistemas', 'ADS', 'Abner'),
(default, 'Engenharia de Pesca', 'EPS', 'Manuh'),
(default, 'Ciências da Computação', 'CCO', 'Matheus');

SELECT * FROM curso;

SELECT coordenador FROM curso;

SELECT * FROM curso
	WHERE sigla = 'ADS';
    
SELECT * FROM curso ORDER BY nome;

SELECT * FROM curso ORDER BY coordenador DESC;

SELECT * FROM curso
	WHERE nome LIKE 'E%';
    
SELECT * FROM curso
	WHERE nome LIKE '%s';

SELECT * FROM curso
	WHERE nome LIKE '_n%';
    
SELECT * FROM curso
	WHERE nome LIKE '%a_';
    
DROP TABLE curso;