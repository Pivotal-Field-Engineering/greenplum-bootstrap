
	 
	
# Greenplum Database Bootstrap Builder
####Packer-Based Virtual Appliance Build Tool for the Greenplum Database

**Requirements:**  

* Packer  
* Virtual Box, VMware Fusion, S3 tools  
* Greenplum Database Binaries  

Modifications Required:  
			
  * Change the following entry in the gpdb-bootstrap.json file to point to the 
  	 absolute path of the directory where you have stored the binaries.  Make
  	 sure and end the "source"	entry with a /.   This keeps the directory
  	 structure the tool is expecting intact.	 

        {
              "type": "file",   
              "source": "/Users/scottkahler/Software/GREENPLUM/",   
              "destination": "/tmp/bins/"  
        }
        

 
1. Install Packer  
2. Clone Repo  
3. Modify json to point to binary location  
4. execute: `packer build -force gpdb-bootstrap-multi.json`  
  or to build either vbox or vmware add "-only=vbox" or "-only=vmware" or "-only=aws"

This will generate the OVA which can then be imported into VirtualBox, and/or a zip file for use with VMware
and/or a AWS AMI

####AMIs from the last run
* us-east-1: ami-794f0b6e
* us-west-1: ami-a98bc5c9
* us-west-2: ami-270dd247

