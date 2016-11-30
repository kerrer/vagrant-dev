#!/usr/bin/env bash
if [ -f "/var/vagrant_prepare" ]; then
 exit 0
fi
touch /var/vagrant_prepare

#apt-get install -y software-properties-common

function setMirrors {
   echo "set new mirrors"	
   cp /etc/apt/sources.list /etc/apt/sources.list.ori
   #sed -i 's/archive.ubuntu.com/mirrors.sohu.com/g' /etc/apt/sources.list
   wget http://mirrors.163.com/.help/sources.list.trusty -O /etc/apt/sources.list
   #sed -i.bak '1 r /utils/sohu.mirrors' /etc/apt/sources.list
}

function setTimeZone {
   echo "set timezone for Asia/Shanghai"
   echo "Asia/Shanghai" | sudo tee /etc/timezone
   dpkg-reconfigure --frontend noninteractive tzdata	
}
 
function setLocal {
   echo "set locale zh_CN.UTF-8"
   locale-gen zh_CN.UTF-8
   update-locale LANG=zh_CN.UTF-8 LC_MESSAGES=POSIX
   dpkg-reconfigure  --frontend noninteractive locales
}


#setTimeZone
#setMirrors
#setLocal
apt-get update 
