CREATE DATABASE FashionStore;

USE FashionStore;

CREATE TABLE produto (
id INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100),
categoria VARCHAR(50),
preco DECIMAL (10,2),
tamanho VARCHAR(5),
dtCadastro DATETIME,
disponivel TINYINT,
CONSTRAINT chkDisp CHECK(disponivel IN (0,1)));

ALTER TABLE produto ADD CONSTRAINT chkTamanho CHECK(tamanho IN ('P','M','G','GG'));

ALTER TABLE produto MODIFY COLUMN dtCadastro DATETIME DEFAULT CURRENT_TIMESTAMP;

INSERT INTO produto (nome, categoria, preco, tamanho, dtCadastro, disponivel)
	VALUES ('Camiseta Slim', 'Camiseta', 75.99, 'M', NOW(), 1),
		   ('Calça Legging', 'Calça', 120.49, 'G', NOW(), 1),
		   ('Regata de algodão', 'Camisa', 25.30, 'P', NOW(), 0),
		   ('Gravata Borboleta', 'Gravata', 12.99, 'GG', NOW(), 1),
		   ('Shorts de Praia', 'Shorts', 45.95, 'M', NOW(), 0),
		   ('Terno Azul Marinho', 'Terno', 250.90, 'P', NOW(), 1);
           
SELECT * FROM produto
	WHERE nome LIKE '%Camiseta%';
    
SELECT * FROM produto
	WHERE tamanho != 'M';
    
SELECT * FROM produto
	WHERE dtCadastro > '2025-08-18';
    
SELECT * FROM produto
	WHERE categoria IN ('Camiseta','Blusa');
    
SELECT CONCAT(nome, ' ', preco) AS produto_preco FROM produto;

UPDATE produto SET dtCadastro = '2025-08-19'
	WHERE id = 1;
    
SELECT * FROM produto
	WHERE NOT categoria = 'Blusa';
    
SELECT *,
	CASE
	WHEN disponivel = 1 THEN 'Disponível'
    ELSE 'Indisponível'
    END AS 'status'
    FROM produto;
    
SELECT * FROM produto
	WHERE categoria = 'Calça' AND preco > 100;
    
SELECT * FROM produto
	WHERE NOT nome LIKE '%Camiseta%';
    
SELECT * FROM produto
	WHERE id IN (1,3,5);
    
SELECT * FROM produto
	WHERE tamanho NOT IN ('P','M');
    
SELECT * FROM produto
	WHERE dtCadastro < '2025-08-18';
    
SELECT CONCAT(nome, ' ',preco) AS produto_valor FROM produto;

SELECT CONCAT(nome, ' / ', categoria, ' / ', preco) AS info_completa FROM produto;

SELECT * FROM produto
	WHERE disponivel > 0 AND tamanho = 'M';
    
SELECT * FROM produto
	WHERE nome LIKE 'C%';
    
INSERT INTO produto (nome, categoria, preco, tamanho, dtCadastro, disponivel)
	VALUES ('Jaqueta Couro', 'Jaqueta', 200.50, 'M', '2025-08-12', 1);
    
UPDATE produto SET preco = 270.00
	WHERE id = 7;
    
UPDATE produto SET disponivel = 0
	WHERE categoria LIKE '%Blusa%';
    
UPDATE produto SET tamanho = 'M'
	WHERE categoria LIKE '%Shorts%';
    
UPDATE produto SET categoria = 'Camiseta'
	WHERE nome LIKE '%Camiseta%';
    
UPDATE produto SET disponivel = 1
	WHERE dtCadastro > '2025-08-20';
    
UPDATE produto SET preco = preco * 1.05
	WHERE preco < 100;
    
UPDATE produto SET nome = 'Short Esportivo Unisex'
	WHERE id = 4;
    
UPDATE produto SET disponivel = 0
	WHERE categoria IN ('Blusa','Moletom');
    
UPDATE produto SET dtCadastro = NOW()
	WHERE categoria = 'Camiseta';
    
INSERT INTO produto (nome, categoria, preco, tamanho, dtCadastro, disponivel)
	VALUES ('Jaqueta Jeans', 'Jaqueta', 189.90, 'G', NOW(), 1),
		   ('Vestido Floral', 'Vestido', 149.90, 'M', NOW(), 1),
		   ('Blusa de Moletom', 'Moletom', 119.90, 'P', NOW(), 0),
		   ('Bermuda Esportiva', 'Bermuda', 59.90, 'G', NOW(), 1),
		   ('Saia Plissada', 'Saia', 89.90, 'M', NOW(), 1),
		   ('Camisa Social Branca', 'Camisa', 139.90, 'GG', NOW(), 0);
           
SELECT * FROM produto
	WHERE categoria = 'Jaqueta' AND disponivel = 0;
    
SELECT * FROM produto
	WHERE tamanho IN ('P','GG') ORDER BY preco DESC;
    
SELECT * FROM produto
	WHERE DATE(dtCadastro) = '2025-08-%%';