#!/bin/bash

# Definir variáveis do admin PostgreSQL
ADMIN_PG_HOST="postgresql.c8966ow2w0q1.us-east-1.rds.amazonaws.com"
ADMIN_PG_PORT=5432
ADMIN_PG_USER="postgres"
ADMIN_PG_PASSWORD="postgres"

# Definir variáveis dos usuários específicos
KONG_USER="kong"
KONG_PASSWORD="kong"
KONG_DATABASE="kong"
KONGA_USER="konga"
KONGA_PASSWORD="konga"
KONGA_DATABASE="konga"

echo "Para criar os bancos de dados e usuários, execute o comando a seguir:"
echo ""
echo "kubectl run postgres-client --rm -i --tty --image=postgres -- bash"
echo ""
echo "Depois, dentro do pod, execute os seguintes comandos:"
echo ""
echo "psql -h $ADMIN_PG_HOST -U $ADMIN_PG_USER -p $ADMIN_PG_PORT"
echo ""
echo "Quando solicitada a senha, digite: $ADMIN_PG_PASSWORD"
echo ""
echo "No console do PostgreSQL, execute os seguintes comandos:"
echo ""
cat << EOF
-- Criar banco de dados para Kong
CREATE DATABASE $KONG_DATABASE;

-- Criar banco de dados para Konga
CREATE DATABASE $KONGA_DATABASE;

-- Criar usuário específico para Kong
CREATE USER $KONG_USER WITH PASSWORD '$KONG_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE $KONG_DATABASE TO $KONG_USER;

-- Criar usuário específico para Konga
CREATE USER $KONGA_USER WITH PASSWORD '$KONGA_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE $KONGA_DATABASE TO $KONGA_USER;

-- Conceder permissões adicionais em cada schema
\c $KONG_DATABASE
GRANT ALL ON SCHEMA public TO $KONG_USER;

\c $KONGA_DATABASE
GRANT ALL ON SCHEMA public TO $KONGA_USER;
EOF
echo ""
echo "Após executar os comandos acima, digite '\q' para sair do PostgreSQL e 'exit' para sair do pod."
echo ""
echo "URLs de conexão:"
echo "Kong: postgresql://$KONG_USER:$KONG_PASSWORD@$ADMIN_PG_HOST:$ADMIN_PG_PORT/$KONG_DATABASE"
echo "Konga: postgresql://$KONGA_USER:$KONGA_PASSWORD@$ADMIN_PG_HOST:$ADMIN_PG_PORT/$KONGA_DATABASE" 