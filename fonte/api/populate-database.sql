-- Script para popular o banco de dados com dados iniciais
-- Inclui todos os campi do IFPR no Paraná

-- 1. Inserir tipos de role
INSERT INTO ap.aux_tipo_role (nome_tipo_role) VALUES
('Admin'),
('Professor'),
('Aluno'),
('Instituicao Publica'),
('Instituicao Privada')
ON CONFLICT DO NOTHING;

-- 2. Inserir status de itens
INSERT INTO ap.aux_status_item (descricao_status_item) VALUES
('Ativo'),
('Reivindicado'),
('Doado')
ON CONFLICT DO NOTHING;

-- 3. Inserir locais de itens
INSERT INTO ap.aux_local_item (nome_local_item, descricao_local_item) VALUES
('Biblioteca', 'Biblioteca central do campus'),
('Laboratório de Informática', 'Laboratório de computação'),
('Auditório', 'Auditório principal'),
('Cantina', 'Refeitório e lanchonete'),
('Quadra de Esportes', 'Quadra poliesportiva'),
('Estacionamento', 'Área de estacionamento'),
('Corredor', 'Corredores e passagens'),
('Sala de Aula', 'Salas de aula'),
('Banheiro', 'Sanitários'),
('Secretaria', 'Secretaria acadêmica'),
('Coordenação', 'Coordenação de cursos'),
('Direção', 'Direção do campus'),
('Pátio', 'Pátio central'),
('Entrada Principal', 'Portão de entrada'),
('Outros', 'Outros locais do campus')
ON CONFLICT DO NOTHING;

-- 4. Inserir Instituição (IFPR)
INSERT INTO ap.instituicao (tipo_instituicao, nome_instituicao, cnpj_filial) VALUES
('PUBLICA', 'Instituto Federal do Paraná', '12345678000195')
ON CONFLICT DO NOTHING;

-- 5. Inserir todos os campi do IFPR no Paraná
INSERT INTO ap.campus (id_instituicao, nome_campus, cidade, estado, endereco, cep, flg_ativo) VALUES
(1, 'IFPR - Sede Curitiba', 'Curitiba', 'Paraná', 'Rua João Negrão, 1285 - Rebouças', '80230-150', true),
(1, 'IFPR - Assis Chateaubriand', 'Assis Chateaubriand', 'Paraná', 'Rua das Flores, 123', '85935-000', true),
(1, 'IFPR - Astorga', 'Astorga', 'Paraná', 'Av. Principal, 456', '86730-000', true),
(1, 'IFPR - Barracão', 'Barracão', 'Paraná', 'Rua Central, 789', '85700-000', true),
(1, 'IFPR - Campo Largo', 'Campo Largo', 'Paraná', 'BR 277, Km 20', '83601-000', true),
(1, 'IFPR - Capanema', 'Capanema', 'Paraná', 'Rua da Educação, 321', '85760-000', true),
(1, 'IFPR - Cascavel', 'Cascavel', 'Paraná', 'Av. Brasil, 1000', '85801-000', true),
(1, 'IFPR - Colombo', 'Colombo', 'Paraná', 'Rua da Paz, 555', '83401-000', true),
(1, 'IFPR - Coronel Vivida', 'Coronel Vivida', 'Paraná', 'Rua das Palmeiras, 200', '85550-000', true),
(1, 'IFPR - Foz do Iguaçu', 'Foz do Iguaçu', 'Paraná', 'Av. Tancredo Neves, 3000', '85856-000', true),
(1, 'IFPR - Goioerê', 'Goioerê', 'Paraná', 'Rua da Liberdade, 150', '87360-000', true),
(1, 'IFPR - Irati', 'Irati', 'Paraná', 'Rua Coronel Emilio Gomes, 100', '84500-000', true),
(1, 'IFPR - Ivaiporã', 'Ivaiporã', 'Paraná', 'Av. Getúlio Vargas, 500', '86870-000', true),
(1, 'IFPR - Jacarezinho', 'Jacarezinho', 'Paraná', 'Rua São Paulo, 300', '86400-000', true),
(1, 'IFPR - Jaguariaíva', 'Jaguariaíva', 'Paraná', 'Rua da República, 400', '84200-000', true),
(1, 'IFPR - Londrina', 'Londrina', 'Paraná', 'Av. Juscelino Kubitschek, 2000', '86020-000', true),
(1, 'IFPR - Palmas', 'Palmas', 'Paraná', 'Rua das Acácias, 250', '85555-000', true),
(1, 'IFPR - Paranaguá', 'Paranaguá', 'Paraná', 'Rua XV de Novembro, 600', '83203-000', true),
(1, 'IFPR - Paranavaí', 'Paranavaí', 'Paraná', 'Av. Dr. João Cândido, 800', '87701-000', true),
(1, 'IFPR - Pinhais', 'Pinhais', 'Paraná', 'Rua da Esperança, 350', '83320-000', true),
(1, 'IFPR - Pitanga', 'Pitanga', 'Paraná', 'Rua das Rosas, 180', '85200-000', true),
(1, 'IFPR - Quedas do Iguaçu', 'Quedas do Iguaçu', 'Paraná', 'Rua da Vitória, 120', '85460-000', true),
(1, 'IFPR - Telêmaco Borba', 'Telêmaco Borba', 'Paraná', 'Av. Industrial, 700', '84270-000', true),
(1, 'IFPR - Umuarama', 'Umuarama', 'Paraná', 'Rua Rio Branco, 900', '87501-000', true),
(1, 'IFPR - União da Vitória', 'União da Vitória', 'Paraná', 'Rua Coronel Amazonas, 450', '84600-000', true)
ON CONFLICT DO NOTHING;

