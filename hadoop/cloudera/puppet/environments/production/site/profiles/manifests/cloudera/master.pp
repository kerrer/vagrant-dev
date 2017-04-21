# Sets ssh config for all instances
class profiles::cloudera::master {
    class { 'postgresql::server':
     listen_addresses           => '*',
     postgres_password          => 'mmmm',
    }->
    class { '::cloudera':
      cm_server_host   => 'one.cluster',
      install_cmserver => true,
       db_type          => 'postgresql',
      db_host          => '127.0.0.1',
      db_port          => '5432',
      db_user          => 'postgres',
      db_pass          => 'mmmm',
    }
}
