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

variable "app_name" {
  description = "Application name used in objects naming convention."
  type        = string
}