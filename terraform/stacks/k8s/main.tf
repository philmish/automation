locals {
  nodes = {
    controlplane = {
      vmname    = "controlplane.talos"
      memory    = 8192
      cores     = 4
      disk_size = "60G"
      ipconfig  = var.controlplane_ipconfig
      ip        = var.controlplane_ip
    }
    worker1 = {
      vmname    = "worker-1.talos"
      memory    = 4096
      cores     = 2
      disk_size = "40G"
      ipconfig  = var.worker1_ipconfig
      ip        = var.worker1_ip
    }
    worker2 = {
      vmname   = "worker-2.talos"
      memory    = 4096
      cores     = 2
      disk_size = "40G"
      ipconfig  = var.worker2_ipconfig
      ip        = var.worker2_ip
    }
  }
}

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = "https://${var.controlplane_ip}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname   = local.nodes.controlplane.vmname
          interfaces = [{
            interface = "eth0"
            addresses = [var.controlplane_ip]
            routes    = [{
              network = "0.0.0.0/0"
              gateway = var.cluster_gateway
            }]
          }]
          nameservers = var.cluster_name_server
        }
      }
    })
  ]
}

data "talos_machine_configuration" "worker1" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = "https://${var.controlplane_ip}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname   = local.nodes.worker1.vmname
          interfaces = [{
            interface = "eth0"
            addresses = [var.worker1_ip]
            routes    = [{
              network = "0.0.0.0/0"
              gateway = var.cluster_gateway
            }]
          }]
          nameservers = var.cluster_name_server
        }
      }
    })
  ]
}

data "talos_machine_configuration" "worker2" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = "https://${var.controlplane_ip}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname   = local.nodes.worker2.vmname
          interfaces = [{
            interface = "eth0"
            addresses = [var.worker2_ip]
            routes    = [{
              network = "0.0.0.0/0"
              gateway = var.cluster_gateway
            }]
          }]
          nameservers = var.cluster_name_server
        }
      }
    })
  ]
}

data "talos_client_configuration" "this" {
  cluster_name          = var.cluster_name
  nodes                 = [var.controlplane_ip]
  client_configuration  = talos_machine_secrets.this.client_configuration
}

module "talos_k8s" {
  source   = "../../modules/pve_talos_k8s"

  for_each       = local.nodes
  node           = var.node
  iso_name       = var.vm_iso
  name_servers   = var.cluster_name_server
  gateway        = var.cluster_gateway
  network_bridge = var.cluster_network_bridge
  vm_ip          = each.value.ip
  vmname         = each.value.vmname
  memory         = each.value.memory
  disk_size      = each.value.disk_size
  cores          = each.value.cores
  ip_config      = each.value.ipconfig
}

resource "local_file" "bootstrap_script" {
  content = templatefile("${path.module}/templates/bootstrap.sh.tpl", {
    controlplane_ip     = var.controlplane_ip
    controlplane_config = base64encode(data.talos_machine_configuration.controlplane.machine_configuration)

    worker1_ip          = var.worker1_ip
    worker1_config      = base64encode(data.talos_machine_configuration.worker1.machine_configuration)

    worker2_ip          = var.worker2_ip
    worker2_config      = base64encode(data.talos_machine_configuration.worker2.machine_configuration)
    talosconfig         = data.talos_client_configuration.this.talos_config
  })
  filename        = "${path.module}/bootstrap.sh"
  file_permission = "0755"
}

output "bootstrap_script_path" {
  description = "Path to generated bootstrap script"
  value       = local_file.bootstrap_script.filename
}

output "node_ips" {
  description = "Node IPs"
  value       = {
    controlplane = var.controlplane_ip
    worker1      = var.worker1_ip
    worker2      = var.worker2_ip
  }
}

output "talosconfig" {
  description = "talosctl configuration"
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}

output "kubeconfig_cmd" {
  description = "Command to retrieve kubeconfig after bootstrap"
  value       = "talosctl kubeconfig --nodes ${var.controlplane_ip} --endpoints ${var.controlplane_ip} --config talosconfig"
}