-- 6. Inserir um usuário de exemplo (Admin)
INSERT INTO ap.usuarios (
    nome_usuario, 
    cpf_usuario, 
    email_usuario, 
    senha_usuario, 
    matricula_usuario, 
    telefone_usuario, 
    data_cadastro, 
    tipo_role_id, 
    flg_inativo, 
    id_instituicao, 
    id_campus
) VALUES (
    'Administrador Sistema',
    '12345678901',
    'admin@ifpr.edu.br',
    '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', -- senha: admin123
    'ADMIN001',
    '(41) 99999-9999',
    CURRENT_TIMESTAMP,
    1, -- Admin
    false,
    1, -- IFPR
    1  -- Curitiba
);

-- 7. Inserir alguns itens de exemplo
INSERT INTO ap.itens (
    nome_item,
    descricao_item,
    data_hora_item,
    data_cadastro,
    flg_inativo,
    status_item_id,
    usuario_id,
    local_id,
    campus_id
) VALUES (
    'Chave do Laboratório',
    'Chave do laboratório de informática, cor prata',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    false,
    1, -- Ativo
    1, -- Admin
    2, -- Laboratório de Informática
    1  -- Curitiba
),
(
    'Óculos de Grau',
    'Óculos de grau com armação preta, encontrado na biblioteca',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    false,
    1, -- Ativo
    1, -- Admin
    1, -- Biblioteca
    1  -- Curitiba
),
(
    'Celular Samsung',
    'Celular Samsung Galaxy, cor preta, com capinha azul',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    false,
    1, -- Ativo
    1, -- Admin
    7, -- Corredor
    1  -- Curitiba
);

-- 8. Verificar os dados inseridos
SELECT 'Dados inseridos com sucesso!' as status;

-- Consultas para verificar os dados
SELECT 'Tipos de Role:' as info;
SELECT * FROM ap.aux_tipo_role;

SELECT 'Status de Itens:' as info;
SELECT * FROM ap.aux_status_item;

SELECT 'Locais de Itens:' as info;
SELECT * FROM ap.aux_local_item;

SELECT 'Instituições:' as info;
SELECT * FROM ap.instituicao;

SELECT 'Campi IFPR:' as info;
SELECT c.nome_campus, c.cidade, c.estado, c.endereco 
FROM ap.campus c 
WHERE c.id_instituicao = 1 
ORDER BY c.nome_campus;

SELECT 'Usuários:' as info;
SELECT u.nome_usuario, u.email_usuario, u.matricula_usuario, tr.nome_tipo_role, c.nome_campus
FROM ap.usuarios u
JOIN ap.aux_tipo_role tr ON u.tipo_role_id = tr.id_tipo_role
JOIN ap.campus c ON u.id_campus = c.id_campus;

SELECT 'Itens:' as info;
SELECT i.nome_item, i.descricao_item, si.descricao_status_item, li.nome_local_item, c.nome_campus
FROM ap.itens i
JOIN ap.aux_status_item si ON i.status_item_id = si.id_status_item
JOIN ap.aux_local_item li ON i.local_id = li.id_aux_local_item
JOIN ap.campus c ON i.campus_id = c.id_campus;
