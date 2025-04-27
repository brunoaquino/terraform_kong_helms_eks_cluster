# Kong e Konga no EKS com PostgreSQL

Este projeto Terraform configura o Kong (API Gateway) e Konga (Interface de gerenciamento do Kong) em um cluster Amazon EKS com banco de dados PostgreSQL.

## Pré-requisitos

- AWS CLI configurado com acesso adequado
- Terraform >= 1.0.0
- kubectl >= 1.20
- Cluster EKS existente
- Banco de dados PostgreSQL (RDS ou outra instância)
- Helm >= 3.0.0
- Domínio configurado com Route53 ou outro provedor DNS
- NGINX Ingress Controller já instalado no cluster
- cert-manager com ClusterIssuer letsencrypt-prod já configurado
- External-DNS já configurado

## Dependências de Versões

- Kong Chart: 2.38.0 (Kong 3.5.x)
- Konga: 0.14.9
- PostgreSQL: 11.x ou superior (PostgreSQL 15 requer ajustes adicionais)
- cert-manager: v1.10.0 ou superior (já instalado)
- NGINX Ingress Controller: v1.5.0 ou superior (já instalado)

## Configuração do Ambiente

### 1. Configurar acesso ao cluster EKS

```bash
# Obter credenciais para o cluster EKS
aws eks update-kubeconfig --region us-east-1 --name seu-cluster-eks

# Verificar conexão com o cluster
kubectl cluster-info

# Verificar os componentes já instalados
kubectl get pods -n ingress-nginx
kubectl get pods -n cert-manager
kubectl get clusterissuer letsencrypt-prod
kubectl get pods -n kube-system -l app.kubernetes.io/name=external-dns
```

### 2. Preparar o Banco de Dados PostgreSQL

Crie os bancos de dados e usuários necessários para o Kong e Konga:

```bash
# Conectar ao PostgreSQL (exemplo com pod temporário)
kubectl run postgres-client --rm -i --tty --image=postgres -- bash

# Dentro do pod, conecte-se ao PostgreSQL
psql -h seu-host-postgresql.region.rds.amazonaws.com -U postgres -p 5432

# No console do PostgreSQL, execute:
CREATE DATABASE kong;
CREATE DATABASE konga;

CREATE USER kong WITH PASSWORD 'senha-segura';
GRANT ALL PRIVILEGES ON DATABASE kong TO kong;

CREATE USER konga WITH PASSWORD 'senha-segura';
GRANT ALL PRIVILEGES ON DATABASE konga TO konga;

# Conceder permissões adicionais (importante para PostgreSQL 11+)
\c kong
GRANT ALL ON SCHEMA public TO kong;

\c konga
GRANT ALL ON SCHEMA public TO konga;

# Se estiver usando PostgreSQL 15+, execute também:
ALTER SCHEMA public OWNER TO postgres;
REVOKE ALL ON SCHEMA public FROM public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO public;
GRANT ALL ON SCHEMA public TO kong;
GRANT ALL ON SCHEMA public TO konga;
```

## Configuração do Terraform

### 1. Configurar Variáveis

Edite o arquivo `terraform.tfvars` com suas informações:

```hcl
aws_region           = "us-east-1"
eks_cluster_name     = "seu-cluster-eks"
eks_cluster_endpoint = "https://seu-endpoint-eks.region.eks.amazonaws.com"
eks_cluster_ca_cert  = "seu-certificado-ca-base64"

# Obtenha o endpoint e certificado CA com esses comandos:
# aws eks describe-cluster --name seu-cluster-eks --query "cluster.endpoint" --output text
# aws eks describe-cluster --name seu-cluster-eks --query "cluster.certificateAuthority.data" --output text

base_domain = "seu-dominio.com"
cert_manager_letsencrypt_server = "prod"

# Kong
kong_namespace                  = "kong"
kong_chart_version              = "2.38.0"
kong_database_type              = "postgres"
kong_proxy_service_type         = "ClusterIP"     # Serviço Kong Proxy interno
kong_admin_service_type         = "ClusterIP"     # Admin API apenas dentro do cluster
kong_create_admin_ingress       = false           # Não criar ingress para Admin API
kong_create_proxy_ingress       = true            # Criar ingress para o Proxy (API)
kong_postgres_host              = "seu-host-postgresql.region.rds.amazonaws.com"
kong_postgres_port              = 5432
kong_postgres_user              = "kong"
kong_postgres_password          = "senha-kong"
kong_postgres_database          = "kong"
kong_pg_ssl                     = "on"
kong_pg_ssl_verify              = "off"
kong_pg_timeout                 = 60

# Konga
konga_namespace                 = "konga"
konga_image_repository          = "pantsel/konga"
konga_image_tag                 = "0.14.9"
konga_service_type              = "ClusterIP"     # Serviço Konga interno
konga_create_ingress            = true            # Criar ingress para acesso externo
konga_postgres_host             = "seu-host-postgresql.region.rds.amazonaws.com"
konga_postgres_port             = 5432
konga_postgres_user             = "konga"
konga_postgres_password         = "senha-konga"
konga_postgres_database         = "konga"
konga_db_ssl                    = true
```

