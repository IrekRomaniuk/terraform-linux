output "admin_username_password" {
  value = "${var.admin_username}/${data.azurerm_key_vault_secret.secret.value}"
}

output "secret" {
    value = "${data.azurerm_key_vault_secret}"
}

output "ip_address" {
  value = "${"azurerm_network_interface.nic.private_ip_address}"
}