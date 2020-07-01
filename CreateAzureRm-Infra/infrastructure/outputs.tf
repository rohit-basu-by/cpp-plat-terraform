output "cosmos_connection" {
  description = "Generic Cosmos Endpoint"
  value       = module.Create-AzCosmos-Infr.cosmos_connection
}

output "cosmos_key" {
  description = "Generic Cosmos Key"
  value       = module.Create-AzCosmos-Infr.cosmos_key
}

output "app_service_plan" {
  description = "Generic App Service Plan"
  value       = module.Create-AzFunctionAppServicePlan-Registration.asp_id
}

output "storage_connection_string" {
  description = "Generic Storage Connection String"
  value       = module.Create-AzStorage-Infr.storage_connection_string
}