# About

This project is meant to deploy a small ceph cluster across vms on a single physical machine (with a lot of RAM) to experiment with ceph in an easy to provision and easy to dispose of throwaway environment.

Installation strategies, failure recoveries, ceph upgrades and other maitenance operations can all be tested safely in this environment before doing it on a live ceph cluster.

The cephadm method of installation is used with the **reef** version of ceph.

A Linux libvirt/kvm environment is expected for the host and terraform is used to do the provisioning.

# Disclaimer

I created this projet to learn how to setup and operate a ceph cluster on virtual machines before I do it on real machines and also to test maintenance operations later on before I perform them on a live cluster.

It is based on what I've learned so far from the official ceph documentation, but this is incomplete knowledge and also is meant to work on a more resource-constrained local environment with fewer hosts.

In a production environment, at the very least least, you would probably want to separate your control plane (monitors, managers, etc) from your osds and use at least 4 machines for osds if you want a safe erasure code strategy than k = 2 , m = 1 on a hosts failure domain.

# Usage

To setup the environment:

1. Go to the **core** directory and run `terraform init & terraform apply` to setup the libvirt network, shared ssh key and ubuntu image that is to be used in all the vms.
2. Go to the **ops** directory and run `terraform init & terraform apply` to setup coredns hosts for the ceph vm domains. If you want to have a seamless experience with the dashboard, you can add the ips of the ops nodes (found in the **params.json** file) as dns nameservers in your host's **etc/resolv.conf** file.
3. Go to the **ceph** directory and run `terraform init & terraform apply` to setup the ceph hosts. Wait for cloud init to finish and type `virsh list --all` to list all your hosts and `virsh console ceph-1` to open an ssh prompt on your first vm.
4. In the **ceph-1** vm, run the **/opt/ceph/scripts/bootstrap.sh** script as root to boostrap your first monitor and manager in your control plane.
5. In the **ceph-1** vm, run the **/opt/ceph/scripts/expand_cluster.sh** script as root to setup the rest of your control plane across all your 3 vms.
6. In the **ceph-1** vm, run the **/opt/ceph/scripts/deploy_osds.sh** script to deploy the osd auto-provisioning daemon that will provision osds for all your free storage devices.

