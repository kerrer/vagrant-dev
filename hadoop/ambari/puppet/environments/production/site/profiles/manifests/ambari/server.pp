# Config common to all nodes

class profiles::ambari::server {
  class { '::ambari::server':
      use_repo   => true,
      db_backend => 'mysql',
      db_host    => '127.0.0.1',
      db_port    => '3306',
      db_username  => 'root',
      db_password  => 'mmmm',
   }
}
