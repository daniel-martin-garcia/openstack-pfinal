#!/bin/bash

neutron lbaas-listener-delete lb-http
neutron lbaas-pool-delete lb-http-pool
neutron lbaas-loadbalancer-delete lb
openstack security group delete lbaasv2

IP_VM1=$1
IP_VM2=$2
IP_VM3=$3
echo ""
echo "Creating load balancer..."
neutron lbaas-loadbalancer-create --name lb subnet1

echo ""
echo "Creating security groups..."
openstack security group create lbaasv2
openstack security group rule create --protocol tcp --dst-port 80:80 lbaasv2
VIP_PORT_ID=$(neutron lbaas-loadbalancer-show lb -f value -c vip_port_id)
openstack port set --security-group lbaasv2 $VIP_PORT_ID
neutron lbaas-listener-create --name lb-http --loadbalancer lb --protocol HTTP --protocol-port 80
sleep 10
#--lb-algorithm es como se llama el parametro, si cambia lb no cambia esto
echo ""
echo "Creating a pool.."
neutron lbaas-pool-create --name lb-http-pool --lb-algorithm ROUND_ROBIN --listener lb-http --protocol HTTP
echo ""
echo "Adding members to pool..."
neutron lbaas-member-create --name lb-member-01 --subnet subnet1 --address $IP_VM1 --protocol-port 80 lb-http-pool
neutron lbaas-member-create --name lb-member-02 --subnet subnet1 --address $IP_VM2 --protocol-port 80 lb-http-pool
neutron lbaas-member-create --name lb-member-03 --subnet subnet1 --address $IP_VM3 --protocol-port 80 lb-http-pool



