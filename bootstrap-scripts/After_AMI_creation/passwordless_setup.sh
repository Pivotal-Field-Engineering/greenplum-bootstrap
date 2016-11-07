#!/usr/bin/env bash

# Prerequisite: a password-less sudo account

# Display command before executing
set -o xtrace


echo y|ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
cat /home/gpadmin/.ssh/id_rsa.pub >> /home/gpadmin/.ssh/authorized_keys

while IFS= read -r line; do
	IFS=' ' read -r -a array <<< "$line"
	if [  "${array[1]}" != `hostname` ]; then
		echo -e "\e[33m*** Setting passwordless ssh between `hostname` to ${array[1]} ***\e[0m"
		/usr/bin/expect << EOF
		set timeout 30
		spawn ssh-copy-id -i /home/gpadmin/.ssh/id_rsa.pub ${array[1]}
		expect {
			"(yes/no)" {send "yes\r"; exp_continue}
			"password:" {send "gpadmin\r"}
		}
		expect eof
EOF
    fi
done < ${IP_HOSTS_MAPPING}