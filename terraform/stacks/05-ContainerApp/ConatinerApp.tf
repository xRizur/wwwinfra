provider "azurerm" {
  features {
  }
}
resource "azurerm_resource_group" "acr_rg" {
  name     = "www-ACR"
  location = "West Europe"
}
