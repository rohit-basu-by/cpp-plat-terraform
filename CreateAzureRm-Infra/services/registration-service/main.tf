provider "azurerm" {
  #   subscription_id = var.subscription_id
  #   client_id       = var.service_principals[0]["Application_Id"]
  #   client_secret   = var.service_principals[0]["Application_Secret"]
  #   tenant_id       = var.tenant_id
  #   version         = "~> 2.0"
  #   features {}
  version = "=2.4.0"

  subscription_id = "00000000-0000-0000-0000-000000000000"
  client_id       = "00000000-0000-0000-0000-000000000000"
  client_secret   = "${var.client_secret}"
  tenant_id       = "00000000-0000-0000-0000-000000000000"

  features {}
}
data "azurerm_resource_group" "Infr" {
  name = var.rg_infr_name
}

module "Create-FunctionApp-Registration-App" {
  source                           = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-FunctionApp?ref=master"
  name                             = "${var.function_app_name}"
  function_app_resource_group_name = data.azurerm_resource_group.Infr.name
  function_app_location            = data.azurerm_resource_group.Infr.location
  app_service_plan_id              = module.Create-AzFunctionAppServicePlan.asp_id
  storage_connection_string        = module.Create-AzStorage-Infr.storage_connection_string

  app_settings = {
    https_only                   = true
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~10"
    FUNCTION_APP_EDIT_MODE       = "readonly"
    COSMOS_DB_ENDPOINT           = module.Create-AzCosmos-Infr.cosmosdb_endpoint
    COSMOS_DB_MASTERKEY          = module.Create-AzCosmos-Infr.cosmosdb_primary_master_key
  }
}