class  sshkey {
  
  file { '/root/.ssh':
    ensure => directory,
    path   => '/root/.ssh',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }->
  file { '/root/.ssh/id_rsa':
    	ensure => file,
    	owner  => 'root',
    	group  => 'root',
   	mode   => '0600',
    	source => '/vagrant/files/id_rsa',
  }->
  file { '/root/.ssh/authorized_keys':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => '/vagrant/files/authorized_keys',
  }
}


node 'one.cluster' {   
   class { '::ntp':
      servers => [ 'cn.ntp.org.cn' ],
   }
   
   include apt 
   include sshkey
    
    class { 'ssh::server':
   	storeconfigs_enabled => false,
   	options => {
		'PasswordAuthentication' => 'no',
        	'PubkeyAuthentication'   => 'yes',
      		'PermitRootLogin'        => 'yes'
   	},
   }
    class { 'ssh::client':
      storeconfigs_enabled => false,
      options => {
        'Host *' => {
          'SendEnv'  => 'LANG LC_*',
          'HashKnownHosts' => 'yes',
          'GSSAPIAuthentication' => 'yes',
          'GSSAPIDelegateCredentials' => 'no',
          'StrictHostKeyChecking' => 'no',
        },
      },
    }

    class { 'firewall': ensure=> 'stopped'}
    
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

node /(two|three|four).cluster/ {
   include ntp
   include apt
   include sshkey
   class { 'firewall': ensure=> 'stopped'}
   class { 'ssh::server':
   	storeconfigs_enabled => false,
   	options => {
		'PasswordAuthentication' => 'no',
        	'PubkeyAuthentication'   => 'yes',
      		'PermitRootLogin'        => 'yes'
   	},
   }
 class { 'ssh::client':
      storeconfigs_enabled => false,
      options => {
        'Host *' => {
          'SendEnv'  => 'LANG LC_*',
          'HashKnownHosts' => 'yes',
          'GSSAPIAuthentication' => 'yes',
          'GSSAPIDelegateCredentials' => 'no',
          'StrictHostKeyChecking' => 'no',
        },
      },
    }

   class { '::cloudera':
     cm_server_host => 'one.cluster',
     use_parcels    => true
   }
}
