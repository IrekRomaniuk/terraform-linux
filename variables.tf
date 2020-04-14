variable "prefix" {
  description = "The Prefix used for all resources in this example"
}

/*variable "location" {
  description = "The Azure Region in which the resources in this example should exist"
}*/

# required variables
variable "hostname" {
  description = "name of the machine to create"
}

variable "ssh_public_key" {
  description = "public key for ssh access"
}

variable "secret" {}

variable "store" {}

variable "vault" {}

variable "rg_sakv" {}

variable "rg_vnet" {}

variable "rg" {}

variable "vnet" {}

variable "subnet" {}

variable "ip_address" {}

variable "data_size" {}

variable "os_size" {}

# optional variables

variable "storage_account_type" {
  description = "type of storage account"
  default     = "StandardSSD_LRS"
}
# B1ls - smallest
variable "vm_size" {
  description = "size of the vm to create"
  default     = "Standard_B1ms" 
}

variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
  default     = "18.04-LTS"
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "administrator user name"
  default     = "docker"
}

/*variable "admin_password" {
  description = "administrator password (recommended to disable password auth)"
  default     = "notused"
}*/

variable "disable_password_authentication" {
  description = "toggle for password auth (recommended to keep disabled)"
  default     = false
}

/*variable "plan_name" {}
variable "plan_publisher" {}
variable "plan_product" {}*/