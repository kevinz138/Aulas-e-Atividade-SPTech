USE sprint2;

-- EX01 

CREATE TABLE Atleta(
idAtleta INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR (40),
modalidade VARCHAR (40),
qtdMedalha INT 
);
 INSERT INTO Atleta VALUES
 (default, 'Kevin', 'Natação', 5),
 (default, 'Alexandriny', 'Futebol', 11),
 (default, 'Gustavo', 'Basquete', 10),
 (default, 'Guilherme', 'Futsal', 3),
 (default, 'Paulo', 'Volei', 4),
 (default, 'Gabriel', 'musculação',2);
 
 CREATE TABLE Pais(
 idPais INT PRIMARY KEY AUTO_INCREMENT,
 nome VARCHAR (30),
 capital VARCHAR (40)
 );
 
 INSERT INTO Pais VALUES
 (default, 'Brasil', 'Brasilia'),
 (default, 'França', 'Paris'),
 (default, 'China', 'Pequim'),
 (default, 'Japao', 'Toquio');
 
 ALTER TABLE Atleta ADD COLUMN fkPais INT,
 ADD CONSTRAINT fkAtletaPais
 FOREIGN KEY (fkPais) 
 REFERENCES Pais(idPais);
 
 UPDATE Pais SET nome = 'Alemanha'
 WHERE idPais = 1;
 
  UPDATE Pais SET nome = 'Noruega'
 WHERE idPais = 2;
 
  UPDATE Pais SET nome = 'Argentina'
 WHERE idPais = 3;
 
  UPDATE Pais SET nome = 'Marrocos'
 WHERE idPais = 4;
 
 UPDATE Atleta SET fkPais = 1
 WHERE idAtleta = 1;

UPDATE Atleta SET fkPais = 2
WHERE idAtleta = 2;

UPDATE Atleta SET fkPais = 3
WHERE idAtleta = 3;

UPDATE Atleta SET fkPais = 4
WHERE idAtleta = 4;

UPDATE Atleta SET fkPais = 5
WHERE idAtleta = 5;

UPDATE Atleta SET fkPais = 6
WHERE idAtleta = 6;
 
 SELECT * FROM Pais 
 JOIN Atleta ON fkPais = idPais;
 
 SELECT * FROM Pais JOIN Atleta ON fkPais = idPais WHERE idAtleta = 1;
 
 SELECT * FROM Pais JOIN Atleta ON fkPais = idPais WHERE capital = 'Paris';
 
 -- EX 02


 CREATE TABLE musica(
 idMusica INT PRIMARY KEY AUTO_INCREMENT,
 titulo VARCHAR (40),
 artista VARCHAR (40),
 genero VARCHAR (40)
 );
 
 INSERT INTO musica VALUES 
 (default, 'musica 1', 'Ale', 'Hip Hop'),
 (default, 'musica 2', 'Kevin', 'Hip Hop'),
 (default, 'musica 3', 'Giovanni', 'Hip Hop'),
 (default, 'musica 4', 'Ale', 'Hip Hop');

 CREATE TABLE album(
 idAlbum INT PRIMARY KEY AUTO_INCREMENT,
 nome VARCHAR (50),
 tipo VARCHAR (10),
 CONSTRAINT chk_tipo CHECK (tipo IN('digital','fisico')),
 dtLancamento DATE
 );

 INSERT INTO album VALUES
 (default, 'Album bão','fisico', '2000-01-01'),
 (default, 'bom dia','digital', '2013-03-10'),
 (default, 'certin','fisico', '2019-08-20'),
 (default, 'correria','digital', '2025-11-24');
 
  SELECT * FROM musica;
  SELECT * FROM album;
  
  ALTER TABLE musica ADD fkAlbum INT;
  ALTER TABLE musica ADD FOREIGN KEY (fkAlbum) 
  REFERENCES album(idAlbum);
  
  UPDATE musica SET fkALbum = 1
  WHERE idMusica = 1;
  
  UPDATE musica SET fkALbum = 2
  WHERE idMusica = 2;
  
   UPDATE musica SET fkALbum = 3
  WHERE idMusica = 3;

   UPDATE musica SET fkALbum = 4
  WHERE idMusica = 4;
  
  SELECT * FROM musica JOIN album ON fkAlbum = idAlbum;
  
  SELECT titulo, nome FROM musica JOIN album ON fkAlbum = idAlbum;
  
  -- EX03
  
  CREATE TABLE pessoa(
  idPessoa int PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR (45),
  cpf CHAR(11)
  );
  
  CREATE TABLE reserva(
  idReserva INT PRIMARY KEY AUTO_INCREMENT,
  dtReserva DATETIME,
  dtRetirada DATETIME,
  dtDevolucao DATETIME,
  fkPessoa INT
  );
  
  INSERT INTO pessoa VALUES 
  (default, 'Alexandriny', '12345678919'),
  (default, 'Kevin', '75098678919'),
  (default, 'Leandro', '12987654321'),
  (default, 'Claudio', '12340371894'),
  (default, 'Giovanna', '73098601350');
  
  INSERT INTO reserva VALUES
  (default, '2025-08-20','2025-08-21','2025-08-31',1),
  (default, '2025-08-01','2025-08-02','2025-08-10',2),
  (default, '2025-03-12','2025-03-13','2025-03-14',3),
  (default, '2025-08-28','2025-08-29','2025-09-01',4),
  (default, '2025-01-01','2025-01-02','2025-01-03',5);
	
  ALTER TABLE reserva ADD FOREIGN KEY (fkPessoa)
  REFERENCES pessoa(idPessoa);
  
  SELECT * FROM reserva;
  SELECT * FROM pessoa;
  
  SELECT r.idReserva AS reserva,
  p.nome AS pessoa 
  FROM reserva AS r JOIN pessoa AS p
  ON idPessoa = fkPessoa; 
  
  SELECT dtReserva,
  CASE
  WHEN dtDevolucao < '2025-08-31' THEN 'Faz tempo'
  ELSE 'agorinha pouco'
  END AS Devolucao
  FROM reserva;
  
  
  SELECT cpf,
  IFNULL(cpf, 'Não contem CPF') AS CPF
  FROM pessoa;
  
  
