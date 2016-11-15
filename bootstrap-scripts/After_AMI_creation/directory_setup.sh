#!/usr/bin/env bash

# Prerequisite: a password-less sudo account

# Display command before executing

if [ ${MY_INTERNAL_IP} != ${MASTER_IP} ] || [ ${MY_INTERNAL_IP} != ${STANDBY_MASTER_IP} ]; then
	echo "This is not a master or standby master node"
	for DATADIR in /data*; do
		mkdir -p ${DATADIR}/primary
		mkdir -p ${DATADIR}/mirror
	done
fi

if [ ${MY_INTERNAL_IP} == ${MASTER_IP} ] || [ ${MY_INTERNAL_IP} == ${STANDBY_MASTER_IP} ]; then
	echo "This is a master or standby master node"
	mkdir -p /data1/master
fi

chown gpadmin:gpadmin -R /data*/*