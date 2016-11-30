#redis replication 
#2个master，每个master3个lave
#redis:2台机器，每台3个结点
#haproxy/1个代理结点



$nodes =['redisnode4.max.com:6379', 'redisnode4.max.com:6380',
         'redisnode2.max.com:6379', 'redisnode2.max.com:6380',
         'redisnode3.max.com:6379', 'redisnode3.max.com:6380'
        ]

include hosts
      
node redisnode1.max.com {
   class {'lamp::nosql::redis::install':
      package_ensure => "3.0.6",
      package_download_url=> "file:/job/redis-3.0.6.tar.gz",
      instances => 1,
      mode      => 'replication',
      slave_config => ['master']
   }
   
   class {'lamp::nosql::redis::sentinel':
     source        => 'file:/vagrant/conf/sentinel.conf'
   }
   
   lamp::nosql::redis::keepalived {'redis':
        state  => 'MASTER',
        vip    => '192.168.56.200',
        vrd    => '50',
        priority => '100',
   }
}

node redisnode3.max.com{
   build::github {"twemproxy":
      source       =>  'https://github.com/twitter/twemproxy.git', 
      buildoptions =>  " --enable-debug=full",
      creates      =>  "/tmp/buildtwmproxy.tmp3",
   }
}

node redisnode2.max.com{
   class {'lamp::nosql::redis::install':
      package_ensure => "3.0.6",
      package_download_url=> "file:/job/redis-3.0.6.tar.gz",
      instances => 1,
      mode      => 'replication',
      slave_config => ['slaveof:redisnode1:6379']
   }
   
   class {'lamp::nosql::redis::sentinel':
     source        => 'file:/vagrant/conf/sentinel.conf'
   }
   
   class {'lamp::nosql::redis::keepalived':    
        state  => 'BACKUP',
        vip    => '192.168.56.200',
        vrd    => '50',
        priority => '100',
   }
}

node redisnode4.max.com {   
   $cluster_nodes = join($nodes, " ")
   class {'lamp::nosql::redis::install':
      package_ensure => "3.0.6",
      bind_ip        => '127.0.0.1',
      package_download_url=> "file:/job/redis-3.0.6.tar.gz",
      mode  => 'basic',
      service_ensure => absent,
      ensure_process  => 'removed'
   }
 
 $nodes = {'redisnode1'=>['192.168.56.101',6379],'redisnode2'=>['192.168.56.102',6379],'redisnode3'=>['192.168.56.103',6379]}
 
 lamp::nosql::redis::haproxy{"haproxy":
    nodes => $nodes
 }
 
}

node temp{
 # ->
  # exec { "redis-cluster":
  #  command => "redis-trib.rb create --replicas 1 ${cluster_nodes} >> /var/log/redis-cluster.log",
  #  path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin",
  #  logoutput => true
  # }
   
   lamp::nosql::redis::haproxy{"haproxy":}
   
   class {"keepalived":
      package_provider         => 'archive',
      package_version          => '1.2.19',
      package_download_url     => 'file:/job/keepalived-1.2.19.tar.gz',
   }
}
