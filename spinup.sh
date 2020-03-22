#!bin/bash

gcloud compute instances create rsyslog-server2 \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-central1-a \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/irishman253/NIT-310/logsrv.sh \
--private-network-ip=10.128.0.17

sleep 20s

gcloud compute instances create ldap2 \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-central1-a \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/irishman253/NIT-310/LDAP \
--private-network-ip=10.128.0.18

sleep 20s
#nfs server
gcloud compute instances create nfs-server2 \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-central1-a \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/irishman253/NIT-310/nfsserver \
--private-network-ip=10.128.0.19

sleep 20s

#postgres server
gcloud compute instances create postgres1 \
--image-family centos-8 \
--image-project centos-cloud \
--zone us-central1-a \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/irishman253/NIT-310/postgres \
--private-network-ip=10.128.0.22

sleep 20s

#Django
gcloud compute instances create django2 \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-central1-a \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/irishman253/NIT-310/django.sh \
--private-network-ip=10.128.0.23

#sleep for 3 minutes allowing servers to boot before client
sleep 3m

#ldapandnsfclient1
gcloud compute instances create ldapandnsfclient1 \
--image-family ubuntu-1804-lts \
--image-project ubuntu-os-cloud \
--zone us-central1-a \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/irishman253/NIT-310/ldapclient.sh \
--private-network-ip=10.128.0.24

#ubuntu with ldap and nsf
gcloud compute instances create ldapandnsfclient2 \
--image-family ubuntu-1804-lts \
--image-project ubuntu-os-cloud \
--zone us-central1-a \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/irishman253/NIT-310/ldapclient.sh \
--private-network-ip=10.128.0.25
