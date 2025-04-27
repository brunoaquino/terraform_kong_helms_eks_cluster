provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = var.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(var.eks_cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
      command     = "aws"
    }
  }
}

# Módulo Kong
module "kong" {
  source = "./modules/kong"

  aws_region           = var.aws_region
  eks_cluster_name     = var.eks_cluster_name
  eks_cluster_endpoint = var.eks_cluster_endpoint
  eks_cluster_ca_cert  = var.eks_cluster_ca_cert
  base_domain          = var.base_domain

  # Configurações específicas do Kong
  namespace                  = var.kong_namespace
  create_namespace           = var.kong_create_namespace
  chart_version              = var.kong_chart_version
  proxy_service_type         = var.kong_proxy_service_type
  admin_service_type         = var.kong_admin_service_type
  database_type              = var.kong_database_type
  enable_proxy_https         = var.kong_enable_proxy_https
  enable_admin_https         = var.kong_enable_admin_https
  create_admin_ingress       = var.kong_create_admin_ingress
  create_proxy_ingress       = var.kong_create_proxy_ingress
  ingress_controller_enabled = var.kong_ingress_controller_enabled
  cert_manager_environment   = var.cert_manager_letsencrypt_server

  # Configurações de banco de dados (se aplicável)
  postgres_host     = var.kong_postgres_host
  postgres_port     = var.kong_postgres_port
  postgres_user     = var.kong_postgres_user
  postgres_password = var.kong_postgres_password
  postgres_database = var.kong_postgres_database
  pg_ssl            = var.kong_pg_ssl
  pg_ssl_verify     = var.kong_pg_ssl_verify
  pg_timeout        = var.kong_pg_timeout
}

# Módulo Konga
module "konga" {
  source = "./modules/konga"

  aws_region           = var.aws_region
  eks_cluster_name     = var.eks_cluster_name
  eks_cluster_endpoint = var.eks_cluster_endpoint
  eks_cluster_ca_cert  = var.eks_cluster_ca_cert
  base_domain          = var.base_domain

  # Configurações específicas do Konga
  namespace                = var.konga_namespace
  create_namespace         = var.konga_create_namespace
  image_repository         = var.konga_image_repository
  image_tag                = var.konga_image_tag
  replicas                 = var.konga_replicas
  node_env                 = var.konga_node_env
  service_type             = var.konga_service_type
  create_ingress           = var.konga_create_ingress
  cert_manager_environment = var.cert_manager_letsencrypt_server

  # Configurações de banco de dados (se aplicável)
  postgres_host      = var.konga_postgres_host
  postgres_port      = var.konga_postgres_port
  postgres_user      = var.konga_postgres_user
  postgres_password  = var.konga_postgres_password
  postgres_database  = var.konga_postgres_database
  db_ssl             = var.konga_db_ssl
  token_secret       = var.konga_token_secret
  konga_hook_timeout = var.konga_hook_timeout

  depends_on = [module.kong]
}
