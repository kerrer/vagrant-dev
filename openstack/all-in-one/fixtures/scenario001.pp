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
    $ipv6            = false
    # gnocchi is not packaged in Ubuntu Cloud Archive
    # https://bugs.launchpad.net/cloud-archive/+bug/1535740
    $gnocchi_enabled = false
  }
  'RedHat': {
    $ipv6            = true
    $gnocchi_enabled = true
  }
  default: {
    fail("Unsupported osfamily (${::osfamily})")
  }
}

# List of workarounds for Ubuntu Xenial:
# - disable SSL
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
  backend => 'rbd',
}
include ::openstack_integration::neutron
class { '::openstack_integration::nova':
  libvirt_rbd => true,
}
class { '::openstack_integration::cinder':
  backend => 'rbd',
}
include ::openstack_integration::ceilometer
include ::openstack_integration::aodh
include ::openstack_integration::gnocchi
include ::openstack_integration::ceph
include ::openstack_integration::provision

class { '::openstack_integration::tempest':
  cinder     => true,
  gnocchi    => $gnocchi_enabled,
  ceilometer => true,
  aodh       => true,
}
