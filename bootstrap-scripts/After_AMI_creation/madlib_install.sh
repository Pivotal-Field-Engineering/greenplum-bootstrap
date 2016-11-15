#!/usr/bin/env bash

##############################################
# Prerequisite: a password-less sudo account #
##############################################

# Display command before executing
set -o xtrace

source /usr/local/greenplum-db/greenplum_path.sh
MADLIB_PKG=`find . -name madlib*.tar.gz`
tar -zxvf $MADLIB_PKG
MADLIB=`find . -name madlib*.gppkg`
gppkg -i $MADLIB
$GPHOME/madlib/bin/madpack install -s madlib -p greenplum -c gpadmin@mdw:5432/postgres