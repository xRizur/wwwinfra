resource "azurerm_resource_group" "acr_rg" {
  name     = "www-ACR"
  location = "West Europe"
}

resource "azurerm_container_registry" "acr" {
  name                = "containerRegistry1"
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  sku                 = "Premium"
  admin_enabled       = false
}