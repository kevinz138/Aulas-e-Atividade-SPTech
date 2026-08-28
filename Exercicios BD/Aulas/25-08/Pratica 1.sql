USE sprint1;

CREATE TABLE cadastro (
id INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50) NOT NULL,
cpf CHAR(11),
dtNasc DATE,
altura FLOAT,
salario DECIMAL(10,2),
email VARCHAR(60),
CONSTRAINT chkEmail CHECK(email LIKE '%@%')
) AUTO_INCREMENT = 2000;

INSERT INTO cadastro (nome, dtNasc, salario, email) VALUES
	('Rick', '2000-01-01', 3000.99, 'rick@gmail.com'),
	('Rock', '2002-03-01', 600.99, 'rock@gmail.com');
    
ALTER TABLE cadastro MODIFY COLUMN cpf CHAR(11) UNIQUE,
	MODIFY COLUMN email VARCHAR(60) not null;
    
DESCRIBE cadastro;

ALTER TABLE cadastro ADD CONSTRAINT chkSalario
	CHECK(salario >= 0);
    
ALTER TABLE cadastro ADD COLUMN dtCadastro DATETIME DEFAULT CURRENT_TIMESTAMP;

-- CURDATE() - APENAS A DATA E A HORA FICA 00:00:00
UPDATE cadastro SET dtCadastro = CURDATE()
	WHERE id >= 2000;
    
-- NOR() - DATA E HORA COMPLETA
UPDATE cadastro SET dtCadastro = NOW()
	WHERE id >= 2000;
    
SELECT * FROM cadastro;