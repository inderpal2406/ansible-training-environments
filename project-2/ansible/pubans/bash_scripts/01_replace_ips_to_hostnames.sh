#!/usr/bin/env bash
file="../inventory"
sed -i 's/10.0.0.4/pubjump/g' $file
sed -i 's/10.0.0.5/squid-proxy/g' $file
sed -i 's/10.0.0.6/pubans/g' $file
sed -i 's/10.0.1.4/pvtjump/g' $file
sed -i 's/10.0.1.5/pvtans/g' $file
sed -i 's/# pubjump//' $file
sed -i 's/# squid-proxy//' $file
sed -i 's/# pubans//' $file
sed -i 's/# pvtjump//' $file
sed -i 's/# pvtans//' $file

