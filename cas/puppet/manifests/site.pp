#CAS
#$jdk_pacakge    = hiera('jdk_oracle::package')
#file {"/usr/local/java":
#    ensure=>"directory"
#}
#file {"copy jdk package":
#   path => "/usr/local/java/${jdk_pacakge}",
#   source => "/vagrant/${jdk_pacakge}",
#}
node 'my1.max.com' {
   include hosts

   
   lamp::auth::cas {"auth.max.com":
   }

   lamp::php::cli{"php5":
      debug => true,
   }
   ->
   lamp::apache2::install {"apache2":
       root=>"/job/web",
       hosts => [{"host"=>"auth.max.com","doc"=>"/job/web/auth.max.com"}],
       ssl => true
   }   
    
   $override_options = {
     'mysqld' => {
        'server-id' => 1,
        'expire-logs-days' => 15
     }
   }

  class { '::mysql::server':
     root_password           => 'mmmm',
     remove_default_accounts => true,
     override_options        => $override_options,
  } 
  
  file {"/home/vagrant/sso.sql":
    ensure => "file",
    source => "puppet:///modules/lamp/cas/sso.sql",
  }
  
  mysql::db {"sso":
     ensure => "present",
     user     => 'max',
     password => 'mmmm',
     host     => 'localhost',
     grant    => ['ALL'],
     sql => "/home/vagrant/sso.sql",
     enforce_sql => true,
     require=>File['/home/vagrant/sso.sql']
  }
}


