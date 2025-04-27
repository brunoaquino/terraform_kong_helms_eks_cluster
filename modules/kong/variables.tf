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
  description = "Namespace do Kubernetes onde o Kong será instalado"
  type        = string
  default     = "kong"
}

variable "create_namespace" {
  description = "Indica se deve criar o namespace"
  type        = bool
  default     = true
}

variable "chart_version" {
  description = "Versão do Helm chart do Kong"
  type        = string
  default     = "2.38.0"
}

variable "proxy_service_type" {
  description = "Tipo de serviço para o proxy do Kong (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "LoadBalancer"
}

variable "admin_service_type" {
  description = "Tipo de serviço para o admin do Kong (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "ClusterIP"
}

variable "database_type" {
  description = "Tipo de banco de dados para o Kong (off, postgres)"
  type        = string
  default     = "postgres"
}

variable "enterprise_license" {
  description = "Licença para Kong Enterprise (deixar vazio para versão gratuita)"
  type        = string
  default     = ""
}

variable "replicas" {
  description = "Número de réplicas do Kong"
  type        = number
  default     = 1
}

variable "ingress_controller_enabled" {
  description = "Indica se o Ingress Controller do Kong deve ser habilitado"
  type        = bool
  default     = true
}

variable "resources" {
  description = "Recursos para o Kong"
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "200m"
      memory = "256Mi"
    }
    limits = {
      cpu    = "500m"
      memory = "512Mi"
    }
  }
}

variable "enable_proxy_https" {
  description = "Habilita HTTPS para o proxy do Kong"
  type        = bool
  default     = true
}

variable "enable_admin_https" {
  description = "Habilita HTTPS para o admin do Kong"
  type        = bool
  default     = true
}

variable "create_admin_ingress" {
  description = "Indica se deve criar um Ingress para o admin do Kong"
  type        = bool
  default     = false
}

variable "create_proxy_ingress" {
  description = "Indica se deve criar um Ingress para o proxy do Kong"
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
  default     = "kong"
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
  default     = "kong"
}

variable "pg_ssl" {
  description = "Habilitar/desabilitar SSL para PostgreSQL no Kong (on/off)"
  type        = string
  default     = "off"
}

variable "pg_ssl_verify" {
  description = "Habilitar/desabilitar verificação de SSL para PostgreSQL no Kong (on/off)"
  type        = string
  default     = "off"
}

variable "pg_timeout" {
  description = "Tempo limite de conexão para o PostgreSQL no Kong (em segundos)"
  type        = number
  default     = 5
}
