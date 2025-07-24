variable "resource_group_name" {
    type = string
    description = "name of resource group"
  
}

variable "location" {
    type = string
    description = "location of azure dc"
  
}

variable "vnet_name" {
    type = string
    description = "name of virtual network"
    default = "ashu-vnet"
  
}

variable "vnet_address_space" {
    type = list(string)
    default = [ "172.16.0.0/16" ] # 172.17-31
  
}

variable "subnet_name" {
    type = string
    default = "ashu-subnet"
  
}

variable "subnet_address_prefix" {
    type = string
    default = "172.16.1.0/24"
  
}

variable "nsg_name" {
    type = string
    default = "ashu-nsg"
}
