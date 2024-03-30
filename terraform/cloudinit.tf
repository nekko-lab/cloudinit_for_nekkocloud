variable username {}
variable public_key {}
variable cores {}
variable memory {}
variable disk_size {}
variable ip_address {}


terraform {
    required_providers {
        proxmox = {
            source  = "telmate/proxmox"
            version = "2.9.11"
        }
    }
}


provider "proxmox" {
    pm_api_token_id = "root@pam!"
    pm_api_token_secret = ""
    pm_api_url = "https://hugeslaight:8006/api2/json"
    pm_tls_insecure = true
    pm_debag = true
}


resource "proxmox_vm_qemu" "nekko-cloud" {
    name = "vm-${var.username}"
    target_node = "pve-c01"
    clone = "ubuntu-22.04a"
    os_type = "cloud-init"
    boot = "order=virtio0"
    cores   = "${var.cores}"
    memory  = "${var.memory}"

    disk {
        storage = "local-lvm"
        type = "virtio"
        size = "${var.disk_size}G"
    }

    network {
        model = "virtio"
        bridge = "vmbr0"
        firewall = false
    }

    ipconfig0 = "ip=${var.ip_address}/24,gw=192.168.0.1"
    ciuser = "${var.username}"
    sshkeys = <<EOF
        ${var.public_key}
    EOF
}
