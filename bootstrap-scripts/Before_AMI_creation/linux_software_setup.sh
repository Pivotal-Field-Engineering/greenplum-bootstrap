#!/usr/bin/env bash

##############################################
# Prerequisite: a password-less sudo account #
##############################################

# Display command before executing
set -o xtrace

# Clean yum cache
yum clean all
yum update -y
yum install -y xfsprogs mdadm unzip ed ntp postgresql time bc vim
yum groupinstall -y "Development Tools"
yum -y install expect gcc-gfortran gcc-c++ scp unzip tar mlocate httpd ntp ntpd sshpass
# Create or update the database used by locate
updatedb
