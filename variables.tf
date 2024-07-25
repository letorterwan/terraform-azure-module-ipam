# Tenant and subscription ID
variable "tenant_id" {
  type        = string
  description = "ID of the tenant"
}

variable "subscription_id" {
  type        = string
  description = "ID of the subscription"
}

# Azure region where resources are deployed
variable "location" {
  type        = string
  description = "Name of the Azure region where the resources will be deployed"
  default     = "eu-west"
}

# Scopes where Reader access will be granted to the IPAM Engine
variable "ipam_scopes" {
  type        = list(string)
  description = "List of scopes (management groups / subscriptions / resource groups / resources ) where Reader access will be granted to the IPAM Engine."
  default     = [""]
}

# Names for each déployed resource
variable "rg_name" {
  type        = string
  description = "Name of the resource group that will contain IPAM resources"
  default     = "rg-ipam"
}

variable "ui_app_name" {
  type        = string
  description = "Name of the UI Application (App Registration)"
  default     = "app-ipam-ui"
}

variable "engine_app_name" {
  type        = string
  description = "Name of the Engine Application (App Registration)"
  default     = "app-ipam-engine"
}

variable "kv_name" {
  type        = string
  description = "Name of the Key Vault. Must be unique worlwide, hence defining it is mandatory here"
}

variable "msi_name" {
  type        = string
  description = "Name of the Managed Identity for the app to access other Azure resources"
  default     = "msi-ipam"
}

variable "cosmosdb_account_name" {
  type        = string
  description = "Name of the Cosmos DB"
  default     = "cosmosdb-ipam"
}

variable "cosmosdb_sql_db_name" {
  type        = string
  description = "Name of the Cosmos SQL Database"
  default     = "cosmosdb-ipam-sql-db"
}

variable "cosmosdb_sql_container_name" {
  type        = string
  description = "Name of the Cosmos SQL Container"
  default     = "cosmosdb-ipam-sql-container"
}

variable "storage_name" {
  type        = string
  description = "Name of the Storage Account.Must be unique worlwide, hence defining it is mandatory here"
}

variable "app_service_plan_name" {
  type        = string
  description = "Name of the App Service Plan"
  default     = "appsvc-ipam"
}

variable "app_service_name" {
  type        = string
  description = "Name of the App Service"
  default     = "app-ipam"
}

# Tags (same for all resources)
variable "tags" {
  type        = map(string)
  description = "Tags applied to the IPAM resources"
}

# Technical
variable "engine_app_secret_end_date" {
  type        = string
  description = "Expiration date of the Engine Azure AD App secret"
  default     = ""
}

# If logging is enabled, send logs to LAW
variable "logging_enabled" {
  type        = bool
  description = "Define if Azure resource logs are sent to a log analytics workspace"
  default     = true
}
variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of the Log Analytics Workspace where resource logs are sent"
}
