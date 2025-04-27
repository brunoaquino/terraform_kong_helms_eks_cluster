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

variable "namespace" {
  description = "Namespace do Kubernetes onde o Konga será instalado"
  type        = string
  default     = "konga"
}

variable "create_namespace" {
  description = "Indica se deve criar o namespace"
  type        = bool
  default     = true
}

variable "image_repository" {
  description = "Repositório da imagem do Konga"
  type        = string
  default     = "pantsel/konga"
}

variable "image_tag" {
  description = "Tag da imagem do Konga"
  type        = string
  default     = "latest"
}

variable "replicas" {
  description = "Número de réplicas do Konga"
  type        = number
  default     = 1
}

variable "node_env" {
  description = "Ambiente do Node.js (production, development)"
  type        = string
  default     = "production"
}

variable "service_type" {
  description = "Tipo de serviço para o Konga (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "ClusterIP"
}

variable "create_ingress" {
  description = "Indica se deve criar um Ingress para o Konga"
  type        = bool
  default     = true
}

variable "base_domain" {
  description = "Domínio base para o qual o External-DNS terá permissões"
  type        = string
}

variable "cert_manager_environment" {
  description = "Ambiente do Cert-Manager (staging ou prod)"
  type        = string
  default     = "prod"
}

variable "postgres_host" {
  description = "Host do PostgreSQL"
  type        = string
  default     = ""
}

variable "postgres_port" {
  description = "Porta do PostgreSQL"
  type        = number
  default     = 5432
}

variable "postgres_user" {
  description = "Usuário do PostgreSQL"
  type        = string
  default     = "konga"
}

variable "postgres_password" {
  description = "Senha do PostgreSQL"
  type        = string
  default     = ""
  sensitive   = true
}

variable "postgres_database" {
  description = "Nome do banco de dados PostgreSQL"
  type        = string
  default     = "konga"
}

variable "db_ssl" {
  description = "Habilitar/desabilitar SSL para PostgreSQL no Konga (true/false)"
  type        = bool
  default     = false
}

variable "konga_hook_timeout" {
  description = "Timeout para hooks do Konga (em milissegundos)"
  type        = number
  default     = 60000
}

variable "token_secret" {
  description = "Segredo para geração de tokens JWT"
  type        = string
  default     = "some-secret-token"
  sensitive   = true
}
