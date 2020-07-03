provider "azurerm" {
  #   subscription_id = var.subscription_id
  #   client_id       = var.service_principals[0]["Application_Id"]
  #   client_secret   = var.service_principals[0]["Application_Secret"]
  #   tenant_id       = var.tenant_id
  #   version         = "~> 2.0"
  #   features {}
  version = "=2.4.0"
  features {}
}

data "azurerm_resource_group" "Infr" {
  name = var.rg_infr_name
}

module "Create-AzStorage-Push-Notification-Infr" {
  source                      = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-StorageAccount?ref=origin/master"
  storage_resource_group_name = data.azurerm_resource_group.Infr.name
  storage_location            = data.azurerm_resource_group.Infr.location
  storage_name                = var.app_name
}
module "Create-AzStorage-Push-Notification-Durable" {
  source                      = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-StorageAccount?ref=origin/master"
  storage_resource_group_name = data.azurerm_resource_group.Infr.name
  storage_location            = data.azurerm_resource_group.Infr.location
  storage_name                = "durable${var.app_name}"
}

resource "azurerm_application_insights" "push_notification" {
  name                = "Notification-Ops-AppInsights"
  location            = data.azurerm_resource_group.Infr.location
  resource_group_name = data.azurerm_resource_group.Infr.name
  application_type    = "Node.JS"
  retention_in_days   = 30
}

module "Create-FunctionApp-Push-Notification-App" {
  source                            = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-FunctionApp?ref=origin/master"
  function_app_name                 = var.app_name
  function_app_resource_group_name  = data.azurerm_resource_group.Infr.name
  function_app_location             = data.azurerm_resource_group.Infr.location
  aspId                             = var.aspId
  storage_primary_connection_string = module.Create-AzStorage-Push-Notification-Infr.storage_connection_string
  app_settings                      = merge(var.app_settings, { "durablefunstorageconnstring" : module.Create-AzStorage-Push-Notification-Durable.storage_connection_string, "APPINSIGHTS_INSTRUMENTATIONKEY" : azurerm_application_insights.push_notification.instrumentation_key, "APPLICATIONINSIGHTS_CONNECTION_STRING" : format("InstrumentationKey=%s", azurerm_application_insights.push_notification.instrumentation_key) })
}