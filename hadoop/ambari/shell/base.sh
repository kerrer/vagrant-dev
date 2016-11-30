#!/usr/bin/env bash

#apt-get install -y software-properties-common
#apt-get -y install build-essential openssl  libcurl4-openssl-dev  zlib1g-dev  libpq-dev  libxml2  libxml2-dev  libxslt1-dev  libsasl2-dev  libjpeg-dev libbz2-dev libsqlite3-dev libreadline-dev
#apt-get install curl -y

MIRROR="http://mirrors.163.com/.help/CentOS7-Base-163.repo"
PROXY="http://172.17.0.4:3142"
RUBYENV="/etc/profile.d/rh-ruby22.sh"
INTALL_PUPPET=" gem update --system && gem list -i -q puppet && echo 'puppet installed' || gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/ &&   gem install  puppet ruby-augeas -N -V"
function setMirrors {
  mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
  curl $MIRROR -o /etc/yum.repos.d/CentOS-Base.repo
  yum clean all && yum makecache
}


function install_ruby {
   yum install -y centos-release-scl 
   yum update
   yum --enablerepo=centos-sclo-rh --nogpgcheck  install -y rh-ruby23 rh-ruby23-ruby-devel   
}



#apt-get install -y software-properties-common
#apt-add-repository ppa:brightbox/ruby-ng
#apt-get update

#apt-get autoremove -y  puppet 
#apt-get install -y ruby2.3  ruby2.3-dev ruby-switch ruby-augeas
#ruby-switch --set ruby2.3
#gem sources --remove http://rubygems.org/
#gem sources -a https://ruby.taobao.org/
#gem install  puppet  -N -V

grep -n 'mirrors.163.com' /etc/yum.repos.d/CentOS-Base.repo && echo yes || setMirrors 
yum install -y augeas augeas-devel

augtool -s set /files/etc/yum.conf/main/provy $PROXY

yum -q list installed rh-ruby23  &>/dev/null && echo "rh-ruby23 Installed" || install_ruby

scl enable rh-ruby23 "$INTALL_PUPPET"




[ -f $RUBYENV ] && echo "Found" || cat >> $RUBYENV <<END
#!/bin/bash

source /opt/rh/rh-ruby23/enable
export X_SCLS="`scl enable rh-ruby23 'echo $X_SCLS'`"
export PATH=$PATH:/opt/rh/rh-ruby23/root/usr/bin:/opt/rh/rh-ruby23/root/usr/local/bin/
END


