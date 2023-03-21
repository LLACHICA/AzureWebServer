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
       storage_account_type = "Standard_LRS"
   }

   tags = {
       owner = var.owner
       title = var.project
   }

}
