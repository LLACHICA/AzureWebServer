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

resource "azurerm_mysql_server" "mysqlDBserver" {
  name                = "webserver-mysqlserver"
  location            = azurerm_resource_group.webserver.location
  resource_group_name = azurerm_resource_group.webserver.name

  administrator_login          = var.mysql_administrator_login
  administrator_login_password = var.mysql_administrator_login_password

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false
  minimal_tls_version               = "TLS1_2"
  
}

resource "azurerm_mysql_database" "mysqlDB" {
  name                = "webserver-mysqldb"
  resource_group_name = azurerm_resource_group.webserver.name
  server_name         = azurerm_mysql_server.mysqlDBserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

}

resource "azurerm_mysql_firewall_rule" "mysqlFW" {
  name                = "AllowMyIP"
  resource_group_name = azurerm_resource_group.webserver.name
  server_name         = azurerm_mysql_server.mysqlDBserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mysql_configuration" "members_table_config" {
  name                = "members_table_config"
  resource_group_name = azurerm_resource_group.webserver.name
  server_name         = azurerm_mysql_server.mysqlDBserver.name
  value               = "sql_mode=NO_ENGINE_SUBSTITUTION"
}

resource "null_resource" "create_members_table" {
  depends_on = [
    azurerm_mysql_database.mysqlDB,
    azurerm_mysql_configuration.members_table_config
  ]

  provisioner "local-exec" {
    command = "mysql -h ${azurerm_mysql_server.mysqlDBserver.fqdn} -u ${var.mysql_administrator_login} -p${var.mysql_administrator_login_password} -e 'CREATE TABLE gym_membership.members (id INT(11) NOT NULL AUTO_INCREMENT, first_name VARCHAR(50) NOT NULL, last_name VARCHAR(50) NOT NULL, email VARCHAR(100) NOT NULL, start_date DATE NOT NULL, duration VARCHAR(20) NOT NULL, payment_type VARCHAR(50) NOT NULL, medical_notes TEXT, PRIMARY KEY (id));'"
  }
}