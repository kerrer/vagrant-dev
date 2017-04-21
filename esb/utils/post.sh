#!/usr/bin/env bash
if [ -f "/var/vagrant_post2" ]; then
 exit 0
fi
touch /var/vagrant_post


export DEBIAN_FRONTEND=noninteractive
ROOT_PASS="mmmm"
NAZ_DB_NAME="dmc070187_db"
WD_DB_NAME="wordpress"
DB_USER="max"
DB_PASS="mmmm" 

sed -i.bak '1 r /utils/xdebug.ini' /etc/php5/apache2/conf.d/20-xdebug.ini
service apache2 restart

#echo "Installing Apache and php and setting it up..."
#apt-get -y install  apache2  php5 
#apt-get install -y   php5-gd php5-curl php5-xdebug php5-mysql php5-mcrypt

#echo "configure apache ..."
#if [ ! -h /var/www/html ];
#then 
#	rm -rf /var/www/html/*
#	ln -fs /vagrant/public/nazcol /var/www/html/nazcol
#    ln -fs /vagrant/public/new-naz /var/www/html/new-naz
#	a2enmod rewrite
	#sed -i -e 's/AllowOverride None/AllowOverride All/' /etc/apache2/sites-available/default
	#service apache2 restart
#fi

#echo "Installing mysql and  setting it up..."
#debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $ROOT_PASS"
#debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $ROOT_PASS"
#apt-get install -y mysql-server-5.5
#sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/my.cnf
#service mysql restart 

echo "configure mysql ..."
if [ ! -f /var/log/databasesetup ];
then
    touch /var/log/databasesetup
	echo "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS'" | mysql -uroot -p$ROOT_PASS	

	if [ -f /vagrant/data/nazold.sql ];
	then
	    echo "CREATE DATABASE $NAZ_DB_NAME character set utf8" | mysql -uroot -p$ROOT_PASS
	    echo "GRANT ALL ON $NAZ_DB_NAME.* TO '$DB_USER'@'localhost'" | mysql -uroot -p$ROOT_PASS
		mysql -uroot -p$ROOT_PASS $NAZ_DB_NAME < /vagrant/data/nazold.sql
		echo "flush privileges" | mysql -uroot -p$ROOT_PASS	
	fi
	
	if [ -f /vagrant/data/wordpress.sql ];
	then
	    echo "CREATE DATABASE $WD_DB_NAME character set utf8" | mysql -uroot -p$ROOT_PASS
	    echo "GRANT ALL ON $WD_DB_NAME.* TO '$DB_USER'@'localhost'" | mysql -uroot -p$ROOT_PASS
		mysql -uroot -p$ROOT_PASS $WD_DB_NAME < /vagrant/data/wordpress.sql
		echo "flush privileges" | mysql -uroot -p$ROOT_PASS	
	fi
fi

#echo "install phpmyadmin"
#echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
#echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
#echo "phpmyadmin phpmyadmin/mysql/admin-user string root" | debconf-set-selections
#echo "phpmyadmin phpmyadmin/mysql/admin-pass password $ROOT_PASS" | debconf-set-selections
#echo "phpmyadmin phpmyadmin/mysql/app-pass password $ROOT_PASS" |debconf-set-selections
#echo "phpmyadmin phpmyadmin/app-password-confirm password $ROOT_PASS" | debconf-set-selections
#apt-get -y install phpmyadmin
