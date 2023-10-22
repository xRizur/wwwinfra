provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "network_rg" {
  name     = "network_rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "main-vnet"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "main-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.KeyVault"]
}
