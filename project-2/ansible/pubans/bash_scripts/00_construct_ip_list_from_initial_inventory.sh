#!/usr/bin/env bash

inventory_name="../initial_inventory"
ip_file="../files/host_ips.txt"

# grep -v "^$" will exclude the blank lines. "^$" indicates nothing between start & end of line.
# grep -v "^\[" will exclude lines beginning with [. Since [ has special meaning in bash, we escape it with \.
awk '{print $1}' $inventory_name | grep -v "^$" | grep -v "^\[" | sort -u > $ip_file

