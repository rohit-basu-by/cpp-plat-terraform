data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "mobility-nosql"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 600
    max_staleness_prefix    = 100050
  }

  geo_location {
    location          = "North Europe"
    failover_priority = 1
  }

  geo_location {
    location          = data.azurerm_resource_group.main.location
    failover_priority = 0
  }
}