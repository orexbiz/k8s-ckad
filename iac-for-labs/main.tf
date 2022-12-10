terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.28.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}


resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "West Europe"
}


resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subbnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

module "vm1" {
  source      = "./modules/vm"
  resource_gr = azurerm_resource_group.rg.name
  location    = azurerm_resource_group.rg.location
  name        = "control-plane-vm"
  sub_net     = azurerm_subnet.subbnet.id
  username    = var.username
  password    = var.password
}

module "vm2" {
  source      = "./modules/vm"
  resource_gr = azurerm_resource_group.rg.name
  location    = azurerm_resource_group.rg.location
  name        = "workernode-vm"
  sub_net     = azurerm_subnet.subbnet.id
  username    = var.username
  password    = var.password
}
