provider "azurerm" {
  #   subscription_id = var.subscription_id
  #   client_id       = var.service_principals[0]["Application_Id"]
  #   client_secret   = var.service_principals[0]["Application_Secret"]
  #   tenant_id       = var.tenant_id
  #   version         = "~> 2.0"
  #   features {}
  version = "=2.4.0"

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}

data "azurerm_resource_group" "Infr" {
  name = var.rg_infr_name
}

module "Create-AzCosmos-Infr" {
  source                     = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-Cosmos?ref=master"
  cosmos_resource_group_name = data.azurerm_resource_group.Infr.name
  cosmos_location            = data.azurerm_resource_group.Infr.location
}

module "Create-AzStorage-Infr" {
  source                 = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-Storage?ref=master"
  storage_resource_group = data.azurerm_resource_group.Infr.name
  storage_location       = data.azurerm_resource_group.Infr.location
}

module "Create-AzFunctionAppServicePlan" {
  source                               = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-AppServicePlan?ref=master"
  app_service_plan_resource_group_name = data.azurerm_resource_group.Infr.name
  app_service_plan_location            = data.azurerm_resource_group.Infr.location
  app_service_plan_kind                = "FunctionApp"
}