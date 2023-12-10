terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "= 0.7.1"
    }
    etcd = {
      source = "Ferlab-Ste-Justine/etcd"
      version = "= 0.9.0"
    }
  }
  required_version = ">= 1.0.0"
}
