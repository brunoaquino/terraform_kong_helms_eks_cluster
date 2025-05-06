resource "kubernetes_namespace" "kong" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

resource "helm_release" "kong" {
  name       = "kong"
  repository = "https://charts.konghq.com"
  chart      = "kong"
  version    = var.chart_version
  namespace  = var.create_namespace ? kubernetes_namespace.kong[0].metadata[0].name : var.namespace

  # Valores básicos
  set {
    name  = "image.repository"
    value = "kong"
  }

  set {
    name  = "image.tag"
    value = "3.5"
  }

  set {
    name  = "replicaCount"
    value = var.replicas
  }

  # Configuração do banco de dados
  set {
    name  = "env.database"
    value = var.database_type
  }

  # Configurações do PostgreSQL (condicionais)
  dynamic "set" {
    for_each = var.database_type == "postgres" && var.postgres_host != "" ? [1] : []
    content {
      name  = "env.pg_host"
      value = var.postgres_host
    }
  }

  dynamic "set" {
    for_each = var.database_type == "postgres" && var.postgres_host != "" ? [1] : []
    content {
      name  = "env.pg_port"
      value = var.postgres_port
    }
  }

  dynamic "set" {
    for_each = var.database_type == "postgres" && var.postgres_host != "" ? [1] : []
    content {
      name  = "env.pg_user"
      value = var.postgres_user
    }
  }

  dynamic "set" {
    for_each = var.database_type == "postgres" && var.postgres_host != "" ? [1] : []
    content {
      name  = "env.pg_password"
      value = var.postgres_password
    }
  }

  dynamic "set" {
    for_each = var.database_type == "postgres" && var.postgres_host != "" ? [1] : []
    content {
      name  = "env.pg_database"
      value = var.postgres_database
    }
  }

  # Configuração SSL para PostgreSQL
  set {
    name  = "env.pg_ssl"
    value = var.pg_ssl
  }

  set {
    name  = "env.pg_ssl_verify"
    value = var.pg_ssl_verify
  }

  # Tempo limite de conexão do Postgres
  set {
    name  = "env.pg_timeout"
    value = var.pg_timeout
  }

  # Configuração Kong License (condicional)
  dynamic "set" {
    for_each = var.enterprise_license != "" ? [1] : []
    content {
      name  = "env.kong_license_data"
      value = var.enterprise_license
    }
  }

  # Admin API
  set {
    name  = "admin.enabled"
    value = "true"
  }

  set {
    name  = "admin.http.enabled"
    value = "true"
  }

  set {
    name  = "admin.http.servicePort"
    value = "8001"
  }

  set {
    name  = "admin.tls.enabled"
    value = var.enable_admin_https
  }

  set {
    name  = "admin.type"
    value = var.admin_service_type
  }

  # Proxy
  set {
    name  = "proxy.enabled"
    value = "true"
  }

  set {
    name  = "proxy.type"
    value = var.proxy_service_type
  }

  set {
    name  = "proxy.http.enabled"
    value = "true"
  }

  set {
    name  = "proxy.tls.enabled"
    value = var.enable_proxy_https
  }

  # Ingress Controller
  set {
    name  = "ingressController.enabled"
    value = var.ingress_controller_enabled
  }

  set {
    name  = "ingressController.installCRDs"
    value = "false"
  }

  # Recursos
  set {
    name  = "resources.requests.cpu"
    value = var.resources.requests.cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.resources.requests.memory
  }

  set {
    name  = "resources.limits.cpu"
    value = var.resources.limits.cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.resources.limits.memory
  }

  depends_on = [
    kubernetes_namespace.kong
  ]
}

resource "kubernetes_ingress_v1" "kong_admin" {
  count = var.create_admin_ingress ? 1 : 0

  metadata {
    name      = "kong-admin-ingress"
    namespace = var.create_namespace ? kubernetes_namespace.kong[0].metadata[0].name : var.namespace

    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-${var.cert_manager_environment}"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "external-dns.alpha.kubernetes.io/hostname"      = "kong-admin.${var.base_domain}"
    }
  }

  spec {
    tls {
      hosts       = ["kong-admin.${var.base_domain}"]
      secret_name = "kong-admin-tls"
    }

    rule {
      host = "kong-admin.${var.base_domain}"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "kong-kong-admin"
              port {
                number = 8001
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.kong
  ]
}

resource "kubernetes_ingress_v1" "kong_proxy" {
  count = var.create_proxy_ingress ? 1 : 0

  metadata {
    name      = "kong-proxy-ingress"
    namespace = var.create_namespace ? kubernetes_namespace.kong[0].metadata[0].name : var.namespace

    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-${var.cert_manager_environment}"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "external-dns.alpha.kubernetes.io/hostname"      = "api.${var.base_domain}"
    }
  }

  spec {
    tls {
      hosts       = ["api.${var.base_domain}"]
      secret_name = "kong-proxy-tls"
    }

    rule {
      host = "api.${var.base_domain}"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "kong-kong-proxy"
              port {
                number = 8000
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.kong
  ]
}
