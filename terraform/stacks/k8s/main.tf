locals {
  nodes = {
    controlplane = [
      {
        vmname    = "controlplane-talos"
        vmid      = 8001
        memory    = 8192
        cores     = 4
        disk_size = 60
        ip        = "${var.controlplane_ip}/${var.controlplane_subnet}"
        ip_bare   = "${var.controlplane_ip}"
        config    = "talos-config-controlplane.yml"
        node_type = "cp"
        mac       = "BC:24:11:2E:5E:76"
      }
    ]
    worker = [
      {
        vmname    = "worker-1-talos"
        vmid      = 8002
        memory    = 4096
        cores     = 2
        disk_size = 40
        ip        = "${var.worker1_ip}/${var.worker1_subnet}"
        ip_bare   = "${var.worker1_ip}"
        config    = "talos-config-worker1.yml"
        node_type = "worker"
        mac       = "BC:24:11:5B:97:EB"
      },
      {
        vmname   = "worker-2-talos"
        vmid      = 8003
        memory    = 4096
        cores     = 2
        disk_size = 40
        ip        = "${var.worker2_ip}/${var.worker2_subnet}"
        ip_bare   = "${var.worker2_ip}"
        config    = "talos-config-worker2.yml"
        node_type = "worker"
        mac       = "BC:24:11:C3:20:2F"
      }
    ]
  }
}

resource "local_file" "controlplane_network_configs" {
  for_each = { for i, node in local.nodes.controlplane : i => node}

  filename = "${path.module}/configs/cp_${each.key}_network_config"
  content = templatefile("${path.module}/templates/network-config.tpl", {
    mac_address = each.value.mac
    ip_address  = each.value.ip_bare
    netmask     = "255.255.255.0"
    gateway     = var.cluster_gateway
  })
}

resource "local_file" "controlplane_meta_data" {
  for_each = { for i, node in local.nodes.controlplane : i => node}

  filename = "${path.module}/configs/cp_${each.key}_meta_data"
  content = templatefile("${path.module}/templates/meta-data.tpl", {
    hostname = each.value.vmname
  })
}

resource "null_resource" "controlplane_cidata" {
  for_each = { for i, node in local.nodes.controlplane : i => node}

  connection {
    type = "ssh"
    host = var.proxmox_host
    user = var.proxmox_ssh_user
    private_key = file(var.proxmox_ssh_key_file)
  }

  provisioner "file" {
    source      = "${path.module}/configs/cp_${each.key}_network_config"
    destination = "/tmp/cp-${each.key}-network-config"
  }

  provisioner "file" {
    source      = "${path.module}/configs/cp_${each.key}_meta_data"
    destination = "/tmp/cp-${each.key}-meta-data"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/cp-${each.key}-config",
      "cp /tmp/cp-${each.key}-network-config /tmp/cp-${each.key}-config/network-config",
      "cp /tmp/cp-${each.key}-meta-data /tmp/cp-${each.key}-config/meta-data",
      "xorriso -as mkisofs -r -V cidata -o /var/lib/vz/template/iso/talos-cp-${each.key}-cidata.iso /tmp/cp-${each.key}-config",
      "rm -rf /tmp/cp-${each.key}-config /tmp/cp-${each.key}-network-config /tmp/cp-${each.key}-meta-data"
    ]
  }

  depends_on = [
    local_file.controlplane_network_configs,
    local_file.controlplane_meta_data,
  ]
}

resource "local_file" "worker_network_configs" {
  for_each = { for i, node in local.nodes.worker : i => node}

  filename = "${path.module}/configs/worker_${each.key}_network_config"
  content = templatefile("${path.module}/templates/network-config.tpl", {
    mac_address = each.value.mac
    ip_address  = each.value.ip_bare
    netmask     = "255.255.255.0"
    gateway     = var.cluster_gateway
  })
}

resource "local_file" "worker_meta_data" {
  for_each = { for i, node in local.nodes.worker : i => node}

  filename = "${path.module}/configs/worker_${each.key}_meta_data"
  content = templatefile("${path.module}/templates/meta-data.tpl", {
    hostname = each.value.vmname
  })
}

resource "null_resource" "worker_cidata" {
  for_each = { for i, node in local.nodes.worker : i => node}

  connection {
    type = "ssh"
    host = var.proxmox_host
    user = var.proxmox_ssh_user
    private_key = file(var.proxmox_ssh_key_file)
  }

  provisioner "file" {
    source      = "${path.module}/configs/worker_${each.key}_network_config"
    destination = "/tmp/worker-${each.key}-network-config"
  }

  provisioner "file" {
    source      = "${path.module}/configs/worker_${each.key}_meta_data"
    destination = "/tmp/worker-${each.key}-meta-data"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/worker-${each.key}-config",
      "cp /tmp/worker-${each.key}-network-config /tmp/worker-${each.key}-config/network-config",
      "cp /tmp/worker-${each.key}-meta-data /tmp/worker-${each.key}-config/meta-data",
      "xorriso -as mkisofs -r -V cidata -o /var/lib/vz/template/iso/talos-worker-${each.key}-cidata.iso /tmp/worker-${each.key}-config",
      "rm -rf /tmp/worker-${each.key}-config /tmp/worker-${each.key}-network-config /tmp/worker-${each.key}-meta-data"
    ]
  }

  depends_on = [
    local_file.worker_network_configs,
    local_file.worker_meta_data,
  ]
}

resource "proxmox_virtual_environment_vm" "controlplane_nodes" {
  for_each = { for i, node in local.nodes.controlplane : i => node}

  agent {
    enabled = true
  }

  vm_id       = each.value.vmid
  name        = "${each.value.vmname}"
  node_name   = var.node
  description = "Talos control plane node"

  operating_system {
    type = "l26"
  }

  cpu {
    cores   = each.value.cores
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory
  }

  disk {
    file_id      = "local:iso/${var.vm_iso}"
    interface    = "scsi0"
    size         = each.value.disk_size
    ssd          = true
  }

  cdrom {
    interface = "ide2"
    enabled   = true
    file_id   = "local:iso/talos-cp-${each.key}-cidata.iso"
  }

  network_device {
    bridge = var.cluster_network_bridge
    mac_address = each.value.mac
  }

  boot_order = ["scsi0", "ide2", "net0"]
  depends_on = [null_resource.controlplane_cidata]
}

resource "proxmox_virtual_environment_vm" "worker_nodes" {
  for_each = { for i, node in local.nodes.worker : i => node}

  agent {
    enabled = true
  }

  vm_id       = each.value.vmid
  name        = "${each.value.vmname}"
  node_name   = var.node
  description = "Talos worker node"

  operating_system {
    type = "l26"
  }

  cpu {
    cores   = each.value.cores
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory
  }

  disk {
    file_id      = "local:iso/${var.vm_iso}"
    interface    = "scsi0"
    size         = each.value.disk_size
    ssd          = true
  }

  cdrom {
    interface = "ide2"
    enabled   = true
    file_id   = "local:iso/talos-worker-${each.key}-cidata.iso"
  }

  network_device {
    bridge = var.cluster_network_bridge
    mac_address = each.value.mac
  }

  boot_order = ["scsi0", "ide2", "net0"]
  depends_on = [null_resource.worker_cidata]
}
