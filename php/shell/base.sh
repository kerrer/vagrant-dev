#!/usr/bin/env bash
if [ -f "/var/vagrant_prepare2" ]; then
 exit 0
fi
touch /var/vagrant_prepare2

apt-get update 
apt-get install -y software-properties-common

