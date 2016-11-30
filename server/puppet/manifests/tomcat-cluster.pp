#tomcat cluster 
#2个tomcat，1个nginx-反向代理，1个redis
#node1: nginx 
#node2: tomcat
#node3: tomcat
#node4: redis

include hosts

$tomcat_url = "http://apache.opencas.org/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz"
        
node tomcatnode1.max.com  {
   class { 'nginx': }
   nginx::resource::upstream { 'tomcat_app':
      members => [
        'tomcatnode2:8080',
        'tomcatnode3:8080',
      ],
   }

   nginx::resource::vhost { 'tomcatnode1.max.com':
      proxy => 'http://tomcat_app',
   }
}

node tomcatnode2.max.com  {
   class { 'jdk_oracle': }
   
   $tomcat7_home = '/opt/apache-tomcat/tomcat7'
   class { 'tomcat': }
   tomcat::instance { 'tomcat7':
      catalina_base => $tomcat7_home,
      source_url => $tomcat_url,
      require => Class['jdk_oracle']
   }->
   file { '/opt/apache-tomcat/tomcat7/lib':
    path         => '/opt/apache-tomcat/tomcat7/lib',
    ensure       => directory,
    source       => ['file:/job/tomcat/lib'],
    recurse      => remote,
    sourceselect => all,
   }->
   tomcat::config::server::tomcat_users {['manager-gui']:
     catalina_base => $tomcat7_home,
     element  => 'role',
   }->
   tomcat::config::server::tomcat_users {"admin":
     catalina_base => $tomcat7_home,
     element  => 'user',
     password => 'mmmm',
     roles    => ['manager-gui']
   }->  
   file {"${tomcat7_home}/conf/context.xml":
      ensure=> present,
      source=> 'file:/vagrant/conf/tomcat/context.xml'
   }->
   tomcat::service { 'default':
      catalina_base => $tomcat7_home,
      service_enable => true
   }
}

node tomcatnode3.max.com  {
   class { 'jdk_oracle': }
   
  $tomcat7_home = '/opt/apache-tomcat/tomcat7'
   class { 'tomcat': }
   tomcat::instance { 'tomcat7':
      catalina_base => $tomcat7_home,
      source_url => $tomcat_url,
      require => Class['jdk_oracle']
   }->
   file { '/opt/apache-tomcat/tomcat7/lib':
    path         => '/opt/apache-tomcat/tomcat7/lib',
    ensure       => directory,
    source       => ['file:/job/tomcat/lib'],
    recurse      => remote,
    sourceselect => all,
   }->
   tomcat::config::server::tomcat_users {['manager-gui']:
     catalina_base => $tomcat7_home,
     element  => 'role',
   }->
   tomcat::config::server::tomcat_users {"admin":
     catalina_base => $tomcat7_home,
     element  => 'user',
     password => 'mmmm',
     roles    => ['manager-gui']
   }->  
   file {"${tomcat7_home}/conf/context.xml":
      ensure=> present,
      source=> 'file:/vagrant/conf/tomcat/context.xml'
   }->
   tomcat::service { 'default':
      catalina_base => $tomcat7_home,
      service_enable => true
   }

}

node tomcatnode4.max.com  {
   class { 'redis':
     manage_repo => true,
     bind        => '0.0.0.0',
     ppa_repo    => 'ppa:rwky/redis',
   }
}
