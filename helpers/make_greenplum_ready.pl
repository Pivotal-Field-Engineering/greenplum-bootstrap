#!/usr/bin/perl
use strict;
use warnings;
system("sed -i '/ephe/d' /etc/fstab");
sleep 2;
system("umount /dev/xvdb");
my @devices = `ls -1 /dev/xvd? | grep -v xvda`;
my $cmd = 'mdadm --create --force --verbose /dev/md0 --level=stripe --raid-devices=' . 
scalar(@devices);

foreach my $device ( @devices ) {
  chomp $device;
  system("dd if=/dev/zero bs=512 count=512 of=$device");
  $cmd .= " $device";
  }
print "$cmd\n";
system "$cmd";
system('mkfs.xfs -f /dev/md0');
sleep 2;
system('echo "/dev/md0 /data xfs rw,noatime,inode64,allocsize=16m" >> /etc/fstab');
sleep 2;
system('mkdir /data');
sleep 2;
system('mount /data');
sleep 2;
system('chown -R gpadmin /data');
sleep 2;
exit;
