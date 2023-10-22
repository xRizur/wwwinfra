terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {
  resource_group_name = "tf-backend"
  storage_account_name = "tfbackendsremote"
  container_name = "network-state"
  key = "network.tfstate"
  }
}