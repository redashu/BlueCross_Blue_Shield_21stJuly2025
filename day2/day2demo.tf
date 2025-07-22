
# Provider configuration about azure cloud 

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.37.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {} # loading default features set by Az
  subscription_id = "ee075321-f9dd-42f2-a56a-2f0a5141d191"
}

data "azurerm_resource_group" "ashu-group" {
    name = "hello-terraform"
  
  
}

# creating azure virtual network in azure cloud
resource "azurerm_virtual_network" "ashu-example" {
  name = "ashu-network"
  address_space = ["172.16.0.0/16"] 
  location = data.azurerm_resource_group.ashu-group.location 
  resource_group_name = data.azurerm_resource_group.ashu-group.name 
  depends_on = [data.azurerm_resource_group.ashu-group]  # optional but important
}

# creating subnet 
resource "azurerm_subnet" "ashu-subnet" {
  name = "ashu-subnet"
  resource_group_name = data.azurerm_resource_group.ashu-group.name 
  virtual_network_name = azurerm_virtual_network.ashu-example.name 
  address_prefixes = ["172.16.1.0/24"] 
  depends_on = [azurerm_virtual_network.ashu-example]
}

