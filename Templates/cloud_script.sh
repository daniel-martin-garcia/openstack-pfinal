#!/bin/bash

ifdir='/etc/network/interfaces.d'; for iface in $(ip -o link | cut -d: -f2 | tr -d ' ' | grep ^ens); do if [ ! -e ${ifdir}'/'${iface}'.cfg' ]; then echo 'Creating iface file for '${iface}; printf 'auto '${iface}'\niface '${iface}' inet dhcp\n' > $ifdir'/'$iface'.cfg'; ifup ${iface}; fi; done

export JRE_HOME=/CNVR-tomcat/jre1.8.0_231
cd /CNVR-tomcat/apache-tomcat/bin
echo $VMNAME > /CNVR-tomcat/apache-tomcat/webapps/ROOT/server.txt
./startup.sh
