# AZ IPAM

Based on the public project available on [github](https://github.com/Azure/ipam).

Reading the [install documentation](https://azure.github.io/ipam/) can be helpfull to understand what will be deployed and how to use it.

This module only handles the Full version deployed on a WebApp, using the public container image hosted on docker.io registry.

## To Do List
- Add an option for private endpoint on the resources
- Use a private acr (needs an image build, therefore should not be included in the module but ensure that it is supported)

## Version details

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.5 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=2.45.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.75.0 |

## Requirements

The account used to execute this module must have :
- The Application Administrator role on the Azure Entra ID tenant.
- The ability to create all Azure resources and apply role assignment on the defined scopes (Owner may seem the easiest choice, at least as a temporary access).

## Usage

This module is designed to work with terraform "vanilla" and should be forked in order to work with specific tools like Terragrunt. Before using this module, make sure that your environment is connected to the right Entra ID tenant and Azure subscription.

With the default value for the "ipam_scopes" variable, permissions for the IPAM Engine will be granted on the current subscription.

```hcl
module "ipam" {
  source = "git@git.cloudtemple.tech:guilds/iac/terraform/azure/modules/azure-module-ipam.git?ref=xxx"

  tenant_id                   = var.tenant_id
  subscription_id             = var.subscription_id
  rg_name                     = "rg-ipam-frc-common"
  location                    = "fr-central"
  
  ui_app_name                 = "ipam-ui"
  engine_app_name             = "ipam-engine"
  engine_app_secret_end_date  = "2024-12-09T22:00:00Z"
  log_analytics_workspace_id  = var.log_analytics_workspace_id
  kv_name                     = "kv-ipam"
  storage_name                = "saipam"
  app_service_name            = "app-ipam"
  cosmosdb_account_name       = "cosmos-ipam"
  cosmosdb_sql_db_name        = "cosmosdb-ipam"
  cosmosdb_sql_container_name = "cosmoscontainer-ipam"
  msi_name                    = "msi-ipam"

  tags                       = {
    App         = "ipam"
    Environment = "common"
    CostCenter  = "shared"
    IAC         = "terraform"
  }
}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_name"></a> [app\_service\_name](#input\_app\_service\_name) | Name of the App Service | `string` | `"app-ipam"` | no |
| <a name="input_app_service_plan_name"></a> [app\_service\_plan\_name](#input\_app\_service\_plan\_name) | Name of the App Service Plan | `string` | `"appsvc-ipam"` | no |
| <a name="input_cosmosdb_account_name"></a> [cosmosdb\_account\_name](#input\_cosmosdb\_account\_name) | Name of the Cosmos DB | `string` | `"cosmosdb-ipam"` | no |
| <a name="input_cosmosdb_sql_container_name"></a> [cosmosdb\_sql\_container\_name](#input\_cosmosdb\_sql\_container\_name) | Name of the Cosmos SQL Container | `string` | `"cosmosdb-ipam-sql-container"` | no |
| <a name="input_cosmosdb_sql_db_name"></a> [cosmosdb\_sql\_db\_name](#input\_cosmosdb\_sql\_db\_name) | Name of the Cosmos SQL Database | `string` | `"cosmosdb-ipam-sql-db"` | no |
| <a name="input_engine_app_name"></a> [engine\_app\_name](#input\_engine\_app\_name) | Name of the Engine Application (App Registration) | `string` | `"app-ipam-engine"` | no |
| <a name="input_engine_app_secret_end_date"></a> [engine\_app\_secret\_end\_date](#input\_engine\_app\_secret\_end\_date) | Expiration date of the Engine Azure AD App secret | `string` | `""` | no |
| <a name="input_ipam_scopes"></a> [ipam\_scopes](#input\_ipam\_scopes) | List of scopes (management groups / subscriptions / resource groups / resources ) where Reader access will be granted to the IPAM Engine. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_kv_name"></a> [kv\_name](#input\_kv\_name) | Name of the Key Vault. Must be unique worlwide, hence defining it is mandatory here | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Name of the Azure region where the resources will be deployed | `string` | `"eu-west"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | ID of the Log Analytics Workspace where resource logs are sent | `string` | n/a | yes |
| <a name="input_logging_enabled"></a> [logging\_enabled](#input\_logging\_enabled) | Define if Azure resource logs are sent to a log analytics workspace | `bool` | `true` | no |
| <a name="input_msi_name"></a> [msi\_name](#input\_msi\_name) | Name of the Managed Identity for the app to access other Azure resources | `string` | `"msi-ipam"` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Name of the resource group that will contain IPAM resources | `string` | `"rg-ipam"` | no |
| <a name="input_storage_name"></a> [storage\_name](#input\_storage\_name) | Name of the Storage Account.Must be unique worlwide, hence defining it is mandatory here | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | ID of the subscription | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the IPAM resources | `map(string)` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | ID of the tenant | `string` | n/a | yes |
| <a name="input_ui_app_name"></a> [ui\_app\_name](#input\_ui\_app\_name) | Name of the UI Application (App Registration) | `string` | `"app-ipam-ui"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service_default_url"></a> [app\_service\_default\_url](#output\_app\_service\_default\_url) | Name of the App Service |
| <a name="output_app_service_id"></a> [app\_service\_id](#output\_app\_service\_id) | ID of the App Service |
| <a name="output_app_service_name"></a> [app\_service\_name](#output\_app\_service\_name) | Name of the App Service |
| <a name="output_app_service_plan_id"></a> [app\_service\_plan\_id](#output\_app\_service\_plan\_id) | ID of the App Service Plan |
| <a name="output_app_service_plan_name"></a> [app\_service\_plan\_name](#output\_app\_service\_plan\_name) | Name of the App Service Plan |
| <a name="output_cosmosdb_account_id"></a> [cosmosdb\_account\_id](#output\_cosmosdb\_account\_id) | ID of the CosmosDB account |
| <a name="output_cosmosdb_account_name"></a> [cosmosdb\_account\_name](#output\_cosmosdb\_account\_name) | Name of the CosmosDB account |
| <a name="output_cosmosdb_sql_container_id"></a> [cosmosdb\_sql\_container\_id](#output\_cosmosdb\_sql\_container\_id) | ID of the CosmosDB SQL Container |
| <a name="output_cosmosdb_sql_container_name"></a> [cosmosdb\_sql\_container\_name](#output\_cosmosdb\_sql\_container\_name) | Name of the CosmosDB SQL Container |
| <a name="output_cosmosdb_sql_database_id"></a> [cosmosdb\_sql\_database\_id](#output\_cosmosdb\_sql\_database\_id) | ID of the CosmosDB SQL database |
| <a name="output_cosmosdb_sql_database_name"></a> [cosmosdb\_sql\_database\_name](#output\_cosmosdb\_sql\_database\_name) | Name of the CosmosDB SQL database |
| <a name="output_engine_app_appid"></a> [engine\_app\_appid](#output\_engine\_app\_appid) | Application ID of the Engine App |
| <a name="output_engine_app_secret"></a> [engine\_app\_secret](#output\_engine\_app\_secret) | Secret of the Engine App |
| <a name="output_engine_app_url"></a> [engine\_app\_url](#output\_engine\_app\_url) | URL of the Engine App |
| <a name="output_resource_group_core_id"></a> [resource\_group\_core\_id](#output\_resource\_group\_core\_id) | ID of the Shared Services RG |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the Shared Services RG |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | ID of the storage account |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | Name of the storage account |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | ID of the Shared Services Subscription |
| <a name="output_ui_app_appid"></a> [ui\_app\_appid](#output\_ui\_app\_appid) | Application ID of the UI App |
| <a name="output_ui_app_url"></a> [ui\_app\_url](#output\_ui\_app\_url) | URL of the UI App |

## Resources

| Name | Type |
|------|------|
| [azuread_application.ipam_engine](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application.ipam_ui](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_api_access.ipam_ui_access_engine](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_api_access) | resource |
| [azuread_application_identifier_uri.ipam_engine_identifier_uri](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_identifier_uri) | resource |
| [azuread_application_password.ipam_engine_secret](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_application_pre_authorized.ipam_engine_pre_authorized_azcli](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_pre_authorized) | resource |
| [azuread_application_pre_authorized.ipam_engine_pre_authorized_powershell](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_pre_authorized) | resource |
| [azuread_service_principal.ipam_engine_sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal.ipam_ui_sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_app_service.ipam_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service) | resource |
| [azurerm_app_service_plan.ipam_appsvc_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan) | resource |
| [azurerm_cosmosdb_account.ipam_cosmosdb_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_sql_container.ipam_cosmosdb_sql_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_container) | resource |
| [azurerm_cosmosdb_sql_database.ipam_cosmosdb_sql_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_database) | resource |
| [azurerm_key_vault.ipam_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.ipam_kv_build_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.ipam_kv_policy_msi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.ipam_secret_cosmos_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ipam_secret_engine_app_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ipam_secret_engine_app_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ipam_secret_tenant_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ipam_secret_ui_app_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_monitor_diagnostic_setting.ipam_app_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.ipam_appsvc_plan_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.ipam_cosmosdb_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.ipam_kv_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.ipam_engine_app_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.ipam_msi_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.ipam_msi_managed_identity_operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.ipam_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_user_assigned_identity.ipam_msi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [null_resource.aad_admin_consent_engine_app](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.aad_admin_consent_ui_app](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_uuid.engine_app_uuid](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_published_app_ids) | data source |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azuread_service_principal.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |