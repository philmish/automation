# Proxmox API
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

variable "proxmox_host" {
  type = string
}

variable "proxmox_ssh_user" {
  type = string
  description = "User used to connect to the proxmox node using ssh"
}

variable "proxmox_ssh_key_file" {
  type = string
  description = "Path to SSH private key file used to connect the proxmox_ssh_user"
}

variable "node" {
  type = string
  description = "Proxmox node to deploy the cluster on"
  default = "pve"
}

# init
variable "ssh_pub_key" {
  type        = string
  description = "Public SSH key used for node initialization"
}

# ISO to use for Node creation
variable "vm_iso" {
  type        = string
  description = "Name of the iso file used to create all vms in the cluster"
}

# k8s cluster
variable "cluster_name" {
  type        = string
  description = "Name of the kubernetes cluster"
  default     = "talos-k8s"
}

variable "pod_subnet" {
  type        = string
  description = "Subnet in cidr notation used for pod deployment in the cluster"
}

variable "service_subnet" {
  type        = string
  description = "Subnet in cidr notation used for service deployment in the cluster"
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
#
# Controlplane
variable "controlplane_ip" {
  type        = string
  description = "Static IP for the controlplane node"
}

variable "controlplane_subnet" {
  type        = string
  description = "CIDR notation of the subnet the controlplane node is part of"
  default     = "24"
}

# Worker 1
variable "worker1_ip" {
  type        = string
  description = "Static IP for the worker node 1"
}

variable "worker1_subnet" {
  type        = string
  description = "CIDR notation of the subnet the worker node 1 is part of"
  default     = "24"
}

# Worker 2
variable "worker2_ip" {
  type        = string
  description = "Static IP for the worker node 2"
}

variable "worker2_subnet" {
  type        = string
  description = "CIDR notation of the subnet the worker node 2 is part of"
  default     = "24"
}
