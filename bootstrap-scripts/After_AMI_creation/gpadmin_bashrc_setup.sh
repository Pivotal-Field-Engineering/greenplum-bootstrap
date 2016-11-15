#!/usr/bin/env bash

# Prerequisite: a password-less sudo account

# Display command before executing
set -o xtrace

if [ ${MY_INTERNAL_IP} == ${MASTER_IP} ] || [ ${MY_INTERNAL_IP} == ${STANDBY_MASTER_IP} ]; then
	echo "export MASTER_DATA_DIRECTORY=${MASTER_DATA_DIRECTORY}" >> /home/gpadmin/.bashrc
fi
echo "source /usr/local/greenplum-db/greenplum_path.sh" >> /home/gpadmin/.bashrc
echo "export GPPERFMONHOME=/usr/local/greenplum-cc-web" >> /home/gpadmin/.bashrc
echo "source \$GPPERFMONHOME/gpcc_path.sh" >> /home/gpadmin/.bashrc