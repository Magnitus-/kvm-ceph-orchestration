ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ansible/playbooks/ceph-cluster.yml \
                 -i ansible-inventory-ceph \
                 --private-key ./shared/ssh_key