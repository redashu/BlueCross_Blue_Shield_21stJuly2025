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

# creating resource group in azure cloud 
resource "azurerm_resource_group" "ashu-group" {
    name = "ashu-group-tf"
  
    location = "eastus"
  
}

# creating azure virtual network in azure cloud
resource "azurerm_virtual_network" "ashu-example" {
  name = "ashu-network"
  address_space = ["172.16.0.0/16"] 
  location = azurerm_resource_group.ashu-group.location 
  resource_group_name = azurerm_resource_group.ashu-group.name 
  depends_on = [azurerm_resource_group.ashu-group]  # optional but important
}

