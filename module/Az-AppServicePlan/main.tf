resource "azurerm_app_service_plan" "asp" {
  name                = "${var.app_service_plan_name}"
  location            = "${var.app_service_plan_location}"
  resource_group_name = "${var.app_service_plan_resource_group_name}"
  kind                = "${var.app_service_plan_kind}"

  sku {
    tier = "${var.app_service_plan_sku_tier}"
    size = "${var.app_service_plan_sku_size}"
  }
}