resource "azurerm_app_service_plan" "ipam_appsvc_plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  kind     = "Linux"
  reserved = true

  sku {
    tier     = "PremiumV3"
    size     = "P1v3"
    capacity = 1
  }

  tags = coalesce(var.tags, local.tags)

}

# App Service Plan Diagnostics Settings
resource "azurerm_monitor_diagnostic_setting" "ipam_appsvc_plan_diagnostics" {
  count                          = var.logging_enabled == true ? 1 : 0 # Deploy only if var logging_enabled is true
  name                           = "appsvc-diagnostics"
  target_resource_id             = azurerm_app_service_plan.ipam_appsvc_plan.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "AzureDiagnostics"

  metric {
    category = "AllMetrics"
  }

  depends_on = [azurerm_app_service_plan.ipam_appsvc_plan]

  lifecycle {
    # temporary fix to ignore continuous drift
    ignore_changes = [log_analytics_destination_type]
  }
}