-- EX04

CREATE TABLE pessoa1(
idPessoa1 INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR (45),	
dtNascimento DATE
);

CREATE TABLE pessoa2(
idPessoa2 INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR (45),
dtNascimento DATE,
fkPessoa1 INT 
);

INSERT INTO pessoa1 VALUES
(default, 'Alexandriny', '2006-08-31'), 
(default, 'Alexandre', '2006-08-20'), 
(default, 'Leonardo', '2009-04-01'), 
(default, 'Marcelo', '2000-01-11'), 
(default, 'Geovanne', '2010-08-20'); 

INSERT INTO pessoa2 VALUES
(default, 'Ricardo', '1999-01-21',1), 
(default, 'Cleidison', '1980-08-20',2), 
(default, 'Ana Maria', '1999-12-12',3), 
(default, 'Fernanda', '1980-09-11',4), 
(default, 'Lindomar', '2020-08-15',5); 
 
 ALTER TABLE pessoa2 ADD FOREIGN KEY (fkPessoa1)
 REFERENCES pessoa1(idPessoa1);
 
 SELECT * FROM pessoa1;
 SELECT * FROM pessoa2;
 
 SELECT p1.idPessoa1 AS pessoa1,
 p2.nome AS pessoa2 
 FROM pessoa1 AS p1 
 JOIN pessoa2 AS p2
 ON idPessoa1 = fkPessoa1;
 
 SELECT nome,
 CASE
 WHEN dtNascimento < '2000-01-01' THEN 'Alfa'
 ELSE 'Beta'
 END AS Dinossauros
 FROM pessoa2;
 
 SELECT nome, 
 IFNULL(nome, 'Sem nome') AS ConsultNomes
 FROM pessoa1;
 
 -- EX05
 
	CREATE TABLE candidato (
		idCandidato INT PRIMARY KEY AUTO_INCREMENT,
		nome VARCHAR(100) NOT NULL,
		cpf CHAR(11) NOT NULL UNIQUE
	);

	CREATE TABLE processo_cnh (
		idProcesso INT PRIMARY KEY AUTO_INCREMENT,
		categoriaPretendida VARCHAR(10) NOT NULL,
		CONSTRAINT chk_categoriaP CHECK (categoriaPretendida IN ('A','B','AB')),
		validadeAnos INT DEFAULT 1,
		dtSolicitacao DATE NOT NULL,
		fkCandidato INT UNIQUE 
	);
 
 INSERT INTO candidato VALUES
 (default, 'Alexandriny', '60098671234'),
 (default, 'Alexandre', '60092671214'),
 (default, 'Roberto', '10098671234'),
 (default, 'Lindomar', '10018671234'),
 (default, 'Fernanda', '90098671234');
 
 INSERT INTO processo_cnh VALUES
 (default, 'B',1,'2026-09-20',1),
 (default, 'A',1,'2025-03-09',2),
 (default, 'AB',1,'2000-01-20',3),
 (default, 'A',1,'2009-09-27',4),
 (default, 'B',1,'2019-08-20',5);
 
 ALTER TABLE processo_cnh ADD FOREIGN KEY (fkCandidato)
 REFERENCES candidato(idCandidato);
 
 SELECT * FROM processo_cnh;
 SELECT * FROM candidato;
 
 SELECT c.nome AS Nome,
