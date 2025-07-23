terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.37.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {} # loading default features set by Az
  subscription_id = var.az_subs
}

variable "az_subs" {

  type        = string
  default     = "ee075321-f9dd-42f2-a56a-2f0a5141d191"
  description = "this is my azure account subs id"
}


# creating resource group in azure cloud 
resource "azurerm_resource_group" "ashu-group" {
    name = "ashu-group-multi"
  
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

resource "azurerm_network_security_group" "example" {
  name                = "ashunsgallowssh"
  location            = azurerm_resource_group.ashu-group.location
  resource_group_name = azurerm_resource_group.ashu-group.name

  security_rule {
    name                       = "ashutest123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

 
}

# assocaite nsg with azsubnet 
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.ashu-subnet.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# creating public ip 
resource "azurerm_public_ip" "example" {
    name = "ashu-publicip1"
    location = azurerm_resource_group.ashu-group.location
    resource_group_name = azurerm_resource_group.ashu-group.name
    allocation_method = "Static"
    sku = "Standard"
  
}
resource "azurerm_network_interface" "main" {
 
  name                = "ashu-nic"
  location            = azurerm_resource_group.ashu-group.location
  resource_group_name = azurerm_resource_group.ashu-group.name

  ip_configuration {
    name                          = "testconfiguration"
    subnet_id                     = azurerm_subnet.ashu-subnet.id
    private_ip_address_allocation = "Dynamic" # private IP with NIC
    public_ip_address_id = azurerm_public_ip.example.id
   
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
    azurerm_network_interface.main.id
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

  provisioner "file" {
    source = "hello.sh"
    destination = "/home/adminuser/hello.sh"

    connection {
       type = "ssh"
       user = "adminuser"
       password = "Redhat@12345"
       host = azurerm_public_ip.example.ip_address # we need public IP 
     }
  }
  provisioner "remote-exec" {
    inline = [ 
        "sudo apt-get update -y",
        "sudo apt-get install vim apache2 -y",
        "echo hello world",
        "sudo chmod +x /home/adminuser/hello.sh",
        "/home/adminuser/hello.sh"
     ]
     connection {
       type = "ssh"
       user = "adminuser"
       password = "Redhat@12345"
       host = azurerm_public_ip.example.ip_address # we need public IP 
       timeout = "5m"
     }
    
  }
  
}

