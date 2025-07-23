terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "ee075321-f9dd-42f2-a56a-2f0a5141d191"
}

variable "vm_count" {
  type    = number
  default = 2
}

variable "location" {
  type    = string
  default = "eastus"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-vm-count"
  location = var.location
}

# Single VNet & Subnet
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${azurerm_resource_group.rg.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create NSG with rule allowing TCP ports 10–1000
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${azurerm_resource_group.rg.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow_tcp_10_1000"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["10-1000"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Allow inbound TCP ports 10–1000"
  }
}

# Associate the NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


# Create public IP for each VM
resource "azurerm_public_ip" "pip" {
  count               = var.vm_count
  name                = "pip-vm-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
} # Defines dynamic Public IPs for each VM :contentReference[oaicite:5]{index=5}

# Create NICs and attach public IPs
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "nic-vm-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipcfg-${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
} # Associates NICs with public IPs :contentReference[oaicite:6]{index=6}

# Create VMs
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "demo-vm-${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"

  admin_username = "azureuser"
  admin_password = "P@ssw0rd1234!"  # replace with a secure method
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
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
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y vim apache2"
    ]

    connection {
      type        = "ssh"
      host        = azurerm_public_ip.pip[count.index].ip_address
      user        = "azureuser"
      password    = "P@ssw0rd1234!"
      timeout     = "5m"
    }
  }
}

# Outputs
output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The Azure Virtual Network ID"
}

output "vm_names" {
  value       = [for vm in azurerm_linux_virtual_machine.vm : vm.name]
  description = "Names of all created VMs"
}

output "public_ips" {
  value = [for pip in azurerm_public_ip.pip : pip.ip_address]
  description = "Public IP addresses for each VM"
}