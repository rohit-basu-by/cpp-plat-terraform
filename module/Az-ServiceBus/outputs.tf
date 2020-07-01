output "servicebus_namespace" {
  value = azurerm_servicebus_namespace.namespace
}

output "queues" {
  value = azurerm_servicebus_queue.queue
}

output "topics" {
  value = azurerm_servicebus_topic.topic
}

output "subscriptions" {
  value = azurerm_servicebus_subscription.subscription
}