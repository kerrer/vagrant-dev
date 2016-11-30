#!/usr/bin/env bash
if [ -f "/var/vagrant_prepare" ]; then
 exit 0
fi
touch /var/vagrant_prepare

wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update  && apt-get install -y puppet
puppet resource package puppetmaster ensure=latest
