#!/usr/bin/env bash

# Script to remove all hosts from known_hosts file and add them again.
# This is being done to automate frequent such tasks done when hosts get recreated.

for i in ubuntu10 ubuntu11 redhat10 redhat11 squid-proxy bastion-server; do 
	echo $i;
	ssh-keygen -f /home/ubuntu/.ssh/known_hosts -R $i;
	if [ $? -eq 0 ]
       	then
		echo "Cached SSH key of host $i is deleted. Press ENTER to proceed with next host.";
		read;
	else
		echo "Removal of cached SSH key of host $i failed. Exiting script now!"
		exit
	fi
done

echo "That's it for now."
