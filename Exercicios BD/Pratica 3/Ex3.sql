CREATE DATABASE desenho;

USE desenho;

CREATE TABLE artes (
idArte INT PRIMARY KEY AUTO_INCREMENT,
titulo VARCHAR(50),
dtLanca DATE,
emissoOrigin VARCHAR(50),
Classi INT,
statuss VARCHAR(15),
nota INT)AUTO_INCREMENT = 10;

INSERT INTO artes (titulo, dtLanca, emissoOrigin, Classi, statuss, nota) VALUES
('Tom e Jerry', '1940-02-10', 'Cartoon Network', 18, 'Finalizado', 9),
('O Laboratorio de Dexter', '1996-04-28', 'Cartoon Network', 16, 'Cancelado', 9),
('As Meninas Superpoderosas', '1998-11-18', 'Cartoon Network', 14, 'Finalizado', 8),
('Ben 10', '2005-12-27', 'Cartoon Network', 10, 'Exibindo', 9),
('Bob Esponja', '1999-05-01', 'Nickelodeon', 16, 'Exibindo', 10),
('Os Padrinhos Magicos', '2001-03-30', 'Nickelodeon', 12, 'Exibindo', 9),
('Jimmy Neutron', '2002-09-06', 'Nickelodeon', 18, 'Cancelado', 8),
('Pica-Pau', '1940-11-25', 'Record TV', 14, 'Exibindo', 9),
('Irmão do Jorel', '2014-09-22', 'Cartoon Network', 10, 'Exibindo', 10),
('O Show de Truman', '1998-06-05', 'Globo', 12, 'Cancelado', 8);

SELECT * FROM artes;

SELECT * FROM artes
	WHERE Classi >= 14;
    
SELECT * FROM artes
	WHERE emissoOrigin = 'Cartoon Network';
    
ALTER TABLE artes ADD CONSTRAINT chkStatus CHECK(statuss IN ('exibindo','finalizado','cancelado'));

INSERT INTO artes (titulo, dtLanca, emissoOrigin, Classi, statuss, nota) VALUES
('Tom e Jerry', '1940-02-10', 'Cartoon Network', 18, 'Continuado', 9);

UPDATE artes SET statuss = 'Finalizado'
	WHERE idArte IN (12,15);
    
SELECT * FROM artes
	WHERE titulo LIKE 'O%';
    
ALTER TABLE artes RENAME COLUMN Classi TO classificacaoIndicativa;

UPDATE artes SET dtLanca = '2000-05-19'
	WHERE idArte = 11;
    
TRUNCATE TABLE artes;

ALTER TABLE artes DROP CONSTRAINT chkStatus;