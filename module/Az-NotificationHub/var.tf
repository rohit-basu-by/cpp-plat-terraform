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


variable "apns_app_mode" {
  description = "Notification Hub APNS name."
  type        = string
}

variable "apns_bundle_id" {
  description = "Notification Hub APNS Bundle ID."
  type        = string
}


variable "apns_key_id" {
  description = "Notification Hub APNS Key."
  type        = string
}


variable "apns_team_id" {
  description = "Notification Hub APNS Team ID."
  type        = string
}


variable "apns_token" {
  description = "Notification Hub APNS Token."
  type        = string
}


variable "gcm_api_key" {
  description = "Notification Hub GCM API Key."
  type        = string
}