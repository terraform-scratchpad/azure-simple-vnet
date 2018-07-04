provider "azurerm" {
  version = ">=1.8.0"
}

#
# Create resource group de be deleted later on
#
resource "azurerm_resource_group" "tf-resource-group" {
  name      = "${var.resource_group_name}"
  location  = "${var.location}"
}

# create the VNet
resource "azurerm_virtual_network" "network" {
  name                = "network-${count.index}"
  location            = "${azurerm_resource_group.tf-resource-group.location}"
  address_space       = ["${var.network_address_space}"]
  resource_group_name = "${azurerm_resource_group.tf-resource-group.name}"
}

# create NSG
resource "azurerm_network_security_group" "nsg" {
  resource_group_name           = "${azurerm_resource_group.tf-resource-group.name}"
  location                      = "${azurerm_resource_group.tf-resource-group.location}"
  name                          = "tf-nsg-${count.index}"

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "https"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "mysql"
    priority                   = 103
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "elasticsearch"
    priority                   = 104
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9200"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# create subnets
resource "azurerm_subnet" "vms-subnet" {
  name = "vms-subnet-${count.index}"
  resource_group_name = "${azurerm_resource_group.tf-resource-group.name}"
  address_prefix = "${var.subnet_address_prefix}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
}

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
