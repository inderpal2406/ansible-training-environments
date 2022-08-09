#!/usr/bin/env bash

# Script to remove all hosts from known_hosts file and add them again.
# This is being done to automate frequent such tasks done when hosts get recreated.

for i in ubuntu10 ubuntu11 redhat10 redhat11 squid-proxy bastion-server; do 
	echo $i;
	ssh-keygen -f /home/ubuntu/.ssh/known_hosts -R $i;
	read;
done

echo "That's it for now."
