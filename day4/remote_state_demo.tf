terraform {
  # defining the backend to store the state file remotely 
  backend "azurerm" {
    resource_group_name  = "bluecross-group"
    storage_account_name = "ashuazurestorage"
    container_name       = "ashutoshhcontainer"
    key                  = "ashutoshh.tfstate" # name of tfstate file 
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.37.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = var.az_subscription_id

}

# variable 
variable "az_subscription_id" {
  type        = string
  description = "this is my azure account subscriptio"
  default     = "ee075321-f9dd-42f2-a56a-2f0a5141d191"
  sensitive   = true
}
# resource group name 
variable "group_name" {
  type    = string
  default = "bluecross-group"

}

# storage account info 
variable "storage_account_name" {
  type    = string
  default = "ashuazurestorage"

}

# container name 
variable "container_name" {
  type    = string
  default = "ashutoshhcontainer"
}
