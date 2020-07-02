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

module "Create-FunctionApp-Push-Notification-App" {
  source                            = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-FunctionApp?ref=origin/master"
  function_app_name                 = var.app_name
  function_app_resource_group_name  = data.azurerm_resource_group.Infr.name
  function_app_location             = data.azurerm_resource_group.Infr.location
  aspId                             = var.aspId
  storage_primary_connection_string = module.Create-AzStorage-Push-Notification-Infr.storage_primary_connection_string
  app_settings                      = var.app_settings
}