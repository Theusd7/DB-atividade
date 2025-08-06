-- ===============================
-- PARTE 1 – CRIAÇÃO DAS TABELAS
-- ===============================

-- Tabela de clientes
CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,       -- Identificador único do cliente
    nome VARCHAR(100) NOT NULL,              -- Nome do cliente (obrigatório)
    email VARCHAR(100) UNIQUE NOT NULL,      -- E-mail do cliente (não pode repetir)
    telefone VARCHAR(20),                    -- Telefone do cliente (pode ser nulo)
    data_cadastro DATE NOT NULL              -- Data em que foi cadastrado
);

-- Tabela de produtos
CREATE TABLE produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,       -- Identificador único do produto
    nome VARCHAR(100) NOT NULL,              -- Nome do produto (obrigatório)
    descricao TEXT,                          -- Descrição do produto
    preco DECIMAL(10,2) NOT NULL,            -- Preço do produto com 2 casas decimais
    estoque INT NOT NULL                     -- Quantidade em estoque
);

-- Tabela de pedidos
CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,       -- Identificador único do pedido
    cliente_id INT NOT NULL,                 -- ID do cliente que fez o pedido
    data_pedido DATE NOT NULL,               -- Data em que o pedido foi realizado
    status VARCHAR(20) NOT NULL,             -- Status do pedido (Ex: Pendente, Entregue)
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)  -- Relaciona com a tabela de clientes
);

-- Tabela de itens do pedido
CREATE TABLE itens_pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,       -- Identificador único do item do pedido
    pedido_id INT NOT NULL,                  -- Pedido ao qual o item pertence
    produto_id INT NOT NULL,                 -- Produto adicionado ao pedido
    quantidade INT NOT NULL,                 -- Quantidade desse produto
    preco_unitario DECIMAL(10,2) NOT NULL,   -- Preço unitário do produto no momento da venda
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),   -- Relaciona com a tabela de pedidos
    FOREIGN KEY (produto_id) REFERENCES produtos(id)  -- Relaciona com a tabela de produtos
);

-- Tabela de suporte técnico
CREATE TABLE suporte_tecnico (
    id INT PRIMARY KEY AUTO_INCREMENT,       -- Identificador único do chamado
    cliente_id INT NOT NULL,                 -- Cliente que abriu o chamado
    descricao_problema TEXT NOT NULL,        -- Descrição do problema
    data_abertura DATE NOT NULL,             -- Data de abertura do chamado
    status VARCHAR(20) NOT NULL,             -- Status do chamado (Ex: Aberto, Resolvido)
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) -- Relaciona com a tabela de clientes
);

-- Tabela de avaliações
CREATE TABLE avaliacoes (
    id INT PRIMARY KEY AUTO_INCREMENT,       -- Identificador único da avaliação
    cliente_id INT NOT NULL,                 -- Cliente que avaliou
    produto_id INT NOT NULL,                 -- Produto avaliado
    nota INT CHECK(nota BETWEEN 1 AND 5),    -- Nota de 1 a 5
    comentario TEXT,                         -- Comentário opcional
    FOREIGN KEY (cliente_id) REFERENCES clientes(id), -- Relaciona com clientes
    FOREIGN KEY (produto_id) REFERENCES produtos(id)  -- Relaciona com produtos
);

-- ===============================
-- PARTE 2 – INSERÇÃO DE DADOS
-- ===============================

-- Inserindo 5 clientes
INSERT INTO clientes (nome, email, telefone, data_cadastro) VALUES
('Ana Silva', 'ana.silva@email.com', '11999999901', '2025-07-15'),
('Carlos Souza', 'carlos.souza@email.com', '11999999902', '2025-07-20'),
('Fernanda Lima', 'fernanda.lima@email.com', '11999999903', '2025-07-25'),
('João Mendes', 'joao.mendes@email.com', '11999999904', '2025-08-01'),
('Mariana Costa', 'mariana.costa@email.com', '11999999905', '2025-08-03');

-- Inserindo 5 produtos
INSERT INTO produtos (nome, descricao, preco, estoque) VALUES
('Notebook X1', 'Notebook leve e rápido', 3500.00, 15),
('Smartphone Y9', 'Celular com ótima câmera', 2500.00, 8),
('Mouse Gamer', 'Mouse com iluminação RGB', 150.00, 50),
('Teclado Mecânico', 'Teclado resistente para gamers', 300.00, 25),
('Monitor 24"', 'Monitor Full HD', 800.00, 12);

