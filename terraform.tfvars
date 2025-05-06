aws_region           = "us-east-1"
eks_cluster_name     = "app-cluster"
eks_cluster_endpoint = "https://4E2E57E93AF9A2622E28F5A6371664AC.gr7.us-east-1.eks.amazonaws.com"
eks_cluster_ca_cert  = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJUEtFTGNxQ1dBKzB3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRBMU1ETXhNakF5TWpaYUZ3MHpOVEExTURFeE1qQTNNalphTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURPTk1oNlJoTkl5ZlROaFMya3ZvblduNEMyNHRJbmlXS1l6dE5EKzI1SXZ6MWpqajZwODU5VmJ1YmcKY3oyZXFibGo5OGdablNXTWRBbGhEQmdBOTFtOHZYZWVNSVFrTWRjU3VSL3FTeXFzYXM0akRVcTY4aktuczViQwplQnNsRThOSFlacGcyaTRKdUdHQmtld1VxM3RyQjgwdzJMaGU4OHJHNXhDZVNLNWlCeUlLVDNHbDhXWG4zd1R5Cjg5TXRhblN6Vldhblc2eTNmZGN2VHU2WW9TSXR2UmREeVc4ejlRb3NGT3drdGNZc3pJSDk2WXA1UUFuMTB6VjUKM2tlVXk2b1lTcnpKbTVqTUZ2Y3RYUmRWQjVCY1dGOGtBRjVjazRORDF4c2RHaEtsYkVSdWxtS2FEM0E3SGlxdQpUWnF6S3l5N0NMMEpnZEVCei9mZ0xFbldTNW5sQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJTSXpXQm1vZzJrZlF2T2l2U2lEUWVnOWNnM1dEQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQzk5ZlZ3VlNjOAppMkM4ZXd5bUJBUVFDQWsyNTRKTkt4T2Y0ei9jV3NHWHRHWnlxK044eDNiYnRaUGd5NDB2bk5OUW85U0lCMGxBCjJORmJBOG83K3gwNGZpUXhEbVBCbGxaYk03VklPazhxTHFtT0ZrSWdnNkpVOTl4bG84WUdaRUpkYWRyTmgwaEYKRkJnVEExdllxRVh2VTkzMDlWUmNUYXYydGdsY1UxZG1UTmRtbGdDb2RseXR5V0V2V3pLcFkwejRuNTdPUUlWLwoxTUMwNUxpbFJ1QlZGMTBkcEJkeWZrdWdXYm5YdSt4WlRiWmpSYWtldVh0bkpmc1lvMFk2WXl0TFNCdDZXZkEwCkxFMmRkNDJoUEU3M2VWc3lOa2xJNEpGV1BHNjZ1dHJrOWVzUHY4aG1xaHFKRElQbzhMUVhieDVuWUR4M0Y3ZXoKVldTa1dJZnZHNkF4Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"

# Domínio Base
base_domain = "mixnarede.com.br"

# Referência ao Cert-Manager já instalado
cert_manager_letsencrypt_server = "prod"

# Kong
kong_namespace                  = "kong"
kong_create_namespace           = true
kong_chart_version              = "2.38.0"
kong_proxy_service_type         = "ClusterIP"
kong_admin_service_type         = "ClusterIP"
kong_database_type              = "postgres"
kong_enable_proxy_https         = true
kong_enable_admin_https         = true
kong_create_admin_ingress       = false
kong_create_proxy_ingress       = true
kong_ingress_controller_enabled = true

# Recursos Kong
kong_cpu_request    = "250m"
kong_memory_request = "300Mi"
kong_cpu_limit      = "600m"
kong_memory_limit   = "600Mi"

# Konga
konga_namespace        = "konga"
konga_create_namespace = true
konga_image_repository = "pantsel/konga"
konga_image_tag        = "0.14.9"
konga_replicas         = 1
konga_node_env         = "production"
konga_service_type     = "ClusterIP"
konga_create_ingress   = true
konga_token_secret     = "w3xbPwz3wv1g96e5E6xHJ5MlI7CxoDmv68YN1BG/7ew="

# Recursos Konga
konga_cpu_request    = "150m"
konga_memory_request = "200Mi"
konga_cpu_limit      = "300m"
konga_memory_limit   = "400Mi"

# Banco de dados específico para Kong
kong_postgres_host     = "kong.c8966ow2w0q1.us-east-1.rds.amazonaws.com"
kong_postgres_port     = 5432
kong_postgres_user     = "postgres"
kong_postgres_password = "postgres"
kong_postgres_database = "kong"
kong_pg_ssl            = "on"
kong_pg_ssl_verify     = "off"
kong_pg_timeout        = 60

# Banco de dados específico para Konga
konga_postgres_host     = "konga.c8966ow2w0q1.us-east-1.rds.amazonaws.com"
konga_postgres_port     = 5432
konga_postgres_user     = "postgres"
konga_postgres_password = "postgres"
konga_postgres_database = "konga"
konga_db_ssl            = true
konga_hook_timeout      = 120000
