variable "location" {
  description = "geographical location"
}

variable "resource_group_name" {
  description = "main resource group"
}

variable subnet_address_prefix {
  description = "subnet address prefix ex: 10.0.0.0/29"
}

variable network_address_space {
  description = "virtual network address space : 10.0.0.0/16"
}

variable "tags" {
  type = "map"
  description = "tags"
}