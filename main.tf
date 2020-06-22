provider "azurerm" {
  version = "=2.4.0"

  subscription_id = "00000000-0000-0000-0000-000000000000"
  client_id       = "00000000-0000-0000-0000-000000000000"
  client_secret   = var.client_secret
  tenant_id       = "00000000-0000-0000-0000-000000000000"

  features {}
}

resource "random_id" "prefix" {
  byte_length = 8
}
resource "azurerm_resource_group" "main" {
  name     = "${random_id.prefix.hex}-rg"
  location = var.location
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

module "cosmos" {
  source = "./modules/cosmos"
}

resource "azurerm_storage_account" "storage" {
  name                     = "functionsappmobilitysa"
  location                 = data.azurerm_resource_group.main.location
  resource_group_name      = data.azurerm_resource_group.main.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "asp" {
  name                = "azure-functions-mobility-service-plan"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = "functionsappmobilitysa"
  location                 = data.azurerm_resource_group.main.location
  resource_group_name      = data.azurerm_resource_group.main.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "mobility" {
  name                      = "mobility-azure-functions"
  location                  = data.azurerm_resource_group.main.location
  resource_group_name       = data.azurerm_resource_group.main.name
  app_service_plan_id       = "${azurerm_app_service_plan.asp.id}"
  storage_connection_string = "${azurerm_storage_account.storage.primary_connection_string}"

  app_settings = {
    https_only                   = true
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~10"
    FUNCTION_APP_EDIT_MODE       = "readonly"
    COSMOS_DB_ENDPOINT           = module.cosmos.cosmos_connection
    COSMOS_DB_MASTERKEY          = module.cosmos.cosmos_key
    //HASH = "${base64encode(filesha256("${var.functionapp}"))}"
    //WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.storage.name}.blob.core.windows.net/${azurerm_storage_container.deployments.name}/${azurerm_storage_blob.appcode.name}${data.azurerm_storage_account_sas.sas.sas}"
  }
}