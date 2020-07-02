output "notificationHubs" {
  value = {
    for hub in azurerm_notification_hub.main :
    hub.name => {
      id   = queue.id
      name = queue.name
      authorization_rules = {
        for rule in azurerm_notification_hub_authorization_rule.main :
        rule.name => {
          name                        = rule.name
          primary_access_key                 = rule.primary_access_key
          secondary_access_key              = rule.secondary_access_key
        }
      }
    }
  }
  description = "Map of notification hubs."
}