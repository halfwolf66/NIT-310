#!/bin/bash
ip="10.128.0.53"
echo "[nti-320]
name=Extra Packages for Centos from NTI-320 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch <- example epel repo
# Note, this is putting repodata at packages instead of 7 and our path is a hack around that.
baseurl=http://10.128.0.53/centos/7/extras/x86_64/Packages/
enabled=1
gpgcheck=0
" > /etc/yum.repos.d/NTI-320.repo

#LDAP Client install
apt-get update
export DEBIAN_FRONTEND=noninteractive
apt -y install libnss-ldap libpam-ldap ldap-utils
unset DEBIAN_FRONTEND

sed -i 's/passwd:         compat systemd/passwd:         compat systemd ldap/g' /etc/nsswitch.conf
sed -i 's/group:          compat systemd/group:          compat systemd ldap/g' /etc/nsswitch.conf
sed -i 's/password        \[success=1 user_unknown=ignore default=die\]     pam_ldap.so use_authtok try_first_pass/password        \[success=1 user_unknown=ignore default=die\]     pam_ldap.so try_first_pass/g' /etc/pam.d/common-password
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/base dc=example,dc=net/base dc=nti310,cd=local/g' /etc/ldap.conf
sed -i 's,uri ldapi:///,uri ldap://ldap,g' /etc/ldap.conf
sed -i 's/rootbinddn cn=manager,dc=example,dc=net/rootbinddn cn=ldapadm,dc=nti310,dc=local/g' /etc/ldap.conf
sed -i "s/#nss_base_group.[ \t]*ou=Group,dc=padl,dc=com?one/nss_base_group          ou=Group,dc=nti310,dc=local/g" /etc/ldap.conf
sed -i 's/#nss_base_passwd.[ \t]*ou=People,dc=padl,dc=com?one/nss_base_passwd        ou=People,dc=nti310,dc=local/g' /etc/ldap.conf
sed -i 's/#nss_base_shadow.[ \t]*ou=People,dc=padl,dc=com?one/nss_base_shadow        ou=People,dc=nti310,dc=local/g' /etc/ldap.conf

systemctl restart sshd
echo "Pa$$w0rd" > /etc/ldap.secret
chmod 0600 /etc/ldap.secret
systemctl restart libnss-ldap
apt -y install debconf-utils

echo "ldap-auth-config        ldap-auth-config/rootbindpw     password
ldap-auth-config        ldap-auth-config/bindpw password
ldap-auth-config        ldap-auth-config/ldapns/ldap_version    select      3
ldap-auth-config        ldap-auth-config/rootbinddn     string  cn=ldapadm,dc=nti310,dc=local
ldap-auth-config        ldap-auth-config/dbrootlogin    boolean true
ldap-auth-config        ldap-auth-config/pam_password   select  md5
ldap-auth-config        ldap-auth-config/dblogin        boolean false
ldap-auth-config        ldap-auth-config/move-to-debconf        boolean     true
ldap-auth-config        ldap-auth-config/ldapns/base-dn string  dc=nti310,dc=local
ldap-auth-config        ldap-auth-config/override       boolean true
ldap-auth-config        ldap-auth-config/ldapns/ldap-server     string      ldap://ldap
ldap-auth-config        ldap-auth-config/binddn string  cn=proxyuser,dc=example,dc=net" > /tmp/ldap_debconf

while read line; do echo "$line" | debconf-set-selections; done < /tmp/ldap_debconf

apt-get install -y nfs-client

showmount -e 10.128.0.8 # where #ip address is the ip of your nfs server
mkdir /mnt/test
echo "10.128.0.8:/var/nfsshare/testing    /mnt/test     nfs   defaults 0 0" >> /etc/fstab
mount -a



