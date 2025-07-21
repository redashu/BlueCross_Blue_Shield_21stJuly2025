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

