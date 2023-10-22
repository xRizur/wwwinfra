terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
    mysql = {
      source = "terraform-providers/mysql"
      version = "1.9.0" # Przykładowa wersja,

    }
  }
  backend "azurerm" {
  resource_group_name = "tf-backend"
  storage_account_name = "tfbackendsremote"
  container_name = "db-state"
  key = "database.tfstate"
  }
}