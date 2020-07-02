output "cosmos_connection" {
  description = "Generic Cosmos Endpoint"
  value       = module.Create-Infrastructure.cosmos_connection
}

output "cosmos_key" {
  description = "Generic Cosmos Key"
  value       = module.Create-Infrastructure.cosmos_key
}

output "app_service_plan" {
  description = "Generic App Service Plan"
  value       = module.Create-Infrastructure.app_service_plan
}

output "storage_connection_string" {
  description = "Generic Storage Connection String"
  value       = module.Create-Infrastructure.storage_connection_string
}

output "queues" {
  value       = module.Create-Infrastructure.queues
  description = "Map of queues."
}