-- Inserindo 3 pedidos
INSERT INTO pedidos (cliente_id, data_pedido, status) VALUES
(1, '2025-08-02', 'Pendente'),  -- Pedido do cliente Ana Silva
(2, '2025-08-03', 'Pendente'),  -- Pedido do cliente Carlos Souza
(3, '2025-08-04', 'Entregue');  -- Pedido do cliente Fernanda Lima

-- Inserindo itens para cada pedido
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 1, 3500.00), -- Pedido 1: Notebook X1
(1, 3, 2, 150.00),  -- Pedido 1: 2x Mouse Gamer
(2, 2, 1, 2500.00), -- Pedido 2: Smartphone Y9
(2, 4, 1, 300.00),  -- Pedido 2: Teclado Mecânico
(3, 5, 1, 800.00),  -- Pedido 3: Monitor 24"
(3, 3, 1, 150.00);  -- Pedido 3: Mouse Gamer

-- Inserindo 2 chamados de suporte técnico
INSERT INTO suporte_tecnico (cliente_id, descricao_problema, data_abertura, status) VALUES
(1, 'Notebook não liga', '2025-08-05', 'Aberto'),
(4, 'Smartphone com defeito na câmera', '2025-08-06', 'Em andamento');

-- Inserindo 3 avaliações de produtos
INSERT INTO avaliacoes (cliente_id, produto_id, nota, comentario) VALUES
(1, 1, 5, 'Excelente notebook, muito rápido'),
(2, 2, 4, 'Ótima câmera, mas bateria poderia ser melhor'),
(3, 3, 5, 'Mouse muito confortável e bonito');

-- ===============================
-- PARTE 3 – CONSULTAS SIMPLES
-- ===============================

-- A) Produtos com estoque maior que 10 unidades
SELECT * 
FROM produtos
WHERE estoque > 10;

-- B) Clientes cadastrados no último mês
SELECT * 
FROM clientes
WHERE data_cadastro >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- C) Pedidos com status "Entregue"
SELECT * 
FROM pedidos
WHERE status = 'Entregue';

-- ===============================
-- PARTE 4 – CONSULTAS COM JOIN
-- ===============================

-- A) Pedidos com nome do cliente (JOIN entre pedidos e clientes)
SELECT 
    pedidos.id AS pedido_id,         -- ID do pedido
    clientes.nome AS cliente_nome,   -- Nome do cliente
    pedidos.data_pedido,             -- Data do pedido
    pedidos.status                   -- Status do pedido
FROM pedidos
JOIN clientes ON pedidos.cliente_id = clientes.id;

-- B) Itens de pedido com nome do produto e valor total
SELECT 
    itens_pedido.id AS item_id,                                  -- ID do item
    produtos.nome AS produto_nome,                               -- Nome do produto
    itens_pedido.quantidade,                                     -- Quantidade pedida
    itens_pedido.preco_unitario,                                 -- Preço por unidade
    (itens_pedido.quantidade * itens_pedido.preco_unitario) AS valor_total -- Calcula total
FROM itens_pedido
JOIN produtos ON itens_pedido.produto_id = produtos.id;

-- C) Avaliações com nome do cliente e produto avaliado
SELECT 
    avaliacoes.id AS avaliacao_id,           -- ID da avaliação
    clientes.nome AS cliente_nome,           -- Nome do cliente
    produtos.nome AS produto_nome,           -- Nome do produto
    avaliacoes.nota,                         -- Nota dada pelo cliente
    avaliacoes.comentario                    -- Comentário da avaliação
FROM avaliacoes
JOIN clientes ON avaliacoes.cliente_id = clientes.id
JOIN produtos ON avaliacoes.produto_id = produtos.id;
    -- ===============================
-- PARTE 5 – ATUALIZAÇÕES
-- ===============================

-- A) Atualizar o preço de um produto específico (exemplo: Notebook X1)
UPDATE produtos
SET preco = 3600.00       -- Novo preço
WHERE nome = 'Notebook X1'; -- Condição para encontrar o produto correto

