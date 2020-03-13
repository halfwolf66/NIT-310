#from the client (ubuntu machine)
#!bin/bash/
apt-get install nfs-client

showmount -e $ipaddress # where #ip address is the ip of your nfs server
mkdir /mnt/test
echo "10.128.0.35:/var/nfsshare/testing    /mnt/test     nfs   defaults 0 0" >> /etc/fstab
mount -a
*profit*
