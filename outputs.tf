output "display_name" {
  value = azuread_service_principal.sp.display_name
}

output "client_id" {
  value = azuread_application.sp.application_id
}

output "client_secret" {
  value = azuread_application_password.sp.value
  sensitive = true
}

output "tenant_id" {
  value = data.azuread_client_config.main.tenant_id
}

output "subscription_id" {
  value = data.azurerm_subscription.main.subscription_id
}