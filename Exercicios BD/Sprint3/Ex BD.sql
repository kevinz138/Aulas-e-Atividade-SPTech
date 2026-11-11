USE SPRINT3;

-- EXERCICIO 1

-- EXERCICIO 1

CREATE TABLE generos (
    idgenero INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE livros (
    idlivro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    anopublicacao INT NOT NULL,
    numeropaginas INT NOT NULL,
    fkgenero INT NOT NULL,
    CONSTRAINT fklivrosgeneros FOREIGN KEY (fkgenero) REFERENCES generos(idgenero)
);

CREATE TABLE leitores (
    idleitor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    cidade VARCHAR(50) NOT NULL
);

CREATE TABLE clubes (
    idclube INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    datacriacao DATE NOT NULL
);

CREATE TABLE participacoes (
    fkleitor INT NOT NULL,
    fkclube INT NOT NULL,
    dataingresso DATE NOT NULL,
    encontrosfrequentados INT NOT NULL,
    PRIMARY KEY (fkleitor, fkclube),
    CONSTRAINT fkparticipacoesleitores FOREIGN KEY (fkleitor) REFERENCES leitores(idleitor),
    CONSTRAINT fkparticipacoesclubes FOREIGN KEY (fkclube) REFERENCES clubes(idclube)
);

INSERT INTO generos (nome) VALUES 
('Ficção Científica'), 
('Romance'), 
('Fantasia');

INSERT INTO livros (titulo, anopublicacao, numeropaginas, fkgenero) VALUES 
('Duna', 1965, 680, 1),
('O Problema dos Três Corpos', 2014, 416, 1),
('O Homem do Castelo Alto', 2015, 288, 1),
('Orgulho e Preconceito', 1813, 424, 2),
('Amor nos Tempos do Cólera', 1985, 368, 2),
('O Hobbit', 1937, 310, 3),
('A Guerra dos Tronos', 1996, 694, 3),
('A Viajante do Tempo', 2018, 520, 2);

INSERT INTO leitores (nome, email, cidade) VALUES 
('Ana Silva', 'ana@email.com', 'São Paulo'),
('Carlos Souza', 'carlos@email.com', 'Rio de Janeiro'),
('Mariana Lima', 'mariana@email.com', 'Curitiba'),
('Roberto Alves', 'roberto@email.com', 'Belo Horizonte'),
('Fernanda Rocha', 'fernanda@email.com', 'Porto Alegre'),
('Lucas Mendes', 'lucas@email.com', 'Salvador');

INSERT INTO clubes (nome, datacriacao) VALUES 
('Clube do Livro SciFi', '2020-01-15'),
('Leitores Clássicos', '2019-05-20'),
('Fantásticos', '2021-03-10');

INSERT INTO participacoes (fkleitor, fkclube, dataingresso, encontrosfrequentados) VALUES 
(1, 1, '2021-02-01', 12),
(1, 2, '2021-06-15', 8),
(2, 1, '2021-03-10', 10),
(3, 1, '2022-01-05', 5),
(3, 3, '2022-02-20', 7),
(4, 2, '2020-08-12', 15),
(5, 3, '2021-11-01', 4);

SELECT l.nome AS nomeleitor, c.nome AS nomeclube, p.dataingresso
FROM participacoes p
JOIN leitores l ON p.fkleitor = l.idleitor
JOIN clubes c ON p.fkclube = c.idclube;

SELECT li.titulo, li.anopublicacao, li.numeropaginas, g.nome AS genero
FROM livros li
JOIN generos g ON li.fkgenero = g.idgenero
WHERE li.anopublicacao >= 2015 AND li.titulo LIKE '%a%'
ORDER BY li.numeropaginas;

SELECT 
    COUNT(*) AS qtdlivros,
    MIN(numeropaginas) AS menorpaginas,
    MAX(numeropaginas) AS maiorpaginas,
    ROUND(AVG(numeropaginas), 1) AS mediapaginas
FROM livros;

SELECT c.nome AS nomeclube, COUNT(p.fkleitor) AS qtdleitores
FROM clubes c
LEFT JOIN participacoes p ON c.idclube = p.fkclube
GROUP BY c.idclube, c.nome;

SELECT l.nome AS nomeleitor, COUNT(p.fkclube) AS qtdclubes
FROM leitores l
LEFT JOIN participacoes p ON l.idleitor = p.fkleitor
GROUP BY l.idleitor, l.nome;

SELECT c.nome AS nomeclube, TRUNCATE(AVG(p.encontrosfrequentados), 1) AS mediaencontros
FROM clubes c
JOIN participacoes p ON c.idclube = p.fkclube
GROUP BY c.idclube, c.nome
HAVING COUNT(p.fkleitor) >= 3;


-- EXERCICIO 2

CREATE TABLE alunos (
    idaluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    datanascimento DATE NOT NULL,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE intensidade (
    idintensidade INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE modalidades (
    idmodalidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    fkintensidade INT NOT NULL,
    CONSTRAINT fkmodalidadesintensidade FOREIGN KEY (fkintensidade) REFERENCES intensidade(idintensidade)
);

CREATE TABLE instrutores (
    idinstrutor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    valoraula DECIMAL(10,2) NOT NULL
);

CREATE TABLE aulas (
    idaula INT AUTO_INCREMENT PRIMARY KEY,
    fkinstrutor INT NOT NULL,
    fkmodalidade INT NOT NULL,
    diasemana VARCHAR(20) NOT NULL,
    duracaominutos INT NOT NULL,
    CONSTRAINT fkaulasinstrutores FOREIGN KEY (fkinstrutor) REFERENCES instrutores(idinstrutor),
    CONSTRAINT fkaulasmodalidades FOREIGN KEY (fkmodalidade) REFERENCES modalidades(idmodalidade)
);

CREATE TABLE matriculas (
    fkaluno INT NOT NULL,
    fkmodalidade INT NOT NULL,
    datamatricula DATE NOT NULL,
    PRIMARY KEY (fkaluno, fkmodalidade),
    CONSTRAINT fkmatriculasalunos FOREIGN KEY (fkaluno) REFERENCES alunos(idaluno),
    CONSTRAINT fkmatriculasmodalidades FOREIGN KEY (fkmodalidade) REFERENCES modalidades(idmodalidade)
);

INSERT INTO alunos (nome, datanascimento, email) VALUES 
('Bruno Lima', '1995-04-12', 'bruno@email.com'),
('Camila Pitanga', '1998-08-25', 'camila@email.com'),
('Diego Souza', '1990-12-01', 'diego@email.com'),
('Elena Ferraz', '2001-02-14', 'elena@email.com'),
('Felipe Neto', '1987-06-30', 'felipe@email.com'),
('Gabriela Cravo', '1993-11-18', 'gabriela@email.com'),
('Heitor Villa', '2000-09-09', 'heitor@email.com'),
('Igor Guimarães', '1996-05-05', 'igor@email.com');

INSERT INTO intensidade (descricao) VALUES 
('Baixa'), 
('Média'), 
('Alta');

INSERT INTO modalidades (nome, fkintensidade) VALUES 
('Yoga', 1),
('Pilates', 1),
('Crossfit', 3),
('Spinning', 3),
('Musculação', 2);

INSERT INTO instrutores (nome, valoraula) VALUES 
('Ricardo Eletro', 80.00),
('Vanessa Camargo', 95.00),
('Tiago Lacerda', 75.00),
('Beatriz Segal', 110.00);

INSERT INTO aulas (fkinstrutor, fkmodalidade, diasemana, duracaominutos) VALUES 
(1, 1, 'Segunda-feira', 60),
(1, 2, 'Quarta-feira', 50),
(2, 3, 'Terça-feira', 45),
(2, 4, 'Quinta-feira', 45),
(3, 5, 'Segunda-feira', 60),
(3, 5, 'Sexta-feira', 60),
(4, 3, 'Sábado', 50),
(4, 1, 'Quarta-feira', 60);

INSERT INTO matriculas (fkaluno, fkmodalidade, datamatricula) VALUES 
(1, 1, '2023-01-10'),
(1, 3, '2023-01-15'),
(2, 1, '2023-02-01'),
(2, 2, '2023-02-01'),
(2, 3, '2023-02-05'),
(3, 3, '2023-01-20'),
(4, 3, '2023-03-01'),
(5, 4, '2023-03-10'),
(6, 5, '2023-02-15');

ALTER TABLE modalidades 
ADD COLUMN qtdmaximaalunos INT NOT NULL DEFAULT 20,
ADD CONSTRAINT chkqtdmaxima CHECK (qtdmaximaalunos > 0);

UPDATE modalidades SET qtdmaximaalunos = 15 WHERE idmodalidade = 1;
UPDATE modalidades SET qtdmaximaalunos = 25 WHERE idmodalidade = 3;

SELECT m.nome AS modalidade, i.nome AS instrutor, a.diasemana, a.duracaominutos
FROM aulas a
JOIN modalidades m ON a.fkmodalidade = m.idmodalidade
JOIN instrutores i ON a.fkinstrutor = i.idinstrutor;

SELECT al.nome AS aluno, COUNT(ma.fkmodalidade) AS qtdmodalidades
FROM alunos al
LEFT JOIN matriculas ma ON al.idaluno = ma.fkaluno
GROUP BY al.idaluno, al.nome;

SELECT 
    i.nome AS instrutor,
    COUNT(DISTINCT a.fkmodalidade) AS qtdmodalidadesdiferentes,
    ROUND(AVG(a.duracaominutos), 1) AS duracaomedia
FROM instrutores i
LEFT JOIN aulas a ON i.idinstrutor = a.fkinstrutor
GROUP BY i.idinstrutor, i.nome;

SELECT 
    m.nome AS modalidade,
    COUNT(DISTINCT a.fkinstrutor) AS qtdinstrutores
FROM modalidades m
JOIN matriculas ma ON m.idmodalidade = ma.fkmodalidade
JOIN aulas a ON m.idmodalidade = a.fkmodalidade
GROUP BY m.idmodalidade, m.nome
HAVING COUNT(DISTINCT ma.fkaluno) > 3;

SELECT 
    i.nome AS instrutor,
    COUNT(a.idaula) AS qsdaulassemanais,
    (COUNT(a.idaula) * i.valoraula) AS valorsemanaltotal
FROM instrutores i
LEFT JOIN aulas a ON i.idinstrutor = a.fkinstrutor
GROUP BY i.idinstrutor, i.nome, i.valoraula;


-- EXERCICIO 3

CREATE TABLE artistas (
    idartista INT AUTO_INCREMENT PRIMARY KEY,
    nomeartistico VARCHAR(100) NOT NULL,
    paisorigem VARCHAR(50) NOT NULL,
    anoestreia INT NOT NULL
);

CREATE TABLE palcos (
    idpalco INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    capacidade INT NOT NULL
);

CREATE TABLE apresentacoes (
    idapresentacao INT AUTO_INCREMENT PRIMARY KEY,
    dataapresentacao DATE NOT NULL,
    horarioinicio TIME NOT NULL,
    duracaominutos INT NOT NULL,
    fkpalco INT NOT NULL,
    CONSTRAINT fkapresentacoespalcos FOREIGN KEY (fkpalco) REFERENCES palcos(idpalco)
);

CREATE TABLE participacoesapresentacao (
    fkartista INT NOT NULL,
    fkapresentacao INT NOT NULL,
    valorcache DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (fkartista, fkapresentacao),
    CONSTRAINT fkparticipacoesartistas FOREIGN KEY (fkartista) REFERENCES artistas(idartista),
    CONSTRAINT fkparticipacoesapresentacoes FOREIGN KEY (fkapresentacao) REFERENCES apresentacoes(idapresentacao)
);

INSERT INTO artistas (nomeartistico, paisorigem, anoestreia) VALUES 
('Anitta', 'Brasil', 2010),
('Alok', 'Brasil', 2004),
('Coldplay', 'Reino Unido', 1996),
('Bad Bunny', 'Porto Rico', 2016),
('Aurora', 'Noruega', 2012),
('Caetano Veloso', 'Brasil', 1965),
('Aethel', 'Suécia', 2021),
('Zeca Pagodinho', 'Brasil', 1983);

INSERT INTO palcos (nome, capacidade) VALUES 
('Palco Mundo', 100000),
('Palco Sunset', 40000),
('Palco Eletrônico', 15000),
('Palco Acústico', 5000);

INSERT INTO apresentacoes (dataapresentacao, horarioinicio, duracaominutos, fkpalco) VALUES 
('2026-09-15', '21:00:00', 90, 1),
('2026-09-15', '23:00:00', 120, 1),
('2026-09-16', '18:00:00', 60, 2),
('2026-09-16', '20:00:00', 90, 2),
('2026-09-17', '01:00:00', 120, 3),
('2026-09-17', '17:00:00', 75, 2),
('2026-09-17', '19:00:00', 60, 1),
('2026-09-18', '20:00:00', 90, 1),
('2026-09-18', '22:00:00', 90, 2),
('2026-09-19', '18:00:00', 60, 3),
('2026-09-19', '20:00:00', 120, 1),
('2026-09-19', '23:00:00', 90, 3);

INSERT INTO participacoesapresentacao (fkartista, fkapresentacao, valorcache) VALUES 
(1, 1, 3000.00),
(2, 1, 3000.00),
(3, 2, 15000.00),
(4, 3, 4000.00),
(5, 4, 2500.00),
(6, 4, 3500.00),
(2, 5, 4500.00),
(1, 6, 2000.00),
(7, 7, 1000.00),
(8, 8, 4000.00),
(3, 9, 12000.00),
(5, 10, 2000.00),
(4, 11, 8000.00),
(2, 12, 5000.00);

SELECT ar.nomeartistico, pa.fkpalco, ap.dataapresentacao, pa.valorcache
FROM participacoesapresentacao pa
JOIN artistas ar ON pa.fkartista = ar.idartista
JOIN apresentacoes ap ON pa.fkapresentacao = ap.idapresentacao;

SELECT ar.nomeartistico, COUNT(pa.fkapresentacao) AS qtdapresentacoes
FROM artistas ar
LEFT JOIN participacoesapresentacao pa ON ar.idartista = pa.fkartista
WHERE ar.nomeartistico LIKE '%a%' AND ar.anoestreia < 2020
GROUP BY ar.idartista, ar.nomeartistico;

SELECT 
    p.nome AS palco,
    COUNT(DISTINCT ap.idapresentacao) AS qtdapresentacoes,
    COALESCE(SUM(pa.valorcache), 0) AS somacaches
FROM palcos p
LEFT JOIN apresentacoes ap ON p.idpalco = ap.fkpalco
LEFT JOIN participacoesapresentacao pa ON ap.idapresentacao = pa.fkapresentacao
GROUP BY p.idpalco, p.nome;

SELECT 
    ar.nomeartistico,
    MIN(pa.valorcache) AS menorcache,
    MAX(pa.valorcache) AS maiorcache,
    ROUND(AVG(pa.valorcache), 2) AS cachemedio
FROM artistas ar
JOIN participacoesapresentacao pa ON ar.idartista = pa.fkartista
GROUP BY ar.idartista, ar.nomeartistico;

SELECT 
    ap.idapresentacao,
    ap.fkpalco,
    COUNT(pa.fkartista) AS qtdartistas,
    SUM(pa.valorcache) AS custototal
FROM apresentacoes ap
JOIN participacoesapresentacao pa ON ap.idapresentacao = pa.fkapresentacao
GROUP BY ap.idapresentacao, ap.fkpalco
HAVING SUM(pa.valorcache) > 5000.00;

SELECT 
    p.nome AS palco,
    COUNT(ap.idapresentacao) AS qtdapresentacoes,
    CASE 
        WHEN COUNT(ap.idapresentacao) = 0 THEN 'Sem apresentações'
        WHEN COUNT(ap.idapresentacao) IN (1, 2) THEN 'Baixa utilização'
        ELSE 'Alta utilização'
    END AS classificacao
FROM palcos p
LEFT JOIN apresentacoes ap ON p.idpalco = ap.fkpalco
GROUP BY p.idpalco, p.nome;


-- EXERCICIO 4

CREATE TABLE areas (
    idarea INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE titulacoes (
    idtitulacao INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE pesquisadores (
    idpesquisador INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    fkarea INT NOT NULL,
    fktitulacao INT NOT NULL,
    CONSTRAINT fkpesquisadoresareas FOREIGN KEY (fkarea) REFERENCES areas(idarea),
    CONSTRAINT fkpesquisadorestitulacoes FOREIGN KEY (fktitulacao) REFERENCES titulacoes(idtitulacao)
);

CREATE TABLE situacoes (
    idsituacao INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE projetos (
    idprojeto INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    orcamentoprevisto DECIMAL(12,2) NOT NULL,
    datainicio DATE NOT NULL,
    fksituacao INT NOT NULL,
    CONSTRAINT fkprojetossituacoes FOREIGN KEY (fksituacao) REFERENCES situacoes(idsituacao)
);

CREATE TABLE equipes (
    fkpesquisador INT NOT NULL,
    fkprojeto INT NOT NULL,
    horasdedicadas INT NOT NULL,
    valorhora DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (fkpesquisador, fkprojeto),
    CONSTRAINT fkequipespesquisadores FOREIGN KEY (fkpesquisador) REFERENCES pesquisadores(idpesquisador),
    CONSTRAINT fkequipesprojetos FOREIGN KEY (fkprojeto) REFERENCES projetos(idprojeto)
);

INSERT INTO areas (descricao) VALUES 
('Biotecnologia'), 
('Inteligência Artificial'), 
('Energia Renovável');

INSERT INTO titulacoes (descricao) VALUES 
('Mestre'), 
('Doutor'), 
('Pós-Doutor');

INSERT INTO pesquisadores (nome, fkarea, fktitulacao) VALUES 
('Alice Monteiro', 1, 2),
('Bernardo Silva', 2, 3),
('Clara Nunes', 3, 1),
('Daniel Costa', 2, 2),
('Eva Green', 1, 3),
('Fabio Assunção', 3, 2),
('Gisele Bündchen', 2, 1),
('Hugo Gloss', 1, 1);

INSERT INTO situacoes (descricao) VALUES 
('Planejado'), 
('Em Andamento'), 
('Concluído');

INSERT INTO projetos (titulo, orcamentoprevisto, datainicio, fksituacao) VALUES 
('Mapeamento Genético Local', 50000.00, '2023-01-10', 2),
('Algoritmos de IA Médica', 120000.00, '2023-03-15', 2),
('Painéis Solares Orgânicos', 80000.00, '2022-06-01', 3),
('Estudo de Vacinas RNA', 200000.00, '2024-01-01', 1),
('Otimização da Rede Elétrica', 45000.00, '2023-08-20', 2),
('Processamento de Linguagem Natural', 60000.00, '2023-05-10', 3);

INSERT INTO equipes (fkpesquisador, fkprojeto, horasdedicadas, valorhora) VALUES 
(1, 1, 100, 150.00),
(5, 1, 80, 200.00),
(2, 2, 200, 250.00),
(4, 2, 150, 180.00),
(3, 3, 120, 120.00),
(6, 3, 100, 160.00),
(6, 5, 90, 160.00),
(2, 6, 50, 250.00);

ALTER TABLE projetos 
ADD COLUMN orcamentomaximo DECIMAL(12,2) NOT NULL DEFAULT 0.00,
ADD CONSTRAINT chkorcamentomaximo CHECK (orcamentomaximo >= 0),
ADD CONSTRAINT chkorcamentoprevisto CHECK (orcamentoprevisto >= 0);

SELECT 
    p.nome AS pesquisador,
    a.descricao AS areaespecializacao,
    eq.horasdedicadas,
    (eq.horasdedicadas * eq.valorhora) AS custoindividual
FROM equipes eq
JOIN pesquisadores p ON eq.fkpesquisador = p.idpesquisador
JOIN areas a ON p.fkarea = a.idarea
JOIN projetos pr ON eq.fkprojeto = pr.idprojeto
JOIN situacoes s ON pr.fksituacao = s.idsituacao
WHERE s.descricao = 'Em Andamento';

SELECT 
    pr.titulo AS projeto,
    COUNT(eq.fkpesquisador) AS qtdpesquisadores,
    SUM(eq.horasdedicadas) AS somahoras,
    SUM(eq.horasdedicadas * eq.valorhora) AS custototalequipe
FROM projetos pr
JOIN equipes eq ON pr.idprojeto = eq.fkprojeto
GROUP BY pr.idprojeto, pr.titulo;

SELECT 
    a.descricao AS area,
    COUNT(DISTINCT p.idpesquisador) AS qtdpesquisadores,
    COUNT(DISTINCT eq.fkprojeto) AS qtdprojetosdiferentes,
    AVG(eq.horasdedicadas) AS mediahorasdedicadas
FROM areas a
LEFT JOIN pesquisadores p ON a.idarea = p.fkarea
LEFT JOIN equipes eq ON p.idpesquisador = eq.fkpesquisador
GROUP BY a.idarea, a.descricao;

SELECT 
    pr.titulo,
    pr.orcamentoprevisto,
    SUM(eq.horasdedicadas * eq.valorhora) AS custototalequipe,
    ROUND((SUM(eq.horasdedicadas * eq.valorhora) / pr.orcamentoprevisto) * 100, 2) AS percentualutilizado
FROM projetos pr
JOIN equipes eq ON pr.idprojeto = eq.fkprojeto
GROUP BY pr.idprojeto, pr.titulo, pr.orcamentoprevisto
HAVING SUM(eq.horasdedicadas * eq.valorhora) > (pr.orcamentoprevisto * 0.70);

SELECT 
    pr.titulo,
    s.descricao AS situacao,
    CASE 
        WHEN COUNT(eq.fkpesquisador) = 0 THEN 'Sem custo'
        WHEN SUM(eq.horasdedicadas * eq.valorhora) <= pr.orcamentoprevisto THEN 'Dentro do orçamento'
        ELSE 'Acima do orçamento'
    END AS classificacaoorcamentaria
FROM projetos pr
JOIN situacoes s ON pr.fksituacao = s.idsituacao
LEFT JOIN equipes eq ON pr.idprojeto = eq.fkprojeto
GROUP BY pr.idprojeto, pr.titulo, s.descricao, pr.orcamentoprevisto;


-- EXERCICIO 5

CREATE TABLE estudantes (
    idestudante INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    cidade VARCHAR(50) NOT NULL
);

CREATE TABLE areasconhecimento (
    idareaconhecimento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE cursos (
    idcurso INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    cargahoraria INT NOT NULL,
    fkareaconhecimento INT NOT NULL,
    CONSTRAINT fkcursosareasconhecimento FOREIGN KEY (fkareaconhecimento) REFERENCES areasconhecimento(idareaconhecimento)
);

CREATE TABLE especialidades (
    idespecialidade INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE instrutorescurso (
    idinstrutor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    fkespecialidade INT NOT NULL,
    CONSTRAINT fkinstrutoresespecialidades FOREIGN KEY (fkespecialidade) REFERENCES especialidades(idespecialidade)
);

CREATE TABLE atuacoes (
    fkinstrutor INT NOT NULL,
    fkcurso INT NOT NULL,
    remuneracao DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (fkinstrutor, fkcurso),
    CONSTRAINT fkatuacoesinstrutores FOREIGN KEY (fkinstrutor) REFERENCES instrutorescurso(idinstrutor),
    CONSTRAINT fkatuacoescursos FOREIGN KEY (fkcurso) REFERENCES cursos(idcurso)
);

CREATE TABLE inscricoes (
    fkestudante INT NOT NULL,
    fkcurso INT NOT NULL,
    datainscricao DATE NOT NULL,
    notafinal DECIMAL(4,2),
    frequencia DECIMAL(5,2),
    PRIMARY KEY (fkestudante, fkcurso),
    CONSTRAINT fkinscricoesestudantes FOREIGN KEY (fkestudante) REFERENCES estudantes(idestudante),
    CONSTRAINT fkinscricoescursos FOREIGN KEY (fkcurso) REFERENCES cursos(idcurso)
);

INSERT INTO estudantes (nome, email, cidade) VALUES 
('Alan Turing', 'alan@email.com', 'São Paulo'),
('Beatriz Haddad', 'beatriz@email.com', 'Rio de Janeiro'),
('Caio Castro', 'caio@email.com', 'Campinas'),
('Daniela Mercury', 'daniela@email.com', 'Salvador'),
('Edson Arantes', 'edson@email.com', 'Santos'),
('Fernanda Montenegro', 'fernanda@email.com', 'Rio de Janeiro'),
('Giba Nogueira', 'giba@email.com', 'Curitiba'),
('Helena Ranaldi', 'helena@email.com', 'São Paulo'),
('Iza Pesadão', 'iza@email.com', 'Niterói'),
('Jão Silva', 'jao@email.com', 'Araraquara');

INSERT INTO areasconhecimento (nome) VALUES 
('Tecnologia'), 
('Negócios'), 
('Design');

INSERT INTO cursos (titulo, cargahoraria, fkareaconhecimento) VALUES 
('Lógica de Programação', 40, 1),
('Banco de Dados SQL', 60, 1),
('Marketing Digital', 30, 2),
('Gestão de Projetos', 50, 2),
('UX/UI Design', 45, 3),
('Desenvolvimento Web', 80, 1);

INSERT INTO especialidades (descricao) VALUES 
('Engenharia de Software'), 
('Administração'), 
('Design Gráfico');

INSERT INTO instrutorescurso (nome, fkespecialidade) VALUES 
('Linus Torvalds', 1),
('Steve Jobs', 2),
('Don Norman', 3),
('Ada Lovelace', 1);

INSERT INTO atuacoes (fkinstrutor, fkcurso, remuneracao) VALUES 
(1, 1, 3000.00),
(1, 2, 4500.00),
(4, 1, 2500.00),
(4, 6, 5000.00),
(2, 3, 3500.00),
(3, 5, 4000.00);

INSERT INTO inscricoes (fkestudante, fkcurso, datainscricao, notafinal, frequencia) VALUES 
(1, 1, '2023-01-10', 9.5, 90.00),
(2, 1, '2023-01-11', 8.0, 85.00),
(3, 1, '2023-01-12', 7.0, 80.00),
(4, 1, '2023-01-12', 5.5, 90.00),
(5, 1, '2023-01-15', 8.5, 70.00),
(1, 2, '2023-02-01', 9.0, 95.00),
(6, 2, '2023-02-02', 6.5, 78.00),
(7, 2, '2023-02-03', 7.5, 82.00),
(8, 3, '2023-03-01', 4.0, 60.00),
(9, 4, '2023-03-05', 8.0, 100.00);

SELECT e.nome AS estudante, c.titulo AS curso, i.notafinal, i.frequencia
FROM inscricoes i
JOIN estudantes e ON i.fkestudante = e.idestudante
JOIN cursos c ON i.fkcurso = c.idcurso
JOIN areasconhecimento a ON c.fkareaconhecimento = a.idareaconhecimento
WHERE a.nome = 'Tecnologia';

SELECT 
    c.titulo AS curso,
    COUNT(i.fkestudante) AS qtdinscritos,
    MIN(i.notafinal) AS menornota,
    MAX(i.notafinal) AS maiornota,
    TRUNCATE(AVG(i.notafinal), 1) AS medianotas
FROM cursos c
LEFT JOIN inscricoes i ON c.idcurso = i.fkcurso
GROUP BY c.idcurso, c.titulo;

SELECT c.titulo AS curso
FROM cursos c
JOIN inscricoes i ON c.idcurso = i.fkcurso
WHERE i.notafinal >= 6.0 AND i.frequencia >= 75.00
GROUP BY c.idcurso, c.titulo
HAVING COUNT(i.fkestudante) >= 3;

SELECT 
    ins.nome AS instrutor,
    esp.descricao AS especialidade,
    COUNT(a.fkcurso) AS qtdcursos,
    SUM(a.remuneracao) AS somaremuneracoes
FROM instrutorescurso ins
JOIN especialidades esp ON ins.fkespecialidade = esp.idespecialidade
JOIN atuacoes a ON ins.idinstrutor = a.fkinstrutor
GROUP BY ins.idinstrutor, ins.nome, esp.descricao
HAVING COUNT(a.fkcurso) > 1;

SELECT 
    CASE 
        WHEN notafinal >= 6.0 AND frequencia >= 75.00 THEN 'Aprovado'
        WHEN frequencia < 75.00 THEN 'Reprovado por frequência'
        ELSE 'Reprovado por nota'
    END AS resultado,
    COUNT(*) AS qtdinscricoes
FROM inscricoes
WHERE notafinal IS NOT NULL AND frequencia IS NOT NULL
GROUP BY 
    CASE 
        WHEN notafinal >= 6.0 AND frequencia >= 75.00 THEN 'Aprovado'
        WHEN frequencia < 75.00 THEN 'Reprovado por frequência'
        ELSE 'Reprovado por nota'
    END;

SELECT 
    a.nome AS areaconhecimento,
    COUNT(DISTINCT c.idcurso) AS qtdcursos,
    COUNT(DISTINCT i.fkestudante) AS qtdestudantesunicos,
    AVG(i.notafinal) AS medianotas,
    ROUND(
        (SUM(CASE WHEN i.notafinal >= 6.0 AND i.frequencia >= 75.00 THEN 1 ELSE 0 END) / COUNT(i.fkestudante)) * 100, 2
    ) AS percentualaprovados
FROM areasconhecimento a
LEFT JOIN cursos c ON a.idareaconhecimento = c.fkareaconhecimento
LEFT JOIN inscricoes i ON c.idcurso = i.fkcurso AND i.notafinal IS NOT NULL AND i.frequencia IS NOT NULL
GROUP BY a.idareaconhecimento, a.nome;


-- EXERCICIO 6

CREATE TABLE tutores (
    idtutor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    cidade VARCHAR(50) NOT NULL
);

CREATE TABLE especies (
    idespecie INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE animais (
    idanimal INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    peso DECIMAL(5,2) NOT NULL,
    datanascimento DATE NOT NULL,
    fktutor INT NOT NULL,
    fkespecie INT NOT NULL,
    CONSTRAINT fkanimaistutores FOREIGN KEY (fktutor) REFERENCES tutores(idtutor),
    CONSTRAINT fkanimaisespecies FOREIGN KEY (fkespecie) REFERENCES especies(idespecie)
);

CREATE TABLE especialidadesvet (
    idespecialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE veterinarios (
    idveterinario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    fkespecialidade INT NOT NULL,
    CONSTRAINT fkveterenariosespecialidades FOREIGN KEY (fkespecialidade) REFERENCES especialidadesvet(idespecialidade)
);

CREATE TABLE situacoesatendimento (
    idsituacao INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE atendimentos (
    idatendimento INT AUTO_INCREMENT PRIMARY KEY,
    dataatendimento DATE NOT NULL,
    fkanimal INT NOT NULL,
    fkveterinario INT NOT NULL,
    fksituacao INT NOT NULL,
    CONSTRAINT fkatendimentosanimais FOREIGN KEY (fkanimal) REFERENCES animais(idanimal),
    CONSTRAINT fkatendimentosveterinarios FOREIGN KEY (fkveterinario) REFERENCES veterinarios(idveterinario),
    CONSTRAINT fkatendimentossituacoes FOREIGN KEY (fksituacao) REFERENCES situacoesatendimento(idsituacao)
);

CREATE TABLE procedimentos (
    idprocedimento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE atendimentosprocedimentos (
    fkatendimento INT NOT NULL,
    fkprocedimento INT NOT NULL,
    valorunitario DECIMAL(10,2) NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (fkatendimento, fkprocedimento),
    CONSTRAINT fkapatendimentos FOREIGN KEY (fkatendimento) REFERENCES atendimentos(idatendimento),
    CONSTRAINT fkapprocedimentos FOREIGN KEY (fkprocedimento) REFERENCES procedimentos(idprocedimento)
);

INSERT INTO tutores (nome, telefone, cidade) VALUES 
('Aline Dias', '11999990001', 'São Paulo'),
('Beto Carreiro', '11999990002', 'Campinas'),
('Clavia Abreu', '11999990003', 'Santos'),
('Davi Lucca', '11999990004', 'São Paulo'),
('Eliana Michaelichen', '11999990005', 'Osasco'),
('Fabiano Silva', '11999990006', 'Guarulhos');

INSERT INTO especies (nome) VALUES 
('Cão'), 
('Gato'), 
('Ave');

INSERT INTO animais (nome, peso, datanascimento, fktutor, fkespecie) VALUES 
('Rex', 15.5, '2020-01-01', 1, 1),
('Thor', 25.0, '2019-05-10', 1, 1),
('Mimi', 4.2, '2021-03-15', 2, 2),
('Frajola', 3.8, '2022-07-20', 3, 2),
('Loro', 0.5, '2018-11-02', 4, 3),
('Mel', 8.0, '2021-12-12', 4, 1),
('Bob', 12.0, '2017-08-30', 5, 1),
('Nina', 3.0, '2023-01-05', 5, 2),
('Bidu', 6.5, '2020-10-10', 6, 1),
('Pipoca', 2.5, '2022-02-14', 6, 2);

INSERT INTO especialidadesvet (nome) VALUES 
('Clinica Geral'), 
('Cirurgia'), 
('Dermatologia');

INSERT INTO veterinarios (nome, fkespecialidade) VALUES 
('Dr. Roberto', 1),
('Dra. Julia', 2),
('Dr. Marcos', 3),
('Dra. Camila', 1);

INSERT INTO situacoesatendimento (descricao) VALUES 
('Agendado'), 
('Realizado'), 
('Cancelado');

INSERT INTO procedimentos (nome) VALUES 
('Consulta de Rotina'),
('Exame de Sangue'),
('Exame de Raio-X'),
('Vacinação Anti-rábica'),
('Limpeza de Tártaro'),
('Exame Ultrassom');

INSERT INTO atendimentos (dataatendimento, fkanimal, fkveterinario, fksituacao) VALUES 
('2023-01-10', 1, 1, 2),
('2023-01-11', 2, 1, 2),
('2023-01-12', 3, 2, 2),
('2023-01-13', 4, 3, 2),
('2023-01-14', 1, 1, 2),
('2023-01-15', 5, 4, 2),
('2023-01-16', 6, 1, 2),
('2023-01-17', 7, 2, 2),
('2023-01-18', 8, 3, 2),
('2023-01-19', 9, 2, 2),
('2023-01-20', 1, 2, 2),
('2023-01-21', 2, 1, 1),
('2023-01-22', 3, 3, 3),
('2023-01-23', 4, 4, 2),
('2023-01-24', 6, 1, 2);

INSERT INTO atendimentosprocedimentos (fkatendimento, fkprocedimento, valorunitario, quantidade) VALUES 
(1, 1, 100.00, 1),
(1, 2, 80.00, 1),
(2, 1, 100.00, 1),
(2, 3, 150.00, 1),
(3, 1, 120.00, 1),
(4, 2, 80.00, 2),
(5, 6, 200.00, 1),
(6, 4, 60.00, 1),
(7, 1, 100.00, 1),
(7, 2, 80.00, 1),
(7, 3, 150.00, 1),
(8, 5, 300.00, 1),
(9, 1, 100.00, 1),
(10, 2, 80.00, 1),
(11, 3, 150.00, 1),
(14, 1, 100.00, 1),
(15, 1, 100.00, 1);

SELECT 
    a.nome AS animal,
    t.nome AS tutor,
    e.nome AS especie,
    COUNT(at.idatendimento) AS qtdatendimentos
FROM animais a
JOIN tutores t ON a.fktutor = t.idtutor
JOIN especies e ON a.fkespecie = e.idespecie
LEFT JOIN atendimentos at ON a.idanimal = at.fkanimal AND at.fksituacao = 2
GROUP BY a.idanimal, a.nome, t.nome, e.nome;

SELECT 
    v.nome AS veterinario,
    ev.nome AS especialidade,
    COUNT(DISTINCT at.fkanimal) AS qtdanimaisdiferentes
FROM veterinarios v
JOIN especialidadesvet ev ON v.fkespecialidade = ev.idespecialidade
LEFT JOIN atendimentos at ON v.idveterinario = at.fkveterinario AND at.fksituacao = 2
GROUP BY v.idveterinario, v.nome, ev.nome;

SELECT 
    p.nome AS procedimento,
    COALESCE(SUM(ap.quantidade), 0) AS totalexecucoes,
    COALESCE(SUM(ap.quantidade * ap.valorunitario), 0) AS valorarrecadado
FROM procedimentos p
JOIN atendimentosprocedimentos ap ON p.idprocedimento = ap.fkprocedimento
JOIN atendimentos at ON ap.fkatendimento = at.idatendimento
WHERE p.nome LIKE '%exame%' AND at.fksituacao = 2
GROUP BY p.idprocedimento, p.nome;

SELECT 
    at.idatendimento,
    COUNT(DISTINCT ap.fkprocedimento) AS qtdprocedimentosdiferentes,
    COALESCE(SUM(ap.quantidade), 0) AS totalexecucoes,
    COALESCE(SUM(ap.quantidade * ap.valorunitario), 0) AS valorcobrado
FROM atendimentos at
LEFT JOIN atendimentosprocedimentos ap ON at.idatendimento = ap.fkatendimento
WHERE at.fksituacao = 2
GROUP BY at.idatendimento;

SELECT 
    v.nome AS veterinario,
    COUNT(DISTINCT at.idatendimento) AS qtdatendimentos,
    COALESCE(SUM(ap.quantidade * ap.valorunitario), 0) / COUNT(DISTINCT at.idatendimento) AS mediaarrecadacao
FROM veterinarios v
JOIN atendimentos at ON v.idveterinario = at.fkveterinario AND at.fksituacao = 2
LEFT JOIN atendimentosprocedimentos ap ON at.idatendimento = ap.fkatendimento
GROUP BY v.idveterinario, v.nome
HAVING COUNT(DISTINCT at.idatendimento) >= 3 
   AND (COALESCE(SUM(ap.quantidade * ap.valorunitario), 0) / COUNT(DISTINCT at.idatendimento)) > 200.00;

SELECT 
    t.nome AS tutor,
    COUNT(DISTINCT a.idanimal) AS qtdanimais,
    COUNT(DISTINCT at.idatendimento) AS qtdatendimentosrealizados,
    COALESCE(SUM(ap.quantidade * ap.valorunitario), 0) AS valorgasto,
    CASE 
        WHEN COALESCE(SUM(ap.quantidade * ap.valorunitario), 0) = 0 THEN 'Sem gastos'
        WHEN COALESCE(SUM(ap.quantidade * ap.valorunitario), 0) <= 500.00 THEN 'Até R$ 500'
        ELSE 'Acima de R$ 500'
    END AS classificacaogasto
FROM tutores t
LEFT JOIN animais a ON t.idtutor = a.fktutor
LEFT JOIN atendimentos at ON a.idanimal = at.fkanimal AND at.fksituacao = 2
LEFT JOIN atendimentosprocedimentos ap ON at.idatendimento = ap.fkatendimento
GROUP BY t.idtutor, t.nome;