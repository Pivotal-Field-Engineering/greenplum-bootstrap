#!/usr/bin/env bash

# Prerequisite: a password-less sudo account

# Display command before executing
set -o xtrace

SEGMENTS=$1
MASTER_DATA_DIRECTORY=$2

echo "Adding ETL hosts to pg_hba.conf"
for IP in $INTERNAL_ETL_IPS; do
  echo -e "host\tall\tgpadmin\t${IP}/32\ttrust" >> "${MASTER_DATA_DIRECTORY}/pg_hba.conf"
done

if [[ $(hostname) == "smdw" ]]; then
  exit
fi

echo "Setting GUCS for ${SEGMENTS} segments"

gpconfig -c optimizer -v on

CORES=$(cat /proc/cpuinfo | grep -c processor)
CORES_PER_SEGMENT=$(bc <<< "scale=2; ${CORES}/${SEGMENTS}")
gpconfig -c gp_resqueue_priority_cpucores_per_segment -v ${CORES_PER_SEGMENT} -m ${CORES}

RAM=$(free -g | grep Mem | xargs | cut -f2 -d' ')
if [[ $RAM -ge 128 ]]; then
  AV_RAM=$(( $RAM - 32 ))
else
  AV_RAM=$(( $RAM - 16 ))
fi
RAM_PER_SEGMENT=$(( $AV_RAM / $SEGMENTS ))
RAM_PER_SEGMENT_KB=$(( $RAM_PER_SEGMENT * 1024 * 1024 ))

gpconfig -c gp_vmem_protect_limit -v ${RAM_PER_SEGMENT_KB}
gpconfig -c max_statement_mem -v ${RAM_PER_SEGMENT}GB

echo "Reloading database"
gpstop -a -r