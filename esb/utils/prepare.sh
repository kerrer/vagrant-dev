#!/usr/bin/env bash
if [ -f "/var/vagrant_prepare" ]; then
 exit 0
fi
touch /var/vagrant_prepare

echo "Asia/Shanghai" | sudo tee /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

locale-gen zh_CN.UTF-8
update-locale LANG=zh_CN.UTF-8 LC_MESSAGES=POSIX
dpkg-reconfigure  --frontend noninteractive locales

sed -i.bak '1 r /utils/sohu.mirrors.ubutnu.14' /etc/apt/sources.list
#apt-get update >/dev/null 2>&1

wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update
puppet resource package puppetmaster ensure=latest
