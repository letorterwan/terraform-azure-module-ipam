# Resource group for core common items
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags     = coalesce(var.tags, local.tags)
}
