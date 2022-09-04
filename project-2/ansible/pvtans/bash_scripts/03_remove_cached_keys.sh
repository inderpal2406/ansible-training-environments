#!/usr/bin/env bash

# Script to remove all hosts from known_hosts file and add them again.
# This is being done to automate frequent such tasks done when hosts get recreated.

known_hosts_file="$HOME/.ssh/known_hosts"  # If i use ~ inside "", it wasn't expanded by bash and so $HOME had to be used.
hosts_file="../files/hostnames.txt"

for i in `cat $hosts_file`
do
	echo $i
	ssh-keygen -f $known_hosts_file -R $i
	if [ $? -eq 0 ]
	then
		echo "Cached SSH key of host $i is deleted, Press ENTER to proceed with next host."
		read
	else
		echo "Removal of cached SSH key of host $i failed. Exiting script now!"
		exit
	fi
done

