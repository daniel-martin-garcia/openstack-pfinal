#!/bin/bash

source /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v01/bin/admin-openrc.sh
#openstack orchestration template validate -t ejemplo1.yml
#openstack stack create -t ejemplo1.yml --parameter "net_name=net0" --parameter "key_name=vm2" stack2
#openstack stack output show --all stack2
#openstack stack output show stack2 instance_ip -c output_value
#openstack stack output show stack2 instance_ip -f json
#openstack stack output show stack2 instance_ip -f value -c output_value #saca IP


#Deleting stacks if created
echo "Deleting stacks..."
openstack stack delete vm1_stack
openstack stack delete vm2_stack
openstack stack delete vm3_stack
openstack stack delete db_stack
openstack stack delete router_stack
openstack stack delete net1_stack
openstack stack delete net2_stack

#Networks
echo ""
echo "Creating networks..."
openstack stack create -t net.yml --parameter "net_name=net1" --parameter "subnet_name=subnet1" --parameter "start_allocation_pools=10.1.1.8" --parameter "end_allocation_pools=10.1.1.100" --parameter "gateway_ip=10.1.1.1" --parameter "subnet_cidr=10.1.1.0/24" net1_stack
openstack stack create -t net.yml --parameter "net_name=net2" --parameter "subnet_name=subnet2" --parameter "start_allocation_pools=10.1.2.8" --parameter "end_allocation_pools=10.1.2.100" --parameter "gateway_ip=10.1.2.1" --parameter "subnet_cidr=10.1.2.0/24" net2_stack

#Servers
echo ""
echo "Creating servers..."
openstack stack create -t vm.yml --parameter "net_name1=net1" --parameter "net_name2=net2" --parameter "key_name=vm1" vm1_stack
openstack stack create -t vm.yml --parameter "net_name1=net1" --parameter "net_name2=net2" --parameter "key_name=vm2" vm2_stack
openstack stack create -t vm.yml --parameter "net_name1=net1" --parameter "net_name2=net2" --parameter "key_name=vm3" vm3_stack
openstack stack create -t vm.yml --parameter "net_name1=net1" --parameter "net_name2=net2" --parameter "key_name=admin" admin_stack

#Router
echo ""
echo "Creating router..."
openstack stack create -t router.yml --parameter "router_name=r1" --parameter "subnet_id=subnet1" router_stack

#Database
echo ""
echo "Creating database..."
openstack stack create -t ddbb.yml --parameter "net_name=net2" --parameter "key_name=db" db_stack

#Load Balancer
#openstack stack create -t lb.yml --parameter "subnet_name=net1" --parameter "ip_address1=${IP_VM1}" --parameter "ip_address2=${IP_VM2}" --parameter "ip_address2=${IP_VM2}" lb_stack

#Servers IP addressed
IP_VM1 = $(openstack stack output show vm1_stack instance_ip -f value -c output_value)
IP_VM2 = $(openstack stack output show vm2_stack instance_ip -f value -c output_value)
IP_VM3 = $(openstack stack output show vm3_stack instance_ip -f value -c output_value)