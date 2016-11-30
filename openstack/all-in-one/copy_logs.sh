#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.
# This script takes bits from devstack-gate/functions/cleanup_host in a
# more generic approach, so we don't need to actually run devstack on the node
# to cleanup an host.

set -o xtrace
set -o errexit

export SCRIPT_DIR=$(cd `dirname $0` && pwd -P)
source $SCRIPT_DIR/functions

print_header 'Copy logs into workspace'

LOG_DIR=$WORKSPACE/logs
mkdir $WORKSPACE/logs

# PROJECTS
#  - for each entry, we will probe /etc/${project} and /var/log/${project}
#    and copy out files
#
# For right now, we populate our projects with a guess from those that
# have puppet modules installed.  revisit this if needs change
if [ -d /etc/puppetlabs/code ]; then
    # puppet4
    PUPPET_MODULES_PATH='/etc/puppetlabs/code/modules'
else
    # puppet3
    PUPPET_MODULES_PATH='/etc/puppet/modules'
fi

for project in $PUPPET_MODULES_PATH/*; do
    # find Puppet OpenStack modules
    if [ -f $project/metadata.json ]; then
        if egrep -q "github.com/(stackforge|openstack)/puppet" $project/metadata.json; then
            PROJECTS+="$(basename $project) "
        fi
    fi
done

# start of log capture
# some commands could fail if service failed to be installed during Puppet runs
set +e

# Archive the project config & logs
mkdir $LOG_DIR/etc/
for p in $PROJECTS; do
    if [ -d /etc/$p ]; then
        sudo cp -r /etc/$p $LOG_DIR/etc/
    fi
    if [ -d /var/log/$p ]; then
        sudo cp -r /var/log/$p $LOG_DIR
    fi
done

#
# Extra bits and pieces follow
#

# system logs
if uses_debs; then
    sudo cp /var/log/kern.log $LOG_DIR/kern_log.txt
fi
if which journalctl &> /dev/null; then
    sudo journalctl --no-pager > $LOG_DIR/syslog.txt
fi

# rabbitmq logs
if [ -d /var/log/rabbitmq ]; then
    sudo cp -r /var/log/rabbitmq $LOG_DIR
fi

# db logs
if [ -d /var/log/postgresql ] ; then
    # Rename log so it doesn't have an additional '.' so it won't get
    # deleted
    sudo cp /var/log/postgresql/*log $LOG_DIR/postgres.log
fi
if [ -f /var/log/mysql.err ] ; then
    sudo cp /var/log/mysql.err $LOG_DIR/mysql_err.log
fi
if [ -f /var/log/mysql.log ] ; then
    sudo cp /var/log/mysql.log $LOG_DIR/
fi

# tempest logs
if [ -f /tmp/openstack/tempest/tempest.log ] ; then
    sudo cp /tmp/openstack/tempest/tempest.log $LOG_DIR/
fi

# Tempest subunit results
if [ -f /tmp/openstack/tempest/testrepository.subunit ] ; then
    sudo cp /tmp/openstack/tempest/testrepository.subunit $LOG_DIR/testrepository.subunit
fi

# dstat logs
if [ -f /var/log/dstat.log ] ; then
    sudo cp /var/log/dstat.log $LOG_DIR/
fi

# libvirt
if [ -d /var/log/libvirt ] ; then
    sudo cp -r /var/log/libvirt $LOG_DIR/
fi

# openvswitch
if [ -d /var/log/openvswitch ] ; then
    sudo cp -r /var/log/openvswitch $LOG_DIR/
fi

# sudo config
sudo cp -r /etc/sudoers.d $LOG_DIR/
sudo cp /etc/sudoers $LOG_DIR/sudoers.txt

# apache logs; including wsgi stuff like horizon, keystone, etc.
if uses_debs; then
    apache_logs=/var/log/apache2
    if [ -d /etc/apache2/sites-enabled ]; then
        mkdir $LOG_DIR/apache_config
        sudo cp /etc/apache2/sites-enabled/* $LOG_DIR/apache_config
        for f in `ls $LOG_DIR/apache_config`; do
            mv $LOG_DIR/apache_config/${f} $LOG_DIR/apache_config/${f}.txt
        done
    fi
elif is_fedora; then
    apache_logs=/var/log/httpd
    if [ -d /etc/httpd/conf.d ]; then
        mkdir $LOG_DIR/apache_config
        sudo cp /etc/httpd/conf.d/* $LOG_DIR/apache_config
        for f in `ls $LOG_DIR/apache_config`; do
            mv $LOG_DIR/apache_config/${f} $LOG_DIR/apache_config/${f}.txt
        done
    fi
fi
if [ -d ${apache_logs} ]; then
    sudo cp -r ${apache_logs} $LOG_DIR/apache
fi

if [ -f /var/log/audit/audit.log ]; then
    sudo cp /var/log/audit/audit.log $LOG_DIR/audit.log.txt
fi

if [ -d /tmp/openstack/tempest ]; then
    sudo cp /tmp/openstack/tempest/etc/tempest.conf $LOG_DIR/tempest.conf.txt
fi

if [ -d /etc/openstack-dashboard ]; then
    sudo cp -r /etc/openstack-dashboard $LOG_DIR/etc/openstack-dashboard
    for f in `ls $LOG_DIR/etc/openstack-dashboard`; do
        sudo mv $LOG_DIR/etc/openstack-dashboard/${f} $LOG_DIR/etc/openstack-dashboard/${f}.txt
    done
fi

# package status and repository list
if [ `command -v dpkg` ]; then
    dpkg -l> $LOG_DIR/dpkg-l.txt
    apt-cache policy > $LOG_DIR/apt-cache-policy.txt
fi
if [ `command -v rpm` ]; then
    rpm -qa > $LOG_DIR/rpm-qa.txt
    yum repolist -v > $LOG_DIR/repolist.txt
fi

# system status & informations
sudo cp /root/openrc $LOG_DIR/openrc.txt
df -h > $LOG_DIR/df.txt
free -m > $LOG_DIR/free.txt
lsmod > $LOG_DIR/lsmod.txt
cat /proc/cpuinfo > $LOG_DIR/cpuinfo.txt
ps -eo user,pid,ppid,lwp,%cpu,%mem,size,rss,cmd > $LOG_DIR/ps.txt

# end of log capture
set -e

# Set permissions to let jenkins compress and archive logs.
# Also make sure zuul can rsync all the logs and configs
sudo find $LOG_DIR -type d -execdir sudo chmod 755 '{}' \;
sudo find $LOG_DIR -type f -execdir sudo chmod 644 '{}' \;
sudo chown -R "$(id -u):$(id -g)" $LOG_DIR

# do not try to save symlinks because source files might not have
# the right permissions to let jenkins user to upload them on log servers.
sudo find $LOG_DIR -type l -execdir sudo rm -f '{}' \;

# rename files to .txt; this is so that when displayed via
# logs.openstack.org clicking results in the browser shows the
# files, rather than trying to send it to another app or make you
# download it, etc.

# firstly, rename all .log files to .txt files
for f in $(find $LOG_DIR -name "*.log"); do
    sudo mv $f ${f/.log/.txt}
done

# append .txt to all config files
# (there are some /etc/swift .builder and .ring files that get
# caught up which aren't really text, don't worry about that)
find $LOG_DIR/sudoers.d $LOG_DIR/etc -type f -exec sudo mv '{}' '{}'.txt \;

# rabbitmq
if [ -f $LOG_DIR/rabbitmq ]; then
    find $LOG_DIR/rabbitmq -type f -exec sudo mv '{}' '{}'.txt \;
    for X in `find $LOG_DIR/rabbitmq -type f` ; do
        sudo mv "$X" "${X/@/_at_}"
    done
fi

# stackviz
if [ -d /opt/stackviz ]; then
    cp -r /opt/stackviz/build /tmp/stackviz
    sudo pip install -U /opt/stackviz
    stackviz-export --env -f /tmp/openstack/tempest/testrepository.subunit /tmp/stackviz/data
    mv /tmp/stackviz $LOG_DIR
fi

# hiera
if [ -d $SCRIPT_DIR/hiera ]; then
    mv $SCRIPT_DIR/hiera $LOG_DIR
fi

# Compress all text logs
sudo find $LOG_DIR -iname '*.txt' -type f -execdir gzip -9 {} \+
sudo find $LOG_DIR -iname '*.dat' -type f -execdir gzip -9 {} \+
sudo find $LOG_DIR -iname '*.conf' -type f -execdir gzip -9 {} \+
