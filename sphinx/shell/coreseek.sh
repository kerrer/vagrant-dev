#!/usr/bin/env bash

CORESEEK=/vagrant/search/coreseek-4.1-beta

cd /vagrant/search
tar xvzf coreseek-4.1-beta.tar.gz

echo build mmseg.....................
cd $CORESEEK/mmseg-3.2.14/
./bootstrap 
./configure --prefix=/usr/local/mmseg3
make &&  make install
echo finish build mmseg

echo build csft.....................
cd $CORESEEK/csft-4.1/
sh buildconf.sh 
sh ./buildconf.sh 
./configure --prefix=/usr/local/coreseek  --without-unixodbc --with-mmseg --with-mmseg-includes=/usr/local/mmseg3/include/mmseg/ --with-mmseg-libs=/usr/local/mmseg3/lib/ --with-mysql
make && make install
echo finish build csft


cp /vagrant/search/sphinx.conf /etc/sphinx.conf
mkdir -p /usr/local/coreseek/var/data/delta
/usr/local/coreseek/bin/indexer --config /etc/sphinx.conf --all
