terraform {
    required_providers {
        proxmox = {
            source  = "telmate/proxmox"
            version = "2.9.11"
        }
    }
}


provider "proxmox" {
    pm_api_token_id = PM_API_TOKEN_ID
    pm_api_token_secret = PM_API_TOKEN_SECRET 
    pm_api_url = PM_PROV_URL
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
