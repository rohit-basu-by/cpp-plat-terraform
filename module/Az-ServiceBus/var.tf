variable "sb_resource_group_name" {
  description = "Service Bus Resource group name."
  type        = string
}

variable "sb_location" {
  description = "Service Bus location."
  type        = string
}

variable "sb_namespace_name" {
  description = "Service Bus name."
  type        = string
}

variable "namespace_sku" {
  description = "Defines which tier to use. Options are basic, standard or premium"
  default     = "basic"
}

variable "namespace_capacity" {
  description = "Specifies the capacity. When sku is Premium, capacity can be 1, 2, 4 or 8. When sku is Basic or Standard, capacity can be 0 only"
  default     = 0
}

variable "queues" {
  description = "List of queues to create"
  type        = list(string)
  default     = []
}

variable "topics" {
  description = "List of topics to create"
  type        = list(string)
  default     = []
}


variable "servicebus_subscription_max_delivery_count" {
  description = "The maximum number of deliveries"
  type        = number
  default     = 1
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}