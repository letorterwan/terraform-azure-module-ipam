# Create the IPAM Engine App
# Create a UUID for the new oauth scope
resource "random_uuid" "engine_app_uuid" {}

# Create the App
resource "azuread_application" "ipam_engine" {
  display_name     = var.engine_app_name
  sign_in_audience = "AzureADMyOrg"

  # Mandatory as Identifier URI is defined after resource creation
  lifecycle {
    ignore_changes = [
      identifier_uris,
    ]
  }

  api {
    mapped_claims_enabled          = true
    requested_access_token_version = 2

    known_client_applications = [
      azuread_application.ipam_ui.client_id
    ]

    oauth2_permission_scope {
      admin_consent_description  = "Allows the IPAM UI to access IPAM Engine API as the signed-in user."
      admin_consent_display_name = "Access IPAM Engine API"
      id                         = random_uuid.engine_app_uuid.result
      type                       = "User"
      enabled                    = true
      user_consent_description   = "Allow the IPAM UI to access IPAM Engine API on your behalf."
      user_consent_display_name  = "Access IPAM Engine API"
      value                      = "access_as_user"
    }
  }

  required_resource_access {
    resource_app_id = local.azure_public_id # Azure Public

    resource_access {
      id   = local.user_impersonation_role_id # azure service management impersonation
      type = "Scope"
    }
  }
}

# Add pre authorized applications on the new app
resource "azuread_application_pre_authorized" "ipam_engine_pre_authorized_powershell" {
  application_id       = azuread_application.ipam_engine.id
  authorized_client_id = "1950a258-227b-4e31-a9cf-717495945fc2" # Azure Powershell

  permission_ids = [
    random_uuid.engine_app_uuid.result
  ]

  depends_on = [azuread_application.ipam_engine]
}

resource "azuread_application_pre_authorized" "ipam_engine_pre_authorized_azcli" {
  application_id       = azuread_application.ipam_engine.id
  authorized_client_id = "04b07795-8ddb-461a-bbee-02f9e1bf7b46" # Azure CLI

  permission_ids = [
    random_uuid.engine_app_uuid.result
  ]

  depends_on = [azuread_application.ipam_engine]
}

# Define the Identifier URI
resource "azuread_application_identifier_uri" "ipam_engine_identifier_uri" {
  application_id = azuread_application.ipam_engine.id
  identifier_uri = "api://${azuread_application.ipam_engine.client_id}"

  depends_on = [azuread_application.ipam_engine]
}

# Add the service principal that goes with the Engine App
resource "azuread_service_principal" "ipam_engine_sp" {
  client_id                    = azuread_application.ipam_engine.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]

  depends_on = [azuread_application.ipam_engine]
}

# Create secret for Engine App
resource "azuread_application_password" "ipam_engine_secret" {
  display_name   = "engine-secret"
  application_id = azuread_application.ipam_engine.id
  end_date       = var.engine_app_secret_end_date

  depends_on = [azuread_application.ipam_engine]
}


# Enable Admin consent for the required resource access
resource "null_resource" "aad_admin_consent_engine_app" {
  triggers = merge(
    [for app in azuread_application.ipam_engine.required_resource_access :
      { for role in app.resource_access :
        join("_", [app.resource_app_id, role.id]) => role.type
      }
    ]...
  )

  provisioner "local-exec" {
    command = "sleep 30 && az ad app permission admin-consent --id ${azuread_application.ipam_engine.client_id}"
  }

  depends_on = [azuread_application.ipam_engine]
}
