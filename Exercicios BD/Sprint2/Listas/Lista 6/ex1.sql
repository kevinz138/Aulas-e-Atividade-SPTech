CREATE TABLE animal (
    id INT,
    nome VARCHAR(100),
    especie VARCHAR(50),
    raca VARCHAR(50),
    idade INT
);

CREATE TABLE ficha_medica (
    id INT,
    data_ultima_consulta DATE,
    peso DECIMAL(5, 2),
    vacina_em_dia BOOLEAN,
    observacao VARCHAR(255),
    fk_animal INT
);

INSERT INTO animal (id, nome, especie, raca, idade) VALUES
(1, 'Rex', 'Cachorro', 'Labrador', 1),
(2, 'Miau', 'Gato', 'Siamês', 4),
(3, 'Thor', 'Cachorro', NULL, 8),
(4, 'Bob', 'Cachorro', 'Poodle', 3),
(5, 'Mel', 'Gato', 'Persa', 2);

INSERT INTO ficha_medica (id, data_ultima_consulta, peso, vacina_em_dia, observacao, fk_animal) VALUES
(1, '2026-01-15', 4.5, TRUE, 'Consulta de rotina realizada', 1),
(2, '2025-11-20', 3.8, FALSE, NULL, 2),
(3, '2026-02-10', 22.0, TRUE, 'Animal em excelente estado', 3),
(4, '2025-08-05', 12.3, FALSE, 'Necessita vacina de raiva', 4);

SELECT * FROM animal;

SELECT * FROM ficha_medica;

INSERT INTO ficha_medica (id, data_ultima_consulta, peso, vacina_em_dia, observacao, fk_animal) VALUES 
(5, '2026-03-01', 4.6, TRUE, 'Segunda ficha para o mesmo animal', 1);

SELECT nome, especie FROM animal;

SELECT * FROM ficha_medica WHERE vacina_em_dia = FALSE;

SELECT * FROM animal ORDER BY idade DESC;

SELECT * FROM animal WHERE especie = 'Cachorro';

SELECT nome AS 'Pet', especie AS 'Tipo' FROM animal;

SELECT peso AS 'Peso (kg)', data_ultima_consulta AS 'Ultima Consulta' FROM ficha_medica;

SELECT nome, idade * 7 AS 'Idade Humana Aproximada' FROM animal;

SELECT nome AS 'Nome do Pet', raca AS 'Raca/Tipo' FROM animal;

SELECT nome, 
       CASE 
           WHEN idade < 2 THEN 'Filhote'
           WHEN idade BETWEEN 2 AND 7 THEN 'Adulto'
           ELSE 'Idoso'
       END AS fase_vida 
FROM animal;

SELECT animal.nome, 
       CASE 
           WHEN ficha_medica.vacina_em_dia = TRUE THEN 'Vacinado'
           ELSE 'Pendente'
       END AS vacinacao 
FROM animal 
INNER JOIN ficha_medica ON animal.id = ficha_medica.fk_animal;

SELECT peso, 
       CASE 
           WHEN peso < 5 THEN 'Pequeno'
           WHEN peso BETWEEN 5 AND 20 THEN 'Médio'
           ELSE 'Grande'
       END AS porte 
FROM ficha_medica;

SELECT nome, 
       CASE 
           WHEN especie = 'Cachorro' THEN 'Canino'
           WHEN especie = 'Gato' THEN 'Felino'
           ELSE 'Outro'
       END AS especie_tipo 
FROM animal;

SELECT animal.nome, IFNULL(ficha_medica.observacao, 'Nenhuma observação') AS observacao 
FROM animal 
INNER JOIN ficha_medica ON animal.id = ficha_medica.fk_animal;

SELECT animal.nome, IFNULL(ficha_medica.data_ultima_consulta, 'SEM FICHA') AS ultima_consulta 
FROM animal 
LEFT JOIN ficha_medica ON animal.id = ficha_medica.fk_animal;

SELECT animal.nome, ficha_medica.peso, ficha_medica.data_ultima_consulta 
FROM animal 
INNER JOIN ficha_medica ON animal.id = ficha_medica.fk_animal;

SELECT CONCAT(animal.nome, ' - ', animal.especie, ' - ', ficha_medica.peso, ' kg') AS resumo 
FROM animal 
INNER JOIN ficha_medica ON animal.id = ficha_medica.fk_animal;

SELECT id, nome, especie, IFNULL(raca, 'Raca não informada') AS raca, idade 
FROM animal;