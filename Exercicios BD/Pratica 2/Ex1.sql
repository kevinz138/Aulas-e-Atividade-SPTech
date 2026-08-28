-- EXERCICIO 1

-- CRIAR BANCO DE DADOS Att (ATIVIDADE)
CREATE DATABASE sprint1;

-- SELECIONAR BANCO DE DADOS Att
USE sprint1;

-- CRIAR TABELA DE ATLETA
CREATE TABLE tbl_atleta (
idAtleta INT PRIMARY KEY,
nome VARCHAR(40),
modalidade VARCHAR(40),
qtdMedalha INT);

-- INSERIR PESSOAS NA TABELA ATLETA
INSERT INTO tbl_atleta (idAtleta, nome, modalidade, qtdMedalha)
	VALUE (1, 'Kevin', 'Natação', 15),
    (2, 'Mymy', 'Natação', 18),
    (3, 'Pedro', 'Futebol', 31),
    (4, 'Lucas', 'Futebol', 24),
    (5, 'Mateus', 'Basquete', 2),
    (6, 'João', 'Basquete', 5),
    (7, 'Julia', 'Volei', 11),
    (8, 'Vanessa', 'Volei', 3);
    
-- INSERIR PESSOAS NA TABELA ATLETA
INSERT INTO tbl_atleta (idAtleta, nome, modalidade, qtdMedalha)
	VALUE (9, 'Tiago', 'Esgrima', 0);

-- EXIBIR TODOS OS DADOS DA TABELA
SELECT * FROM tbl_atleta;

-- ATUALIZAR QUANTIDADE DE MEDALHA ONDE O ID É IGUAL 1
UPDATE tbl_atleta SET qtdMedalha = 99
	WHERE idAtleta = 1;
    
-- ATULIZAR QUANTIDADE DE MEDALHA ONDE ID É IGUAL 2 e 3
UPDATE tbl_atleta SET qtdMedalha = 20
	WHERE idAtleta IN (2,3);
    
-- ATUALIZAR NOME ONDE ID É IGUAL A 4
UPDATE tbl_atleta SET nome = 'Gustavo'
	WHERE idAtleta = 4;
    
-- ADICIONAR COLUNA COM O NOME DTNASCIMENTO
ALTER TABLE tbl_atleta ADD COLUMN dtNasc DATE;

-- ATUALIZAR A DATA DE NASCIMENTO DE TODOS OS ATLETAS
UPDATE tbl_atleta SET dtNasc = '2006-09-29'
	WHERE idAtleta = 1;
    
UPDATE tbl_atleta SET dtNasc = '2006-10-27'
	WHERE idAtleta = 2;
    
UPDATE tbl_atleta SET dtNasc = '2007-05-31'
	WHERE idAtleta = 3;
    
UPDATE tbl_atleta SET dtNasc = '1998-02-05'
	WHERE idAtleta = 4;
    
UPDATE tbl_atleta SET dtNasc = '2000-11-17'
	WHERE idAtleta = 5;
    
UPDATE tbl_atleta SET dtNasc = '2012-04-22'
	WHERE idAtleta = 6;
    
UPDATE tbl_atleta SET dtNasc = '2017-01-09'
	WHERE idAtleta = 7;
    
UPDATE tbl_atleta SET dtNasc = '1999-02-28'
	WHERE idAtleta = 8;
    
UPDATE tbl_atleta SET dtNasc = '2001-12-25'
	WHERE idAtleta = 9;
    
-- DELETAR ATLETA DA TABELA ONDE O ID É IGUAL A 5
DELETE FROM tbl_atleta WHERE idAtleta = 5;

-- EXIBIR TODOS ATLETAS ONDE A MODALIDADE É DIFERENTE DE NATAÇÃO
SELECT * FROM tbl_atleta WHERE modalidade != 'Natação';

-- EXIBIR ATLETAS ONDE A QUANTIDADE DE MEDALHAS É MAIOR OU IGUAL A 3
SELECT * FROM tbl_atleta WHERE qtdMedalha >= 3;

-- MODICAR O CAMPO MODALIDADE DO TAMANHO 40 PARA O 60
ALTER TABLE tbl_atleta MODIFY COLUMN modalidade VARCHAR(60);

-- DESCREVER OS CAMPOS DA TABELA
DESCRIBE tbl_atleta;

-- LIMPAR DADOS DA TABELA
TRUNCATE TABLE tbl_atleta;

-- DELETAR TABELA
DROP TABLE tbl_atleta;