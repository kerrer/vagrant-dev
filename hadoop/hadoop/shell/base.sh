#!/usr/bin/env bash
if [ ! -f "/var/vagrant_prepare2" ]; then

#apt-get install -y software-properties-common
#apt-get -y install build-essential openssl  libcurl4-openssl-dev  zlib1g-dev  libpq-dev  libxml2  libxml2-dev  libxslt1-dev  libsasl2-dev  libjpeg-dev libbz2-dev libsqlite3-dev libreadline-dev
#apt-get install curl -y
mv /etc/apt/sources.list /etc/apt/sources.list.backup
cp /vagrant/shell/sources.list.trusty /etc/apt/sources.list


#apt-get install -y software-properties-common
#apt-add-repository ppa:brightbox/ruby-ng
#apt-get update

#apt-get autoremove -y  puppet 
#apt-get install -y ruby2.3  ruby2.3-dev ruby-switch ruby-augeas
#ruby-switch --set ruby2.3
#gem sources --remove http://rubygems.org/
#gem sources -a https://ruby.taobao.org/
#gem install  puppet  -N -V


cp /vagrant/shell/cloudera.list /etc/apt/sources.list.d/cloudera.list


cat >> /etc/apt/apt.conf.d/16proxy <<END 
Acquire::HTTP::Proxy "http://172.17.0.3:3142";
Acquire::HTTPS::Proxy "false";
END

cat > /etc/apt/preferences.d/cloudera.pref <<END
Package: *
Pin: release o=Cloudera, l=Cloudera
Pin-Priority: 501
END

cat >> /etc/profile.d/java.sh  <<END
#!/bin/sh

export JAVA_HOME="/opt/jdk1.8.0_51"
export PATH=$PATH:$JAVA_HOME/bin
END

curl -s http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -

apt-get update
apt-get autoremove -y  puppet 
apt-get install -y  ruby-augeas
gem update --system
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
gem install  puppet  -N -V

touch /var/vagrant_prepare
fi

