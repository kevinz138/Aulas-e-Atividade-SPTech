USE sprint2;

CREATE TABLE animal (
idAnimal INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45),
especie VARCHAR(45),
raca VARCHAR(45),
idade INT
);

CREATE TABLE ficha_medica (
    idFichamedica INT AUTO_INCREMENT PRIMARY KEY,
    data_ultima_consulta DATE,
    peso DECIMAL(5,2),
    vacina_em_dia BOOLEAN,
    observacao VARCHAR(255),
    fkAnimal INT UNIQUE,
    CONSTRAINT fk_Animal FOREIGN KEY (fkAnimal) REFERENCES animal(idAnimal)
);

INSERT INTO animal (nome, especie, raca, idade) VALUES 
('Rex', 'Cão', 'Pastor Alemão', 5),
('Miau', 'Gato', 'Siamês', 3),
('Bob', 'Cão', 'Labrador', 2),
('Thor', 'Gato', 'Persa', 4),
('Pipoca', 'Coelho', 'Mini Lop', 1);

INSERT INTO ficha_medica (data_ultima_consulta, peso, vacina_em_dia, observacao, fkAnimal) VALUES 
('2023-01-15', 25.5, TRUE, 'Saudável', 1),
('2023-02-20', 4.2, TRUE, 'Sem alterações', 2),
('2023-03-10', 30.0, FALSE, 'Necessita vacina', 3),
('2023-04-05', 3.8, TRUE, 'Check-up realizado', 4);

SELECT * FROM animal;
SELECT * FROM ficha_medica;

SELECT nome, especie FROM animal;

SELECT * FROM ficha_medica
	WHERE vacina_em_dia = FALSE;
    
SELECT * FROM animal ORDER BY idade DESC;

