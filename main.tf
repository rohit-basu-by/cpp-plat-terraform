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
}

module "Create-Push-Notification-LCT-Service" {
  source = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//CreateAzureRm-Infra/services/push-notification-service?ref=origin/master"
  //source       = "./CreateAzureRm-Infra/services/registration-service"
  rg_infr_name = var.rg_infr_name
  aspId        = module.Create-Infrastructure.push_notification_app_service_plan
  app_name     = "cpplctpnservice"
  app_settings = {
    https_only                      = true
    FUNCTIONS_WORKER_RUNTIME        = "node"
    WEBSITE_NODE_DEFAULT_VERSION    = "~10"
    FUNCTION_APP_EDIT_MODE          = "readonly"
    hub_connection_string           = module.Create-Infrastructure.notificationHubs.by-lct.authorization_rules.by-lct.hub_connection_string
    hubAccessKeyName                = "by-lct"
    hubAccessKeySig                 = module.Create-Infrastructure.notificationHubs.by-lct.authorization_rules.by-lct.primary_access_key
    hubName                         = "by-lct"
    ServiceBusQueueConnectionString = module.Create-Infrastructure.queues.lct.authorization_rules.lct.primary_connection_string
    servicebusqueuename             = "lct"
    cosmodb_endpoint                = module.Create-Infrastructure.cosmos_connection
    cosmodb_primaryKey              = module.Create-Infrastructure.cosmos_key
  }
}

module "Create-Push-Notification-TMS-Service" {
  source = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//CreateAzureRm-Infra/services/push-notification-service?ref=origin/master"
  //source       = "./CreateAzureRm-Infra/services/registration-service"
  rg_infr_name = var.rg_infr_name
  aspId        = module.Create-Infrastructure.push_notification_app_service_plan
  app_name     = "cpptmspnservice"
  app_settings = {
    https_only                      = true
    FUNCTIONS_WORKER_RUNTIME        = "node"
    WEBSITE_NODE_DEFAULT_VERSION    = "~10"
    FUNCTION_APP_EDIT_MODE          = "readonly"
    hub_connection_string           = module.Create-Infrastructure.notificationHubs.by-transport.authorization_rules.by-transport.hub_connection_string
    hubAccessKeyName                = "by-transport"
    hubAccessKeySig                 = module.Create-Infrastructure.notificationHubs.by-transport.authorization_rules.by-transport.primary_access_key
    hubName                         = "by-transport"
    ServiceBusQueueConnectionString = module.Create-Infrastructure.queues.transport.authorization_rules.transport.primary_connection_string
    servicebusqueuename             = "transport"
    cosmodb_endpoint                = module.Create-Infrastructure.cosmos_connection
    cosmodb_primaryKey              = module.Create-Infrastructure.cosmos_key
  }
}

module "Create-Push-Notification-WFMR-Service" {
  source = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//CreateAzureRm-Infra/services/push-notification-service?ref=origin/master"
  //source       = "./CreateAzureRm-Infra/services/registration-service"
  rg_infr_name = var.rg_infr_name
  aspId        = module.Create-Infrastructure.push_notification_app_service_plan
  app_name     = "cppwfmrpnservice"
  app_settings = {
    https_only                      = true
    FUNCTIONS_WORKER_RUNTIME        = "node"
    WEBSITE_NODE_DEFAULT_VERSION    = "~10"
    FUNCTION_APP_EDIT_MODE          = "readonly"
    hub_connection_string           = module.Create-Infrastructure.notificationHubs.by-wfmr.authorization_rules.by-wfmr.hub_connection_string
    hubAccessKeyName                = "by-wfmr"
    hubAccessKeySig                 = module.Create-Infrastructure.notificationHubs.by-wfmr.authorization_rules.by-wfmr.primary_access_key
    hubName                         = "by-wfmr"
    ServiceBusQueueConnectionString = module.Create-Infrastructure.queues.wfmr.authorization_rules.wfmr.primary_connection_string
    servicebusqueuename             = "wfmr"
    cosmodb_endpoint                = module.Create-Infrastructure.cosmos_connection
    cosmodb_primaryKey              = module.Create-Infrastructure.cosmos_key
  }
}