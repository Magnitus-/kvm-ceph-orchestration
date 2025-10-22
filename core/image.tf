resource "libvirt_pool" "ceph" {
  name = "ceph"
  type = "dir"
  path = var.ceph_pool_path
}

resource "libvirt_volume" "ubuntu_jammy_2023_10_26" {
  name   = "ubuntu-jammy-2023-10-26"
  pool   = libvirt_pool.ceph.name
  source = "https://cloud-images.ubuntu.com/releases/jammy/release-20231026/ubuntu-22.04-server-cloudimg-amd64.img"
}