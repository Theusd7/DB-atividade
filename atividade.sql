create database ATIVIDADE;
use ATIVIDADE;
--clientes (id, nome, email, telefone, data_cadastro)
create table CLIENTES(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255),
    email VARCHAR(255),
    telefone VARCHAR(255),
    data_cadastro DATE
);
--produtos (id, nome, descricao, preco, estoque)
create table PRODUTOS(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255),
    descricao VARCHAR(255),
    preco DECIMAL(9,2),
    estoque DECIMAL(9,2)
);
--pedidos (id, cliente_id, data_pedido, status)
create table PEDIDOS(
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    data_pedido DATE,
    status VARCHAR(25),
    FOREIGN KEY (cliente_id) REFERENCES CLIENTES(ID)

);
--itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario)
create table itens_pedido(
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade int,
    preco_unitario DECIMAL(9,3),
    FOREIGN KEY (pedido_id) REFERENCES PEDIDOS(id),
    FOREIGN KEY (produto_id) REFERENCES PRODUTOS(id)
);
--suporte_tecnico (id, cliente_id, descricao_problema, data_abertura, status)
create table suporte_tecnico(
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    descricao_problema LONGTEXT,
    data_abertura DATE,
    status VARCHAR(25),
    FOREIGN KEY (cliente_id) REFERENCES CLIENTES(id)
);
--avaliacoes (id, cliente_id, produto_id, nota, comentario)
create table avaliacoes(
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    produto_id INT NOT NULL,
    nota DECIMAL(9,2),
    comentario LONGTEXT,
    FOREIGN KEY (cliente_id) REFERENCES CLIENTES(id),
    FOREIGN KEY (produto_id) REFERENCES PRODUTOS(id)
);

