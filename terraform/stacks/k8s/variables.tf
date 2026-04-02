# Proxmox
variable "proxmox_api_url" {
  type = string
  description = "Base URL of the Proxmox instances API"
}

variable "proxmox_api_token_id" {
  type = string
  description = "ID used for the authentication with the Proxmox API"
  sensitive = true
}

variable "proxmox_api_token" {
  type = string
  description = "Token used for authenticating the ID with the Proxmox API"
  sensitive = true
}

variable "node" {
  type = string
  description = "Proxmox node to deploy the cluster on"
  default = "pve"
}

variable "vm_iso" {
  type        = string
  description = "Name of the iso file used to create all vms in the cluster"
}

# Network
variable "cluster_name_server" {
  type        = list(string)
  description = "Nameserver used by all vms in the cluster"
}

variable "cluster_gateway" {
  type        = string
  description = "Network Gateway used by all vms in the cluster"
}

variable "cluster_network_bridge" {
  type        = string
  description = "Proxmox network bridge used by all vms in the cluster"
}

# Cluster Nodes

variable "controlplane_ip" {
  type        = string
  description = "Static IP for the controlplane node"
}

variable "controlplane_ipconfig" {
  type        = string
  description = "Network interface configuration for controlplane node"
}

variable "worker1_ip" {
  type        = string
  description = "Static IP for the worker node 1"
}

variable "worker1_ipconfig" {
  type        = string
  description = "Network interface configuration for worker node 1"
}

variable "worker2_ip" {
  type        = string
  description = "Static IP for the worker node 2"
}

variable "worker2_ipconfig" {
  type        = string
  description = "Network interface configuration for worker node 2"
}
