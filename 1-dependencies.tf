locals {
  virtual_machine_name = "${var.prefix}-vm"
}

data "azurerm_resource_group" "rg" {
  name     = "${var.rg}"
  #location = "${var.location}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet}"
  #location            = "${data.azurerm_resource_group.rg.location}"
  #resource_group_name = "${data.azurerm_resource_group.rg.name}"
  resource_group_name   = "${var.rg_vnet}"
}

data "azurerm_subnet" "subnet" {
  name                 = "${var.subnet}"
  #resource_group_name  = "${data.azurerm_resource_group.rg.name}"
  virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
  resource_group_name   = "${var.rg_vnet}"
}


resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  #network_security_group_id = "${azurerm_network_security_group.nsg.id}"

  ip_configuration {
    name                          = "${var.prefix}ipconfig"
    subnet_id                     = "${data.azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.ip_address}"
    public_ip_address_id          = ""
  }
}

data "azurerm_storage_account" "store" {
  name                = "${var.store}"
  resource_group_name = "${var.rg_sakv}"
  #account_type        = "${var.storage_account_type}"
}

resource "azurerm_storage_container" "container" {
  name                  = "${var.prefix}-vhds"
  resource_group_name   = "${var.rg_sakv}"
  storage_account_name  = "${var.store}"
  container_access_type = "private"
}

data "azurerm_key_vault" "vault" {
  name                        = "${var.vault}"
  resource_group_name         = "${var.rg_sakv}"
}    

data "azurerm_key_vault_secret" "secret" {
  name         = "${var.secret}"
  key_vault_id = "${data.azurerm_key_vault.vault.id}"
}  


/*
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "rulessh" {
  name                        = "${var.prefix}rulessh"
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