c.cpf AS CPF,
p.categoriaPretendida AS Categoria,
p.validadeAnos AS ValidadeCNH,
p.dtSolicitacao AS Solicitacao
FROM candidato AS c 
JOIN processo_cnh AS p
ON idCandidato = fkCandidato;

SELECT nome,
CASE 
WHEN nome LIKE 'A%' THEN 'Seu nome começa com A'
ELSE 'Seu nome não começa com a letra A'
END AS Inicial
FROM candidato;

SELECT categoriaPretendida,
IFNULL(categoriaPretendida, 'Vai escolher não?') AS categoria
FROM processo_cnh;

-- EX06

CREATE TABLE farmacia(
idFarmacia INT PRIMARY KEY AUTO_INCREMENT,
nomeFarmacia VARCHAR (45),
fkEndereco INT UNIQUE
);
INSERT INTO farmacia VALUES
(default, 'Bem-estar',1),
(default, 'Bem-viver',2),
(default, 'Saúde',3),
(default, 'Vive',4),
(default, 'DrogariaBrasil',5);

CREATE TABLE farmaceutico(
idFarmaceutico INT PRIMARY KEY AUTO_INCREMENT,
nomeFarmaceutico VARCHAR (25),
dtNascimento DATE,
fkFarmacia INT 
);
INSERT INTO farmaceutico VALUES
(default, 'Jose', '1999-08-09',1),
(default, 'Isa', '2001-11-11',2),
(default, 'Roberta', '1991-01-06',3),
(default, 'Carla', '2002-10-09',4),
(default, 'Alexandre', '1980-08-27',5);


CREATE TABLE endereco(
idEndereco INT PRIMARY KEY AUTO_INCREMENT,
logradouro VARCHAR (40),
CEP CHAR (9)
);

INSERT INTO endereco VALUES
(default, 'Rua padre', '09217-510'),
(default, 'Rua flaquer', '01010-510'),
(default, 'Rua WS', '02022-510'),
(default, 'Rua Banco', '09091-210'),
(default, 'Rua Ata', '04678-510');

ALTER TABLE farmacia ADD FOREIGN KEY (fkEndereco)
REFERENCES endereco(idEndereco);

ALTER TABLE farmaceutico ADD FOREIGN KEY (fkFarmacia)
REFERENCES farmacia(idFarmacia);


SELECT * FROM farmaceutico;
SELECT * FROM farmacia;
SELECT * FROM endereco;

SELECT f.nomeFarmacia AS NomeFarmacia,
c.nomeFarmaceutico AS NomeFarmaceutico,
c.dtNascimento AS dtNascimento,
e.logradouro AS logradouro,
e.CEP AS CEP
FROM farmacia AS f
JOIN farmaceutico AS c
ON f.idFarmacia = c.fkFarmacia
JOIN endereco AS e
ON f.fkEndereco = e.idEndereco;

SELECT nomeFarmaceutico,
       dtNascimento,
       CASE
           WHEN dtNascimento < '2000-01-01' THEN 'Mais velho'
           ELSE 'Mais novo'
       END AS Faixa
FROM farmaceutico;

SELECT logradouro,
       IFNULL(CEP, 'Sem CEP') AS CEP
FROM endereco;