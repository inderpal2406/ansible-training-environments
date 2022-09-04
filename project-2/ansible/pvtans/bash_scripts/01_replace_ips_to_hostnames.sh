#!/usr/bin/env bash

src_file="../initial_inventory"
file="../inventory"

if [ -f $file ]
then
	echo "$file already exists. Exiting script now!"
	exit
else
	cp $src_file $file
	echo "Copied $src_file to $file."
fi

echo "Replacing IP addresses to hostnames in $file."
sed -i 's/10.0.2.4/web-dev/g' $file
sed -i 's/10.0.2.5/db-dev/g' $file
sed -i 's/# web-dev//' $file
sed -i 's/# db-dev//' $file
echo "Replacement of IP addresses is done now."

