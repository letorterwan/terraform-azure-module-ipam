# Create a secret on the Key Vault for UI App ID
resource "azurerm_key_vault_secret" "ipam_secret_ui_app_id" {
  name         = "UI-ID"
  value        = azuread_application.ipam_ui.client_id
  key_vault_id = azurerm_key_vault.ipam_kv.id

  depends_on = [azurerm_key_vault_access_policy.ipam_kv_build_policy]
}

# Create a secret on the Key Vault for Engine App ID
resource "azurerm_key_vault_secret" "ipam_secret_engine_app_id" {
  name         = "ENGINE-ID"
  value        = azuread_application.ipam_engine.client_id
  key_vault_id = azurerm_key_vault.ipam_kv.id

  depends_on = [azurerm_key_vault_access_policy.ipam_kv_build_policy]
}

# Create a secret on the Key Vault for Engine App Secret
resource "azurerm_key_vault_secret" "ipam_secret_engine_app_secret" {
  name         = "ENGINE-SECRET"
  value        = azuread_application_password.ipam_engine_secret.value
  key_vault_id = azurerm_key_vault.ipam_kv.id

  depends_on = [azurerm_key_vault_access_policy.ipam_kv_build_policy]
}

# Create a secret on the Key Vault for Tenant ID
resource "azurerm_key_vault_secret" "ipam_secret_tenant_id" {
  name         = "TENANT-ID"
  value        = var.tenant_id
  key_vault_id = azurerm_key_vault.ipam_kv.id

  depends_on = [azurerm_key_vault_access_policy.ipam_kv_build_policy]
}

# Create a secret on the Key Vault for CosmosDB Master Key
resource "azurerm_key_vault_secret" "ipam_secret_cosmos_key" {
  name         = "COSMOS-KEY"
  value        = azurerm_cosmosdb_account.ipam_cosmosdb_account.primary_key
  key_vault_id = azurerm_key_vault.ipam_kv.id

  depends_on = [azurerm_key_vault_access_policy.ipam_kv_build_policy]
}
