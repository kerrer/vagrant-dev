#!/usr/bin/env bash

curl -sS https://getcomposer.org/installer | php
chmod +x composer.phar
mv composer.phar /usr/local/bin/composer

#composer global require drush/drush:dev-master
#COMPOSER_HOME=/opt/drush COMPOSER_BIN_DIR=/usr/local/bin COMPOSER_VENDOR_DIR=/opt/drush/dev-master composer require drush/drush:dev-master

#install wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp


wget http://files.drush.org/drush.phar
chmod +x drush.phar
mv drush.phar /usr/local/bin/drush


curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
chmod a+x /usr/local/bin/symfony
