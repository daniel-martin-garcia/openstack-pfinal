#!/bin/bash
source /mnt/tmp/openstack_lab-stein_4n_classic_ovs-v05/bin/demo-openrc.sh

#SECURITY GROUPS
demo_project_id=$(openstack project show demo -c id -f value)
default_secgroup_id=$(openstack security group list -f value | grep default | grep $demo_project_id | cut -d " " -f1)
openstack security group rule create --proto icmp --dst-port 0  $default_secgroup_id
openstack security group rule create --proto tcp  --dst-port 80 $default_secgroup_id
openstack security group rule create --proto tcp  --dst-port 22 $default_secgroup_id
openstack security group rule create --proto tcp  --dst-port 8080 $default_secgroup_id
echo ""

echo "Creating scenario..."
openstack stack create -t ../Templates/net.yml --parameter "net_name=net0" --parameter "subnet_name=subnet0" --parameter "start_allocation_pools=10.1.0.8" --parameter "end_allocation_pools=10.1.0.100" --parameter "gateway_ip=10.1.0.1" --parameter "subnet_cidr=10.1.0.0/24" net0_stack
sleep 5
openstack stack create -t ../Templates/router.yml --parameter "router_name=r0" --parameter "subnet_id=subnet0" router0_stack
sleep 5
openstack stack create -t server_image.yml --parameter "net_name=net0" --parameter "key_name=vm0" server_image_stack
echo "Scenario created. Waiting for VMs to download server..."
#-------------------------------------------------------------------------------------
#PARA MIRAR DENTRO DE LA VM: openstack server ssh --login root --port 22 <server-name>
#-------------------------------------------------------------------------------------

sleep 300

echo "Stopping server vm..."
sleep 5
VM0=$(openstack server list -c ID -f value)
openstack server stop $VM0
sleep 5

STATUS=$(openstack server list -c Status -f value)
while :
do
    STATUS=$(openstack server list -c Status -f value)
    if [ $STATUS != "SHUTOFF" ]
        then
            sleep 5
    else
        echo "Server VM stopped."
        break
    fi
done

echo "Creating image..."
openstack server image create --name server-image --wait $VM0

echo "Image created successfully."
echo "Deleting stacks..."
openstack stack delete -y server_image_stack
sleep 2
openstack stack delete -y router0_stack
sleep 2
openstack stack delete -y net0_stack
sleep 2
echo "Stacks deleted successfully"
