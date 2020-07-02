resource "azurerm_notification_hub_namespace" "main" {
  name                = var.nh_namespace_name
  resource_group_name = var.nh_resource_group_name
  location            = var.nh_location
  namespace_type      = "NotificationHub"

  sku_name = "Standard"
}

resource "azurerm_notification_hub" "main" {
  count               = length(var.notificationHubs)
  name                = element(var.notificationHubs, count.index).nh_name
  namespace_name      = azurerm_notification_hub_namespace.main.name
  resource_group_name = var.nh_resource_group_name
  location            = var.nh_location

  apns_credential {
    application_mode = element(var.notificationHubs, count.index).apns_app_mode
    bundle_id        = element(var.notificationHubs, count.index).apns_bundle_id
    key_id           = element(var.notificationHubs, count.index).apns_key_id
    team_id          = element(var.notificationHubs, count.index).apns_team_id
    token            = element(var.notificationHubs, count.index).apns_token
  }

  gcm_credential {
    api_key = element(var.notificationHubs, count.index).gcm_api_key
  }

  depends_on = [azurerm_notification_hub_namespace.main]
}

resource "azurerm_notification_hub_authorization_rule" "main" {
  count               = length(var.notificationHubs)
  name                  = element(var.notificationHubs, count.index).nh_name
  notification_hub_name = element(var.notificationHubs, count.index).nh_name
  namespace_name        = azurerm_notification_hub_namespace.main.name
  resource_group_name   = azurerm_notification_hub_namespace.main.name
  manage                = true
  send                  = true
  listen                = true
}