CREATE SCHEMA IF NOT EXISTS ap;
SET search_path TO ap, public;

-- 1) Tabelas auxiliares
CREATE TABLE IF NOT EXISTS aux_tipo_role (
    id_tipo_role SERIAL PRIMARY KEY,
    nome_tipo_role VARCHAR(50) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    flg_inativo BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS aux_status_item (
    id_status_item SERIAL PRIMARY KEY,
    descricao_status_item VARCHAR(50) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    flg_inativo BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS aux_local_item (
    id_aux_local_item SERIAL PRIMARY KEY,
    nome_local_item VARCHAR(150) NOT NULL,
    descricao_local_item VARCHAR(255),
    data_cadastro_local_item TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    flg_inativo_local_item BOOLEAN DEFAULT FALSE
);

-- 2) Instituicao
-- ENUM('PUBLICA','PRIVADA')
CREATE TABLE IF NOT EXISTS instituicao (
    id_instituicao SERIAL PRIMARY KEY,
    tipo_instituicao VARCHAR(20) NOT NULL,
    nome_instituicao VARCHAR(255) NOT NULL,
    cnpj_filial CHAR(14) UNIQUE,
    flg_inativo BOOLEAN DEFAULT FALSE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3) Empresa
CREATE TABLE IF NOT EXISTS empresa (
    id_empresa SERIAL PRIMARY KEY,
    nome_empresa VARCHAR(255) NOT NULL,
    cnpj_matriz CHAR(14) UNIQUE,
    pais_sede VARCHAR(100),
    website VARCHAR(255),
    contato_principal VARCHAR(255),
    flg_ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4) Campus
CREATE TABLE IF NOT EXISTS campus (
    id_campus SERIAL PRIMARY KEY,
    id_instituicao INT NULL,
    nome_campus VARCHAR(150) NOT NULL,
    cidade VARCHAR(100),
    estado VARCHAR(50),
    endereco VARCHAR(255),
    cep VARCHAR(20),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    flg_ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_campus_instituicao FOREIGN KEY (id_instituicao) REFERENCES instituicao(id_instituicao) ON DELETE SET NULL
);

-- 5) Usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nome_usuario VARCHAR(255) NOT NULL,
    cpf_usuario CHAR(11) UNIQUE,
    email_usuario VARCHAR(255) UNIQUE NOT NULL,
    senha_usuario VARCHAR(255) NOT NULL,
    matricula_usuario VARCHAR(50) UNIQUE,
    telefone_usuario VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_role_id INT NOT NULL,
    foto_item_id INT,
    foto_perfil_usuario INT,
    flg_inativo BOOLEAN DEFAULT FALSE,
    id_instituicao INT,
    id_empresa INT,
    id_campus INT,
    CONSTRAINT fk_usuarios_tipo_role FOREIGN KEY (tipo_role_id) REFERENCES aux_tipo_role(id_tipo_role),
    CONSTRAINT fk_usuarios_instituicao FOREIGN KEY (id_instituicao) REFERENCES instituicao(id_instituicao) ON DELETE SET NULL,
    CONSTRAINT fk_usuarios_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa) ON DELETE SET NULL,
    CONSTRAINT fk_usuarios_campus FOREIGN KEY (id_campus) REFERENCES campus(id_campus) ON DELETE SET NULL
);

-- 6) Itens
CREATE TABLE IF NOT EXISTS itens (
    id_item SERIAL PRIMARY KEY,
    nome_item VARCHAR(255) NOT NULL,
    descricao_item TEXT NOT NULL,
    data_hora_item TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    flg_inativo BOOLEAN DEFAULT FALSE,
    status_item_id INT,
    usuario_id INT,
    local_id INT,
    campus_id INT,
    id_empresa INT,
    CONSTRAINT fk_itens_status FOREIGN KEY (status_item_id) REFERENCES aux_status_item(id_status_item) ON DELETE SET NULL,
    CONSTRAINT fk_itens_local FOREIGN KEY (local_id) REFERENCES aux_local_item(id_aux_local_item) ON DELETE SET NULL,
    CONSTRAINT fk_itens_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    CONSTRAINT fk_itens_campus FOREIGN KEY (campus_id) REFERENCES campus(id_campus) ON DELETE SET NULL,
    CONSTRAINT fk_itens_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa) ON DELETE SET NULL
);

-- 7) Fotos
CREATE TABLE IF NOT EXISTS fotos (
    id_foto SERIAL PRIMARY KEY,
    usuario_id INT,
    item_id INT,
    provedor_armazenamento VARCHAR(100) NOT NULL DEFAULT 'local',
    nome_bucket VARCHAR(255),
    chave_objeto TEXT,
    url_arquivo TEXT NOT NULL,
    nome_original VARCHAR(255),
    largura INT,
    altura INT,
    perfil_usuario BOOLEAN DEFAULT FALSE,
    foto_item BOOLEAN DEFAULT FALSE,
    flg_inativo BOOLEAN DEFAULT FALSE,
    data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_exclusao TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fotos_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_fotos_item FOREIGN KEY (item_id) REFERENCES itens(id_item) ON DELETE CASCADE
);

-- 8) Reivindicacoes
CREATE TABLE IF NOT EXISTS reivindicacoes (
    id_reivindicacao SERIAL PRIMARY KEY,
    id_item INT NOT NULL,
    id_usuario_post INT,
    id_usuario_proprietario INT,
    data_reivindicacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observacao VARCHAR(512),
    CONSTRAINT fk_reivindicacoes_item FOREIGN KEY (id_item) REFERENCES itens(id_item) ON DELETE CASCADE,
    CONSTRAINT fk_reivindicacoes_post FOREIGN KEY (id_usuario_post) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    CONSTRAINT fk_reivindicacoes_prop FOREIGN KEY (id_usuario_proprietario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
);

INSERT INTO aux_tipo_role (nome_tipo_role) VALUES
('Admin'), ('Professor'), ('Aluno'), ('Instituicao Publica'), ('Instituicao Privada')
ON CONFLICT DO NOTHING;

INSERT INTO aux_status_item (descricao_status_item) VALUES
('Ativo'), ('Reivindicado'), ('Doado')
ON CONFLICT DO NOTHING;