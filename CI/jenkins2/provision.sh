#!/usr/bin/env bash

if [ -f "/var/cruisecontro" ]; then
   exit 0;
fi

touch /var/cruisecontro

unzip -o /vagrant/cruisecontrol-bin-2.8.4.zip -d /opt/
ln -sf /opt/cruisecontrol-bin-2.8.4 /opt/cruise

chown -R vagrant:vagrant /opt/cruise
