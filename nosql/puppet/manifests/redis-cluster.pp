#redis cluster 
#3个master，3个lave
#redis:3台机器，每台2个结点
#haproxy/1个代理结点

$nodes =['redisnode4.max.com:6379', 'redisnode4.max.com:6380',
         'redisnode2.max.com:6379', 'redisnode2.max.com:6380',
         'redisnode3.max.com:6379', 'redisnode3.max.com:6380'
        ]
        
node redisnode4.max.com,redisnode3.max.com,redisnode2.max.com {
   class {'lamp::nosql::redis::install':
      package_ensure => "3.0.6",
      package_download_url=> "file:/job/redis-3.0.6.tar.gz",
      instances => 2
   }
}

node redisnode1.max.com {   
   $cluster_nodes = join($nodes, " ")
   class {'lamp::nosql::redis::install':
      package_ensure => "3.0.6",
      bind_ip        => '127.0.0.1',
      package_download_url=> "file:/job/redis-3.0.6.tar.gz",
      mode  => 'basic',
      service_ensure => absent,
      ensure_process  => 'removed'
   }
  # ->
  # exec { "redis-cluster":
  #  command => "redis-trib.rb create --replicas 1 ${cluster_nodes} >> /var/log/redis-cluster.log",
  #  path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin",
  #  logoutput => true
  # }
   
   lamp::nosql::redis::haproxy{"haproxy":}
}
