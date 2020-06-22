resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "mobility-nosql"
  location            = "${var.cosmos_location}"
  resource_group_name = "${var.cosmos_resource_group_name}"
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 600
    max_staleness_prefix    = 100050
  }

  geo_location {
    location          = "westus"
    failover_priority = 1
  }

  geo_location {
    location          = "${var.cosmos_location}"
    failover_priority = 0
  }

  app_settings = {
    abs = 

  }
}