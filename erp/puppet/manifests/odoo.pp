#$jdk_pacakge    = hiera('jdk_oracle::package')
#file {"/usr/local/java":
#    ensure=>"directory"
#}
#file {"copy jdk package":
#   path => "/usr/local/java/${jdk_pacakge}",
#   source => "/vagrant/${jdk_pacakge}",
#}
$pkgs = ['build-essential','openssl', 'libcurl4-openssl-dev', 'zlib1g-dev', 'libpq-dev', 'libxml2', 'libxml2-dev', 'libxslt1-dev', 'libsasl2-dev', 'libjpeg-dev','libsqlite3-dev', 'libreadline-dev']
package {$pkgs:
   ensure => 'present'
}
class { 'postgresql::server':
  ip_mask_deny_postgres_user => '0.0.0.0/32',
  ip_mask_allow_all_users    => '0.0.0.0/0',
  listen_addresses           => '*',
  postgres_password          => 'mmmm',
}
postgresql::server::role { "odoo":
   createdb => true,
   password_hash => postgresql_password('odoo', 'mmmm'),
}
class { 'postgresql::server::contrib': }
postgresql::server::pg_hba_rule { 'allow application network to access app database':
  description => "Open up postgresql for access from 200.1.2.0/24",
  type => 'host',
  database => 'all',
  user => 'postgres',
  address => '0.0.0.0/32',
  auth_method => 'md5',
}

class { 'python' :
    version    => 'system',
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
    gunicorn   => 'present',
}
python::virtualenv { '/home/vagrant/odoo' :
	ensure       => present,
	version      => 'system',
	requirements => '/job/odoo/requirements.txt',
	#proxy        => 'http://proxy.domain.com:3128',
	systempkgs   => true,
	distribute   => false,
	#venv_dir     => '/home/vagrant/odoo',
	owner        => 'vagrant',
	group        => 'vagrant',
	cwd          => '/home/vagrant/odoo',
	timeout      => 0,
}

python::pip { 'virtualenvwrapper' :
    pkgname       => 'virtualenvwrapper',
    ensure        => 'present',
    #virtualenv    => '/var/www/project1',
    #owner         => 'appuser',
    #proxy         => 'http://proxy.domain.com:3128',
    #environment   => 'ORACLE_HOME=/usr/lib/oracle/11.2/client64',
    #install_args  => ['-e'],
    timeout       => 0,
    notify        => File["/etc/profile.d/max.sh"]
}
 
file { "/etc/profile.d/max.sh":
  content => "source /usr/local/bin/virtualenvwrapper.sh",
  mode    => 755
}

class { 'nodejs':
  repo_url_suffix => 'node_4.x',
}
->
package {['less','less-plugin-clean-css']:
  ensure   => 'present',
  provider => 'npm',
}

