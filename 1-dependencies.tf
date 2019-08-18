locals {
  virtual_machine_name = "${var.prefix}-vm"
}

data "azurerm_resource_group" "rg" {
  name     = "${var.rg}"
  location = "${var.location}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

data "azurerm_subnet" "subnet" {
  name                 = "${var.subnet}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
}


resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  #network_security_group_id = "${azurerm_network_security_group.nsg.id}"

  ip_configuration {
    name                          = "${var.name_prefix}ipconfig"
    subnet_id                     = "${data.azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "${var.ip_address}"
    public_ip_address_id          = ""
  }
}

resource "azurerm_storage_account" "sa" {
  name                = "${var.sa}"
  location            = "${var.location}"
  resource_group_name = "${var.rg_sa}"
}

resource "azurerm_storage_container" "container" {
  name                  = "${var.name_prefix}-vhds"
  resource_group_name   = "${var.rg_sa}"
  storage_account_name  = "${var.sa}"
  container_access_type = "private"
}

data "azurerm_key_vault" "vault" {
  name                        = "${var.kv}"
  resource_group_name         = "${var.rg_sakv}"
}    

data "azurerm_key_vault_secret" "secret" {
  name         = "${var.secret}"
  key_vault_id = "${data.azurerm_key_vault.vault.id}"
}  


/*
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name_prefix}nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "rulessh" {
  name                        = "${var.name_prefix}rulessh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nsg.name}"
}*/
