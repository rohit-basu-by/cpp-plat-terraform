output "notificationHubs" {
  value = {
    for hub in azurerm_notification_hub.main :
    hub.name => {
      id   = hub.id
      name = hub.name
      authorization_rules = {
        for rule in azurerm_notification_hub_authorization_rule.main :
        rule.name => {
          name                 = rule.name
          hub_connection_string   = "Endpoint=sb://"+rule.name+".servicebus.windows.net/;SharedAccessKeyName="+rule.name+";SharedAccessKey="rule.primary_connection_string
          primary_access_key   = rule.primary_access_key
          secondary_access_key = rule.secondary_access_key
          //secondary_connection_string = rule.secondary_connection_string
        } if hub.name == rule.name
      }
    }
  }
  description = "Map of notification hubs."
}