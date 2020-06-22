provider "azurerm" {
  #   subscription_id = var.subscription_id
  #   client_id       = var.service_principals[0]["Application_Id"]
  #   client_secret   = var.service_principals[0]["Application_Secret"]
  #   tenant_id       = var.tenant_id
  #   version         = "~> 2.0"
  #   features {}
  version = "=2.4.0"

  subscription_id = "00000000-0000-0000-0000-000000000000"
  client_id       = "00000000-0000-0000-0000-000000000000"
  client_secret   = var.client_secret
  tenant_id       = "00000000-0000-0000-0000-000000000000"

  features {}
}

data "azurerm_resource_group" "Infr" {
  name = var.rg_infr_name
}

module "Create-AzCosmos-Infr" {
  source                     = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//module/Az-Cosmos?ref=master"
  cosmos_resource_group_name = data.azurerm_resource_group.Infr.name
  comos_location             = data.azurerm_resource_group.Infr.location
}