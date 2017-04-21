#$jdk_pacakge    = hiera('jdk_oracle::package')
#file {"/usr/local/java":
#    ensure=>"directory"
#}
#file {"copy jdk package":
#   path => "/usr/local/java/${jdk_pacakge}",
#   source => "/vagrant/${jdk_pacakge}",
#}

$pkgs = ['libsqlite3-dev']
package {$pkgs:
   ensure => 'present'
}
class { 'nodejs':
  repo_url_suffix => '4.x',
}
->
package { ['grunt-cli']:
	ensure   => 'installed',
	provider => 'npm'
}

