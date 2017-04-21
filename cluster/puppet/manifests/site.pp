$slaves = {'host1'=>'192.168.56.42','host2'=>'192.168.56.43','host3'=>'192.168.56.44'}
$proxys = {'host0'=>'192.168.56.41'}
$discover_url ='https://discovery.etcd.io/da63ec1c37c7e32f2536ab53809c0f6f'
$bootstrap = 'discover'

node 'my1.max.com' {  
   class {'lamp::cluster::ssh': }
   class {'lamp::cluster::etcd':
        proxy  =>true,
        server_id =>0,
        slaves => $slaves,
        ip =>$proxys[host0],
        discover_url => $discover_url,
        bootstrap => $bootstrap
   }
}


node 'my2.max.com' {  
   class {'lamp::cluster::ssh': }
   class {'lamp::cluster::etcd':
        server_id =>1,
        slaves => $slaves,
        ip =>$slaves[host1],
        discover_url => $discover_url,
        bootstrap => $bootstrap
   }
}

node 'my3.max.com' {  
  class {'lamp::cluster::ssh': }
  class {'lamp::cluster::etcd':
        server_id =>2,
        slaves => $slaves,
        ip =>$slaves[host2],
        discover_url => $discover_url,
	bootstrap => $bootstrap
  }

}
node 'my4.max.com' {  
  class {'lamp::cluster::ssh': }
  class {'lamp::cluster::etcd':
        server_id =>3,
        slaves => $slaves,
         ip =>$slaves[host3],
        discover_url => $discover_url,
	bootstrap => $bootstrap
  }
}
