#!/bin/bash

file="../inventories/hosts"
for i in `awk '{print $1}' $file | grep -v "^$" | grep -v "^\[" | sort -u`
do
	host_vars_file="../host_vars/$i"
	echo "hostname: $i" > $host_vars_file
	echo "host_vars file for host $i created."
	sleep 2
done
echo
echo "host_vars file for all available hosts in file $file is created. That's it for now :)"
echo

