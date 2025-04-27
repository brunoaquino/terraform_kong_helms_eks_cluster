output "namespace" {
  description = "Namespace onde o Konga foi instalado"
  value       = var.create_namespace ? kubernetes_namespace.konga[0].metadata[0].name : var.namespace
} 
