variable "app_service_plan_resource_group_name" {
  description = "App Service Plan Resource group name."
  type        = string
}

variable "app_service_plan_location" {
  description = "App Service Plan location."
  type        = string
}

variable "app_service_plan_kind" {
  description = "App Service Plan kind."
  default     = "Windows"
  type        = string
}

variable "app_service_plan_name" {
  description = "App Service Plan name."
  type        = string
}

variable "app_service_plan_sku_tier" {
  description = "App Service Plan SKU Tier"
  type        = string
}

variable "app_service_plan_sku_size" {
  description = "App Service Plan SKU Size"
  type        = string
}