#!/usr/bin/env bash
source /tmp/release.properties
set -e

get_versions(){
shopt -s nullglob
echo $BUILD_NAME Build Started
for filename in /tmp/bins/*
do
	justfile=${filename:10}
        case $justfile in
                *greenplum-db*) gpdb=$justfile
				strip_ext $justfile
				echo "GPDB_FILE=$gpdb" >> /tmp/release.properties
				echo "GPDB_VERSION=$shortname" >> /tmp/release.properties
				gpdbnum=${gpdb:13}
				echo "GPDB_VERSION_NUMBER=${gpdbnum%%-*}" >>/tmp/release.properties 
				;;
                *)              echo "UNrecognized File: $justfile"
                                ;;

        esac
done
}


strip_ext(){
 case ${1##*.} in
        *gppkg)        shortname=${1%.gppkg};;
        *zip)          shortname=${1%.zip};;
        *tar)          shortname=${1%.tar};;
        *gz)           shortname=${1%.tar.gz};;
 esac
}


install_binaries(){
source /tmp/release.properties
yum -y install unzip

unzip  /tmp/bins/$GPDB_VERSION.zip -d /tmp/bins/

sed -i 's/more <</cat <</g' /tmp/bins/$GPDB_VERSION.bin
sed -i 's/agreed=/agreed=1/' /tmp/bins/$GPDB_VERSION.bin
sed -i 's/pathVerification=/pathVerification=1/' /tmp/bins/$GPDB_VERSION.bin
sed -i '/defaultInstallPath=/a installPath=${defaultInstallPath}' /tmp/bins/$GPDB_VERSION.bin

/tmp/bins/$GPDB_VERSION.bin 

chown -R gpadmin: /usr/local/greenplum*

}

setup_gpdb(){

fqdn="$BOOTSTRAP.localdomain"
hostsfile="/etc/hosts"
shortname=$(echo "$fqdn" | cut -d "." -f1)
ip=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
#ip=$(/sbin/ifconfig | perl -e 'while (<>) { if (/inet +addr:((\d+\.){3}\d+)\s+/ and $1 ne "127.0.0.1") { $ip = $1; break; } } print "$ip\n"; ' )
cat > $hostsfile <<HOSTS
#This file is automatically genreated on boot; updated at $(date)
127.0.0.1 localhost.localdomain localhost

$ip $fqdn $shortname
HOSTS
 echo $fqdn >> /usr/local/greenplum-db/hostsfile
 source /usr/local/greenplum-db/greenplum_path.sh
}

setup_configs(){
echo "==> Setting up sysctl and limits"
cat /tmp/configs/sysctl.conf.add >> /etc/sysctl.conf
cat /tmp/configs/limits.conf.add >> /etc/security/limits.conf
}

setup_ipaddress() {
echo "==> IP Address Setup"
rm -rf /etc/udev/rules.d/70-persistent-net.rules
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth*

}

setup_hostname() {
echo "==> Hostname Setup"
}


setup_message(){
echo "==> Message Setup"
}



_main() {
	get_versions
	setup_hostname
	setup_ipaddress
	install_binaries
}



_main "$@"
