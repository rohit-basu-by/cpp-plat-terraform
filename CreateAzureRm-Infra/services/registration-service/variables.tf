terraform {
  backend "azurerm" {
     resource_group_name  = "cpp-terraform-rg"
     storage_account_name = "terraformstoragecpp"
     container_name       = "cppterraformapps"
     key                  = "4wty/jZXTOFCXXlVw+wbVsYSs+lBIVjv8bquWKSN4acxTkVK8lA9cQLYiA7WVG1AYzeRzFqMuTRZMTbaISgqGA=="
   }
  }
  required_version = ">= 0.12.6"
}


variable "rg_infr_name" {
  description = "infra resource group name."
  type        = string
}

variable "parallel_execution" {
  description = "parallel exec."
  type        = string
}