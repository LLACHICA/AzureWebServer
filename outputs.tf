output "resource_group_name" {
  value = azurerm_resource_group.webserver.name

}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.nginx.public_ip_address
}

output "mysql_database_hostname" {
  value = azurerm_mariadb_server.mysqlDBserver.fqdn
}
#output "tls_private_key" {
# value     = tls_private_key.example_ssh.private_key_pem
# sensitive = true
#}