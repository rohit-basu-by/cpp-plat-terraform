variable "nh_resource_group_name" {
  description = "Notification Hub Resource group name."
  type        = string
}

variable "nh_location" {
  description = "Notification Hub location."
  type        = string
}

variable "nh_namespace_name" {
  description = "Notification Hub name."
  type        = string
}

variable "notificationHubs" {
  description = "List of notification Hubs to create"
  type        = list(any)
  default     = []
}