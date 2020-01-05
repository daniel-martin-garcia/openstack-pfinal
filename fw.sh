#!/bin/bash

#Borrar fw 

echo ""
echo "Deleting firewall group, rules and policies..."
openstack firewall group delete fw
openstack firewall group policy delete fw-policy
openstack firewall group rule delete rule1
sleep 10

echo ""
echo "Creating firewall group, rules and policies..."
openstack firewall group rule create --protocol tcp --destination-ip-address 10.1.1.0/24 --action allow --name rule1
sleep 3
openstack firewall group policy create --firewall-rule rule1 fw-policy
sleep 3

PORT_ID=$(openstack port list --fixed-ip subnet=subnet1,ip-address=10.1.1.1 -c ID -f value)
openstack firewall group create --ingress-firewall-policy fw-policy --egress-firewall-policy 68359d90-b1a1-47cb-a6c2-85002b11d4f2 --port $PORT_ID --name fw

