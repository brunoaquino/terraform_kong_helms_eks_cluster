
-- Criar banco de dados para Kong
CREATE DATABASE kong;

-- Criar banco de dados para Konga
CREATE DATABASE konga;

-- Criar usuário específico para Kong
CREATE USER kong WITH PASSWORD 'kong';
GRANT ALL PRIVILEGES ON DATABASE kong TO kong;

-- Criar usuário específico para Konga
CREATE USER konga WITH PASSWORD 'konga';
GRANT ALL PRIVILEGES ON DATABASE konga TO konga;

-- Conceder permissões adicionais necessárias
\c kong
GRANT ALL ON SCHEMA public TO kong;

\c konga
GRANT ALL ON SCHEMA public TO konga; 

-- Conectar ao banco kong
\c kong

-- Conceder permissões ao usuário kong
GRANT ALL ON SCHEMA public TO kong;
GRANT USAGE ON SCHEMA public TO kong;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO kong;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO kong;

-- Conectar ao banco konga
\c konga

-- Conceder permissões ao usuário konga
GRANT ALL ON SCHEMA public TO konga;
GRANT USAGE ON SCHEMA public TO konga;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO konga;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO konga;