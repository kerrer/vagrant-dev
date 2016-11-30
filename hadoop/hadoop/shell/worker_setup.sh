#Install Dependencies
apt-get -y install  curl openjdk-7-jre libapache2-mod-wsgi python-pip python-requests
apt-get -y install nginx git vim curl
#service nginx restart
#Add Flask Application
#pip install flask grequests
#mkdir -p /var/www/myapp
#cp /vagrant/app.wsgi /var/www/myapp/
#cp /vagrant/myapp.py /var/www/myapp/
#cp -pR /vagrant/app.conf /etc/apache2/sites-enabled/000-default
#service apache2 restart

#Install Apache Flume
cd /opt/
tar xvzf /vagrant/apache-flume-1.6.0-bin.tar.gz   -C /opt/

#Install Elasticsearch jars


#Add flume user to group adm so it can read the apache logs
#usermod -a -G adm flume

#Configure flume and restart the service
#cp /vagrant/flume.conf /opt/apache-flume-1.6.0-bin/conf/flume.conf
#cd /opt/apache-flume-1.6.0-bin
#/usr/bin/nohup ./bin/flume-ng agent --conf conf --conf-file conf/flume.conf --name agent -Dflume.root.logger=INFO,console > /var/log/flume 2>&1 &

#Run Our Test Driver
#python /vagrant/test_script.py
