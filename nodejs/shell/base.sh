#!/usr/bin/env bash
if [ -f "/var/vagrant_prepare" ]; then
 exit 0
fi
touch /var/vagrant_prepare

apt-get -y update
apt-get install -y software-properties-common
#apt-get -y install build-essential openssl  libcurl4-openssl-dev  zlib1g-dev  libpq-dev  libxml2  libxml2-dev  libxslt1-dev  libsasl2-dev  libjpeg-dev libbz2-dev libsqlite3-dev libreadline-dev

CNPM="alias cnpm=\"npm --registry=http://registry.npm.taobao.org  --cache=~/.npm/.cache/cnpm   --disturl=http://registry.npm.taobao.org/mirrors/node   --userconfig=~/.cnpmrc\"" 
echo $CNPM >> $HOME/.bashrc 
echo $CNPM >> /home/vagrant/.bashrc 
