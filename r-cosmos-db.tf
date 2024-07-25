resource "azurerm_cosmosdb_account" "ipam_cosmosdb_account" {
  name                = var.cosmosdb_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  default_identity_type     = "FirstPartyIdentity"
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  enable_automatic_failover = true

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  backup {
    type                = "Periodic"
    interval_in_minutes = 240
    retention_in_hours  = 8
    storage_redundancy  = "Local"
  }
}

resource "azurerm_cosmosdb_sql_database" "ipam_cosmosdb_sql_db" {
  name                = var.cosmosdb_sql_db_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.ipam_cosmosdb_account.name
  throughput          = 400 # Minimum value

  depends_on = [azurerm_cosmosdb_account.ipam_cosmosdb_account]
}

resource "azurerm_cosmosdb_sql_container" "ipam_cosmosdb_sql_container" {
  name                = var.cosmosdb_sql_container_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.ipam_cosmosdb_account.name
  database_name       = azurerm_cosmosdb_sql_database.ipam_cosmosdb_sql_db.name

  partition_key_path = "/tenant_id"
  throughput         = 1000

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    excluded_path {
      path = "/\"_etag\"/?"
    }
  }

  depends_on = [azurerm_cosmosdb_sql_database.ipam_cosmosdb_sql_db]

  lifecycle {
    # Terraform interprets the string as different than the one setted in CosmosDB. Quick fix to ignore continous drift.
    ignore_changes = [indexing_policy[0].excluded_path]
  }
}

# CosmosDB Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "ipam_cosmosdb_diagnostics" {
  count                          = var.logging_enabled == true ? 1 : 0 # Deploy only if var logging_enabled is true
  name                           = "cosmosdb-diagnostics"
  target_resource_id             = azurerm_cosmosdb_account.ipam_cosmosdb_account.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "DataPlaneRequests"
  }

  enabled_log {
    category = "QueryRuntimeStatistics"
  }

  enabled_log {
    category = "PartitionKeyStatistics"
  }

  enabled_log {
    category = "PartitionKeyRUConsumption"
  }

  enabled_log {
    category = "ControlPlaneRequests"
  }

  metric {
    category = "Requests"
  }

  depends_on = [azurerm_cosmosdb_account.ipam_cosmosdb_account]
}
