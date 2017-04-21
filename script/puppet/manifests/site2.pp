class {"lamp::php_cli":}
->
class {"lamp::apache2::php5":}
->
class {"lamp::apache2::cgi_perl":}
->
class {"lamp::apache2::perl_mod":}

class {'lamp::mysql::mysql_server': }
class { 'memcached': }
package {['libmemcached10','libmemcached-tools']:
  ensure => 'installed'
}


#package
#libmysqlclient-dev
#apache2-dev
##CPAN
#Cache::Memcached::libmemcached
#DBIx::Password
#DBD::mysql
#Data::Dumper
#CGI
#YAML
#Digest::MD5
#Apache2::Directive
#Apache2::Cookie
#Apache2::Request
#Apache2::Upload
#Storable
#Mail::Sendmail
#Email::Valid
#HTML::Entities
#File::Slurp
