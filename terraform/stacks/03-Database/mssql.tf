data "azurerm_key_vault" "example" {
  name                = "KubeProdkv"
  resource_group_name = "secrets_rg"
}

provider "azurerm" {
  features {}
}

provider "mysql" {
  endpoint = "${azurerm_mysql_server.example.fqdn}:3306"
  username = azurerm_mysql_server.example.administrator_login
  password = azurerm_mysql_server.example.administrator_login_password
}

resource "random_string" "admin_username" {
  length  = 10
  special = false
  upper   = true
  lower   = true
  number  = true
}

resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_string" "db_username" {
  length  = 10
  special = false
  upper   = true
  lower   = true
  number  = true
}

resource "random_password" "db_username_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_resource_group" "example" {
  name     = "database_rg"
  location = var.location
}

resource "azurerm_mysql_flexible_server" "example" {
  name                   = "kube-prod-mysql"
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  administrator_login    = random_string.admin_username.result
  administrator_password = random_password.admin_password.result
  sku_name               = "B_Standard_B1ms" 
}

resource "azurerm_mysql_flexible_database" "example" {
  name                = "exampledb"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_flexible_server.example.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "example" {
  name                = "allowip"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_flexible_server.example.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# resource "mysql_database" "example" {
#   name = "my_database"
# }

# resource "mysql_user" "example" {
#   user     =  random_string.db_username.result
#   host     = "%"
#   password = random_password.db_username_password.result
# }

# resource "mysql_grant" "example" {
#   user       = mysql_user.example.user
#   host       = mysql_user.example.host
#   database   = mysql_database.example.name
#   privileges = ["SELECT", "INSERT", "UPDATE"]
# }

resource "azurerm_key_vault_secret" "admin_username_secret" {
  name         = "admin-username"
  value        = random_string.admin_username.result
  key_vault_id = data.azurerm_key_vault.example.id
}

resource "azurerm_key_vault_secret" "admin_password_secret" {
  name         = "admin-password"
  value        = random_password.admin_password.result
  key_vault_id = data.azurerm_key_vault.example.id
}
