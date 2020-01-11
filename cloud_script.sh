#!/bin/bash
export JRE_HOME=/CNVR-tomcat/jre1.8.0_231
cd /CNVR-tomcat/apache-tomcat/bin
echo $VMNAME > /CNVR-tomcat/apache-tomcat/webapps/ROOT/server.txt
./startup.sh
