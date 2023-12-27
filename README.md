# About

This project is meant to deploy a small ceph cluster across vms on a single physical machine (with a lot of RAM) to experiment with ceph in an easy to provision and easy to dispose of throwaway environment.

Installation strategies, failure recoveries, ceph upgrades and other maitenance operations can all be tested safely in this environment before doing it on a live ceph cluster.

The cephadm method of installation is used with the **reef** version of ceph.

A Linux libvirt/kvm environment is expected for the host and terraform is used to do the provisioning.

# Disclaimer

This project is based on what I've learned so far from the official ceph documentation so this project is based on pretty incomplete knowledge from a ceph novice and also is meant to work on a more resource-constrained local environment with fewer hosts to prepare for a only marginally more complex homelab environment.

In a serious production environment, at the very least least, you would probably want to separate your control plane hosts (monitors, managers, etc) from your  osds hosts and use at least 4 machines for osds if you want erasure coding with a safer strategy than k = 2 , m = 1. You would also likely want a more complex crush map than the default crush map (which only supports a failure domain on hosts) to allow for failure domains across different locations in the datacenter and possibly even across datacenters and regions. You may also want to perform many fine-tuning operations (primary affinity adjustment for different kinds of drive, fine tune pg distribution across pools based on expected pool sizes, fine-tuning scrubing recurrence, etc) that are outside the scope of this project.

# Usage

To setup the environment:

1. Go to the **core** directory and run `terraform init & terraform apply` to setup the libvirt network, shared ssh key and ubuntu image that is to be used in all the vms.
2. Go to the **ops** directory and run `terraform init & terraform apply` to setup coredns hosts for the ceph vm domains. If you want to have a seamless experience with the dashboard, you can add the ips of the ops nodes (found in the **params.json** file) as dns nameservers in your host's **etc/resolv.conf** file.
3. Go to the **ceph** directory and run `terraform init & terraform apply` to setup the ceph hosts. Wait for cloud init to finish and type `virsh list --all` to list all your hosts and `virsh console ceph-1` to open an ssh prompt on your first vm.
4. In the **ceph-1** vm, run the **/opt/ceph/scripts/bootstrap.sh** script as root to boostrap your first monitor and manager in your control plane.
5. In the **ceph-1** vm, run the **/opt/ceph/scripts/expand_cluster.sh** script as root to setup the rest of your control plane across all your 3 vms.
6. In the **ceph-1** vm, run the **/opt/ceph/scripts/deploy_osds.sh** script to deploy the osd auto-provisioning daemon that will provision osds for all your free storage devices.

# Useful Commands

Compilation of some useful ceph commands that I'm updating as I learn.

## Info commands

1. For an overview: `ceph -s`
2. A slightly more detailed overview: `ceph status`
3. Automation-friendly command just to get cluster health: `ceph health`
4. For an overview of your services: `ceph orch ls`
5. List of externally accessible services endpoints (by ips) managed by the active mgr deamon: `ceph mgr services`
6. For an overview of your hosts: `ceph orch host ls`
7. For an overview of your devices and availability to be managed by osds: `ceph orch device ls`
8. To view all your containers across hosts: `ceph orch ps`
9. View the monitor map: `ceph mon dump`
10. Overview of your managers (in json): `ceph mgr stat`
11. Quick overview of your osds: `ceph osd stat`
12. More detailed overview of your osds listing them: `ceph osd status`
13. View you osds with weight and primary affinity adjustments: `ceph osd tree`
14. View the crushmap (and optionally shadow crush maps if you have different kinds of devices): `ceph osd crush tree [--show-shadow]`
15. Name listing of your crush rules: `ceph osd crush rule ls`
16. Detailed listing of your crush rules: `ceph osd crush rule dump`
17. Listing of available device classes (ex: hdd, ssd, nvme, etc): `ceph osd crush class ls`
18. Listing of erasure code profiles by name: `ceph osd erasure-code-profile ls`
19. More detailed view of particular erasure code profile: `ceph osd erasure-code-profile get default`
20. List your pools with their ids: `ceph osd lspools`
21. List pools with more details: `ceph osd pool ls detail`
22. Quick overview of your placement groups: `ceph pg stat`
23. More detailed listing of your placement groups: `ceph pg dump pgs_brief` 
24. See osd automatic weight balancer status: `ceph balancer status`
25. See pools placement groups autoscaling status: `ceph osd pool autoscale-status`
26. See pool utilization statistics: `rados df`
27. See pool io stats: `ceph osd pool stats`
28. See users: `ceph auth list`
29. See specific user: `ceph auth get <user name>`
30. See specific user access key: `ceph auth print-key <user name>`
31. List rados gateway realms: `radosgw-admin realm list`
32. See more info on a rados gateway realm: `radosgw-admin realm get --rgw-realm=<realm name>`
33. List rados gateway zonegroups: `radosgw-admin zonegroup list`
34. See more info on a rados gateway zonegroup: `radosgw-admin zonegroup get --rgw-zonegroup=<zonegroup name>`
34. See more info on a rados gateway zone: `radosgw-admin zone get --rgw-zone=<zone name>`

