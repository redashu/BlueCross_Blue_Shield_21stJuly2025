# creating resource group in azure cloud 
resource "azurerm_resource_group" "ashu-group" {
    name = "ashu-group-common"
  
    location = "eastus"
  
}

  
# }


# creating azure virtual network in azure cloud
resource "azurerm_virtual_network" "ashu-example" {
  name = "ashu-network-common"
  address_space = ["172.16.0.0/16"] 
  location = azurerm_resource_group.ashu-group.location 
  resource_group_name = azurerm_resource_group.ashu-group.name 
  depends_on = [azurerm_resource_group.ashu-group]  # optional but important
}

# creating subnet 
resource "azurerm_subnet" "ashu-subnet" {
  name = "ashu-subnet-common"
  resource_group_name = azurerm_resource_group.ashu-group.name 
  virtual_network_name = azurerm_virtual_network.ashu-example.name 
  address_prefixes = ["172.16.1.0/24"] 
  depends_on = [azurerm_virtual_network.ashu-example]
}

