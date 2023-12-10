module "coredns_domain" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-etcd-zonefile.git"
  domain = "ns.lan"
  key_prefix = "/coredns/"
  dns_server_name = "ns.lan."
  a_records = [for node in local.params.network.machines.ops_nodes:
    {
      prefix = ""
      ip =  node.ip
    }
  ]
}

module "ceph_domain" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-etcd-zonefile.git"
  domain = "ceph.lan"
  key_prefix = "/coredns/"
  dns_server_name = "ns.lan."
  a_records = [for idx, node in local.params.network.machines.ceph_nodes:
    {
      prefix = "server-${idx + 1}"
      ip =  node.ip
    }
  ]
}