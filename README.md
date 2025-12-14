# Automation

This repository contains a collection of different resources used to create infrastructure in an automated fashion.
This includes but is not limited to VMs and Containers.


## Virtual Machines

The basis for the setup and use of virtual machines in the context of this repository is `Proxmox`. The automation for creating VMs and setting them up assumes a running `PVE` setup with version >= 9.0.0

For the creation of virtual machines `Terraform` with the `telmate/proxomox` provider is used. In most cases these VMs rely on a cloudinit ready template being available. Information about the creation of such templates is contained in the `hypervisor/cloudinit` subdirectory.
Most of the information about how to work with cloudinit in the context of `Proxmox` comes from the following sources:

- [Offical Proxmox Documentation](https://pve.proxmox.com/wiki/Cloud-Init_Support)
- [This very helpful Repository](https://github.com/UntouchedWagons/Ubuntu-CloudInit-Docs/tree/main)

Different combinations of VMs created with the provided terraform modules can be found in the `stacks` subdirectory of the terraform directory at the root of this repository.

Each of these stacks assumes you crate a `secrets.auto.tfvars` file in it, which will not be tracked by git, containing all the specific definitions for your local setup.

## Setup and Configuration of Resources

For setting up and configuring resources like virtual machines or containers `Ansible` is used.

Each stack definition in the `terraform/stacks` directory creates an `Ansible` inventory at the root of this repository, which can then be used for running different playbooks against all or a subset of the created resources.
