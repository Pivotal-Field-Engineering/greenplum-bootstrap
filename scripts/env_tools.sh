#!/bin/bash -eux


case "$PACKER_BUILDER_TYPE" in

amazon-ebs)
    echo "==> Performing AWS EC2 items that are normally done in kickstart"
    chkconfig iptables off
    /etc/init.d/iptables stop
    setenforce 0
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux 
    /usr/bin/yum -y install kernel-headers kernel-devel gcc make perl curl wget git java-1.7.0-openjdk java-1.7.0-openjdk-devel unzip sudo epel-releases ed sed ntpd xfsprogs
    /usr/sbin/groupadd gpadmin
    /usr/sbin/useradd gpadmin -g gpadmin -G wheel
    /usr/sbin/useradd gpuser -g gpadmin -G wheel
    echo "pivotal"|passwd --stdin gpuser
    echo "gpuser        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
    echo "gpdb-bootstrap.localdomain" > /etc/hostname
    hostname gpdb-gpbootstrap.localdomain
    sed -i "s/NETWORKING=.*/NETWORKING=yes/g" /etc/sysconfig/network
    sed -i "s/HOSTNAME=.*/HOSTNAME=gpdb-bootstrap.localdomain/g" /etc/sysconfig/network
   ;;

*)
    echo "==> Unknown Packer Build Type >>$PACKER_BUILDER_TYPE<< "
    ;;

esac
