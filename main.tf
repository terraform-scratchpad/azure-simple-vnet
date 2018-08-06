provider "azurerm" {
  version = "1.12.0"
}

provider "random" {
  version = "1.3.0"
}

# generate random username and password
resource "random_string" "vm-username" {
  length = 10
  special = false
}

# create the VNet
resource "azurerm_virtual_network" "network" {
  name                = "network-${random_string.vm-username.id}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  address_space       = ["${var.network_address_space}"]
  tags                = "${var.tags}"
}

# create NSG
resource "azurerm_network_security_group" "nsg" {
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  name                          = "tf-nsg-${random_string.vm-username.id}"

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

  tags                          = "${var.tags}"
}

# create subnets
resource "azurerm_subnet" "vms-subnet" {
  name                  = "vms-subnet-${random_string.vm-username.id}"
  resource_group_name   = "${var.resource_group_name}"
  address_prefix        = "${var.subnet_address_prefix}"
  virtual_network_name  = "${azurerm_virtual_network.network.name}"
  tags                  = "${var.tags}"
}

