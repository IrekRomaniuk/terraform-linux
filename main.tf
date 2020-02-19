resource "azurerm_virtual_machine" "vm" {
  name                  = "${local.virtual_machine_name}"
  location              = "${data.azurerm_resource_group.rg.location}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "${var.vm_size}"

  # This means the OS Disk will be deleted when Terraform destroys the Virtual Machine
  # NOTE: This may not be optimal in all cases.
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  dynamic plan {
    name = "${var.plan_name}"
    publisher = "${var.plan_publisher}"
    product = "${var.plan_product}"
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb = "${var.os_size}"
    managed_disk_type = "${var.storage_account_type}" 
    #vhd_uri       = "${data.azurerm_storage_account.store.primary_blob_endpoint}${azurerm_storage_container.container.name}/${var.prefix}osdisk.vhd"
  }

  storage_data_disk {
    name              = "${var.prefix}-datadisk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    disk_size_gb      = "${var.data_size}"
    lun = 0
    managed_disk_type = "${var.storage_account_type}" 
    #vhd_uri       = "${data.azurerm_storage_account.store.primary_blob_endpoint}${azurerm_storage_container.container.name}/${var.prefix}datadisk.vhd"
  }

  os_profile {
    computer_name  = "${local.virtual_machine_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${data.azurerm_key_vault_secret.secret.value}"
  }

  os_profile_linux_config {
    disable_password_authentication = "${var.disable_password_authentication}"
 
  
  ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${var.ssh_public_key}"
    }
 }
  provisioner "remote-exec" {
    connection {
      user     = "${var.admin_username}"
      password = "${data.azurerm_key_vault_secret.secret.value}"
      host = "${azurerm_network_interface.nic.private_ip_address}"
      timeout  = "1m"
    }

    inline = [
      "hostnamectl",
    ]
  }
}
