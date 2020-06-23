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
  name                      = "${var.function_app_name}"
  location                  = "${var.function_app_location}"
  resource_group_name       = "${var.function_app_resource_group_name}"
  app_service_plan_id       = "${var.aspId}"
  storage_connection_string = "${var.storage_primary_connection_string}"

  app_settings = "${var.app_settings}"
}
