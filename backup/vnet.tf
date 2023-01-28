module "network" {
   source = "Azure/vnet/azurerm"
   version = "3.1.0"
   resource_group_name = azurerm_resource_group.webserver.name
   address_space = ["10.0.0.0/16"]
   subnet_prefixes = ["10.0.1.0/24", "10.0.2.0/24"]
   subnet_names = ["subnet1", "subnet2"]
   vnet_location       = "Canada Central"
   vnet_name            ="nginx_vnet"

   nsg_ids = {
       subnet1 = azurerm_network_security_group.allowedports.id
   }

   tags = {
       title = var.project
       owner = var.owner
   }

   depends_on = [azurerm_resource_group.webserver]
}

resource "azurerm_public_ip" "webserver_public_ip" {
   name = "webserver_public_ip"
   location = var.location
   resource_group_name = azurerm_resource_group.webserver.name
   allocation_method = "Dynamic"

   tags = {
       title = var.project
       owner = var.owner
   }

   depends_on = [azurerm_resource_group.webserver]
}

resource "azurerm_network_interface" "webserver" {
   name = "nginx-interface"
   location = azurerm_resource_group.webserver.location
   resource_group_name = azurerm_resource_group.webserver.name

   ip_configuration {
       name = "internal"
       private_ip_address_allocation = "Dynamic"
       subnet_id = module.network.vnet_subnets[0]
       public_ip_address_id = azurerm_public_ip.webserver_public_ip.id
   }

   depends_on = [azurerm_resource_group.webserver]
}