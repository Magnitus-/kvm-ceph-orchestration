resource "libvirt_network" "ceph" {
  name = "ceph"
  mode = "nat"

  addresses = [local.params.network.addresses]

  dhcp {
    enabled = false
  }

  dns {
    enabled = true
    local_only = true
  }

  autostart = true
}