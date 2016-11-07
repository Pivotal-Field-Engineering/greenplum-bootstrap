#!/usr/bin/env bash

##############################################
# Prerequisite: a password-less sudo account #
##############################################

# Display command before executing
set -o xtrace

sed -i 's/^#\{0,1\}PubkeyAuthentication.*/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^#\{0,1\}PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config

service sshd restart