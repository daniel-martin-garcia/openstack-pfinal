#!/bin/bash

source /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v05/bin/admin-openrc.sh
#openstack orchestration template validate -t ejemplo1.yml
#openstack stack create -t ejemplo1.yml --parameter "net_name=net0" --parameter "key_name=vm2" stack2
#openstack stack output show --all stack2
#openstack stack output show stack2 instance_ip -c output_value
#openstack stack output show stack2 instance_ip -f json
#openstack stack output show stack2 instance_ip -f value -c output_value #saca IP


#Deleting stacks if created
echo "Deleting stacks..."

#neutron lbaas-listener-delete lb-http
#neutron lbaas-pool-delete lb-http-pool
#neutron lbaas-loadbalancer-delete lb
#openstack security group delete lbaasv2
#sleep 3
openstack stack delete -y vm1_stack
sleep 2
openstack stack delete -y vm2_stack
sleep 2
openstack stack delete -y vm3_stack
sleep 2
openstack stack delete -y admin_stack
sleep 2
openstack stack delete -y db_stack
sleep 2
openstack stack delete -y lb_stack
sleep 2
openstack stack delete -y router_stack
sleep 2
openstack stack delete -y net1_stack
sleep 2
openstack stack delete -y net2_stack
echo ""
echo "All stacks deleted."
sleep 40


admin_project_id=$(openstack project show admin -c id -f value)
default_secgroup_id=$(openstack security group list -f value | grep default | grep $admin_project_id | cut -d " " -f1)
openstack security group rule create --proto icmp --dst-port 0  $default_secgroup_id
openstack security group rule create --proto tcp  --dst-port 80 $default_secgroup_id
openstack security group rule create --proto tcp  --dst-port 22 $default_secgroup_id
openstack security group rule create --proto tcp  --dst-port 8080 $default_secgroup_id

#Networks
echo ""
echo "Creating networks..."
openstack stack create -t net.yml --parameter "net_name=net1" --parameter "subnet_name=subnet1" --parameter "start_allocation_pools=10.1.1.8" --parameter "end_allocation_pools=10.1.1.100" --parameter "gateway_ip=10.1.1.1" --parameter "subnet_cidr=10.1.1.0/24" net1_stack
openstack stack create -t net.yml --parameter "net_name=net2" --parameter "subnet_name=subnet2" --parameter "start_allocation_pools=10.1.2.8" --parameter "end_allocation_pools=10.1.2.100" --parameter "gateway_ip=10.1.2.1" --parameter "subnet_cidr=10.1.2.0/24" net2_stack
sleep 5

#Router
echo ""
echo "Creating router..."
openstack stack create -t router.yml --parameter "router_name=r1" --parameter "subnet_id=subnet1" router_stack
sleep 5

#Servers
echo ""
echo "Creating servers..."
openstack stack create -t vm.yml --parameter "net_name1=net1" --parameter "net_name2=net2" --parameter "key_name=vm1" vm1_stack
openstack stack create -t vm.yml --parameter "net_name1=net1" --parameter "net_name2=net2" --parameter "key_name=vm2" vm2_stack
openstack stack create -t vm.yml --parameter "net_name1=net1" --parameter "net_name2=net2" --parameter "key_name=vm3" vm3_stack

sleep 100

#Admin
openstack stack create -t admin.yml --parameter "net_name1=net1" --parameter "net_name2=net2" --parameter "key_name=admin" admin_stack
sleep 20

#Database
echo ""
echo "Creating database..."
openstack stack create -t db_final.yml --parameter "net_name=net2" --parameter "key_name=db" db_stack
sleep 60

#Servers IP addressed
IP_VM1=$(openstack stack output show vm1_stack instance_ip -f value -c output_value)
echo "Vm1 IP Address is : $IP_VM1"
IP_VM2=$(openstack stack output show vm2_stack instance_ip -f value -c output_value)
echo "Vm2 IP Address is : $IP_VM2"
IP_VM3=$(openstack stack output show vm3_stack instance_ip -f value -c output_value)
echo "Vm3 IP Address is : $IP_VM3"
IP_ADMIN=$(openstack stack output show admin_stack instance_ip -f value -c output_value)
echo "Admin Floating IP is : $IP_ADMIN"
IP_FIXED_ADMIN=$(openstack stack output show admin_stack instance_fixed_ip -f value -c output_value)
echo "Admin Fixed IP is : $IP_FIXED_ADMIN"


#LoadBalancer
echo ""
echo "Creating load balancer..."
openstack stack create -t lb.yml --parameter "subnet_name=subnet1" --parameter "ip_address1=$IP_VM1" --parameter "ip_address2=$IP_VM2" --parameter "ip_address3=$IP_VM3" lb_stack
#./lb.sh $IP_VM1 $IP_VM2 $IP_VM3 
sleep 20
IP_LB=$(openstack stack output show lb_stack instance_ip -f value -c output_value)
echo "LB fixed IP is : $IP_LB"

#Firewall
echo ""
echo "Creating firewall ..."
./fw.sh $IP_FIXED_ADMIN $IP_LB


