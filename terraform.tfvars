aws_region           = "us-east-1"
eks_cluster_name     = "app-cluster"
eks_cluster_endpoint = "https://C790C43D70761FCCA628E2CBE1704AF2.sk1.us-east-1.eks.amazonaws.com"
eks_cluster_ca_cert  = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJYzJwdmZjZFZRMTR3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRBME1qY3hOREEwTlRsYUZ3MHpOVEEwTWpVeE5EQTVOVGxhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURoTlBETXBmb0JCRitjOS9HSldLV21NYXp2K0UwRGxodVR5U3hxZVRQNXJWVGk2amp4a3JuOVE4dWMKTHhWOC83L1BiaEtWU3RTTlduNndSQmE3aGhBb3R0aldyRjJLZWlRaUZiVlBwSUxPRmp4YmMrQTJyTnNBYllCSgpKRUQrT2FiMVZxRzVPRlkrMXh6S1VlQ2JXc1hybVFSVWM1UHM4VU5QNnhCZHlIN3dkRXJ2UWJ3NHpReFExTTdpCkh1bTJRVWU4MnhralNTSjFVb24wWTROUEVncndEMytrd1Zna0dsakgzaTdoV1hlZURTTjhjY1BGZHFJSnRxR1AKMDFPVTM4VzNCbmsxZGUybjU4YUJJd2V2RVkvOGpFLzkxVWs2VlFlaWxjMGpsQjlESVFhbCtNbVhyd2hYTHJHWApTS1FVcCt0NmMydU1FTjAydEJkSlgwNnk1UVpoQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJTVWZCbTZ5SkFKUExtcDlqV0ZScVNhdXl2ZnFqQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ2pUQndxaWZ5VgprQzB1dTMrR0N6WWFER01iN0ltbjk3Zy9UR1pEODBPaVZuazMyZGtLMm8xZlNmZ3E3RUE3SjBPS25jMEVSdGw5CjNLckVhT0FxZUxoa1h2YjhyYXZGTG1lb3EvOVZ3Q2o1NUlqWjZHSEcrUCs1UEpwSExOOTlBN1hxcXNBclN0U0cKNE1ubXlvZ1dodm4vQjJUajU5QVRoa1EreUYzcDVZeTVNOWxDVVRmTWx1YW1CK0lLZUFWUUE4WkphNm5ObklwZgpkQTd5ZkdZV1R0UkNMb2lRd2xYcGJWNzZTWHM5bnd5MkJNejJ4d3N6UFdha09MQnBwc2lZakExRFZ3ZFVjSUsxCisrc05iT0JXUVhCVGdMQldXTWRPMEJ3aTJsQjhyd2lTZ3NHRjRlTVR3Q3lNSVJWMzZuQ1czcVljNVVYUHR2NUgKL2VidGI0TGd6MDQ0Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"

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
kong_cpu_request                = "200m"
kong_memory_request             = "512Mi"
kong_cpu_limit                  = "500m"
kong_memory_limit               = "1024Mi"

# Konga
konga_namespace        = "konga"
konga_create_namespace = true
konga_image_repository = "pantsel/konga"
konga_image_tag        = "0.14.9"
konga_replicas         = 1
konga_node_env         = "production"
konga_service_type     = "ClusterIP"
konga_create_ingress   = true
konga_cpu_request      = "200m"
konga_memory_request   = "512Mi"
konga_cpu_limit        = "500m"
konga_memory_limit     = "1024Mi"
konga_token_secret     = "token-secret-konga-123"

# Banco de dados específico para Kong
kong_postgres_host     = "postgresql.c8966ow2w0q1.us-east-1.rds.amazonaws.com"
kong_postgres_port     = 5432
kong_postgres_user     = "kong"
kong_postgres_password = "kong"
kong_postgres_database = "kong"
kong_pg_ssl            = "on"
kong_pg_ssl_verify     = "off"
kong_pg_timeout        = 60

# Banco de dados específico para Konga
konga_postgres_host     = "postgresql.c8966ow2w0q1.us-east-1.rds.amazonaws.com"
konga_postgres_port     = 5432
konga_postgres_user     = "konga"
konga_postgres_password = "konga"
konga_postgres_database = "konga"
konga_db_ssl            = true
konga_hook_timeout      = 120000
