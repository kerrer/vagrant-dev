# Config common to all nodes
class profiles::hadoop::repo {
  exec { 'apt-get update':
     path => '/usr/bin',
     refreshonly => true,
  }
  
  file {'/etc/apt/preferences.d/cloudera.pref':
    ensure  => 'present',
    replace => 'yes', # this is the important property
    source => "puppet:///modules/profiles/cloudera.pref",
    mode    => '0644',   
  }->
  file {'/etc/apt/sources.list.d/cloudera.list':
    ensure  => 'present',
    replace => 'yes', # this is the important property
    source => "puppet:///modules/profiles/cloudera.list",
    mode    => '0644',
    notify => Exec['apt-get update']
  }
}
