#!/usr/bin/env bash

# Prerequisite: a password-less sudo account

# Display command before executing
set -o xtrace

echo "Installing gpperfmon"

echo "Updating pg_hba"

if [[ $(hostname) == "mdw" ]]; then
	su gpadmin -l -c "gpperfmon_install --enable --password pivotal --port 5432"
	echo "local   gpperfmon         gpmon         md5" >> ${MASTER_DATA_DIRECTORY}/pg_hba.conf
	echo "host    gpperfmon      gpmon        127.0.0.1/28       md5" >> ${MASTER_DATA_DIRECTORY}/pg_hba.conf
	# if [[ -n "$STANDBY" ]] && [[ "$STANDBY" -ge 1 ]]; then
	echo "Copying over .pgpass file to smdw"
	su gpadmin -c "scp ${MASTER_DATA_DIRECTORY}/pg_hba.conf smdw:${MASTER_DATA_DIRECTORY}/pg_hba.conf"
	su gpadmin -c "scp ~/.pgpass smdw:~gpadmin/.pgpass"
	# fi
	echo "Restarting gpdb"
	su gpadmin -l -c "gpstop -a -r"
fi

echo "Initialize GPCC"

# if [[ "$STANDBY" -ge 1 ]]; then
# 	#su gpadmin -l -c  'source /usr/local/greenplum-db/greenplum_path.sh; echo -e "GPDB\nn\nGPDB\n\n\n\nn\nn\nn\ny\nsmdw\n" | gpcmdr --setup' || [[ $? == 255 ]]
su gpadmin -l -c  'source /usr/local/greenplum-db/greenplum_path.sh; echo -e "GPDB\nn\nGPDB\n\n\n\n\n\n\n\nsmdw\n" | gpcmdr --setup' || [[ $? == 255 ]]
# else
# 	#su gpadmin -l -c 'source /usr/local/greenplum-db/greenplum_path.sh; echo -e "GPDB\nn\nGPDB\n\n\n\nn\nn\nn\nn" | gpcmdr --setup' || [[ $? == 255 ]]
# 	su gpadmin -l -c 'source /usr/local/greenplum-db/greenplum_path.sh; echo -e "GPDB\nn\nGPDB\n\n\n\n\n\n\nn\n" | gpcmdr --setup' || [[ $? == 255 ]]
# fi
su gpadmin -l -c 'source /usr/local/greenplum-db/greenplum_path.sh; echo -e "y\n" | gpcmdr --start'
