#!/usr/bin/env bash

##############################################
# Prerequisite: a password-less sudo account #
##############################################

# Display command before executing
set -o xtrace

echo "Running GPDB Comand Center installer"
unzip greenplum-cc*.zip

GREENPLUM_CC=`find . -name greenplum-cc*.bin`
chmod a+x ${GREENPLUM_CC}
echo -e "yes\n\nyes\nyes\n" | MORE=-1000 sh ${GREENPLUM_CC}
chown -R gpadmin:gpadmin /usr/local/greenplum-cc-web*
chmod -R 777 /usr/local/greenplum-cc-web*
