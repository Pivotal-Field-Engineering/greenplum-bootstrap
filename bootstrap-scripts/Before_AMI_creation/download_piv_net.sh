#!/bin/bash

# Download binaries from network.pivotal.io using the provided token
if [ "$release_name" == "4.3.9.1" ] ;
then
	echo "inside if"
	curl -f -o greenplum-db.zip -d "" -H "Authorization: Token ${pivnet_access_token}" -L https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2146/product_files/5948/download
#	curl -f -o greenplum-cc.zip -d "" -H "Authorization: Token rL1NeFhzsDFHopeCB3r1" -L https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2146/product_files/6225/download
	curl -f -o greenplum-cc.zip -d "" -H "Authorization: Token rL1NeFhzsDFHopeCB3r1" -L https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2146/product_files/3191/download
fi

# If binary file not found, try downloading using a fallback token and version 4.3.9.1
if [ ! -f greenplum-db.zip ] || [ ! -f greenplum-cc.zip ] ;
then
	echo "inside else if"
	curl -f -o greenplum-db.zip -d "" -H "Authorization: Token rL1NeFhzsDFHopeCB3r1" -L https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2146/product_files/5948/download
#	curl -f -o greenplum-cc.zip -d "" -H "Authorization: Token rL1NeFhzsDFHopeCB3r1" -L https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2146/product_files/6225/download
	curl -f -o greenplum-cc.zip -d "" -H "Authorization: Token rL1NeFhzsDFHopeCB3r1" -L https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/2146/product_files/3191/download
else
	echo "Could not download required softwares. Abort!"
fi