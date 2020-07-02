resource "azurerm_servicebus_namespace" "cpp-namespace" {
  resource_group_name = var.sb_resource_group_name
  name                = var.sb_namespace_name
  location            = var.sb_location
  sku                 = var.namespace_sku
  capacity            = var.namespace_capacity
  tags                = var.tags
}

resource "azurerm_servicebus_queue" "queue" {
  count               = length(var.queues)
  name                = element(var.queues, count.index)
  resource_group_name = var.sb_resource_group_name
  namespace_name      = azurerm_servicebus_namespace.cpp-namespace.name
  enable_partitioning = true
  depends_on = [azurerm_servicebus_namespace.cpp-namespace]
}

resource "azurerm_servicebus_topic" "topic" {
  count               = var.namespace_sku != "basic" ? length(var.topics) : 0
  name                = element(var.topics, count.index)
  resource_group_name = var.sb_resource_group_name
  namespace_name      = azurerm_servicebus_namespace.cpp-namespace.name
  depends_on = [azurerm_servicebus_namespace.cpp-namespace]
}

resource "azurerm_servicebus_subscription" "subscription" {
  count               = var.namespace_sku != "basic" ? length(var.topics) : 0
  name                = "${element(azurerm_servicebus_topic.topic.*.name, count.index)}-sub"
  resource_group_name = var.sb_resource_group_name
  namespace_name      = azurerm_servicebus_namespace.cpp-namespace.name
  topic_name          = element(azurerm_servicebus_topic.topic.*.name, count.index)
  max_delivery_count  = var.servicebus_subscription_max_delivery_count
  depends_on = [azurerm_servicebus_namespace.cpp-namespace]
}