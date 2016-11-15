#!/usr/bin/env bash

##############################################
# Prerequisite: a password-less sudo account #
##############################################

# Display command before executing
set -o xtrace

echo "Creating use gpadmin"
# Add user gpadmin with password gpadmin
password=gpadmin
getent passwd gpadmin || useradd -m gpadmin
passwd gpadmin << EOF
$password
$password
EOF