node 'control.max.com' {
  include ::openstack::role::controller
}

node 'storage.max.com' {
  include ::openstack::role::storage
}

node 'network.max.com' {
  include ::openstack::role::network
}

node /compute[0-9]+.max.com/ {
  include ::openstack::role::compute
}

node /swift[0-9]+zone1.max.com/ {
  class { '::openstack::role::swiftstorage':
    zone => '1',
  }

node /swift[0-9]+zone2.max.com/ {
  class { '::openstack::role::swiftstorage':
    zone => '2',
  }

node /swift[0-9]+zone3.max.com/ {
  class { '::openstack::role::swiftstorage':
    zone => '3',
  }
