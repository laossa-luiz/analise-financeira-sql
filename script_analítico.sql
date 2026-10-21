-- ============================================================
-- PROJETO: Análise Financeira Relacional e Agregações de Negócio
-- AUTOR: Luiz
-- FERRAMENTA: MySQL
-- ============================================================

-- 1. Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS relatorios_financeiros;
USE relatorios_financeiros;

-- 2. Tabela de Categorias
CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    tipo ENUM('RECEITA', 'DESPESA') NOT NULL
);

-- 3. Tabela de Transações
CREATE TABLE IF NOT EXISTS transacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_nome VARCHAR(100) NOT NULL,
    categoria_id INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    data_transacao DATE NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- 4. Inserção de Dados
INSERT INTO categorias (nome, tipo) VALUES 
('Salário', 'RECEITA'),
('Freelance', 'RECEITA'),
('Alimentação', 'DESPESA'),
('Moradia', 'DESPESA'),
('Transporte', 'DESPESA');

INSERT INTO transacoes (usuario_nome, categoria_id, valor, data_transacao) VALUES 
('Mariana Silva', 1, 6200.00, '2026-10-01'),
('Carlos Eduardo', 1, 4800.00, '2026-10-01'),
('Fernanda Lima', 2, 1800.00, '2026-10-03'),
('Mariana Silva', 3, 520.40, '2026-10-05'),
('Lucas Mendes', 4, 1600.00, '2026-10-07'),
('Carlos Eduardo', 3, 340.00, '2026-10-08'),
('Fernanda Lima', 5, 210.50, '2026-10-10'),
('Lucas Mendes', 3, 410.00, '2026-10-12'),
('Mariana Silva', 4, 1900.00, '2026-10-15');

-- 5.Resumo Financeiro por Cliente e Categoria
SELECT 
    t.usuario_nome AS cliente,
    c.nome AS categoria,
    c.tipo AS tipo_movimentacao,
    COUNT(t.id) AS qtd_transacoes,
    SUM(t.valor) AS valor_total,
    ROUND(AVG(t.valor), 2) AS ticket_medio
FROM transacoes t
JOIN categorias c ON t.categoria_id = c.id
GROUP BY t.usuario_nome, c.nome, c.tipo
HAVING valor_total > 300.00
ORDER BY valor_total DESC;

-- 6. 3 Clientes com Maiores Gastos
SELECT 
    t.usuario_nome AS cliente,
    COUNT(t.id) AS qtd_despesas,
    SUM(t.valor) AS total_gasto,
    ROUND(AVG(t.valor), 2) AS ticket_medio_despesa
FROM transacoes t
JOIN categorias c ON t.categoria_id = c.id
WHERE c.tipo = 'DESPESA'
GROUP BY t.usuario_nome
ORDER BY total_gasto DESC
LIMIT 3;
