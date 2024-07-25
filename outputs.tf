# Global outputs
output "subscription_id" {
  value       = data.azurerm_client_config.current.subscription_id
  description = "ID of the Shared Services Subscription"
}

# Resource Group outputs - IPAM  RG
output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Name of the Shared Services RG"
}

output "resource_group_core_id" {
  value       = azurerm_resource_group.rg.id
  description = "ID of the Shared Services RG"
}

# UI App outputs
output "ui_app_url" {
  value       = "https://${var.ui_app_name}.azurewebsites.net"
  description = "URL of the UI App"
}

output "ui_app_appid" {
  value       = azuread_application.ipam_ui.client_id
  description = "Application ID of the UI App"
}

# Engine App outputs
output "engine_app_url" {
  value       = "https://${var.engine_app_name}.azurewebsites.net"
  description = "URL of the Engine App"
}

output "engine_app_appid" {
  value       = azuread_application.ipam_engine.client_id
  description = "Application ID of the Engine App"
}

output "engine_app_secret" {
  value       = azuread_application_password.ipam_engine_secret.value
  description = "Secret of the Engine App"
}

# App Service Plan outputs
output "app_service_plan_id" {
  value       = azurerm_app_service_plan.ipam_appsvc_plan.id
  description = "ID of the App Service Plan"
}

output "app_service_plan_name" {
  value       = azurerm_app_service_plan.ipam_appsvc_plan.name
  description = "Name of the App Service Plan"
}

# App Service outputs
output "app_service_id" {
  value       = azurerm_app_service.ipam_app.id
  description = "ID of the App Service"
}

output "app_service_name" {
  value       = azurerm_app_service.ipam_app.name
  description = "Name of the App Service"
}

output "app_service_default_url" {
  value       = "https://${azurerm_app_service.ipam_app.name}.azurewebservices.net"
  description = "Name of the App Service"
}

# CosmosDB outputs
output "cosmosdb_account_id" {
  value       = azurerm_cosmosdb_account.ipam_cosmosdb_account.id
  description = "ID of the CosmosDB account"
}

output "cosmosdb_account_name" {
  value       = azurerm_cosmosdb_account.ipam_cosmosdb_account.name
  description = "Name of the CosmosDB account"
}

output "cosmosdb_sql_database_id" {
  value       = azurerm_cosmosdb_sql_database.ipam_cosmosdb_sql_db.id
  description = "ID of the CosmosDB SQL database"
}

output "cosmosdb_sql_database_name" {
  value       = azurerm_cosmosdb_sql_database.ipam_cosmosdb_sql_db.name
  description = "Name of the CosmosDB SQL database"
}

output "cosmosdb_sql_container_id" {
  value       = azurerm_cosmosdb_sql_container.ipam_cosmosdb_sql_container.id
  description = "ID of the CosmosDB SQL Container"
}

output "cosmosdb_sql_container_name" {
  value       = azurerm_cosmosdb_sql_container.ipam_cosmosdb_sql_container.name
  description = "Name of the CosmosDB SQL Container"
}

# Storage account outpits
output "storage_account_id" {
  value       = azurerm_storage_account.ipam_storage.id
  description = "ID of the storage account"
}

output "storage_account_name" {
  value       = azurerm_storage_account.ipam_storage.name
  description = "Name of the storage account"
}
