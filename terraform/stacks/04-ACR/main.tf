provider "azurerm" {
  features {
  }
}
data "azurerm_key_vault" "KubeProdkv" {
  name                = "KubeProdkv"
  resource_group_name = "secrets_rg"
}
resource "azurerm_resource_group" "acr_rg" {
  name     = "www-ACR"
  location = "West Europe"
}

resource "azurerm_container_registry" "acr" {
  name                = "technikiwwwACR"
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  sku                 = "Standard"
  admin_enabled       = false
}
resource "azurerm_container_registry_scope_map" "example" {
  name                    = "example-scope-map"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = azurerm_resource_group.acr_rg.name
  actions = [
    "repositories/my_vue_app/content/read",
    "repositories/my_vue_app/content/write"
  ]
}

resource "azurerm_container_registry_token" "example" {
  name                    = "exampletoken"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = azurerm_resource_group.acr_rg.name
  scope_map_id            = azurerm_container_registry_scope_map.example.id
}

resource "azurerm_container_registry_token_password" "example" {
  container_registry_token_id = azurerm_container_registry_token.example.id

  password1 {
    expiry = "2023-12-22T17:57:36+08:00"
  }
}

resource "azurerm_key_vault_secret" "ACRuser" {
  name         = "ACRuser"
  value        = azurerm_container_registry_token.example.name
  key_vault_id = data.azurerm_key_vault.KubeProdkv.id
}

resource "azurerm_key_vault_secret" "acrpassword" {
  name         = "acrpassword"
  value        = azurerm_container_registry_token_password.example.password1[0].value
  key_vault_id = data.azurerm_key_vault.KubeProdkv.id
  
}