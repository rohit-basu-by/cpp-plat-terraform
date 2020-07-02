output "servicebus_namespace" {
  value = azurerm_servicebus_namespace.cpp-namespace
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

output "queues" {
  value = {
    for queue in azurerm_servicebus_queue.queue :
    queue.name => {
      id   = queue.id
      name = queue.name
      authorization_rules = {
        for rule in azurerm_servicebus_queue_authorization_rule.auth-rule :
        rule.name => {
          name                        = rule.name
          primary_key                 = rule.primary_key
          primary_connection_string   = rule.primary_connection_string
          secondary_key               = rule.secondary_key
          secondary_connection_string = rule.secondary_connection_string
        } if queue.name == rule.queue_name
      }
    }
  }
  description = "Map of queues."
}