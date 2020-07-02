terraform {
  # backend "azurerm" {
  #   resource_group_name  = "cpp-terraform-rg"
  #   storage_account_name = "terraformstoragecpp"
  #   container_name       = "cppterraform"
  #   key                  = "4wty/jZXTOFCXXlVw+wbVsYSs+lBIVjv8bquWKSN4acxTkVK8lA9cQLYiA7WVG1AYzeRzFqMuTRZMTbaISgqGA=="
  # }
  required_version = ">= 0.12.6"
}


variable "rg_infr_name" {
  description = "infra resource group name."
  type        = string
}

variable "app_name" {
  description = "function app name."
  type        = string
}

variable "aspId" {
  description = "Function App location."
  type        = string
}

# variable "storage_primary_connection_string" {
#   description = "Function App Storage Connection String"
#   type        = string
# }

variable "app_settings" {
  default     = {}
  type        = "map"
  description = "Application settings to insert on creating the function app. Following updates will be ignored, and has to be set manually. Updates done on application deploy or in portal will not affect terraform state file."
}