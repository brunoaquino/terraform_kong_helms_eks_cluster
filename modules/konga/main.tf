resource "kubernetes_namespace" "konga" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

# Job para preparar o banco de dados do Konga
resource "kubernetes_job" "konga_prepare" {
  metadata {
    name      = "konga-prepare"
    namespace = var.create_namespace ? kubernetes_namespace.konga[0].metadata[0].name : var.namespace
  }

  spec {
    template {
      metadata {
        name = "konga-prepare"
      }
      spec {
        container {
          name  = "konga-prepare"
          image = "${var.image_repository}:${var.image_tag}"

          command = ["/bin/sh", "-c"]
          args    = ["cd /app && node ./bin/konga.js prepare --adapter postgres --uri postgresql://${var.postgres_user}:${var.postgres_password}@${var.postgres_host}:${var.postgres_port}/${var.postgres_database}"]

          env {
            name  = "DB_ADAPTER"
            value = "postgres"
          }

          env {
            name  = "DB_HOST"
            value = var.postgres_host
          }

          env {
            name  = "DB_PORT"
            value = tostring(var.postgres_port)
          }

          env {
            name  = "DB_USER"
            value = var.postgres_user
          }

          env {
            name  = "DB_PASSWORD"
            value = var.postgres_password
          }

          env {
            name  = "DB_DATABASE"
            value = var.postgres_database
          }

          env {
            name  = "DB_SSL"
            value = tostring(var.db_ssl)
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 4
  }

  depends_on = [
    kubernetes_namespace.konga
  ]
}

resource "kubernetes_deployment" "konga" {
  metadata {
    name      = "konga"
    namespace = var.create_namespace ? kubernetes_namespace.konga[0].metadata[0].name : var.namespace
    labels = {
      app = "konga"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "konga"
      }
    }

    template {
      metadata {
        labels = {
          app = "konga"
        }
      }

      spec {
        container {
          name  = "konga"
          image = "${var.image_repository}:${var.image_tag}"

          port {
            container_port = 1337
          }

          env {
            name  = "NODE_ENV"
            value = var.node_env
          }

          env {
            name  = "DB_ADAPTER"
            value = "postgres"
          }

          dynamic "env" {
            for_each = var.postgres_host != "" ? [1] : []
            content {
              name  = "DB_HOST"
              value = var.postgres_host
            }
          }

          dynamic "env" {
            for_each = var.postgres_port != 0 ? [1] : []
            content {
              name  = "DB_PORT"
              value = tostring(var.postgres_port)
            }
          }

          dynamic "env" {
            for_each = var.postgres_user != "" ? [1] : []
            content {
              name  = "DB_USER"
              value = var.postgres_user
            }
          }

          dynamic "env" {
            for_each = var.postgres_password != "" ? [1] : []
            content {
              name  = "DB_PASSWORD"
              value = var.postgres_password
            }
          }

          dynamic "env" {
            for_each = var.postgres_database != "" ? [1] : []
            content {
              name  = "DB_DATABASE"
              value = var.postgres_database
            }
          }

          env {
            name  = "DB_SSL"
            value = tostring(var.db_ssl)
          }

          env {
            name  = "KONGA_HOOK_TIMEOUT"
            value = tostring(var.konga_hook_timeout)
          }

          env {
            name  = "TOKEN_SECRET"
            value = var.token_secret
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.konga,
    kubernetes_job.konga_prepare
  ]
}

resource "kubernetes_service" "konga" {
  metadata {
    name      = "konga"
    namespace = var.create_namespace ? kubernetes_namespace.konga[0].metadata[0].name : var.namespace
  }

  spec {
    selector = {
      app = "konga"
    }

    port {
      port        = 80
      target_port = 1337
    }

    type = var.service_type
  }

  depends_on = [
    kubernetes_deployment.konga
  ]
}

resource "kubernetes_ingress_v1" "konga" {
  count = var.create_ingress ? 1 : 0

  metadata {
    name      = "konga-ingress"
    namespace = var.create_namespace ? kubernetes_namespace.konga[0].metadata[0].name : var.namespace

    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-${var.cert_manager_environment}"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "external-dns.alpha.kubernetes.io/hostname"      = "konga.${var.base_domain}"
    }
  }

  spec {
    tls {
      hosts       = ["konga.${var.base_domain}"]
      secret_name = "konga-tls"
    }

    rule {
      host = "konga.${var.base_domain}"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.konga.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
