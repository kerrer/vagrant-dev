
class { 'jdk_oracle': }

package {['zip','unzip']:
   ensure => "installed"
}

class {"lamp::php_cli_centos":}
->
class {"lamp::apache2_php5":}
$enhancers = ['make','gcc','gcc-c++','libtool','autoconf','automake','imake','mysql-devel','libxml2-devel','expat-devel']
package {$enhancers:   
   ensure => "installed",
   notify => Exec['install_coreseek']
}
exec { "install_coreseek":
    command => "/vagrant/shell/coreseek.sh",
    path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
    logoutput => true,
    timeout => 600    
}

class { 'supervisord':
  install_pip => true,
  require => Exec['install_coreseek'],
}
