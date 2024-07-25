# Create a Key Vault
resource "azurerm_key_vault" "ipam_kv" {
  name                = var.kv_name
  location            = var.location
  tenant_id           = var.tenant_id
  resource_group_name = azurerm_resource_group.rg.name

  enabled_for_disk_encryption     = false
  enabled_for_deployment          = false
  enabled_for_template_deployment = false
  enable_rbac_authorization       = false
  soft_delete_retention_days      = 30
  purge_protection_enabled        = false
  sku_name                        = "standard"
  tags                            = coalesce(var.tags, local.tags)
}

# Create an access policy allowing the managed identity
resource "azurerm_key_vault_access_policy" "ipam_kv_policy_msi" {
  key_vault_id = azurerm_key_vault.ipam_kv.id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.ipam_msi.principal_id

  secret_permissions = [
    "Get",
  ]

  depends_on = [azurerm_user_assigned_identity.ipam_msi, azurerm_key_vault.ipam_kv]
}

# Create an access policy allowing the builder account to access and manage secrets
# -> UPDATE TO DO : use RBAC mode instead of policy-based access
resource "azurerm_key_vault_access_policy" "ipam_kv_build_policy" {
  key_vault_id = azurerm_key_vault.ipam_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey",
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set",
  ]

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update",
  ]

  depends_on = [azurerm_key_vault.ipam_kv]
}

# Key Vault Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "ipam_kv_diagnostics" {
  count                          = var.logging_enabled == true ? 1 : 0 # Deploy only if var logging_enabled is true
  name                           = "kv-diagnostics"
  target_resource_id             = azurerm_key_vault.ipam_kv.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "AzureDiagnostics"

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
  }

  depends_on = [azurerm_key_vault.ipam_kv]
}
