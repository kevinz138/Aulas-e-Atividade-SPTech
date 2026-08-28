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