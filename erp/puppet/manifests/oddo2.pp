
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
class { 'postgresql::server::contrib': }
postgresql::server::pg_hba_rule { 'allow application network to access app database':
  description => "Open up postgresql for access from 200.1.2.0/24",
  type => 'host',
  database => 'all',
  user => 'postgres',
  address => '0.0.0.0/0',
  auth_method => 'md5',
}

python::pyvenv { '/home/vagrant/odoo' :
    ensure       => present,
    version      => '2.7.9',
    systempkgs   => true,
    #venv_dir     => '/home/appuser/virtualenvs',
    owner        => 'vagrant',
    group        => 'vagrant',
}

python::requirements { '/job/odoo/requirements.txt' :
    virtualenv => 'home/vagrant/odoo',
    #proxy      => 'http://proxy.domain.com:3128',
    owner      => 'vagrant',
    group      => 'vagrant',
}


#python::pip { 'virtualenvwrapper' :
#    pkgname       => 'virtualenvwrapper',
#    ensure        => 'present',
#    #virtualenv    => '/var/www/project1',
#    #owner         => 'appuser',
#    #proxy         => 'http://proxy.domain.com:3128',
#    #environment   => 'ORACLE_HOME=/usr/lib/oracle/11.2/client64',
#    #install_args  => ['-e'],
#    timeout       => 1800,
#    notify        => File["/etc/profile.d/max.sh"]
#}

#python::virtualenv { '/job/odoo' :
#  ensure       => present,
#  version      => 'system',
#  requirements => '/job/odoo/requirements.txt',
# # proxy        => 'http://proxy.domain.com:3128',
#  systempkgs   => true,
#  distribute   => false,
#  venv_dir     => '/home/vagrant/virtualenvs',
#  owner        => 'vagrant',
#  group        => 'vagrant',
#  cwd          => '/job/odoo',
3  timeout      => 0,
#}

#file { "/etc/profile.d/max.sh":
#  content => "source /usr/local/bin/virtualenvwrapper.sh",
#  mode    => 755
#}


$pkgs = ['build-essential','openssl', 'libcurl4-openssl-dev', 'zlib1g-dev', 'libpq-dev', 'libxml2', 'libxml2-dev', 'libxslt1-dev', 'libsasl2-dev', 'libjpeg-dev','libsqlite3-dev', 'libreadline-dev']
package {$pkgs:
   ensure => 'present'
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
