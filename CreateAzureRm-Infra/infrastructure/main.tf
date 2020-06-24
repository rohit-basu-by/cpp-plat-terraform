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

resource "azurerm_cosmosdb_mongo_database" "cpp" {
  name                = "cpp-database"
  resource_group_name = data.azurerm_resource_group.Infr.name
  account_name        = "mobility-nosql"
}
resource "azurerm_cosmosdb_mongo_collection" "collection" {
  name                = "Customers"
  resource_group_name = data.azurerm_resource_group.Infr.name
  account_name        = "mobility-nosql"
  database_name       = "cpp-database"
  default_ttl_seconds = "777"
  throughput          = 400
  shard_key           = "customerId"
}
resource "azurerm_cosmosdb_mongo_collection" "collection" {
  name                = "Products"
  resource_group_name = data.azurerm_resource_group.Infr.name
  account_name        = "mobility-nosql"
  database_name       = "cpp-database"
  default_ttl_seconds = "777"
  throughput          = 400
  shard_key           = "productId"
}
resource "azurerm_cosmosdb_mongo_collection" "collection" {
  name                = "Environments"
  resource_group_name = data.azurerm_resource_group.Infr.name
  account_name        = "mobility-nosql"
  database_name       = "cpp-database"
  default_ttl_seconds = "777"
  throughput          = 400
  shard_key           = "ENV_KEY"
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

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}