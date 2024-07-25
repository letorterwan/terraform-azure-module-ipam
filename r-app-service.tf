# Create the App Service powering the IPAM
# The new resource linux_web_app doesn't support linux_fx and compose, this should be updated when fixed (actual resource is deprecated and will not be usable with AzureRM 4.0)
resource "azurerm_app_service" "ipam_app" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.ipam_appsvc_plan.id
  https_only          = true

  site_config {
    always_on        = true
    linux_fx_version = "COMPOSE|${filebase64("${path.module}/files/docker-compose.yml")}"
  }

  app_settings = {
    "AZURE_ENV"                       = "azureCloud"
    "COSMOS_URL"                      = azurerm_cosmosdb_account.ipam_cosmosdb_account.endpoint
    "COSMOS_KEY"                      = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.ipam_secret_cosmos_key.versionless_id})"
    "DATABASE_NAME"                   = azurerm_cosmosdb_sql_database.ipam_cosmosdb_sql_db.name
    "CONTAINER_NAME"                  = azurerm_cosmosdb_sql_container.ipam_cosmosdb_sql_container.name
    "UI_APP_ID"                       = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.ipam_secret_ui_app_id.versionless_id})"
    "ENGINE_APP_ID"                   = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.ipam_secret_engine_app_id.versionless_id})"
    "ENGINE_APP_SECRET"               = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.ipam_secret_engine_app_secret.versionless_id})"
    "TENANT_ID"                       = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.ipam_secret_tenant_id.versionless_id})"
    "KEYVAULT_URL"                    = azurerm_key_vault.ipam_kv.vault_uri
    "DOCKER_ENABLE_CI"                = true
    "DOCKER_REGISTRY_SERVER_URL"      = "https://index.docker.io/v1"
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE" = true
  }

  key_vault_reference_identity_id = azurerm_user_assigned_identity.ipam_msi.id
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.ipam_msi.id]
  }

  logs {
    detailed_error_messages_enabled = true
    failed_request_tracing_enabled  = true
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 50
      }
    }
  }

  tags = coalesce(var.tags, local.tags)

  depends_on = [azurerm_app_service_plan.ipam_appsvc_plan, azurerm_cosmosdb_sql_container.ipam_cosmosdb_sql_container]
}

# App Service Diagnostics Settings
resource "azurerm_monitor_diagnostic_setting" "ipam_app_diagnostics" {
  count                          = var.logging_enabled == true ? 1 : 0 # Deploy only if var logging_enabled is true
  name                           = "app-diagnostics"
  target_resource_id             = azurerm_app_service.ipam_app.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "AzureDiagnostics"

  enabled_log {
    category = "AppServiceAntivirusScanAuditLogs"
  }

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_log {
    category = "AppServiceAppLogs"
  }

  enabled_log {
    category = "AppServiceFileAuditLogs"
  }

  enabled_log {
    category = "AppServiceAuditLogs"
  }

  enabled_log {
    category = "AppServiceIPSecAuditLogs"
  }

  enabled_log {
    category = "AppServicePlatformLogs"
  }

  metric {
    category = "AllMetrics"
  }

  depends_on = [azurerm_app_service.ipam_app]
  lifecycle {
    # temporary fix to ignore continuous drift
    ignore_changes = [log_analytics_destination_type]
  }
}
