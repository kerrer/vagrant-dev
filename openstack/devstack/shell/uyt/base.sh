#!/usr/bin/env bash

#apt-get install -y software-properties-common
#apt-get -y install build-essential openssl  libcurl4-openssl-dev  zlib1g-dev  libpq-dev  libxml2  libxml2-dev  libxslt1-dev  libsasl2-dev  libjpeg-dev libbz2-dev libsqlite3-dev libreadline-dev
#apt-get install curl -y


INTALL_PUPPET="gem update --system && gem list -i -q puppet && echo 'puppet installed' || gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/ &&   gem install  puppet ruby-augeas -N -V"

function setMirrors {
  sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
  apt-get update
}


function install_ruby {
    apt-get install ruby2.3  ruby2.3-dev  
    gem install puppet ruby-augeas -N -V
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

grep -n 'mirrors.163.com' /etc/apt/sources.list && echo yes || setMirrors 
apt-get install -y augeas-tools  libaugeas-dev

install_ruby






