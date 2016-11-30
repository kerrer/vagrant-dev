node 'my1.max.com' {  
   include ::openstack::role::controller
}

node 'my2.max.com' {  
   include ::openstack::role::storage
   include ::openstack::role::network
   
}
node 'my3.max.com' {
   include ::openstack::role::compute
}
node 'my4.max.com' {  
   include ::openstack::role::compute 
}
node 'my5.max.com' {    
  class { '::openstack::role::swiftstorage':
    zone => '1',
  }
}
node 'my6.max.com' {    
  class { '::openstack::role::swiftstorage':
    zone => '2',
  }
}

