resource "azurerm_app_service_plan" "asp" {
  name                = "${var.app_service_plan_name}"
  location            = "${var.app_service_plan_location}"
  resource_group_name = "${var.app_service_plan_resource_group}"
  kind                = "${var.app_service_plan_kind}"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}