## Crush Buckets Manipulation

1. To create a bucket: `ceph osd crush add-bucket <bucket name> <bucket type>`
2. To place a bucket in the existing crush hiearchy: `ceph crush move <bucket name> <bucket position>`

For example, to create rack1 and move host1, host2 and host3 under it:

```
#Create rack1 bucket
ceph osd crush add-bucket rack1 rack
#Place rack1 bucket in the existing crush hiearchy 
ceph crush move rack1 root=default
#Place host1, host2 and host3 buckets under it
ceph crush move host1 rack=rack1
ceph crush move host2 rack=rack1
ceph crush move host3 rack=rack1
```

## Osd Manipulations

1. To change osd primary affinity (weight is between 0 and 1, defaults to 1 for every osd): `ceph osd primary-affinity <osd-id> <weight>`

## Pools Manipulations

1. To create an erasure code profile: `ceph osd erasure-code-profile set <profile name> k=<number of data chunks> m=<number of code chunks> crush-failure-domain=<failure domain type>`
2. To create a replicated  pool: `ceph osd pool create <name> [<pg number> <pg number>] replicated <crush rule name>`
3. To create an erasure coded pool: `ceph osd pool create <name> [<pg number> <pg number>] erasure <erasure code profile> <crush rule name>`
4. To assign an application to a pool (cephfs, rgw or rbd for application name): `ceph osd pool application enable <pool name> <application name>`
5. To set quotas (object number and/or size) on a pool: `ceph osd pool set-quota <pool name> [max_objects <object count>] [max_bytes <max bytes>]`
6. To delete a pool: `ceph osd pool delete <pool name> <pool name> --yes-i-really-really-mean-it`
7. To rename a pool: `ceph osd pool rename <old name> <new name>`
8. To make a snapshot of a pool: `ceph osd pool mksnap <pool name> <snapshot name>`
9. To remove a snapshot of a pool: `ceph osd pool rmsnap <pool name> <snapshot name>`
10. To set pool values: `ceph osd pool set <pool name> <key> <value>`. Of specific note:
  - To change a repliced pool size: `ceph osd pool set <pool name> size <number of copies>`
  - To change acceptable number of remaining copies to accept read/write: `ceph osd pool set <pool name> min_size <number of copies>`
  - To change the number of placement groups: `ceph osd pool set <pool name> pg_num <number of groups>` and `ceph osd pool set <pool name> pgp_num <number of groups>`
  - to change the crush rule: `ceph osd pool set <pool name> crush_rule <new rule>`

For example, to setup an erasure coded pool with 2 data chunks, 1 coded chunks (3 osds, can afford to lose 1, 66% storage efficiency) and a failure domain at the host level, for object storage:

```
ceph osd erasure-code-profile set k2m1 k=2 m=1 crush-failure-domain=host
ceph osd pool create objpool 32 32 erasure k2m1
ceph osd pool application enable objpool rgw
```

To setup a replicated pool with 3 copies that stops accepting read/write when a single copy is left, with a failure domain at the host level (default replicated_rule), for object storage:
```
ceph osd pool create objpool2 32 32 replicated replicated_rule
ceph osd pool set objpool2 size 3
ceph osd pool set objpool2 min_size 2
ceph osd pool application enable objpool2 rgw
```

## User Manipulations

1. To create a new user account: `ceph auth get-or-create <user name> <permissions>`
2. To change the permissions of an existing user account: `ceph auth caps <user name> <new permissions>`
3. To delete a user account: `ceph auth del <user name>`

For example, to create an ops client that can access all pools:

```
ceph auth get-or-create client.ops mon 'allow r' osd 'allow rw' -o /etc/ceph/ceph.client.ops.keyring
```

To create a user that can only on access the **objpool** pool:
```
ceph auth get-or-create client.user1 mon 'allow r' osd 'allow rw pool=objpool' -o /etc/ceph/ceph.client.user1.keyring
```

To create a user that can only on access objects prefixed by **user2** in the **objpool** pool:
```
ceph auth get-or-create client.user2 mon 'allow r' osd 'allow rw pool=objpool object_prefix user2' -o /etc/ceph/ceph.client.user2.keyring
```

To create a user that can only access resources under the **user3** namespace across your pools:
```
ceph auth get-or-create client.user3 mon 'allow r' osd 'allow rw namespace=user3' -o /etc/ceph/ceph.client.user3.keyring
```