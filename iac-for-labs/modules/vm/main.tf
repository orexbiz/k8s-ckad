terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.28.0"
    }
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_gr
  location            = var.location
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-nic"
  resource_group_name = var.resource_gr
  location            = var.location

  ip_configuration {
    name                          = "${var.name}-internal"
    subnet_id                     = var.sub_net
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = var.name
  resource_group_name             = var.resource_gr
  location                        = var.location
  size                            = "Standard_D2s_v3"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

data "azurerm_public_ip" "pip-data" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = var.resource_gr
}

data "azurerm_network_interface" "privateip-data" {
  name = azurerm_network_interface.nic.name
  resource_group_name = var.resource_gr
}