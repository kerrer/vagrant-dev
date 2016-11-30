#!/usr/bin/env bash

apt-get install -y  apache2-utils

if [ -f "/var/nagios_core_installed" ]; then
    echo "nagios_core_installed already installed"	
else
   cd /home/vagrant
	tar -C /home/vagrant -xzf /vagrant/soft/nagios-4.1.0rc1.tar.gz
	cd /home/vagrant/nagios-4.1.0rc1
	./configure --with-command-group=nagcmd
	make all
	make install
	make install-init
	make install-config
	make install-commandmode
	make install-webconf
	htpasswd -cb /usr/local/nagios/etc/htpasswd.users nagiosadmin  mmmm
	touch /var/nagios_core_installed
fi

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

exit 0
