#!/usr/bin/env bash
if [ ! -f "/var/vagrant_prepare" ]; then

#apt-get install -y software-properties-common
#apt-get -y install build-essential openssl  libcurl4-openssl-dev  zlib1g-dev  libpq-dev  libxml2  libxml2-dev  libxslt1-dev  libsasl2-dev  libjpeg-dev libbz2-dev libsqlite3-dev libreadline-dev
#apt-get install curl -y

sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
cat >> /etc/pip.conf <<END 
[global]
trusted-host=mirrors.aliyun.com 
index-url=http://mirrors.aliyun.com/pypi/simple/ 
END

#apt-get install -y software-properties-common
#apt-add-repository ppa:brightbox/ruby-ng
#apt-get update

#apt-get autoremove -y  puppet 
#apt-get install -y ruby2.3  ruby2.3-dev ruby-switch ruby-augeas
#ruby-switch --set ruby2.3
#gem sources --remove http://rubygems.org/
#gem sources -a https://ruby.taobao.org/
#gem install  puppet  -N -V

apt-get update
apt-get install -y puppet  ruby-augeas
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/

touch /var/vagrant_prepare
fi

