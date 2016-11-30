#!/usr/bin/env bash

apt-get install -y  libssl-dev

if [ -f "/var/nagios_plugins_installed" ]; then
  echo "nagios-plugins already installed"
else
  cd /home/vagrant
  tar -C /home/vagrant -xzf /vagrant/soft/nagios-plugins-2.0.3.tar.gz
  cd /home/vagrant/nagios-plugins-2.0.3
  ./configure --with-nagios-user=nagios --with-nagios-group=nagios
  make
  make install
  touch /var/nagios_plugins_installed
fi


if [ -f "/var/nrpe_installed" ]; then
    echo "nrpe has already installed"
else
  cd /home/vagrant
  tar -C /home/vagrant -xzf /vagrant/soft/nrpe-2.15.tar.gz
  cd /home/vagrant/nrpe-2.15
  ./configure --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu
  make all
  make install-plugin
  make install-daemon
  make install-daemon-config
  touch /var/nrpe_installed
fi

exit 0

#/usr/local/nagios/bin/nrpe  -c /usr/local/nagios/etc/nrpe.cfg  -d
