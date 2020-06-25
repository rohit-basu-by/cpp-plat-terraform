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

module "Create-Infrastructure" {
  source       = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//CreateAzureRm-Infra/infrastructure?ref=feature/terraform-final"
  rg_infr_name = var.rg_infr_name
}

module "Create-Registration-Service" {
  source       = "git::https://github.com/rohit-basu-by/cpp-plat-terraform.git//CreateAzureRm-Infra/services/registration-service?ref=feature/terraform-final"
  rg_infr_name = var.rg_infr_name
  parallel = module.Create-Infrastructure.cosmos_key
}