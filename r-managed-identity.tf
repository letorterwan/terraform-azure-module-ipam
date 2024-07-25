resource "azurerm_user_assigned_identity" "ipam_msi" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = var.msi_name
}
