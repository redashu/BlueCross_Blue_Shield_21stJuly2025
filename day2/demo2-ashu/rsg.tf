# creating resource group in azure cloud 
resource "azurerm_resource_group" "ashu-group" {
    name = var.resg_name
  
    location = var.resg_location
  
}

# using data source to use existing resource group 



# data "azurerm_resource_group" "ashu-group" {
#     name = "hello-terraform"
  
  
# }