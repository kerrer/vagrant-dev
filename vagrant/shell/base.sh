#!/usr/bin/env bash
if [ -f "/var/vagrant_prepare" ]; then
 exit 0
fi
touch /var/vagrant_prepare

######################################################################
#echo "Asia/Shanghai" | sudo tee /etc/timezone
#dpkg-reconfigure --frontend noninteractive tzdata

#locale-gen zh_CN.UTF-8
#update-locale LANG=zh_CN.UTF-8 LC_MESSAGES=POSIX
#dpkg-reconfigure  --frontend noninteractive locales

#add-apt-repository "deb http://mirrors.163.com/ubuntu/ precise universe multiverse"
#add-apt-repository "deb http://mirrors.163.com/ubuntu/ precise-updates universe multiverse"

#sed -i.bak '1 r /utils/sohu.mirrors' /etc/apt/sources.list
#apt-get update >/dev/null 2>&1

#######################################################################
apt-get update 
