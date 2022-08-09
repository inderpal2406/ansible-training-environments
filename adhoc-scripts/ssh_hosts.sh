#!/usr/bin/env bash

# Script to ssh to all hosts to accept keys for first time and add to known_hosts.
# This is being done to automate frequent such tasks done when hosts get recreated.

for i in ubuntu10 ubuntu11 squid-proxy; do
	echo $i;
	ssh $i;
done

for i in bastion-server; do
	echo $i;
	ssh -i /home/ubuntu/.ssh/bastion-server-key $i;
done

for i in redhat10 redhat11; do
	echo $i;
	ssh -l ec2-user $i;
done

echo "That's it for now."

