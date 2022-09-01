#!/usr/bin/env bash

# Script to ssh to all hosts to accept keys for first time and add to known_hosts.
# This is being done to automate frequent such tasks done when hosts get recreated.

hostfile="../files/host_ips.txt"

for i in `cat $hostfile`
do
	echo $i
	ssh $i
done

