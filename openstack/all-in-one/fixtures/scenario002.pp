#
# Copyright 2015 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case $::osfamily {
  'Debian': {
    $ipv6             = false
    # zaqar is not packaged in Ubuntu Trusty
    $zaqar_enabled    = false
    # we'll start testing barbican after Newton stable, Ubuntu packaging is not
    # updated enough.
    $barbican_enabled = false
    # ec2api is not packaged on Ubuntu Trusty
    $ec2api_enabled   = false
  }
  'RedHat': {
    $ipv6               = true
    $zaqar_enabled      = true
    $barbican_enabled   = true
    $ec2api_enabled     = true
  }
  default: {
    fail("Unsupported osfamily (${::osfamily})")
  }
}

# Disable SSL (workaround for Xenial)
if ($::operatingsystem == 'Ubuntu') and (versioncmp($::operatingsystemmajrelease, '16') >= 0) {
  $ssl_enabled = false
} else {
  $ssl_enabled = true
}

include ::openstack_integration
class { '::openstack_integration::config':
  ssl  => $ssl_enabled,
  ipv6 => $ipv6,
}
include ::openstack_integration::cacert
include ::openstack_integration::memcached
include ::openstack_integration::rabbitmq
include ::openstack_integration::mysql
include ::openstack_integration::keystone
class { '::openstack_integration::glance':
  backend => 'swift',
}
include ::openstack_integration::neutron
include ::openstack_integration::swift
include ::openstack_integration::ironic
include ::openstack_integration::zaqar
include ::openstack_integration::mongodb
include ::openstack_integration::provision

class { '::openstack_integration::nova':
  volume_encryption => $barbican_enabled,
}

class { '::openstack_integration::cinder':
  volume_encryption => $barbican_enabled,
  cinder_backup     => 'swift',
}

if $barbican_enabled {
  include ::openstack_integration::barbican
}

if $ec2api_enabled {
  include ::openstack_integration::ec2api
}

class { '::openstack_integration::tempest':
  cinder                  => true,
  cinder_backup           => true,
  swift                   => true,
  ironic                  => true,
  zaqar                   => $zaqar_enabled,
  attach_encrypted_volume => $barbican_enabled,
  ec2api                  => $ec2api_enabled,
}
