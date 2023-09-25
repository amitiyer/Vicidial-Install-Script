#!/bin/bash
echo
echo
echo "=========By Amit Iyer================";
echo "=========amitiyer@hotmail.com========";
echo "Vicidial Custom Install CentOS 7.";
echo

sleep 3

yum check-update
yum update -y
yum -y install epel-release
yum -y groupinstall 'Development Tools'
yum -y update
yum install -y kernel*
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
timedatectl set-timezone America/New_York
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils
yum-config-manager --enable remi-php74
yum update -y

reboot
