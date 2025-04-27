output "namespace" {
  description = "Namespace onde o Kong foi instalado"
  value       = var.create_namespace ? kubernetes_namespace.kong[0].metadata[0].name : var.namespace
} 
