variable "function_app_resource_group_name" {
  description = "Function App Resource group name."
  type        = string
}

variable "function_app_location" {
  description = "Function App location."
  type        = string
}

variable "aspId" {
  description = "Function App location."
  type        = string
}

variable "storage_primary_connection_string" {
  description = "Function App Storage Connection String"
  type        = string
}

variable "function_app_name" {
  description = "Function App name"
  type        = string
}

variable "app_settings" {
  default     = {}
  type        = "map"
  description = "Application settings to insert on creating the function app. Following updates will be ignored, and has to be set manually. Updates done on application deploy or in portal will not affect terraform state file."
}