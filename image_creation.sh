#!/bin/bash
echo "Creating scenario..."
openstack stack create -t net.yml --parameter "net_name=net0" --parameter "subnet_name=subnet0" --parameter "start_allocation_pools=10.1.0.8" --parameter "end_allocation_pools=10.1.0.100" --parameter "gateway_ip=10.1.0.1" --parameter "subnet_cidr=10.1.0.0/24" net0_stack
openstack stack create -t router.yml --parameter "router_name=r0" --parameter "subnet_id=subnet0" router0_stack
openstack stack create -t server_image.yml --parameter "net_name=net0" --parameter "key_name=vm0" server_image_stack
echo "Scenario created. Waiting for VMs to download server..."
#-------------------------------------------------------------------------------------
#PARA MIRAR DENTRO DE LA VM: openstack server ssh --login root --port 22 <server-name>
#-------------------------------------------------------------------------------------

#counter=1 
#while [ $counter -lt 10 ] 
#do
#    if [ -e server.txt ]
#    then
#        echo "Server creation finished successfully."
#        break
#    else
#        echo "Server not created yet. Waiting..."
#        sleep 10
#        ((counter++))
#        if [ $counter -eq 10 ]
#        then
#            echo "Server could not be created. Exiting..."
#            exit(0)
#        fi
#    fi
#done

sleep 60


echo "Stopping server vm..."
sleep 5
VM0=$(openstack server list -c ID -f value)
openstack server stop $VM0
sleep 5

STATUS=$(openstack server list -c Status -f value)
while :
do
    if [ $STATUS != "SHUTOFF" ] #Mirar la condicion
        then
            sleep 5
    else
        echo "Server VM stopped."
        break
    fi
done

echo "Creating image..."
openstack server image create --name server-image --wait $VM0 #obtener el valor del servidor
echo "Image created successfully."
echo "Deleting stacks..."
openstack stack delete server_image_stack
sleep 2
openstack stack delete router0_stack
sleep 2
openstack stack delete net0
sleep 2
echo "Stacks deleted successfully"
