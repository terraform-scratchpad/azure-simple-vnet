
#
# Outputs
#
output "core-network-id" {
  value = "${azurerm_virtual_network.network.id}"
}

output "core-subnet-id" {
  value = "${azurerm_subnet.vms-subnet.id}"
}

output "core-nsg-id" {
  value = "${azurerm_network_security_group.nsg.id}"
}