#!/bin/bash

source /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v01/bin/admin-openrc.sh
openstack orchestration template validate -t ejemplo1.yml
openstack stack create -t ejemplo1.yml --parameter "net_name=net0" --parameter "key_name=vm2" stack2
openstack stack output show --all stack2
openstack stack output show stack2 instance_ip -c output_value
openstack stack output show stack2 instance_ip -f json

openstack stack output show stack2 instance_ip -f value -c output_value #saca IP


# NETWOKS
openstack stack create -t net.yml --parameter "net_name=net1" --parameter "subnet_name=subnet1" --parameter "start_allocation_pools=10.1.1.8" --parameter "end_allocation_pools=10.1.1.100" --parameter "gateway_ip=10.1.1.1" --parameter "subnet_cidr=10.1.1.0/24" net1_stack
openstack stack create -t net.yml --parameter "net_name=net2" --parameter "subnet_name=subnet2" --parameter "start_allocation_pools=10.1.2.8" --parameter "end_allocation_pools=10.1.2.100" --parameter "gateway_ip=10.1.2.1" --parameter "subnet_cidr=10.1.2.0/24" net2_stack