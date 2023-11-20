
terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      version = "0.7.6"
      source  = "registry.terraform.io/dmacvicar/libvirt"
    }
  }
}

# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "kubernetes" {
  name = "kubernetes"
  type = "dir"
  path = var.kubernetes_pool_path
}

resource "libvirt_volume" "os_image_ubuntu" {
  name   = "os_image_ubuntu"
  pool   = libvirt_pool.kubernetes.name
  source = var.os_image
  format = "qcow2"
}

resource "libvirt_network" "kubernetes_network" {
  name      = "k8s_net"
  addresses = ["10.21.7.0/24"]
  dhcp {
    enabled = false
  }
  dns {
    enabled = true
  }
}


