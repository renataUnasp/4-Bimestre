1//

DELIMITER //
CREATE FUNCTION total_livros_por_genero(genero_nome VARCHAR(255))
RETURNS INT
BEGIN
    DECLARE total INT;
    SET total = 0;

    SELECT COUNT(*) INTO total
    FROM Livro
    WHERE id_genero = (SELECT id FROM Genero WHERE nome_genero = genero_nome);

    RETURN total;
END//
DELIMITER ;



2// 

DELIMITER //
CREATE FUNCTION listar_livros_por_autor(primeiro_nome_autor VARCHAR(255), ultimo_nome_autor VARCHAR(255))
RETURNS TEXT
BEGIN
    DECLARE livro_list TEXT DEFAULT '';
    DECLARE livro_title VARCHAR(255);
    
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT Livro.titulo
        FROM Livro
        JOIN Livro_Autor ON Livro.id = Livro_Autor.id_livro
        JOIN Autor ON Livro_Autor.id_autor = Autor.id
        WHERE Autor.primeiro_nome = primeiro_nome_autor AND Autor.ultimo_nome = ultimo_nome_autor;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO livro_title;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        SET livro_list = CONCAT(livro_list, livro_title, ', ');
    END LOOP;
    
    CLOSE cur;
    
    RETURN livro_list;
END //
DELIMITER ;


3//

DELIMITER //
CREATE FUNCTION atualizar_resumos()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE livro_id INT;
    DECLARE resumo_text TEXT;
    
    DECLARE cur CURSOR FOR
        SELECT id, resumo
        FROM Livro;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    update_loop: LOOP
        FETCH cur INTO livro_id, resumo_text;
        IF done = 1 THEN
            LEAVE update_loop;
        END IF;
        UPDATE Livro
        SET resumo = CONCAT(resumo_text, ' Este é um excelente livro!')
        WHERE id = livro_id;
    END LOOP;
    
    CLOSE cur;
END //
DELIMITER ;



4// 

DELIMITER //
CREATE FUNCTION media_livros_por_editora()
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total_editoras INT;
    DECLARE total_livros INT;
    DECLARE media DECIMAL(10, 2);

    SELECT COUNT(*) INTO total_editoras FROM Editora;

    SELECT SUM(editora_count) INTO total_livros
    FROM (
        SELECT id_editora, COUNT(*) as editora_count
        FROM Livro
        GROUP BY id_editora
    ) AS editoras_livros;

    IF total_editoras > 0 THEN
        SET media = total_livros / total_editoras;
    ELSE
        SET media = 0;
    END IF;

    RETURN media;
END;
//
DELIMITER ;



5//

DELIMITER //
CREATE FUNCTION autores_sem_livros()
RETURNS TEXT
BEGIN
    DECLARE autor_list TEXT DEFAULT '';
    DECLARE autor_full_name VARCHAR(255);
    
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT CONCAT(primeiro_nome, ' ', ultimo_nome) as nome_autor
        FROM Autor
        WHERE Autor.id NOT IN (SELECT id_autor FROM Livro_Autor);
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO autor_full_name;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        SET autor_list = CONCAT(autor_list, autor_full_name, ', ');
    END LOOP;
    
    CLOSE cur;
    
    RETURN autor_list;
END //
DELIMITER ;

