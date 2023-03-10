provider "azurerm" {
  features {}
  }

resource "azurerm_resource_group" "webserver" {
   name = "Capstone_project"
   location = var.location
}


resource "azurerm_linux_virtual_machine" "nginx" {
   size = var.instance_size
   name = "nginx-webserver"
   resource_group_name = azurerm_resource_group.webserver.name
   location = azurerm_resource_group.webserver.location
   custom_data = base64encode(file("scripts/init.sh"))
   network_interface_ids = [
       azurerm_network_interface.webserver_NIC.id,
   ]

   source_image_reference {
       publisher = "Canonical"
       offer = "UbuntuServer"
       sku = "18.04-LTS"
       version = "latest"
   }

   computer_name = "websvr01"
   admin_username = "webadmin"
   admin_password = "Admin123!"
   disable_password_authentication = false

   os_disk {
       name = "websvr01_disk1"
       caching = "ReadWrite"
       #create_option = "FromImage"
       storage_account_type = "Standard_LRS"
   }

   tags = {
       owner = var.owner
       title = var.project
   }

   depends_on = [azurerm_resource_group.webserver]
   
}

resource "azurerm_mariadb_server" "mysqlDBserver" {
  name                          = "webserver-mysqlserver"
  location                      = azurerm_resource_group.webserver.location
  resource_group_name           = azurerm_resource_group.webserver.name

  administrator_login           = var.mysql_administrator_login
  administrator_login_password  = var.mysql_administrator_login_password

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "10.2"

  auto_grow_enabled                = true
  backup_retention_days            = 7
  geo_redundant_backup_enabled     = false
  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

}


resource "azurerm_mariadb_database" "mysqlDB" {
  name                = "webserver_mysqldb"
  resource_group_name = azurerm_resource_group.webserver.name
  server_name         = azurerm_mariadb_server.mysqlDBserver.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_520_ci"
}

resource "azurerm_mariadb_firewall_rule" "mysqlFW" {
  name                = "AllowMyIP"
  resource_group_name = azurerm_resource_group.webserver.name
  server_name         = azurerm_mariadb_server.mysqlDBserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mariadb_configuration" "dbconf" {
  name                = "MariaDb-conf"
  resource_group_name = azurerm_resource_group.webserver.name
  server_name         = azurerm_mariadb_server.mysqlDBserver.name
  value               = "600"
}

