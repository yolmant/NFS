#!/bin/bash

#this shell script will install and allow you to connect as LDAP user

#update the system to add the latest version of the services
apt-get --yes update && apt-get --yes upgrade && apt-get --yes dist-upgrade

#Disable the interaction with the system
export DEBIAN_FRONTEND=noninteractive

#install ldap and authentication client
apt-get --yes install libpam-ldap nscd
unset DEBIAN_FRONTEND

#installing NFS client
apt-get -y install nfs-common
sed -i "30s,uri ldapi:///,uri ldaps://10.128.0.3/,g" /etc/ldap.conf
#modify ldap.conf 
sed -i "s/base dc=example,dc=net/base dc=NTI\,dc=local/" /etc/ldap.conf
sed -i "30s,uri ldapi:///,uri ldaps://10.128.0.3/,g" /etc/ldap.conf
sed -i "57i port 636" /etc/ldap.conf
sed -i -e "s/pam_password md5/pam_password ssha/" /etc/ldap.conf
sed -i 's,rootbinddn cn=manager\,dc=example\,dc=net,#rootbinddn cn=manager\,dc=example\,dc=net,g' /etc/ldap.conf
sh -c 'echo "TLS_REQCERT allow" >> /etc/ldap/ldap.conf'
					
#modify nsswitch.conf	
sed -i 's,passwd:         compat,passwd:     ldap compat,g' /etc/nsswitch.conf 
sed -i 's,group:          compat,group:      ldap compat,g' /etc/nsswitch.conf
sed -i 's,shadow:         compat,shadow:     ldap compat,g' /etc/nsswitch.conf
sed -i 's,netgroup:       nis,netgroup:       ldap,g' /etc/nsswitch.conf

#modify common-session file
sed -i '$ a\session required      pam_mkhomedir.so skel=/etc/skel umask=0022' /etc/pam.d/common-session
					
#restarting the nscd service
/etc/init.d/nscd restart

#creating a directory for mounts
mkdir -p /NFS/sharedfiles
mkdir -p /NFS/sharedfiles/home
mkdir -p /NFS/sharedfiles/dev
mkdir -p /NFS/sharedfiles/config

#server ip
Ipserver=10.128.0.4

#modify the fstab file to mount our directory from the server
echo "$Ipserver:/NFS/sharedfiles/test  /NFS/sharedfiles  nfs  defaults 0 0" >> /etc/fstab
echo "$Ipserver:/home  /NFS/sharedfiles/home  nfs  defaults 0 0" >> /etc/fstab
echo "$Ipserver:/NFS/dev  /NFS/sharedfiles/dev  nfs  defaults  0 0" >> /etc/fstab
echo "$Ipserver:/NFS/config  /NfS/sharedfiles/config  nfs  defaults  0 0" >> /etc/fstab

#mount the directories
mount -a
