### Revision

![Revision Diagram](rev1.png)

### Resource Dependency Graph

![Resource Dependency Graph](rev2.png)

### Installing Azure CLI

```sh
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

After installation, verify your account:

```sh
az account show
```

Example output:
```json
{
   "environmentName": "AzureCloud",
   "homeTenantId": "da228470-00d6-408f-a48b-645b4818de82",
   "id": "ee075321-f9dd-42f2-a56a-2f0a5141d191",
   "isDefault": true,
   "managedByTenants": []
}
```

## Some Important Terraform Commands

```sh
terraform init -upgrade

terraform plan

terraform plan -target=azurerm_virtual_network.ashu-example

terraform plan -target=azurerm_virtual_network.ashu-example -out=ashuvnetplan

terraform apply ashuvnetplan

terraform destroy -target=azurerm_virtual_network.ashu-example
```

### terraform state command option 

```
thexyzcompany2022@cloudshell:~/ashu-tf-code (terraform-466505)$ terraform  state  list
data.azurerm_resource_group.ashu-group
azurerm_subnet.ashu-subnet
azurerm_virtual_network.ashu-example
thexyzcompany2022@cloudshell:~/ashu-tf-code (terraform-466505)$ terraform  state  show azurerm_virtual_network.ashu-example
# azurerm_virtual_network.ashu-example:
resource "azurerm_virtual_network" "ashu-example" {
    address_space                  = [
        "172.16.0.0/16",
    ]
    bgp_community                  = null
    dns_servers                    = []
    edge_zone                      = null
    flow_timeout_in_minutes        = 0
    guid                           = "615161e4-844e-4228-b162-acd92f2bccdd"
    id                             = "/subscriptions/ee075321-f9dd-42f2-a56a-2f0a5141d191/resourceGroups/hello-terraform/providers/Microsoft.Network/virtualNetworks/ashu-network"
    location                       = "eastus"
    name                           = "ashu-network"
    private_endpoint_vnet_policies = "Disabled"
    resource_group_name            = "hello-terraform"
    subnet                         = []
}

```

