#!/usr/bin/env bash

set -o errexit -o nounset

TOP_DIR=$(cd "$(dirname "$0")/.." && pwd)

source "$TOP_DIR/config/paths"
source "$CONFIG_DIR/openstack"
source "$CONFIG_DIR/localrc"
source "$LIB_DIR/functions.guest.sh"

echo "finish 1"
indicate_current_auto

echo "finish 2"
exec_logfile

function set_apt_proxy {
    local PRX_KEY="Acquire::http::Proxy"
    local APT_FILE=/etc/apt/apt.conf

    if [ -f $APT_FILE ] && grep -q $PRX_KEY $APT_FILE; then
        # apt proxy has already been set (by preseed/kickstart)
        if [ -n "${VM_PROXY-}" ]; then
            # Replace with requested proxy
            sudo sed -i "s#^\($PRX_KEY\).*#\1 \"$VM_PROXY\";#" $APT_FILE
        else
            # No proxy requested -- remove
            sudo sed -i "s#^$PRX_KEY.*##" $APT_FILE
        fi
    elif [ -n "${VM_PROXY-}" ]; then
        # Proxy requested, but none configured: add line
        echo "$PRX_KEY \"$VM_PROXY\";" | sudo tee -a $APT_FILE
    fi
    
    sudo sed -i 's/us.archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list 
    cat << DEB |sudo tee /etc/pip.conf
[global]
trusted-host=mirrors.aliyun.com
index-url=http://mirrors.aliyun.com/pypi/simple/
DEB
   echo "finish 3"
}

set_apt_proxy

# Get apt index files
sudo apt-get update
echo "finish 4"

function ubuntu_cloud_archive {
    # cloud-keyring to verify packages from ubuntu-cloud repo
    sudo apt-get install ubuntu-cloud-keyring

    #--------------------------------------------------------------------------
    # Enable the OpenStack repository
    # http://docs.openstack.org/mitaka/install-guide-ubuntu/environment-packages.html
    #--------------------------------------------------------------------------

    # Install packages needed for add-apt-repository
    sudo apt-get -y install software-properties-common \
                            python-software-properties
    sudo add-apt-repository -y "cloud-archive:$OPENSTACK_RELEASE"
    echo "finish 5"
}

function ubuntu_cloud_staging {
    #--------------------------------------------------------------------------
    # Enable the OpenStack repository
    # https://launchpad.net/~ubuntu-cloud-archive/+archive/ubuntu/mitaka-staging
    #
    # NOTE: Using pre-release staging ppa is not documented in install-guide
    #--------------------------------------------------------------------------

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9F68104E

    cat << DEB |sudo tee /etc/apt/sources.list.d/cloudarchive-$OPENSTACK_RELEASE.list
deb http://ppa.launchpad.net/ubuntu-cloud-archive/$OPENSTACK_RELEASE/ubuntu trusty main
deb-src http://ppa.launchpad.net/ubuntu-cloud-archive/$OPENSTACK_RELEASE/ubuntu trusty main
DEB
    echo "finish 6"
}

# precise needs the cloud archive, and so does trusty for non-Icehouse releases
if grep -qs DISTRIB_CODENAME=precise /etc/lsb-release ||
        [ "$OPENSTACK_RELEASE" != "icehouse" ]; then
    if [[ "$OPENSTACK_RELEASE" =~ staging ]]; then
        echo "Enabling the Ubuntu cloud staging ppa."
        ubuntu_cloud_staging
    else
        echo "Enabling the Ubuntu cloud archive."
        ubuntu_cloud_archive
    fi

    # Get index files only for ubuntu-cloud repo but keep standard lists
    src_list=cloudarchive-$OPENSTACK_RELEASE.list
    if [ -f "/etc/apt/sources.list.d/$src_list" ]; then
        sudo apt-get update \
            -o Dir::Etc::sourcelist="sources.list.d/$src_list" \
            -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
    else
        echo "ERROR: apt source not found: /etc/apt/sources.list.d/$src_list"
        exit 1
    fi
    echo "finish 7"
fi
