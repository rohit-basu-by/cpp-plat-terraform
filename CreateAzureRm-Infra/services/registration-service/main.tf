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

data "terraform_remote_state" "infrastructure" {
  backend = "azurerm"
  config = {
    resource_group_name  = "cpp-terraform-rg"
    storage_account_name = "terraformstoragecpp"
    container_name       = "cppterraform"
    key                  = "Ods3a9o4WCMGcK8wdt34cbmiQKTzXW0r8EK58tQ7BhYFgwWhcyQyxap5xIBjSO9te4kBjCV7LmZHmnNB2Tp1Qg=="
  }
}

module "Create-FunctionApp-Registration-App" { //module A
  source                            = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-FunctionApp?ref=master"
  function_app_name                 = "cpp-registration-service"
  function_app_resource_group_name  = data.azurerm_resource_group.Infr.name
  function_app_location             = data.azurerm_resource_group.Infr.location
  aspId                             = data.terraform_remote_state.infrastructure.outputs.app_service_plan
  storage_primary_connection_string = data.terraform_remote_state.infrastructure.outputs.storage_connection_string // refer module C outisde of A

  app_settings = {
    https_only                   = true
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~10"
    FUNCTION_APP_EDIT_MODE       = "readonly"
    COSMOS_DB_ENDPOINT           = data.terraform_remote_state.infrastructure.outputs.cosmos_connection
    COSMOS_DB_MASTERKEY          = data.terraform_remote_state.infrastructure.outputs.cosmos_key
  }
}