# Sets ssh config for all instances
class profiles::cloudera::agent {
   class { '::cloudera':
     cm_server_host => 'one.cluster',
     use_parcels    => true
   }
}
