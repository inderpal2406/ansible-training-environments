#!/usr/bin/env bash

file1="../inventory"
file2="../files/hostnames.txt"
awk '{print $1}' $file1 | grep -v "^$" | grep -v "^\[" | sort -u > $file2

