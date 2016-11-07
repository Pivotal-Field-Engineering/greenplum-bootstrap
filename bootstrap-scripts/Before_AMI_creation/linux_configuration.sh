#!/usr/bin/env bash

##############################################
# Prerequisite: a password-less sudo account #
##############################################

# display command before executing
set -o xtrace

# disable the need for a tty when running sudo
sed -i '/Defaults[[:space:]]\+!*requiretty/s/^/#/' /etc/sudoers



# disable SELinux
setenforce 0
if test -f /etc/selinux/config; then
    sed -i s/SELINUX=enforcing/SELINUX=disabled/ /etc/selinux/config
fi
if test -f /selinux/enforce; then
   echo 0 > /selinux/enforce
fi



# turn off iptables and ip6tables
if test -f /etc/init.d/iptables; then
    /etc/init.d/iptables save
    /etc/init.d/iptables stop
fi
if test -f /etc/init.d/ip6tables; then
    /etc/init.d/ip6tables save
    /etc/init.d/ip6tables stop
fi
# persist the config
chkconfig iptables off
chkconfig ip6tables off
service iptables stop
service ip6tables stop



# start ntpd on boot
service ntpd start
service ntpd status
chkconfig ntpd on



# Disable Transparent Huge Pages THP
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
   echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
   echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
# Make THP disable persist across reboot
cat << EOF >> /etc/rc.d/rc.local
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
   echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
   echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
EOF



# linux.sysctl settings
cat<<EOF >> /etc/sysctl.conf
###### Newly Added ######
kernel.shmmax = 500000000
kernel.shmmni = 4096
kernel.shmall = 4000000000
kernel.sem = 250 512000 100 2048
kernel.sysrq = 1
kernel.core_uses_pid = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.msgmni = 2048
net.ipv4.tcp_syncookies = 1
net.ipv4.ip_forward = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.conf.all.arp_filter = 1
net.ipv4.ip_local_port_range = 1025 65535
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.core.netdev_max_backlog = 10000
net.core.rmem_max = 2097152
net.core.wmem_max = 2097152
vm.overcommit_memory = 2
EOF
# become effective immediately
sysctl -p



# linux.sysctl settings
cat<<EOF >> /etc/security/limits.conf
###### Newly Added ######
* soft nofile 65536
* hard nofile 65536
* soft nproc 131072
* hard nproc 131072
EOF
# For RedHat Enterprise Linux 6.x and CentOS 6.x, 
# parameter values in the /etc/security/limits.d/90-nproc.conf 
# file override the values in the limits.conf file. 
# If a parameter value is set in both conf files, ensure that the 
# parameter is set properly in the 90-nproc.conf file. 
# The Linux module pam_limits sets user limits by reading the 
# values from the limits.conf file and then from the 90-nproc.conf file. 
# For information about PAM and user limits, 
# see the documentation on PAM and pam_limits.
cat<<EOF >> /etc/security/limits.d/90-nproc.conf
###### Newly Added ######
* soft nofile 65536
* hard nofile 65536
* soft nproc 131072
* hard nproc 131072
EOF



# The Linux disk I/O scheduler for disk access supports different policies, 
# such as CFQ, AS, and deadline.
# Greenplum recommends the following scheduler option: deadline.
for BLOCKDEV in /sys/block/*/queue/scheduler; do
    echo deadline > "$BLOCKDEV"
done
# You can specify the I/O scheduler at boot time with the elevator kernel parameter. 
# Add the parameter elevator=deadline to the kernel command in the file /boot/grub/grub.conf, 
# the GRUB boot loader configuration file.
sed -i -r "s/kernel(.+)/kernel\1 elevator=deadline transparent_hugepage=never/" /boot/grub/grub.conf