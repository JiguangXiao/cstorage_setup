#!/bin/bash

echo "########## remove samba ##########"
rpm -e --nodeps samba-common-4.7.1-6.el7.noarch
rpm -e --nodeps samba-4.7.1-6.el7.x86_64
rpm -e --nodeps samba-common-tools-4.7.1-6.el7.x86_64
rpm -e --nodeps samba-common-libs-4.7.1-6.el7.x86_64
rpm -e --nodeps samba-libs-4.7.1-6.el7.x86_64
rpm -e --nodeps samba-client-4.7.1-6.el7.x86_64
rpm -e --nodeps samba-client-libs-4.7.1-6.el7.x86_64

echo "########## install tools ##########"
yum install -y gcc perl python-devel gnutls-devel libacl-devel openldap-devel pam-devel

echo "########## close firewall ##########"
systemctl disable firewalld.service
systemctl stop firewalld.service
setenforce 0
sed -i -e 's|SELINUX=enforcing|SELINUX=disabled|' /etc/selinux/config

echo "########## install samba-4.7.8 ##########"
cp samba-4.7.8.tar.gz /usr/local
cd /usr/local
tar -zxvf samba-4.7.8.tar.gz
cd -
cd /usr/local/samba-4.7.8
./configure && make && make install
echo “/usr/local/samba/lib”>> /etc/ld.so.conf ldconfig

cd -
cp smb.conf /usr/local/samba/etc/
cp cstorage.conf cstorage.license cstorage.msg /etc
cp cstorage.so /usr/local/samba/lib/vfs/
cd /usr/local/samba/lib/vfs/
chmod 755 cstorage.so
cd -

mkdir /cstorage
mkdir /cstorage/resource
mkdir /cstorage/samba
