#!/bin/bash

#Borrar fw 
IP_FIXED_ADMIN=$1
IP_LB=$2

echo "$IP_FIXED_ADMIN"
echo "$IP_LB"

echo ""
echo "Deleting firewall group, rules and policies..."
openstack firewall group set --no-port --no-ingress-firewall-policy --no-egress-firewall-policy fw-group
openstack firewall group delete fw-group
openstack firewall group policy delete fw-policy
openstack firewall group rule delete lb_rule
openstack firewall group rule delete admin_rule
sleep 10

echo ""
echo "Creating firewall group, rules and policies..."
openstack firewall group rule create --protocol tcp --destination-ip-address $IP_LB --action allow --name lb_rule
openstack firewall group rule create --protocol tcp --destination-port 22 --destination-ip-address $IP_FIXED_ADMIN --action allow --name admin_rule
sleep 3
openstack firewall group policy create --firewall-rule lb_rule --firewall-rule admin_rule fw-policy
sleep 3

PORT_ID=$(openstack port list --fixed-ip subnet=subnet1,ip-address=10.1.1.1 -c ID -f value)
openstack firewall group create --ingress-firewall-policy fw-policy --egress-firewall-policy 68359d90-b1a1-47cb-a6c2-85002b11d4f2 --port $PORT_ID --name fw-group

