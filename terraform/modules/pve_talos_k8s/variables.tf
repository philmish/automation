# Proxmox

variable "node" {
  type = string
  description = "Proxmox node to deploy the container on"
  default = "pve"
}

variable "disk_storage" {
  type    = string
  default = "local-lvm"
}

variable "iso_stoage" {
  type        = string
  description = "Storage volume containing ISOs"
  default     = "local"
}

# Virtual Machines

variable "iso_name" {
  type = string
  description = "Name of the Talos ISO file"
}

variable "vmname" {
  type = string
  description = "Name of the VM"
}

variable "memory" {
  type = number
  description = "Amount of RAM in MB assigned to the VM"
  default = 4096
}

variable "cores" {
  type        = number
  description = "Number of virtual CPU cores assigned to the VM"
  default     = 2
}

variable "disk_size" {
  type = string
  description = "Disk storage size for a VM"
}

variable "ip_config" {
  type        = string
  description = "Network interface configuration of the VM"
}

# Network

variable "name_servers" {
  type        = list(string)
  description = "Nameservers used by cluster VMs"
}

variable "gateway" {
  type        = string
  description = "Gateway IP used for outbound traffic from the cluster VMs"
}

variable "vm_ip" {
  type        = string
  description = "Static IP assigned to a cluster VM"
}

variable "network_bridge" {
  type        = string
  description = "Network bridge used by the cluster VMs"
}

variable "nic_model" {
  type        = string
  description = "Model of network card used by the VM"
  default     = "virtio"
}

# k8s cluster

variable "cluster_name" {
  type        = string
  description = "Name of the deployed cluster"
  default     = "talos-proxmox"
}
