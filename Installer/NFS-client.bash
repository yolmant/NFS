!#/bin/bash

#configuration of NFS client in ubuntu
#install the NFS
apt-get -y install nfs-common

#creat a directory for the mounts
mkdir -p /NFS/home

#modify the fstab file to mount our directory from the server
sh -c 'echo "10.128.0.4:/NFS/sharedfiles  /NFS/home  nfs  defaults  0 0" >> /etc/fstab

#mount the directory
mount -a
