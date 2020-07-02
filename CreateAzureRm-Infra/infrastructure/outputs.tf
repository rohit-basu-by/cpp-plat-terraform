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

output "push_notification_app_service_plan" {
  description = "Push Notification App Service Plan"
  value = module.Create-AzFunctionAppServicePlan-PushNotification.asp_id
}

output "storage_connection_string" {
  description = "Generic Storage Connection String"
  value       = module.Create-AzStorage-Infr.storage_connection_string
}

output "notification_ops_storage_connection_string" {
  description = "Generic Storage Connection String"
  value       = module.Create-AzStorage-Notificaion-Ops-Infr.storage_connection_string
}

output "queues" {
  value       = module.Create-CPP-ServiceBus.queues
  description = "Map of queues."
}

output "notificationHubs" {
  value       = module.Create-CPP_NotificationHubs.notificationHubs
  description = "Map of notification hubs."
}