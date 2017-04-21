#$jdk_pacakge    = hiera('jdk_oracle::package')
#file {"/usr/local/java":
#    ensure=>"directory"
#}
#file {"copy jdk package":
#   path => "/usr/local/java/${jdk_pacakge}",
#   source => "/vagrant/${jdk_pacakge}",
#}

class { 'jdk_oracle': }

class { 'postgresql::server':
  ip_mask_deny_postgres_user => '0.0.0.0/32',
  ip_mask_allow_all_users    => '0.0.0.0/0',
  listen_addresses           => '*',
  postgres_password          => 'mmmm',
}

postgresql::server::role { "openbravo":
   createdb => true,
   password_hash => postgresql_password('openbravo', 'mmmm'),
}

class { 'postgresql::server::contrib': }

postgresql::server::pg_hba_rule { 'allow application network to access app database':
  description => "Open up postgresql for access from 200.1.2.0/24",
  type => 'host',
  database => 'all',
  user => 'postgres',
  address => '0.0.0.0/0',
  auth_method => 'md5',
}

package { "ant":
    ensure => "installed"
}
->
file { "/etc/profile.d/cus_env.sh":
  content => "export ANT_OPTS='-Xmx1024M -XX:MaxPermSize=128M'"
}

class { 'tomcat': }
tomcat::instance { 'tomcat':
  install_from_source => true,
  source_url => 'puppet:///modules/tomcat/apache-tomcat-7.0.63.tar.gz'
  #source_url => 'http://apache.fayea.com/tomcat/tomcat-7/v7.0.61/bin/apache-tomcat-7.0.61.tar.gz'
}->
tomcat::setenv::entry{ 'tomcat':
   value => "-Xms384M -Xmx1024M -XX:MaxPermSize=256M",
   quote_char => '"'
}->
tomcat::service { 'default':
  use_jsvc     => false,
  use_init     => false,
  service_name => 'tomcat',
  service_ensure => 'running'
}
