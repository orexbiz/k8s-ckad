output "publicip" {
  value = data.azurerm_public_ip.pip-data.ip_address
}

output "privateip" {
  value = data.azurerm_network_interface.privateip-data.private_ip_address
}