
variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "desafio-jd-rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}


#################################################

# Variables for the Service Principal that will be used by Terraform to deploy the resources.
variable "SUBSCRIPTION_ID" {
  type        = string
  description = "Subscription ID where the resources will be deployed."
}

variable "CLIENT_ID" {
  type        = string
  description = "Client ID (aka App ID) of the Service Principal."
}

variable "CLIENT_SECRET" {
  type        = string
  description = "Client Secret (aka App Secret) of the Service Principal."
}

variable "TENANT_ID" {
  type        = string
  description = "Tenant ID of your Azure subscription."
}

#################################################

# Variables for subnet
variable "subnet_prefix" {
  type        = list
  default = [
    {
      ip = "10.0.1.0/24"
      name = "my-VM-Subnet"
    },
    {
      ip = "10.0.2.0/24"
      name = "mysql-subnet"
    }
  ]
}

#     Example of how to use the variable subnet_prefix
#resource "azurerm_subnet" "test_subnet" {
#    name = "${lookup(element(var.subnet_prefix, count.index), "name")}"
#    count = "${length(var.subnet_prefix)}"
#    resource_group_name = "${local.resource_group_name}"
#    virtual_network_name = "${azurerm_virtual_network.lab_vnet.name}"
#    address_prefix = "${lookup(element(var.subnet_prefix, count.index), "ip")}"
#}