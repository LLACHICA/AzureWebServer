provider "azurerm" {
  version = "=3.39.1"
  features {}
}

resource "azurerm_resource_group" "webserver" {
   name = "Capstone_project"
   location = var.location
}

resource "azurerm_network_security_group" "allowedports" {
   name = "allowedports"
   resource_group_name = azurerm_resource_group.webserver.name
   location = azurerm_resource_group.webserver.location
  
   security_rule {
       name = "http"
       priority = 100
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "80"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }

   security_rule {
       name = "https"
       priority = 200
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "443"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }

   security_rule {
       name = "ssh"
       priority = 300
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "22"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }
}

resource "azurerm_linux_virtual_machine" "nginx" {
   size = var.instance_size
   name = "nginx-webserver"
   resource_group_name = azurerm_resource_group.webserver.name
   location = azurerm_resource_group.webserver.location
   custom_data = base64encode(file("scripts/init.sh"))
   network_interface_ids = [
       azurerm_network_interface.webserver.id,
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

resource "azurerm_mysql_server" "mysqlserver" {
  name                = "mysqlserver"
  location            = azurerm_resource_group.webserver.location
  resource_group_name = azurerm_resource_group.webserver.name

  administrator_login          = "mysqladmin"
  administrator_login_password = "Admin123!"

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "mysqlDB" {
  name                = "mysqlDB"
  resource_group_name = azurerm_resource_group.webserver.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}