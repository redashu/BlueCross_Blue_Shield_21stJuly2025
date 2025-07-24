resource "null_resource" "example" {

  provisioner "local-exec" {
    command = "echo 'Hello guys please perform labs if possible' >hello.txt"

  }

}

# using network module to create vm 
module "network" {
  source = "./network"
  resource_group_name = var.group_name
  location = "eastus"
  
}
# creating vm 
resource "azurerm_linux_virtual_machine" "example" {
  name                = "ashu-example-machine"
  resource_group_name = var.group_name
  location            = "eastus"
  size                = "Standard_F2"
  
  network_interface_ids = [module.network.network_interface_Id]

  admin_username = "azureuser"
  admin_password = "P@ssw0rd1234!"  # replace with a secure method
  disable_password_authentication = false

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
