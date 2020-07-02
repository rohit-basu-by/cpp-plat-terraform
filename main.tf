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

module "Create-Infrastructure" {
  source       = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//CreateAzureRm-Infra/infrastructure?ref=origin/master"
  rg_infr_name = var.rg_infr_name
}



module "Create-Registration-Service" {
  source = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//CreateAzureRm-Infra/services/registration-service?ref=origin/master"
  //source       = "./CreateAzureRm-Infra/services/registration-service"
  rg_infr_name                      = var.rg_infr_name
  aspId                             = module.Create-Infrastructure.app_service_plan
  storage_primary_connection_string = module.Create-Infrastructure.storage_connection_string
  app_settings = {
    https_only                   = true
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~10"
    FUNCTION_APP_EDIT_MODE       = "readonly"
    COSMOS_DB_ENDPOINT           = module.Create-Infrastructure.cosmos_connection
    COSMOS_DB_MASTERKEY          = module.Create-Infrastructure.cosmos_key
  }
  parallel_execution = false
}

module "Create-Notification-Ops-Service" {
  source = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//CreateAzureRm-Infra/services/notification-ops-service?ref=origin/master"
  //source       = "./CreateAzureRm-Infra/services/registration-service"
  rg_infr_name                      = var.rg_infr_name
  aspId                             = module.Create-Infrastructure.app_service_plan
  storage_primary_connection_string = module.Create-Infrastructure.notification_ops_storage_connection_string
  app_settings = {
    https_only                   = true
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~10"
    FUNCTION_APP_EDIT_MODE       = "readonly"
    COSMOS_DB_ENDPOINT           = module.Create-Infrastructure.cosmos_connection
    COSMOS_DB_MASTERKEY          = module.Create-Infrastructure.cosmos_key
  }
  parallel_execution = false
}