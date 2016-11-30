

node 'one.cluster' {  
    include ntp
    include hosts
    include '::tuned'
    include disable_transparent_hugepage
    class { 'firewall': ensure=> 'stopped'}
    class { '::ambari::server':
      use_repo   => true,
      db_backend => 'mysql',
      db_host    => '172.17.0.3',
      db_port    => '3306',
      db_username  => 'root',
      db_password  => 'mmmm',
   }

   class { '::ambari::agent':
       ambari_server => 'one.cluster'
   }

   Class['tuned'] -> Class['disable_transparent_hugepage'] -> Class['ntp'] -> Class['hosts'] -> Class['ambari::server'] -> Class['ambari::agent']
}

node 'two.cluster' {  
   include ntp
   include hosts
   include '::tuned'
   include disable_transparent_hugepage
   class { 'firewall': ensure=> 'stopped'}

    class { '::ambari::agent':
       ambari_server => 'one.cluster'
   }

   Class['tuned'] -> Class['disable_transparent_hugepage']
}
node 'three.cluster' {  
   include ntp
   include hosts
    include '::tuned'
    include disable_transparent_hugepage
   class { 'firewall': ensure=> 'stopped'}

    class { '::ambari::agent':
       ambari_server => 'one.cluster'
   }

   Class['tuned'] -> Class['disable_transparent_hugepage']
}
