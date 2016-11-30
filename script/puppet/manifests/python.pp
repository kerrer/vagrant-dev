
file { ['/home/vagrant/project']:
    ensure => "directory",
    owner =>'vagrant',
    group => 'vagrant',
}

class { 'python' :
    version    => 'system',
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
    gunicorn   => 'present',
}
python::virtualenv { '/home/vagrant/project' :
	ensure       => present,
	version      => 'system',
	requirements => '/vagrant/requirements.txt',
	systempkgs   => true,
	distribute   => false,
	venv_dir     => "/home/vagrant/.pythonenv",
	owner        => 'vagrant',
	group        => 'vagrant',
	cwd          => '/home/vagrant/project',
	timeout      => 0,
}

#python::pip { 'virtualenvwrapper' :
#    pkgname       => 'virtualenvwrapper',
#    ensure        => 'present',
#    timeout       => 1880,
   # notify        => File["/etc/profile.d/virtualenvwrapper.sh"]
#}


class { 'pyenv': }
pyenv::plugin { ['yyuu/pyenv-virtualenvwrapper', 'yyuu/pyenv-virtualenv']: latest => true }
pyenv::build { '3.4.4': global => true, env=>['PYTHON_BUILD_CACHE_PATH=/job/python','PYTHON_BUILD_BUILD_PATH=/job/python']}
 



