#!/usr/bin/env bash

##############################################
# Prerequisite: a password-less sudo account #
##############################################

# display command before executing
set -o xtrace

# install aws-cfn-bootstrap
easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz
#curl -O https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz
#tar -zxvf aws-cfn-bootstrap*.tar.gz
#cd aws-cfn-bootstrap-*/ && python setup.py install && cd ..

curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install awscli
