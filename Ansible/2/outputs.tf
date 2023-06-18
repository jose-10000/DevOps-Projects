#####################################
# Azure Database for MySQL - Output #
#####################################

output "azurerm_mysql_flexible_server" {
  value = azurerm_mysql_flexible_server.default.name
}

output "admin_login" {
  value = azurerm_mysql_flexible_server.default.administrator_login
}

output "admin_password" {
  sensitive = true
  value     = azurerm_mysql_flexible_server.default.administrator_password
}

output "mysql_flexible_server_database_name" {
  value = azurerm_mysql_flexible_database.main.name
}



#####################################
#       Azure instance - Output     #
#####################################

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

