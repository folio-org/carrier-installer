provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "Carrier-resources"
  location = "SELECTLOCATION"
}

resource "azurerm_virtual_network" "main" {
  name                = "Carrier-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_public_ip" "pub" {
    name                         = "Carrier-PublicIP"
    location                     = azurerm_resource_group.main.location
    resource_group_name          = azurerm_resource_group.main.name
    allocation_method            = "Dynamic"

}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "main" {
  name                = "Carrier-NIC"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pub.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "Carrier"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "VMSELECT"
  admin_username                  = "Carrier"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username = "Carrier"
    public_key = file("/installer/azure_install/id_rsa.pub")
  }

  source_image_reference {
    OSSELECTP
    OSSELECTO
    OSSELECTS
    OSSELECTV
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
