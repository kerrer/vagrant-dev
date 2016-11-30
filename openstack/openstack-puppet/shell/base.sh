#!/usr/bin/env bash
if [ -f "/var/vagrant_prepare" ]; then
 exit 0
fi
touch /var/vagrant_prepare

#apt-get install -y software-properties-common
#apt-get -y install build-essential openssl  libcurl4-openssl-dev  zlib1g-dev  libpq-dev  libxml2  libxml2-dev  libxslt1-dev  libsasl2-dev  libjpeg-dev libbz2-dev libsqlite3-dev libreadline-dev
#apt-get install curl -y
mv /etc/apt/sources.list /etc/apt/sources.list.backup
#curl http://mirrors.163.com/.help/sources.list.trusty -o /etc/apt/sources.list
cp /vagrant/shell/sources.list.trusty /etc/apt/sources.list

cat >> /etc/apt/apt.conf.d/16proxy <<END 
Acquire::HTTP::Proxy "http://172.17.0.8:3142";
Acquire::HTTPS::Proxy "false";
END

apt-get update
apt-get -y install git curl
