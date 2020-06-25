terraform {
  backend "azurerm" {
    resource_group_name  = "cpp-terraform-rg"
    storage_account_name = "terraformstoragecpp"
    container_name       = "cppterraform"
    key                  = "Ods3a9o4WCMGcK8wdt34cbmiQKTzXW0r8EK58tQ7BhYFgwWhcyQyxap5xIBjSO9te4kBjCV7LmZHmnNB2Tp1Qg=="
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