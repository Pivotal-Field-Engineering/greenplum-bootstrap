#!/usr/bin/env bash

# Prerequisite: a password-less sudo account

# Display command before executing

echo "generating ip host mapping file ${IP_HOSTS_MAPPING}"
awk '{if (NR==1) {printf "%s mdw\n",$0} else if (NR==2) {printf "%s smdw\n",$0} else printf "%s sdw%d\n",$0,NR-2}' ${INTERNAL_IP_FILE} > ${IP_HOSTS_MAPPING}
cat ${IP_HOSTS_MAPPING} | cut -d" " -f2 > ${HOSTNAME_FILE}

# Update /etc/hosts
echo "Updating /etc/hosts"
HOSTFILE_HEAD="# BEGIN GENERATED CONTENT"
HOSTFILE_TAIL="# END GENERATED CONTENT"
sed -i -e "/$HOSTFILE_HEAD/,/$HOSTFILE_TAIL/d" /etc/hosts
echo "$HOSTFILE_HEAD" >> /etc/hosts
cat "${IP_HOSTS_MAPPING}" >> /etc/hosts
echo "$HOSTFILE_TAIL" >> /etc/hosts

while IFS= read -r line; do
	IFS=' ' read -r -a array <<< "$line"
	if [  "${array[0]}" = "$MY_INTERNAL_IP" ]; then
		echo -e "\e[33m*** Updating hostname of ${array[0]} to ${array[1]} ***\e[0m"
		hostname ${array[1]}
		echo "Testing..."
		echo -e "\e[32m`hostname`\e[0m"
		echo -e "\e[33m*** Updating /etc/sysconfig/network of ${array[1]}(${array[0]}) ***\e[0m"
		printf '%s\n%s\n%s\n%s\n' 'NETWORKING=yes' 'NETWORKING_IPV6=no' "HOSTNAME=`hostname --fqdn`" 'NOZEROCONF=yes' > /etc/sysconfig/network
		echo "Testing..."
		echo -e "\e[32m`cat /etc/sysconfig/network`\e[0m"
    fi
done < ${IP_HOSTS_MAPPING}