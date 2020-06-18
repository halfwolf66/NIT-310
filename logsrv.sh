#!/bin/bash
for file in $( ls /etc/yum.repos.d/ ); do mv /etc/yum.repos.d/$file /etc/yum.repos.d/$file.bak; done
ip="10.128.0.53"
echo "[nti-310-epel]
name=NTI310 EPEL
baseurl=http://104.197.59.12/epel
gpgcheck=0
enabled=1" >> /etc/yum.repos.d/local-repo.repo
echo "[nti-310-base]
name=NTI310 BASE
baseurl=http://104.197.59.12/base
gpgcheck=0
enabled=1" >> /etc/yum.repos.d/local-repo.repo
echo "[nti-310-extras]
name=NTI310 EXTRAS
baseurl=http://104.197.59.12/extras/
gpgcheck=0
enabled=1" >> /etc/yum.repos.d/local-repo.repo
echo "[nti-310-updates]
name=NTI310 UPDATES
baseurl=http://104.197.59.12/updates/
gpgcheck=0
enabled=1" >> /etc/yum.repos.d/local-repo.repo
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch <- example epel repo
# Note, this is putting repodata at packages instead of 7 and our path is a hack around that.
baseurl=http://10.128.0.53/centos/7/extras/x86_64/Packages/
enabled=1
gpgcheck=0
" > /etc/yum.repos.d/NTI-320.repo

sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf
sed -i 's/#$InputTCPServerRun 514/$InputTCPServerRun 514/g' /etc/rsyslog.conf
sed -i 's/#$ModLoad imtcp/$ModLoad imtcp/g' /etc/rsyslog.conf
sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf
setenforce 0
systemctl restart rsyslog
netstat -antup | grep 514

#echo "*.info;mail.none;authpriv.none   @rsyslog" >> /etc/rsyslog.conf && systemctl restart rsyslog.service

yum install -y nagios-plugins nrpe nagios-plugins-load nagios-plugins-ping nagios-plugins-disk nagios-plugins-http nagios-plugins-procs nagios-plugins-all wget
wget -O /usr/lib64/nagios/plugins/check_mem.sh https://raw.githubusercontent.com/nic-instruction/hello-nti-320/master/check_mem.sh
chmod +x /usr/lib64/nagios/plugins/check_mem.sh
systemctl enable nrpe
systemctl start nrpe
sed -i 's/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, 10.128.0.2/g' /etc/nagios/nrpe.cfg
echo "command[check_disk]=/usr/lib64/nagios/plugins/check_disk -w 20% -c 10% -p /dev/disk" >> /etc/nagios/nrpe.cfg
echo "command[check_mem]=/usr/lib64/nagios/plugins/check_mem.sh -w 80 -c 90" >> /etc/nagios/nrpe.cfg
systemctl restart nrpe
