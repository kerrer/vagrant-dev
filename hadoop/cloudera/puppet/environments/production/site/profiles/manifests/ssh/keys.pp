# Sets ssh config for all instances
class profiles::ssh::keys {
    
     
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
    	source => "puppet:///modules/profiles/ssh/id_rsa",
  }->
  file { '/root/.ssh/authorized_keys':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => "puppet:///modules/profiles/ssh/authorized_keys",
  }

}
