CREATE DATABASE aula6;

USE aula6;

-- Criar tabela empresa pq ela n tem FK
CREATE TABLE responsavel (
idResponsavel INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45),
salario DECIMAL(10,2)
) AUTO_INCREMENT = 5000;

INSERT INTO responsavel VALUES
(default, 'Jow', 1.88),
(default, 'Jerry', 1.48),
(default, 'Jan', 1.98);

CREATE TABLE empresa (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45),
cnpj CHAR(15) UNIQUE,
fkResponsavel INT NOT NULL UNIQUE,
CONSTRAINT fkEmpresaResp 
	FOREIGN KEY (fkResponsavel)
		REFERENCES responsavel(idResponsavel)
);

INSERT INTO empresa VALUES
(default, 'C6 Bank', null, 5000),
(default, 'Safra', null, 5001),
(default, 'Stefanini', null, 5002);

-- Nosso primeiro JOIN
-- Junção, Associaçãoptimize

SELECT * FROM responsavel
	JOIN empresa ON fkResponsavel = idResponsavel;
    
SELECT r.nome AS Responsa,
	e.nome AS NomeEmpresa
    FROM empresa AS e JOIN responsavel AS r
		ON fkResponsavel = idResponsavel;
        
CREATE TABLE aluno (
ra CHAR(8) PRIMARY KEY,
nome VARCHAR(45),
bairro VARCHAR(45),
fkEmpresa INT NOT NULL
);

ALTER TABLE aluno ADD CONSTRAINT fkEmpresaAluno
	FOREIGN KEY (fkEmpresa)
		REFERENCES empresa(idEmpresa);
        
INSERT INTO aluno VALUES
('01262999', 'Jonas', 'Paraíso', 1),
('01262998', 'Jana', 'Perdizes', 1),
('01262997', 'Alexandriny', NULL , 3),
('01262996', 'Januário', NULL , 2);

SELECT * FROM empresa
	JOIN aluno ON fkEmpresa = idEmpresa;
    
SELECT empresa.nome AS Empresa, 
	aluno.nome AS Aluno,
    responsavel.nome AS Responsavel
    FROM empresa JOIN responsavel
		ON idResponsavel = fkResponsavel
        JOIN aluno
			ON idEmpresa = fkEmpresa;
            
SELECT responsavel.nome AS Responsa, 
	empresa.nome AS NomeEmpresa
	FROM empresa JOIN responsavel
		ON idResponsavel = fkResponsavel
        WHERE empresa.nome = 'C6 Bank';