# Create virtual network
resource "azurerm_virtual_network" "webserver_vnet" {
name = "nginx_vnet"
location = var.location
resource_group_name = azurerm_resource_group.webserver.name
address_space = ["10.0.0.0/16"]
}

# Create subnet VM
resource "azurerm_subnet" "webserver_subnet1" {
  name                 = "SubnetInt1"
  resource_group_name = azurerm_resource_group.webserver.name
  virtual_network_name = azurerm_virtual_network.webserver_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create subnet DB
resource "azurerm_subnet" "webserver_subnet2" {
  name                 = "SubnetInt2"
  resource_group_name = azurerm_resource_group.webserver.name
  virtual_network_name = azurerm_virtual_network.webserver_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_mariadb_virtual_network_rule" "maria-vnetrule" {
  name                = "mariadb-vnet-rule"
  resource_group_name = azurerm_resource_group.webserver.name
  server_name         = azurerm_mariadb_server.mysqlDBserver.name
  subnet_id           = azurerm_subnet.webserver_subnet2.id
}

resource "azurerm_private_dns_zone" "webserverDNS" {
  name                = "webserver.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.webserver.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "webserverzone" {
  name                  = "WebVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.webserverDNS.name
  virtual_network_id    = azurerm_virtual_network.webserver_vnet.id
  resource_group_name   = azurerm_resource_group.webserver.name
}

# Create public IPs
resource "azurerm_public_ip" "webserver_public_ip" {
  name                = "PublicIP"
  location = var.location
  resource_group_name = azurerm_resource_group.webserver.name
  allocation_method   = "Dynamic"
  domain_name_label = "hamza-gym"

  tags = {
    title = var.project
    owner = var.owner
  }

}

# Create network interface
resource "azurerm_network_interface" "webserver_NIC" {
  name                = "webserver-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.webserver.name

  ip_configuration {
    name                       = "internal"
    subnet_id                  = azurerm_subnet.webserver_subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.webserver_public_ip.id
  }

  tags = {
    title = var.project
    owner = var.owner
  }
  depends_on = [azurerm_virtual_network.webserver_vnet]
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
