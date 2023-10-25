1 //

DELIMITER //
CREATE TRIGGER Adicao_de_Cliente
AFTER INSERT ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Novo cliente inserido em ', NOW()));
END;
//
DELIMITER ;


2 //

DELIMITER //
CREATE TRIGGER RetirarCliente
BEFORE DELETE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Tentativa de retirar cliente: ', OLD.nome, ' em ', NOW()));
END;
//
DELIMITER ;


3 ---

DELIMITER //
CREATE TRIGGER NovoNome
AFTER UPDATE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Nome do cliente atualizado de "', OLD.nome, '" para "', NEW.nome, '" em ', NOW()));
END;
//
DELIMITER ;
  

4 //

DELIMITER //
CREATE TRIGGER NovoNomeCliente
BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL OR NEW.nome = '' THEN
       INSERT INTO Auditoria (mensagem) VALUES  (CONCAT('Não foi concedido a tentativa de atualização do nome para uma string vazia ou NULL'); 
    SET NEW.nome = OLD.nome;
    END IF;
END;
//
DELIMITER ;


5 //

DELIMITER //
CREATE TRIGGER NovoProdutoEstoque
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    UPDATE Produtos
    SET estoque = estoque - NEW.quantidade
    WHERE id = NEW.produto_id;

    IF (SELECT estoque FROM Produtos WHERE id = NEW.produto_id) < 5 THEN
        INSERT INTO Auditoria (mensagem) VALUES ('Está abaixo de 5 unidades o estoque do produto');
    END IF;
END;
//
DELIMITER ;


