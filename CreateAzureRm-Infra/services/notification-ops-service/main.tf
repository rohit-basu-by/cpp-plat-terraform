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
  //parallel_execution = var.parallel_execution
}

resource "azurerm_application_insights" "cpp-notification_ops" {
  name                = "CPP-Notification-Ops-AppInsights"
  location            = data.azurerm_resource_group.Infr.location
  resource_group_name = data.azurerm_resource_group.Infr.name
  application_type    = "Node.JS"
  retention_in_days   = 30
}

module "Create-FunctionApp-Notification-Ops-App" {
  source                           = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-FunctionApp?ref=origin/master"
  function_app_name                = "cpp-notification-ops-service"
  function_app_resource_group_name = data.azurerm_resource_group.Infr.name
  function_app_location            = data.azurerm_resource_group.Infr.location
  #aspId                             = data.terraform_remote_state.infrastructure.outputs.app_service_plan
  #storage_primary_connection_string = data.terraform_remote_state.infrastructure.outputs.storage_connection_string // refer module C outisde of A
  aspId                             = var.aspId
  storage_primary_connection_string = var.storage_primary_connection_string
  app_settings                      = merge(var.app_settings, { "APPINSIGHTS_INSTRUMENTATIONKEY" : azurerm_application_insights.cpp-notification_ops.instrumentation_key, "APPLICATIONINSIGHTS_CONNECTION_STRING" : format("InstrumentationKey=%s", azurerm_application_insights.cpp-notification_ops.instrumentation_key) })
}