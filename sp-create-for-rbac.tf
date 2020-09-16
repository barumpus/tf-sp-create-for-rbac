# the service principal must be linked to a valid application so we create one
resource "azuread_application" "sp" {
  name = var.sp_name
  # prevent_duplicate_names = true
}

# create service principal linked to the application
resource "azuread_service_principal" "sp" {
  application_id = azuread_application.sp.application_id
}

resource "random_password" "sp" {
  length = 32
  special = true
  override_special = "_%@-~"
}

# create application password; a service principal credential would not be good enough
resource "azuread_application_password" "sp" {
  application_object_id = azuread_application.sp.object_id
  value = random_password.sp.result 
  end_date_relative = "${var.sp_days*24}h"
}

# create role assignment
resource "azurerm_role_assignment" "sp" {
  scope = data.azurerm_subscription.main.id
  role_definition_name = "Contributor"
  principal_id = azuread_service_principal.sp.id
}
