node logNode1.max.com {

   class { 'jdk_oracle': }
   
   
   #class { 'apache':
   #   default_vhost => false,
   #}   
   #apache::vhost { 'testa.max.com':
   #  port    => '8081',
   #  docroot => '/var/www/testa.max.com',
   #}
   
   $log_format = ['$http_host $server_addr $remote_addr [$time_local] "$request" ',
                   '$request_body $status $body_bytes_sent "$http_referer" "$http_user_agent" ',
                   '$request_time $upstream_response_time'
                 ]
                 
   class { 'nginx': 
      log_format=> {logstash => join($log_format,"' '")}
   }
   nginx::resource::vhost { 'testb.max.com':
       www_root => '/var/www/testb.max.com',
       listen_port => '80',
       #access_log => '/var/log/nginx/puppet_access.log',
       format_log => "logstash"
   }
   
   class { 'logstash':
     package_url => 'file:/job/elk/logstash_2.1.1-1_all.deb',
     require => Class['jdk_oracle']
   }
   logstash::configfile { 'logstash_agent':
      source => '/vagrant/logstash_agent.conf'
   }
}

node logNode2.max.com {
   class { 'jdk_oracle': }
   class { 'redis':
     bind        => '0.0.0.0';
     #masterauth  => 'secret';
   }

   class { 'logstash':
      package_url => 'file:/job/elk/logstash_2.1.1-1_all.deb',
      require => Class['jdk_oracle']
   }
   logstash::configfile { 'logstash_indexer':
      source => '/vagrant/logstash_indexer.conf'
   }
   

   class {'lamp::dsf::zookeeper::install':
      package_ensure => "3.4.6",
      package_download_url=> "file:/job/zookeeper-3.4.6.tar.gz",
      require => Class['jdk_oracle']
   }->
   exec { 'download-kafka':
    command => "cp /job/kafka_2.11-0.9.0.0.tgz /var/lib/kafka/",
    path    => ['/usr/bin', '/bin'],
    creates => '/var/lib/kafka/kafka_2.11-0.9.0.0.tgz'
   }->
   class { 'kafka':
        version => '0.9.0.0',
        scala_version => '2.11'
   }
   class { 'kafka::broker':
      config => { 'broker.id' => '0', 'zookeeper.connect' => 'localhost:2181' },
   } 
}

node logNode3.max.com {
  class { 'jdk_oracle': }
  class { 'elasticsearch':
  package_url => 'file:/job/elk/elasticsearch-2.1.1.deb',
  require => Class['jdk_oracle']
 }
 elasticsearch::instance { 'es-01':
   config => { 'network.host' => '0.0.0.0' }
 }
 
 class { '::kibana4':
  package_ensure    => '4.3.1-linux-x64',
  package_provider  => 'archive',
  archive_provider  => 'puppet',
  package_download_url => 'file:/job/elk/kibana-4.3.1-linux-x64.tar.gz',
  symlink           => true,
  manage_user       => true,
  kibana4_user      => kibana4,
  kibana4_group     => kibana4,
  kibana4_gid       => 200,
  kibana4_uid       => 200,
  config            => {
      'server.port'           => 5601,
      'server.host'           => '0.0.0.0',
      'elasticsearch.url'     => 'http://localhost:9200',
      }
 }

}

node logNode4.max.com {
   class { 'jdk_oracle': }
   class {'lamp::dsf::zookeeper::install':
      package_ensure => "3.4.6",
      package_download_url=> "file:/job/zookeeper-3.4.6.tar.gz"
   }

}
