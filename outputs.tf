# Outputs do Kong
output "kong_namespace" {
  description = "Namespace onde o Kong foi instalado"
  value       = module.kong.namespace
}

output "kong_proxy_endpoint" {
  description = "Endpoint do proxy do Kong"
  value       = "Para obter o endpoint do proxy do Kong, execute: kubectl get svc -n ${module.kong.namespace} kong-kong-proxy -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}

output "kong_admin_endpoint" {
  description = "Endpoint do admin do Kong"
  value       = "Para acessar o admin do Kong, use: https://kong-admin.${var.base_domain}"
}

# Outputs do Konga
output "konga_namespace" {
  description = "Namespace onde o Konga foi instalado"
  value       = module.konga.namespace
}

output "konga_endpoint" {
  description = "Endpoint do Konga"
  value       = "Para acessar o Konga, use: https://konga.${var.base_domain}"
}

output "konga_connection_setup" {
  description = "Instruções para configurar a conexão Konga-Kong"
  value       = <<-EOT
    1. Acesse o Konga em: https://konga.${var.base_domain}
    2. Crie uma conta de administrador no primeiro acesso
    3. Na tela de configuração de conexão, use:
       - Nome: Kong
       - URL do Kong Admin: http://kong-kong-admin.${module.kong.namespace}.svc.cluster.local:8001
    4. Clique em 'Add Connection'
  EOT
}

# Informações gerais
output "info_message" {
  description = "Informações gerais sobre a instalação"
  value       = <<-EOT
    Kong e Konga foram instalados com sucesso!
    
    Kong:
    - Namespace: ${module.kong.namespace}
    - Admin GUI: https://kong-admin.${var.base_domain}
    
    Konga:
    - Namespace: ${module.konga.namespace}
    - GUI: https://konga.${var.base_domain}
    
    Observações:
    - Se você deixou postgres_host vazio, o Kong está usando seu banco de dados embutido (DB-less)
    - Para usar um PostgreSQL externo, defina as variáveis postgres_* e reimplante
  EOT
}
