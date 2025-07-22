# defining variable for az subscription id 
variable "ashu_az_id" {
    description = "this is azure subscription id"
    default = "ee075321-f9dd-42f2-a56a-2f0a5141d191" # value of variable 
    type = string # data type of variable 
  
}

# variable for name of resource group 
variable "ashu_rsg" {
    type = string
    default = "ashu_day2_rsg"
  
}

variable "ashu_rsg_location" {
    type = string
    default = "eastus"
  
}

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
  subscription_id = var.ashu_az_id
}


# creating resource group 
resource "azurerm_resource_group" "example" {
    name = var.ashu_rsg
    location = var.ashu_rsg_location
     
}