terraform {
  backend "azurerm" {
  }
  required_version = ">= 0.12.6"
}


variable "subscription_id" {
  description = "Azure subscription Id."
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant Id."
  type        = string
}

variable "rg_infr_name" {
  description = "infra resource group name."
  type        = string
}