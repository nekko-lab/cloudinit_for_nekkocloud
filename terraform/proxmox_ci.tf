# Description: This file contains the terraform configuration for creating a new VM on the Proxmox server.

# locals: Argument reference
locals {
    pve_node         = "pve-node-1"
    iso_storage_pool = "cephfs"
    target_node      = "Hugesleigh"
}

# proxmox_cloud_init_disk: nc-<Region Name>-ci
resource "proxmox_cloud_init_disk" "nc-ur-ci" {
  name     = PM_USER
  pve_node = local.pve_node
  storage  = local.iso_storage_pool

  meta_data = yamlencode({
    instance_id    = sha1(var.vm_name)
    local-hostname = var.vm_name
  })

#   user_data = <<EOT
# #cloud-config
# users:
#   - default
# ssh_authorized_keys:
#   - ssh-rsa AAAAB3N......
# EOT

  network_config = yamlencode({
    version = 1
    config = [{
      type = "physical"
      name = "eth0"
      subnets = [{
        type            = "static"
        address         = "192.168.1.100/24"
        gateway         = "192.168.1.1"
        dns_nameservers = ["1.1.1.1", "8.8.8.8"]
      }]
    }]
  })
}
