# Create a storage account for Nginx configuration
resource "azurerm_storage_account" "ipam_storage" {
  name                = lower(var.storage_name)
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  account_tier             = "Standard"
  access_tier              = "Hot"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"

  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false

  tags = coalesce(var.tags, local.tags)

}
