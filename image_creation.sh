#!/bin/bash

openstack stack create -t vm.yml --parameter "net_name1=net1" --parameter "net_name2=net2" --parameter "key_name=vm3" vm0_stack
#-------------------------------------------------------------------------------------
#PARA MIRAR DENTRO DE LA VM: openstack server ssh --login root --port 22 <server-name>
#-------------------------------------------------------------------------------------

counter=1 
while [ $counter -lt 10 ] 
do
    if [ -e server.txt ]
    then
        echo "Server creation finished successfully."
        break
    else
        echo "Server not created yet. Waiting..."
        sleep 10
        ((counter++))
        if [ $counter -eq 10 ]
        then
            echo "Server could not be created. Exiting..."
            exit(0)
        fi
    fi
done

echo "Stopping server vm..."
sleep 5
VM0=$(openstack server list -c NAME -f value)
openstack server stop $VM0
sleep 5

STATUS=$(openstack server list -c STATUS -f value)
while :
do
    if [ $STATUS != "STOP" ] #Mirar la condicion
        then
            sleep 5
    else
        echo "Server VM stopped."
        break
    fi
done

echo "Creating image..."
openstack server image create --name server-image --wait vm0 #obtener el valor del servidor
echo "Image created successfully."
echo "Deleting stack..."
openstack stack delele vm0_stack
echo "Stack deleted successfully"