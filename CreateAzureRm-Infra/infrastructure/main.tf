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
  name = "${var.rg_infr_name}"
}

module "Create-AzCosmos-Infr" {
  source                     = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-Cosmos?ref=origin/master"
  cosmos_resource_group_name = data.azurerm_resource_group.Infr.name

  cosmos_location = data.azurerm_resource_group.Infr.location
}

resource "azurerm_cosmosdb_mongo_database" "cpp" {
  name                = "cpp-database"
  resource_group_name = data.azurerm_resource_group.Infr.name
  account_name        = "mobility-nosql-mongo"
  depends_on          = [module.Create-AzCosmos-Infr.cosmos_connection]
}
resource "azurerm_cosmosdb_mongo_collection" "Customers" {
  name                = "Customers"
  resource_group_name = data.azurerm_resource_group.Infr.name
  account_name        = "mobility-nosql-mongo"
  database_name       = "cpp-database"
  default_ttl_seconds = "777"
  throughput          = 400
  shard_key           = "customerId"
}
resource "azurerm_cosmosdb_mongo_collection" "Products" {
  name                = "Products"
  resource_group_name = data.azurerm_resource_group.Infr.name
  account_name        = "mobility-nosql-mongo"
  database_name       = "cpp-database"
  default_ttl_seconds = "777"
  throughput          = 400
  shard_key           = "productId"
}
resource "azurerm_cosmosdb_mongo_collection" "Environments" {
  name                = "Environments"
  resource_group_name = data.azurerm_resource_group.Infr.name
  account_name        = "mobility-nosql-mongo"
  database_name       = "cpp-database"
  default_ttl_seconds = "777"
  throughput          = 400
  shard_key           = "ENV_KEY"
}


module "Create-AzStorage-Infr" {
  source                      = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-StorageAccount?ref=origin/master"
  storage_resource_group_name = data.azurerm_resource_group.Infr.name
  storage_location            = data.azurerm_resource_group.Infr.location
  storage_name                = "functionsappmobilitysa"
}

module "Create-AzFunctionAppServicePlan-Registration" {
  source                               = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-AppServicePlan?ref=origin/master"
  app_service_plan_resource_group_name = data.azurerm_resource_group.Infr.name
  app_service_plan_location            = data.azurerm_resource_group.Infr.location
  app_service_plan_kind                = "FunctionApp"
  app_service_plan_name                = "cpp-registration-asp"

  app_service_plan_sku_tier = "Dynamic"
  app_service_plan_sku_size = "Y1"

}

module "Create-CPP-ServiceBus" {
  source                 = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-ServiceBus?ref=origin/master"
  sb_namespace_name      = "cpp-core-sb-namespace"
  namespace_sku          = "Standard"
  sb_location            = data.azurerm_resource_group.Infr.location
  sb_resource_group_name = data.azurerm_resource_group.Infr.name

  tags = {
    source = "terraform"
  }

  queues = ["lct", "transport", "wfmr", "debugqueue"]
}