### 2. Inicializar e Aplicar o Terraform

```bash
terraform init
terraform apply
```

## Arquitetura de Exposição Segura

Esta configuração expõe apenas os componentes necessários:

1. **Exposto externamente via Ingress:**

   - Kong Proxy em `https://api.seu-dominio.com`: Ponto de entrada para todas as APIs
   - Konga UI em `https://konga.seu-dominio.com`: Interface de gerenciamento protegida por HTTPS

2. **Apenas interno (dentro do cluster):**
   - Kong Admin API: Acessível apenas via Konga ou de dentro do cluster

## Acesso às Interfaces

### Kong Proxy (Para Acesso às APIs)

Acesse suas APIs através da URL:

```
https://api.seu-dominio.com/<rota-da-api>
```

Por exemplo, se você configurou uma rota para "/users", a URL completa seria:

```
https://api.seu-dominio.com/users
```

### Konga (Interface de Gerenciamento)

Acesse o Konga através da URL:

```
https://konga.seu-dominio.com
```

Na primeira execução, será necessário criar um usuário admin. Em seguida, configure a conexão com o Kong:

- Nome: Kong
- URL do Kong Admin: http://kong-kong-admin.kong.svc.cluster.local:8001

### Acesso ao Kong Admin API (quando necessário)

Se precisar acessar o Kong Admin API de fora do cluster temporariamente:

```bash
kubectl port-forward -n kong svc/kong-kong-admin 8001:8001
```

Depois acesse em `http://localhost:8001` enquanto o port-forward estiver ativo.

## Solução de Problemas

### Problema com Certificados

Se os certificados não forem emitidos automaticamente:

```bash
# Verificar status dos certificados
kubectl get certificate -n kong
kubectl get certificate -n konga

# Verificar status dos CertificateRequests
kubectl get certificaterequest -n kong
kubectl get certificaterequest -n konga

# Verificar logs do cert-manager
kubectl logs -n cert-manager -l app=cert-manager
```

### Problemas com o Kong ou Konga

```bash
# Verificar logs do Kong
kubectl logs -n kong -l app.kubernetes.io/name=kong

# Verificar logs do Konga
kubectl logs -n konga -l app=konga

# Reiniciar o Konga
kubectl rollout restart deployment -n konga konga

# Reiniciar o Kong
kubectl rollout restart deployment -n kong kong-kong
```

### Problemas com o Banco de Dados do Konga

Se o Konga não inicializar o banco de dados corretamente, use o job de preparação:

```bash
kubectl apply -f - <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: konga-prepare
  namespace: konga
spec:
  template:
    spec:
      containers:
      - name: konga-prepare
        image: pantsel/konga:0.14.9
        command: ["/bin/sh", "-c"]
        args:
        - cd /app && node ./bin/konga.js prepare --adapter postgres --uri postgresql://konga:senha-konga@seu-host-postgresql:5432/konga
        env:
        - name: DB_ADAPTER
          value: "postgres"
        - name: DB_HOST
          value: "seu-host-postgresql.region.rds.amazonaws.com"
        - name: DB_PORT
          value: "5432"
        - name: DB_USER
          value: "konga"
        - name: DB_PASSWORD
          value: "senha-konga"
        - name: DB_DATABASE
          value: "konga"
        - name: DB_SSL
          value: "true"
      restartPolicy: Never
  backoffLimit: 1
EOF
```

### Resetar Senha do Konga

Para resetar a senha de um usuário do Konga:

```bash
# Usar o pod existente para executar o comando
kubectl exec -it -n konga $(kubectl get pods -n konga -l app=konga -o jsonpath="{.items[0].metadata.name}") -- node ./bin/konga.js reset-password-for-user --user admin@exemplo.com --password NovaSenha123
```

## Requisitos de Recursos

Recomendação mínima para ambiente de produção:

- Kong: CPU: 500m, Memória: 1Gi
- Konga: CPU: 200m, Memória: 512Mi

Para ambientes de desenvolvimento, reduza conforme necessário.

## Desinstalação

Para remover todos os recursos:

```bash
terraform destroy
```

Para limpar apenas os bancos de dados:

```bash
psql -h seu-host-postgresql.region.rds.amazonaws.com -U postgres -p 5432

DROP DATABASE kong;
DROP DATABASE konga;
DROP USER kong;
DROP USER konga;
```
