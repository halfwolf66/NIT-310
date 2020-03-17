#!/bin/bash

#syslog
gcloud compute instances create rsyslog-server2 \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-central1-a \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/sfenner89/nti310/logsrv.sh \
--private-network-ip=10.128.0.5

sleep 20s

#LDAP
gcloud compute instances create ldap2 \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-central1-a \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/sfenner89/nti310/LDAP-automated.sh \
--private-network-ip=10.128.0.7

sleep 20s

#nfs server
gcloud compute instances create nfs2 \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-central1-a \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/sfenner89/nti310/nfsserver.sh \
--private-network-ip=10.128.0.12

sleep 20s

#postgres server
gcloud compute instances create postgres1 \
--image-family centos-8 \
--image-project centos-cloud \
--zone us-central1-a \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/sfenner89/nti310/postgres.sh \
--private-network-ip=10.128.0.12

sleep 20s

#Django
gcloud compute instances create django2 \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-central1-a \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/sfenner89/nti310/django.sh \
--private-network-ip=10.128.0.8

#sleep for 3 minutes allowing servers to boot before clients
sleep 3m

#ldapandnsfclient1
gcloud compute instances create ldapandnsfclient1 \
--image-family ubuntu-1804 \
--image-project ubuntu-os-cloud \
--zone us-central1-a \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/sfenner89/nti310/ldap_client.sh \
--private-network-ip=10.128.0.13

#ubuntu with ldap and nsf
gcloud compute instances create ldapandnsfclient2 \
--image-family ubuntu-1804 \
--image-project ubuntu-os-cloud \
--zone us-central1-a \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/sfenner89/nti310/ldap_client.sh \
--private-network-ip=10.128.0.16
