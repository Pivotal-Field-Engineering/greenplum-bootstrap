#!/usr/bin/env bash

##############################################
# Prerequisite: a password-less sudo account #
##############################################

# Display command before executing
set -o xtrace

echo "Running GPDB installer"
unzip greenplum-db*.zip

GREENPLUM_DB=`find . -name greenplum-db*.bin`
chmod a+x ${GREENPLUM_DB}
echo -e "yes\n\nyes\nyes\n" | MORE=-1000 sh ${GREENPLUM_DB}
chown -R gpadmin:gpadmin /usr/local/greenplum-db*
chmod -R 777 /usr/local/greenplum-db*
