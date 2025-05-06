variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
}

variable "eks_cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "eks_cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  type        = string
}

variable "eks_cluster_ca_cert" {
  description = "Certificado CA do cluster EKS"
  type        = string
}

variable "base_domain" {
  description = "Nome de domínio base para o qual o External-DNS terá permissões"
  type        = string
}

# Referência ao Cert-Manager já instalado no cluster
variable "cert_manager_letsencrypt_server" {
  description = "Servidor do Let's Encrypt (staging ou prod)"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["staging", "prod"], var.cert_manager_letsencrypt_server)
    error_message = "O valor de cert_manager_letsencrypt_server deve ser 'staging' ou 'prod'."
  }
}

# Variáveis para o módulo Kong
variable "kong_namespace" {
  description = "Namespace do Kubernetes onde o Kong será instalado"
  type        = string
  default     = "kong"
}

variable "kong_create_namespace" {
  description = "Indica se deve criar o namespace para o Kong"
  type        = bool
  default     = true
}

variable "kong_chart_version" {
  description = "Versão do Helm chart do Kong"
  type        = string
  default     = "2.38.0"
}

variable "kong_proxy_service_type" {
  description = "Tipo de serviço para o proxy do Kong (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "LoadBalancer"
}

variable "kong_admin_service_type" {
  description = "Tipo de serviço para o admin do Kong (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "ClusterIP"
}

variable "kong_database_type" {
  description = "Tipo de banco de dados para o Kong (off, postgres)"
  type        = string
  default     = "postgres"
}

variable "kong_enable_proxy_https" {
  description = "Habilita HTTPS para o proxy do Kong"
  type        = bool
  default     = true
}

variable "kong_enable_admin_https" {
  description = "Habilita HTTPS para o admin do Kong"
  type        = bool
  default     = true
}

variable "kong_create_admin_ingress" {
  description = "Indica se deve criar um Ingress para o admin do Kong"
  type        = bool
  default     = false
}

variable "kong_create_proxy_ingress" {
  description = "Indica se deve criar um Ingress para o proxy do Kong"
  type        = bool
  default     = true
}

variable "kong_ingress_controller_enabled" {
  description = "Indica se o Ingress Controller do Kong deve ser habilitado"
  type        = bool
  default     = true
}

variable "kong_cpu_request" {
  description = "Requisição de CPU para o Kong"
  type        = string
  default     = "200m"
}

variable "kong_memory_request" {
  description = "Requisição de memória para o Kong"
  type        = string
  default     = "256Mi"
}

variable "kong_cpu_limit" {
  description = "Limite de CPU para o Kong"
  type        = string
  default     = "500m"
}

variable "kong_memory_limit" {
  description = "Limite de memória para o Kong"
  type        = string
  default     = "512Mi"
}

# Variáveis para banco de dados Kong
variable "kong_postgres_host" {
  description = "Host do PostgreSQL para Kong"
  type        = string
  default     = ""
}

variable "kong_postgres_port" {
  description = "Porta do PostgreSQL para Kong"
  type        = number
  default     = 5432
}

variable "kong_postgres_user" {
  description = "Usuário específico do PostgreSQL para o Kong"
  type        = string
  default     = "kong"
}

variable "kong_postgres_password" {
  description = "Senha específica do PostgreSQL para o Kong"
  type        = string
  default     = ""
  sensitive   = true
}

variable "kong_postgres_database" {
  description = "Nome do banco de dados PostgreSQL para o Kong"
  type        = string
  default     = "kong"
}

variable "kong_pg_ssl" {
  description = "Habilitar/desabilitar SSL para PostgreSQL no Kong (on/off)"
  type        = string
  default     = "off"
}

variable "kong_pg_ssl_verify" {
  description = "Habilitar/desabilitar verificação de SSL para PostgreSQL no Kong (on/off)"
  type        = string
  default     = "off"
}

variable "kong_pg_timeout" {
  description = "Tempo limite de conexão para o PostgreSQL no Kong (em segundos)"
  type        = number
  default     = 5
}

# Variáveis para o módulo Konga
variable "konga_namespace" {
  description = "Namespace do Kubernetes onde o Konga será instalado"
  type        = string
  default     = "konga"
}

variable "konga_create_namespace" {
  description = "Indica se deve criar o namespace para o Konga"
  type        = bool
  default     = true
}

variable "konga_image_repository" {
  description = "Repositório da imagem do Konga"
  type        = string
  default     = "pantsel/konga"
}

variable "konga_image_tag" {
  description = "Tag da imagem do Konga"
  type        = string
  default     = "latest"
}

variable "konga_replicas" {
  description = "Número de réplicas do Konga"
  type        = number
  default     = 1
}

variable "konga_node_env" {
  description = "Ambiente do Node.js para o Konga (production, development)"
  type        = string
  default     = "production"
}

variable "konga_service_type" {
  description = "Tipo de serviço para o Konga (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "ClusterIP"
}

variable "konga_create_ingress" {
  description = "Indica se deve criar um Ingress para o Konga"
  type        = bool
  default     = true
}

variable "konga_cpu_request" {
  description = "Requisição de CPU para o Konga"
  type        = string
  default     = "100m"
}

variable "konga_memory_request" {
  description = "Requisição de memória para o Konga"
  type        = string
  default     = "128Mi"
}

variable "konga_cpu_limit" {
  description = "Limite de CPU para o Konga"
  type        = string
  default     = "200m"
}

variable "konga_memory_limit" {
  description = "Limite de memória para o Konga"
  type        = string
  default     = "256Mi"
}

# Variáveis para banco de dados Konga
variable "konga_postgres_host" {
  description = "Host do PostgreSQL para Konga"
  type        = string
  default     = ""
}

variable "konga_postgres_port" {
  description = "Porta do PostgreSQL para Konga"
  type        = number
  default     = 5432
}

variable "konga_postgres_user" {
  description = "Usuário específico do PostgreSQL para o Konga"
  type        = string
  default     = "konga"
}

variable "konga_postgres_password" {
  description = "Senha específica do PostgreSQL para o Konga"
  type        = string
  default     = ""
  sensitive   = true
}

variable "konga_postgres_database" {
  description = "Nome do banco de dados PostgreSQL para o Konga"
  type        = string
  default     = "konga"
}

variable "konga_db_ssl" {
  description = "Habilitar/desabilitar SSL para PostgreSQL no Konga (true/false)"
  type        = bool
  default     = false
}

variable "konga_token_secret" {
  description = "Segredo para geração de tokens JWT no Konga"
  type        = string
  default     = "some-secret-token"
  sensitive   = true
}

variable "konga_hook_timeout" {
  description = "Timeout para hooks do Konga (em milissegundos)"
  type        = number
  default     = 60000
}
