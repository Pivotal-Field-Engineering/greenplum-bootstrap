#!/usr/bin/env bash

# Prerequisite: a password-less sudo account

# Display command before executing
set -o xtrace

echo "Preparing /home/gpadmin/gpconfigs"

mkdir -p /home/gpadmin/gpconfigs
cp /usr/local/greenplum-db/docs/cli_help/gpconfigs/gpinitsystem_config /home/gpadmin/gpconfigs/
echo "$SEGMENT_HOSTS" > /home/gpadmin/gpconfigs/hostfile_gpinitsystem

chown gpadmin:gpadmin -R /home/gpadmin/gpconfigs

sed -i -r "s/#MACHINE_LIST_FILE/MACHINE_LIST_FILE/" /home/gpadmin/gpconfigs/gpinitsystem_config

sed -i -r "s/#MIRROR_PORT_BASE/MIRROR_PORT_BASE/" /home/gpadmin/gpconfigs/gpinitsystem_config
sed -i -r "s/#REPLICATION_PORT_BASE/REPLICATION_PORT_BASE/" /home/gpadmin/gpconfigs/gpinitsystem_config
sed -i -r "s/#MIRROR_REPLICATION_PORT_BASE/MIRROR_REPLICATION_PORT_BASE/" /home/gpadmin/gpconfigs/gpinitsystem_config
sed -i -r "s/#declare -a MIRROR_DATA_DIRECTORY/declare -a MIRROR_DATA_DIRECTORY/" /home/gpadmin/gpconfigs/gpinitsystem_config

sed -i -r "s| DATA_DIRECTORY=\(.*\)| DATA_DIRECTORY\=\(${DATA_DIRECTORY}\)|" /home/gpadmin/gpconfigs/gpinitsystem_config
sed -i -r "s| MIRROR_DATA_DIRECTORY=\(.*\)| MIRROR_DATA_DIRECTORY\=\(${MIRROR_DATA_DIRECTORY}\)|" /home/gpadmin/gpconfigs/gpinitsystem_config

sed -i -r "s|MASTER_DIRECTORY=/data/master|MASTER_DIRECTORY=${MASTER_DIRECTORY}|" /home/gpadmin/gpconfigs/gpinitsystem_config
echo "Running gpinitsystem"

if [ -z "$STANDBY_MASTER_IP" ]; then
	echo "No standby master specified..."
	echo | su - gpadmin -c "bash -c 'gpinitsystem -a -c /home/gpadmin/gpconfigs/gpinitsystem_config'" || [[ $? -lt 2 ]]
else
	echo "Standby master specified IP=$STANDBY_MASTER_IP HOST=$STANDBY_MASTER_HOST"
	echo | su - gpadmin -c "bash -c 'gpinitsystem -a -c /home/gpadmin/gpconfigs/gpinitsystem_config -s smdw'" || [[ $? -lt 2 ]]
fi