# variable section 
variable "az_subs" {

  type        = string
  default     = "ee075321-f9dd-42f2-a56a-2f0a5141d191"
  description = "this is my azure account subs id"
}

variable "az_storage_account" {
  type    = string
  default = "ashutoshhstacc"

}

variable "staccount_tier" {
  type    = string
  default = "Standard"

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
data "azurerm_resource_group" "example" {
  name = "bluecross-group"
}

# output section
output "storage_account_url" {
    value = azurerm_storage_account.example.primary_blob_endpoint
  
}

output "storage_account_web_url" {
  value = azurerm_storage_account.example.primary_web_endpoint
  
}

# storage account section
resource "azurerm_storage_account" "example" {
  name                     = var.az_storage_account
  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  account_tier             = var.staccount_tier
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

}

# enable static web  hosting 
# creating static webhosting 
resource "azurerm_storage_account_static_website" "example" {
  storage_account_id = azurerm_storage_account.example.id
  index_document     = "index.html"
  error_404_document = "404.html"
}

# creating blob storage 
resource "azurerm_storage_blob" "example" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = "$web"
  type                   = "Block"
  source_content = file("mypages/index.html")
  content_type = "text/html"
}