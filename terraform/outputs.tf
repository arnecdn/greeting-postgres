output "postgres_service_name" {
  description = "Name of the PostgreSQL service"
  value       = kubernetes_service.postgres_greeting.metadata[0].name
}

output "postgres_deployment_name" {
  description = "Name of the PostgreSQL deployment"
  value       = kubernetes_deployment.postgres_greeting.metadata[0].name
}