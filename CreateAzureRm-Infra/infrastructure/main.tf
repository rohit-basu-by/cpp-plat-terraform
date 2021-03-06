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
  depends_on          = [azurerm_cosmosdb_mongo_database.cpp]
}
resource "azurerm_cosmosdb_mongo_collection" "Products" {
  name                = "Products"
  resource_group_name = data.azurerm_resource_group.Infr.name
  account_name        = "mobility-nosql-mongo"
  database_name       = "cpp-database"
  default_ttl_seconds = "777"
  throughput          = 400
  shard_key           = "productId"
  depends_on          = [azurerm_cosmosdb_mongo_database.cpp]
}
resource "azurerm_cosmosdb_mongo_collection" "Environments" {
  name                = "Environments"
  resource_group_name = data.azurerm_resource_group.Infr.name
  account_name        = "mobility-nosql-mongo"
  database_name       = "cpp-database"
  default_ttl_seconds = "777"
  throughput          = 400
  shard_key           = "ENV_KEY"
  depends_on          = [azurerm_cosmosdb_mongo_database.cpp]
}

resource "azurerm_cosmosdb_mongo_collection" "MessageAudit" {
  name                = "MessageAudit"
  resource_group_name = data.azurerm_resource_group.Infr.name
  account_name        = "mobility-nosql-mongo"
  database_name       = "cpp-database"
  default_ttl_seconds = "777"
  throughput          = 400
  shard_key           = "ENV_KEY"
  depends_on          = [azurerm_cosmosdb_mongo_database.cpp]
}

resource "azurerm_cosmosdb_mongo_collection" "AppUsers" {
  name                = "AppUsers"
  resource_group_name = data.azurerm_resource_group.Infr.name
  account_name        = "mobility-nosql-mongo"
  database_name       = "cpp-database"
  default_ttl_seconds = "777"
  throughput          = 400
  shard_key           = "ENV_KEY"
  depends_on          = [azurerm_cosmosdb_mongo_database.cpp]
}


module "Create-AzStorage-Infr" {
  source                      = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-StorageAccount?ref=origin/master"
  storage_resource_group_name = data.azurerm_resource_group.Infr.name
  storage_location            = data.azurerm_resource_group.Infr.location
  storage_name                = "functionsappmobilitysa"
}

module "Create-AzStorage-Notificaion-Ops-Infr" {
  source                      = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-StorageAccount?ref=origin/master"
  storage_resource_group_name = data.azurerm_resource_group.Infr.name
  storage_location            = data.azurerm_resource_group.Infr.location
  storage_name                = "notificationops"
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

module "Create-AzFunctionAppServicePlan-PushNotification" {
  source                               = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-AppServicePlan?ref=origin/master"
  app_service_plan_resource_group_name = data.azurerm_resource_group.Infr.name
  app_service_plan_location            = data.azurerm_resource_group.Infr.location
  app_service_plan_kind                = "FunctionApp"
  app_service_plan_name                = "cpp-push-notifications-asp"

  app_service_plan_sku_tier = "Standard"
  app_service_plan_sku_size = "S2"
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

module "Create-CPP_NotificationHubs" {
  source                 = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-NotificationHub?ref=origin/master"
  nh_resource_group_name = data.azurerm_resource_group.Infr.name
  nh_location            = data.azurerm_resource_group.Infr.location
  nh_namespace_name      = "cpp-core-nh-namespace"
  notificationHubs = [
    {
      nh_name        = "by-lct"
      apns_app_mode  = "Production"
      apns_bundle_id = "com.jda.mobility.lct"
      apns_key_id    = "ZR2VH6AS32"
      apns_team_id   = "472WHE9N6Q"
      apns_token     = "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgIrRyErKeOtk8LDJ8  TVh2HOOiwiZGXIQcgWekWTEU9g6gCgYIKoZIzj0DAQehRANCAATpRHN38fBJENsB  QStkShXNMV8boQl/WrULs+2W1LH/cS8mnw0oWrJwLDJtihjE6AaeJbM/OztVbO5J  UjSFCNDr"
      gcm_api_key    = "AAAA198d8O0:APA91bGcwi6150YmmMekgh1heZHTDYcYO7unu8fQPArrdR2Ip3VyRPKZ0WeupkM26wuSm6t2RKxZzCm83AuMgRJ4FUBW4gUYVsN1eNjttD3gaitScj1JLEkJW3rpy23_3l99dM7_0bhf"
    },
    {
      nh_name        = "by-transport"
      apns_app_mode  = "Production"
      apns_bundle_id = "com.jda.mobility.trans"
      apns_key_id    = "ZR2VH6AS32"
      apns_team_id   = "472WHE9N6Q"
      apns_token     = "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgIrRyErKeOtk8LDJ8 TVh2HOOiwiZGXIQcgWekWTEU9g6gCgYIKoZIzj0DAQehRANCAATpRHN38fBJENsB QStkShXNMV8boQl/WrULs+2W1LH/cS8mnw0oWrJwLDJtihjE6AaeJbM/OztVbO5J UjSFCNDr"
      gcm_api_key    = "AAAArxW8mmM:APA91bHP3DBkROBMzXL3In7CscPxjOFDRNf9-q21jtZiCqRylDQRGBMAWETa4LNeezfveh1d9eZthcdL_aJroezKYpdke8_NgPBGQI00_edh2eXGhx934BTFcQwdX4tN56KEgq81vREm"
    },
    {
      nh_name        = "by-wfmr"
      apns_app_mode  = "Production"
      apns_bundle_id = "com.jda.mobility.wfmr"
      apns_key_id    = "ZR2VH6AS32"
      apns_team_id   = "472WHE9N6Q"
      apns_token     = "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgIrRyErKeOtk8LDJ8  TVh2HOOiwiZGXIQcgWekWTEU9g6gCgYIKoZIzj0DAQehRANCAATpRHN38fBJENsB  QStkShXNMV8boQl/WrULs+2W1LH/cS8mnw0oWrJwLDJtihjE6AaeJbM/OztVbO5J  UjSFCNDr"
      gcm_api_key    = "AAAAZFLaoQ4:APA91bHVlTVf70Y7AowRwazgRkLvaByijTu3zdFisQyUpBoK6IpA-LMCQ9zQ3wrKuSWlf9325-7HCVDi6_rhRMUJPZNtI-36wZkXrtSMxTUhkc6pxuZQA4bWFs-YKb2vDRaV__wEGVRm"
    }
  ]

}

