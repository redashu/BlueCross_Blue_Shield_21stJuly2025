# variable section 
variable "az_subs" {
  
  type = string
  default = "ee075321-f9dd-42f2-a56a-2f0a5141d191"
  description = "this is my azure account subs id"
}




# provider section
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
  subscription_id = var.az_subs
}

# data source section
data "azurerm_resource_group" "name" {
  name = "bluecross-group"
}