# Use data resources to get the UUIDs to address them by name
data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
}

# Create the IPAM UI App
resource "azuread_application" "ipam_ui" {
  display_name     = var.ui_app_name
  sign_in_audience = "AzureADMyOrg"

  # Allow the App to access Azure Entra ID resources
  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["openid"]
      type = "Scope"
    }

    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["profile"]
      type = "Scope"
    }

    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["offline_access"]
      type = "Scope"
    }

    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.Read"]
      type = "Scope"
    }

    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["Directory.Read.All"]
      type = "Scope"
    }
  }

  # This is mandatory because another resource access is defined in a dedicated resource
  lifecycle {
    ignore_changes = [
      required_resource_access,
    ]
  }

  single_page_application {
    redirect_uris = ["https://${var.app_service_name}.azurewebsites.net/"]
  }

  web {
    implicit_grant {
      access_token_issuance_enabled = true
      id_token_issuance_enabled     = true
    }
  }
}

# Add the service principal that goes with the UI App
resource "azuread_service_principal" "ipam_ui_sp" {
  client_id                    = azuread_application.ipam_ui.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]

  depends_on = [azuread_application.ipam_ui]
}

# Allow the UI App to access Engine App
resource "azuread_application_api_access" "ipam_ui_access_engine" {
  application_id = azuread_application.ipam_ui.id
  api_client_id  = azuread_application.ipam_engine.client_id

  scope_ids = [
    random_uuid.engine_app_uuid.result
  ]

  depends_on = [azuread_application.ipam_ui, azuread_application.ipam_engine]
}

# Enable Admin consent for the required resource access
resource "null_resource" "aad_admin_consent_ui_app" {
  triggers = merge(
    [for app in azuread_application.ipam_ui.required_resource_access :
      { for role in app.resource_access :
        join("_", [app.resource_app_id, role.id]) => role.type
      }
    ]...
  )

  provisioner "local-exec" {
    command = "sleep 30 && az ad app permission admin-consent --id ${azuread_service_principal.ipam_ui_sp.client_id}"
  }
}
