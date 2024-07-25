locals {
  # Some default tags if none is passed as variable
  tags = {
    "Environment" = "Common"
    "Project"     = "IPAM"
    "CostCenter"  = "Management"
  }

  # Static values used for App Registration creation
  # -> UPDATE TO DO : use data or other dynamic way to get those
  azure_public_id            = "797f4846-ba00-4fd7-ba43-dac1f8f63013"
  user_impersonation_role_id = "41094075-9dad-400e-a0bd-54e686782033"

  # Default scope value for IPAM Engine Reader access
  default_ipam_scope = ["/subscriptions/${var.subscription_id}"]
}
