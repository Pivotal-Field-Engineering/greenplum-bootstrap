
	 
	
# Greenplum Database Bootstrap Builder
####Packer-Based AWS Greenplum Environment Build Tool for the Greenplum Database

**Requirements:**  

* Packer  
* S3 tools  

Modifications Required:  
			
1. Install Packer  
2. Clone Repo  
4. execute: `packer build -force gpdb-bootstrap-multi.json`  
  or to build either vbox or vmware add "-only=vbox" or "-only=vmware" or "-only=aws"

This will generate the OVA which can then be imported into VirtualBox, and/or a zip file for use with VMware
and/or a AWS AMI

#### AMIs from the last run
* us-east-1: ami-c51255d2
* us-west-1: ami-d3aee0b3
* us-west-2: ami-dc518ebc

#### Base AMI Notes and changes

* 20160927 - ami-29084f3e
** yum update
** added :git, epel, dkms
** kernel-2.6.32-642.4.2
** ixgbevf 3.2.2 for enhanced networking in AWS
** AWS CLI Bundle installed
** Set sriovNetSupport to simple
** added make_greenplum_ready.pl utility script to /root which will raid and format additional devices as one xfs volume

* 20160923 - ami-c74105d0 
**Changed AMI Image to be 40G
