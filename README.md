## Example: using Provisioner over SSH to a Linux Virtual Machine

This example provisions a Virtual Machine running Ubuntu 16.04-LTS with a Public IP Address and [runs a `remote-exec` provisioner](https://www.terraform.io/docs/provisioners/remote-exec.html) over SSH.

Notes:

- The files involved in this example are split out to make it easier to read, however all of the resources could be combined into a single file if needed.

Looks also [here](https://github.com/trstringer/terraform-azure-linux-vm)

Assuming key vault and storage account in same resource group and subscription (can be different than rg of vm)

module "azlinuxvm" {
  source = "github.com/IrekRomaniuk/terraform-linux.git"

  provider = azurerm.net
  name_prefix    = "lin"
  hostname       = "ubuntu-server"
  rg = "Spoke-EastUS-Prod-Hub"
  vnet = "vnet-eastus-nonprod-net"
  subnet = "default"
  rg_sakv = "net-spoke-eastus-prod-automation"
  sa = "sta360spokeneteastus"
  kv = "kvt-a360-net-east-spoke"
  ssh_public_key = "${file("/home/docker/.ssh/id_rsa.pub")}"
}
