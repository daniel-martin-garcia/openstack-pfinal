#!/bin/bash
DIRECTORY=$(pwd)

echo "Downloading Openstack..."
/mnt/vnx/repo/cnvr/bin/get-openstack-tutorial.sh
cd /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v05

echo "Starting Openstack..."
sudo vnx -f openstack_lab.xml --create
sudo vnx -f openstack_lab.xml -x start-all
sudo vnx -f openstack_lab.xml -x load-img

echo "Enabling NAT configuration..."
#REMOTE LAB B
sudo vnx_config_nat ExtNet enp1s0

#IN LAB B
sudo vnx_config_nat ExtNet enp2s0

#REMOTE IN LAB A
sudo vnx_config_nat ExtNet eno1

echo "Scenario created."
