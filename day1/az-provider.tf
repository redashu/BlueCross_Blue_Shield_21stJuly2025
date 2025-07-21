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

# creating subnet 
resource "azurerm_subnet" "ashu-subnet" {
  name = "ashu-subnet"
  resource_group_name = azurerm_resource_group.ashu-group.name 
  virtual_network_name = azurerm_virtual_network.ashu-example.name 
  address_prefixes = ["172.16.1.0/24"] 
  depends_on = [azurerm_virtual_network.ashu-example]
}

# creating azure network interface with private ip access

resource "azurerm_network_interface" "main" {
  name                = "ashu-nic"
  location            = azurerm_resource_group.ashu-group.location
  resource_group_name = azurerm_resource_group.ashu-group.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.ashu-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "ashu-example-machine"
  resource_group_name = azurerm_resource_group.ashu-group.name
  location            = azurerm_resource_group.ashu-group.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "Redhat@12345"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}