#!/bin/bash

file="../inventories/hosts"
for i in `awk '{print $1}' $file | grep -v "^$" | grep -v "^\[" | sort -u`
do
	clear
	echo $i
	sleep 2
	ssh $i
done
echo
echo "SSH to all available hosts in file $file tried. That's it for now :)"
echo

