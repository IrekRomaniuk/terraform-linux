## Example: using Provisioner over SSH to a Linux Virtual Machine

This example provisions a Virtual Machine running Ubuntu 16.04-LTS with a Public IP Address and [runs a `remote-exec` provisioner](https://www.terraform.io/docs/provisioners/remote-exec.html) over SSH.

Notes:

- The files involved in this example are split out to make it easier to read, however all of the resources could be combined into a single file if needed.


module "azlinuxvm" {
  source = "github.com/tstringer/terraform-azure-linux-vm"

  name_prefix    = "myprefix"
  hostname       = "myhostname"
  ssh_public_key = "${file("/home/yourlocaluser/.ssh/id_rsa.pub")}"
}
