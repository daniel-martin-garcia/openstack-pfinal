#!/bin/bash

source /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v01/bin/admin-openrc.sh
openstack orchestration template validate -t ejemplo1.yml
openstack stack create -t ejemplo1.yml --parameter "net_name=net0" --parameter "key_name=vm2" stack2
openstack stack output show --all stack2
openstack stack output show stack2 instance_ip -c output_value
openstack stack output show stack2 instance_ip -f json

openstack stack output show stack2 instance_ip -f value -c output_value #saca IP
