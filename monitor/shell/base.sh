#!/usr/bin/env bash
if [ -f "/var/vagrant_prepare" ]; then
 exit 0
fi
touch /var/vagrant_prepare

apt-get -y install curl
