resource "azurerm_storage_account" "storage" {
  name                     = "functionsappmobilitysa"
  resource_group_name      = "${var.storage_group_name}"
  location                 = "${var.storage_location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}