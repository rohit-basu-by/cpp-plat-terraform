resource "azurerm_app_service_plan" "asp" {
  name                = "azure-functions-mobility-service-plan"
  location            = "${var.function_app_location}"
  resource_group_name = "${var.function_app_resource_group_name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "mobility" {
  name                      = "mobility-azure-functions"
  location                  = "${var.function_app_location}"
  resource_group_name       = "${var.function_app_resource_group_name}"
  app_service_plan_id       = "${var.aspId}"
  storage_connection_string = "${var.storage_primary_connection_string}"

  app_settings = {
    https_only                   = true
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~10"
    FUNCTION_APP_EDIT_MODE       = "readonly"
    COSMOS_DB_ENDPOINT           = "${var.cosmosdb_endpoint}"
    COSMOS_DB_MASTERKEY          = "${var.cosmosdb_primary_master_key}"
    //HASH = "${base64encode(filesha256("${var.functionapp}"))}"
    //WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.storage.name}.blob.core.windows.net/${azurerm_storage_container.deployments.name}/${azurerm_storage_blob.appcode.name}${data.azurerm_storage_account_sas.sas.sas}"
  }
}