-- B) Alterar o status de um pedido para "Entregue" (exemplo: pedido id = 1)
UPDATE pedidos
SET status = 'Entregue'
WHERE id = 1;

-- C) Corrigir o e-mail de um cliente específico (exemplo: cliente Ana Silva)
UPDATE clientes
SET email = 'ana.silva.novo@email.com'
WHERE nome = 'Ana Silva';

-- ===============================
-- PARTE 6 – DELEÇÕES CONTROLADAS
-- ===============================

-- A) Remover uma avaliação específica (exemplo: avaliação id = 2)
DELETE FROM avaliacoes
WHERE id = 2;

-- B) Cancelar um pedido sem excluir dados (só altera o status)
UPDATE pedidos
SET status = 'Cancelado'
WHERE id = 2;

-- C) Excluir um cliente somente se não houver pedidos ou chamados de suporte
-- Verificar antes se existe algum relacionamento
SELECT * FROM pedidos WHERE cliente_id = 5;        -- Verifica pedidos
SELECT * FROM suporte_tecnico WHERE cliente_id = 5; -- Verifica suporte

-- Se não houver resultados, pode excluir:
DELETE FROM clientes
WHERE id = 5;

-- ===============================
-- PARTE 7 – AGREGAÇÕES (FUNÇÕES)
-- ===============================

-- A) Média de avaliações por produto
SELECT 
    produtos.nome AS produto_nome,
    AVG(avaliacoes.nota) AS media_nota
FROM avaliacoes
JOIN produtos ON avaliacoes.produto_id = produtos.id
GROUP BY produtos.nome;

-- B) Total vendido (valor) por pedido
SELECT 
    pedido_id,
    SUM(quantidade * preco_unitario) AS valor_total
FROM itens_pedido
GROUP BY pedido_id;

-- C) Total de produtos vendidos por cliente
SELECT 
    clientes.nome AS cliente_nome,
    SUM(itens_pedido.quantidade) AS total_produtos
FROM pedidos
JOIN itens_pedido ON pedidos.id = itens_pedido.pedido_id
JOIN clientes ON pedidos.cliente_id = clientes.id
GROUP BY clientes.nome;

-- ===============================
-- PARTE 8 – ALTERAÇÕES ESTRUTURAIS
-- ===============================

-- A) Adicionar coluna "categoria" em produtos
ALTER TABLE produtos
ADD categoria VARCHAR(50);

-- B) Criar tabela endereços (um cliente pode ter vários endereços)
CREATE TABLE enderecos (
    id INT PRIMARY KEY AUTO_INCREMENT,   -- Identificador do endereço
    cliente_id INT NOT NULL,             -- Cliente dono do endereço
    rua VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    cep VARCHAR(15) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- ===============================
-- PARTE 9 – CONSULTA AVANÇADA
-- ===============================

-- Clientes que compraram e avaliaram o mesmo produto
SELECT 
    clientes.nome AS cliente_nome,
    produtos.nome AS produto_nome,
    avaliacoes.nota,
    pedidos.data_pedido
FROM avaliacoes
JOIN produtos ON avaliacoes.produto_id = produtos.id
JOIN clientes ON avaliacoes.cliente_id = clientes.id
JOIN pedidos ON pedidos.cliente_id = clientes.id
JOIN itens_pedido ON itens_pedido.pedido_id = pedidos.id
    AND itens_pedido.produto_id = produtos.id;

-- ===============================
-- PARTE 10 – RELATÓRIO GERENCIAL
-- ===============================

-- Nome do cliente, quantidade total de pedidos, valor total gasto,
-- quantidade total de produtos comprados e avaliação média
SELECT 
    clientes.nome AS cliente_nome,
    COUNT(DISTINCT pedidos.id) AS total_pedidos, -- Quantidade de pedidos únicos
    SUM(itens_pedido.quantidade * itens_pedido.preco_unitario) AS valor_total_gasto,
    SUM(itens_pedido.quantidade) AS total_produtos_comprados,
    AVG(avaliacoes.nota) AS avaliacao_media
FROM clientes
LEFT JOIN pedidos ON clientes.id = pedidos.cliente_id
LEFT JOIN itens_pedido ON pedidos.id = itens_pedido.pedido_id
LEFT JOIN avaliacoes ON clientes.id = avaliacoes.cliente_id
GROUP BY clientes.nome;
