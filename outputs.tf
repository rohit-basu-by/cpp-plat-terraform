output "cosmos_connection" {
  value = azurerm_cosmosdb_account.cosmosdb.endpoint
}

output "cosmos_key" {
  value = azurerm_cosmosdb_account.cosmosdb.primary_master_key
}