#!/bin/bash
#Ubuntu:
#prep:
# 1. install zsh and chsh zsh
# 2. conf cpan "o conf urllist  unshift http://mirrors.aliyun.com/CPAN/"
#1. install geany nano git mercurial 
#2. install build essential(build tool dev) 
#3. install java (openjdk/oracle jdk)http://www.if-not-true-then-false.com/2010/install-sun-oracle-java-jdk-jre-7-on-fedora-centos-red-hat-rhel/
#4. install virtualbox
#5. install vagant
#6. install docker
#7. pull vagran images  ubuntu centos
#8. pull docker container  drupal,joomla,wordpress,mongdb,jenkins,redmine,registry,sonatype/nexus3,odoo.vimagick/opencart,alexcheng/magento,zeromq/zeromq,webcenter/activemq,rakudo-star,golang,java,ruby,perl,python
#9. rbenv,pyenv,nvm,gvm,sdk

echo "Hello World!"
echo progress-bar >> ~/.curlrc
PATH="/usr/local/heroku/bin:/home/max/bin/roo/bin:$PATH"
export JAVA_HOME=/usr/lib/jvm/latest
export GOROOT_BOOTSTRAP=/home/max/bin/go1.4
MAX_HOME="/home/max"
MAX_SH="$MAX_HOME/.max"
LOGINPASSWD="mmmm"

LOG_FILE="$MAX_HOME/install_log"


#itdocker or itdocker fix [first|all]
itdocker(){
	if [ ! -z "$1" ] && [[ $# -ge 2 ]] && [[ "$1" = "fix" ]]; then
	   echo "You had choosed to fix docker images"
	   _itdocker_fix $2
	   return 0
	fi
	
	echo "\e[1;31m  Installing new docker ........................  \e[0m"
	echo $LOGINPASSWD |  sudo -S apt-get update
    echo $LOGINPASSWD | sudo -S apt-get install -y --no-install-recommends  linux-image-extra-$(uname -r)  linux-image-extra-virtual
    echo $LOGINPASSWD |  sudo -S apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
    
    curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -   
    apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D
    echo $LOGINPASSWD | sudo -S add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
    sudo apt-get update
    sudo apt-get -y install docker-engine
    
    grep -i "^docker" /etc/group ||  sudo groupadd docker 
	id -Gn "max" | grep -qc "docker" || sudo usermod -a -G docker max
	sudo service enable docker
	sudo service start docker
	sudo docker run hello-world
}



lddocker2(){
 #flannel version from coreos
 #/usr/lib/systemd/system/flannel-docker-opts.service
 #/usr/lib/systemd/system/flanneld.service
VAR=$(cat <<'END_HEREDOC'


docker  quay.io/coreos/hyperkube:v1.5.3_coreos.0


docker  gcr.io/google-samples/gb-frontend:v4
docker  gcr.io/google_containers/redis:e2e
docker  gcr.io/google_samples/gb-redisslave:v1
END_HEREDOC
)	

while read line; do
 conType=$(echo $line | awk  '{print $1}')
 conImage=$(echo $line | awk  '{print $2}')
 imageName=$(echo $conImage | awk -F:  '{print $1}')
 imageVersion=$(echo $conImage | awk -F: '{print $2}')
 imageBase="${imageName##*/}"
 if [[ "rkt" = "$conType" ]]; then 
    echo "rkt fetch $imageName:$imageVersion......"
    echo $LOGINPASSWD | sudo -S rkt image list | grep -s "$imageName.*$imageVersion" ||  sudo rkt fetch $imageName:$imageVersion  
    echo $LOGINPASSWD | sudo -S rkt image export  $imageName:$imageVersion "/job/images/${imageBase}_${imageVersion}.aci"
 elif [[ "docker" = "$conType" ]]; then
    echo "docker pull  $imageName:$imageVersion...."
    echo $LOGINPASSWD | sudo -S docker images | grep -s "$imageName.*$imageVersion" ||  sudo docker pull $imageName:$imageVersion  
    echo $LOGINPASSWD | sudo -S docker save $imageName:$imageVersion > "/job/images/${imageBase}_${imageVersion}.tar"
 fi
 sudo chmod -R 0777 /job/images
 
done <<< "$VAR"
}


itdocker
lddocker2
