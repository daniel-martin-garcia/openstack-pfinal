#!/bin/bash
#apt-get install git
#echo "VM name: $VMNAME"
git clone https://github.com/daniel-martin-garcia/CNVR-tomcat
sleep 3
cd CNVR-tomcat
sleep 2
echo $VMNAME > server.txt
sleep 5
./commands.sh