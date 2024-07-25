# Assign necessary roles for identities
# The Engine App is used to read Azure and detect existing networks
resource "azurerm_role_assignment" "ipam_engine_app_reader" {
  for_each                         = toset(coalesce(local.default_ipam_scope, var.ipam_scopes))
  scope                            = each.key
  role_definition_name             = "Reader"
  principal_id                     = azuread_service_principal.ipam_engine_sp.id
  skip_service_principal_aad_check = true

  depends_on = [azuread_service_principal.ipam_engine_sp]
}

# Add access to the MSI used by appservice
resource "azurerm_role_assignment" "ipam_msi_contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.ipam_msi.principal_id
  description          = "Grant Contributor to IPAM Managed Identity"

  depends_on = [azurerm_user_assigned_identity.ipam_msi]
}

resource "azurerm_role_assignment" "ipam_msi_managed_identity_operator" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.ipam_msi.principal_id
  description          = "Grant Managed Identity operator to IPAM Managed Identity"

  depends_on = [azurerm_user_assigned_identity.ipam_msi]
}
