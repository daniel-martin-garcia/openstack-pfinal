#!/bin/bash
#apt-get install git
#echo "VM name: $VMNAME"
git clone https://github.com/daniel-martin-garcia/CNVR-tomcat
cd CNVR-tomcat
echo $VMNAME > server.txt
