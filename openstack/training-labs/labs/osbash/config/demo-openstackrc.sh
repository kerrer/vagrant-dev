# The variables in this file are exported for use by OpenStack client
# applications.

# Unlike a regular openstackrc.sh file, this file gets its variable values
# from other configuration files (to limit redundancy).

# Use BASH_SOURCE so the file works when sourced from a shell, too
CONFIG_DIR=$(dirname "$BASH_SOURCE")
source "$CONFIG_DIR/openstack"
source "$CONFIG_DIR/credentials"

#------------------------------------------------------------------------------
# OpenStack client environment scripts
# http://docs.openstack.org/mitaka/install-guide-ubuntu/keystone-openrc.html
#------------------------------------------------------------------------------
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=$DEMO_PROJECT_NAME
export OS_USERNAME=$DEMO_USER_NAME
export OS_PASSWORD=$DEMO_PASS
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
#------------------------------------------------------------------------------
# http://docs.openstack.org/mitaka/install-guide-ubuntu/glance-verify.html
#------------------------------------------------------------------------------
export OS_IMAGE_API_VERSION=2
