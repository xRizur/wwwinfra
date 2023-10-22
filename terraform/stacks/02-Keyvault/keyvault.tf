provider "azurerm" {
  features {}
}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "secrets_rg"
  location = "West Europe"
}

resource "azurerm_key_vault" "example" {
  name                = "KubeProdkv"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id

  tags = {
    environment = "production"
  }
}


resource "azurerm_key_vault_access_policy" "example" {
  key_vault_id = azurerm_key_vault.example.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
  "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"
]


  secret_permissions = [
  "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
]


 certificate_permissions = [
  "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers"
]

}