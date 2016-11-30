#Install Kibana

tar xvzf /vagrant/kibana-4.6.1-linux-x86_64.tar.gz   -C /opt/ 

#cd /opt/kibana-4.6.1-linux-x86_64
#/usr/bin/nohup  ./bin/kibana > /var/log/kibana 2>&1 &

#Install Elasticsearch
apt-get install openjdk-7-jre-headless -y
tar xvzf /vagrant/elasticsearch-2.4.0.tar.gz   -C /opt/
cd  /opt/elasticsearch-2.4.0
#/usr/bin/nohup ./bin/elasticsearch -Dnetwork.host=0.0.0.0 -Dcluster.name=elasticsearch  -Des.insecure.allow.root=true > /var/log/elasticsearch 2>&1 &
