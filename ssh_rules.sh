#!/bin/bash

ACTION=$1

if [ $ACTION == "SET" ]
then
	echo "Adding admin ssh firewal rule"
	openstack firewall group policy set --firewall-rule admin_rule fw-policy
	sleep 3
fi

if [ $ACTION == "UNSET" ] 
then
	echo "Removing admin ssh firewall rule"
	openstack firewall group policy unset --firewall-rule admin_rule fw-policy
	sleep 3
fi