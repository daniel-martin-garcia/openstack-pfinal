#!/bin/bash
DIRECTORY=$(pwd)
/mnt/vnx/repo/cnvr/bin/get-openstack-tutorial.sh
cd /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v04
#cp ${DIRECTORY}/openstack_lab.xml .
sudo vnx -f openstack_lab.xml --create
sudo vnx -f openstack_lab.xml -x start-all
sudo vnx -f openstack_lab.xml -x load-img
sudo vnx_config_nat ExtNet enp1s0
echo "Escenario desplegado"
