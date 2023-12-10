provider "libvirt" {
  uri = "qemu:///system"
}

provider "etcd" {
  endpoints = join(",", [for etcd in local.params.network.machines.ops_nodes: "${etcd.ip}:2379"])
  ca_cert = "${path.module}/../shared/etcd-ca.crt"
  cert = "${path.module}/../shared/etcd-root.crt"
  key = "${path.module}/../shared/etcd-root.key"
}
