# Configure the Cinder service
#
# [*backend*]
#   (optional) Cinder backend to use.
#   Can be 'iscsi' or 'rbd'.
#   Defaults to 'iscsi'.
#
# [*volume_encryption*]
#   (optional) Boolean to configure or not volume encryption
#   Defaults to false.
#
# [*cinder_backup*]
#   (optional) Set type of cinder backup
#   Possible values: false, swift
#   defaults to false.
class openstack_integration::cinder (
  $backend           = 'iscsi',
  $volume_encryption = false,
  $cinder_backup     = false,
) {

  include ::openstack_integration::config
  include ::openstack_integration::params

  rabbitmq_user { 'cinder':
    admin    => true,
    password => 'an_even_bigger_secret',
    provider => 'rabbitmqctl',
    require  => Class['::rabbitmq'],
  }
  rabbitmq_user_permissions { 'cinder@/':
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
    require              => Class['::rabbitmq'],
  }

  if $::openstack_integration::config::ssl {
    openstack_integration::ssl_key { 'cinder':
      notify  => Service['httpd'],
      require => Package['cinder'],
    }
    Exec['update-ca-certificates'] ~> Service['httpd']
  }
  class { '::cinder::db::mysql':
    password => 'cinder',
  }
  class { '::cinder::keystone::auth':
    public_url      => "${::openstack_integration::config::base_url}:8776/v1/%(tenant_id)s",
    internal_url    => "${::openstack_integration::config::base_url}:8776/v1/%(tenant_id)s",
    admin_url       => "${::openstack_integration::config::base_url}:8776/v1/%(tenant_id)s",
    public_url_v2   => "${::openstack_integration::config::base_url}:8776/v2/%(tenant_id)s",
    internal_url_v2 => "${::openstack_integration::config::base_url}:8776/v2/%(tenant_id)s",
    admin_url_v2    => "${::openstack_integration::config::base_url}:8776/v2/%(tenant_id)s",
    public_url_v3   => "${::openstack_integration::config::base_url}:8776/v3/%(tenant_id)s",
    internal_url_v3 => "${::openstack_integration::config::base_url}:8776/v3/%(tenant_id)s",
    admin_url_v3    => "${::openstack_integration::config::base_url}:8776/v3/%(tenant_id)s",
    password        => 'a_big_secret',
  }
  class { '::cinder':
    database_connection => 'mysql+pymysql://cinder:cinder@127.0.0.1/cinder?charset=utf8',
    rabbit_host         => $::openstack_integration::config::ip_for_url,
    rabbit_port         => $::openstack_integration::config::rabbit_port,
    rabbit_userid       => 'cinder',
    rabbit_password     => 'an_even_bigger_secret',
    rabbit_use_ssl      => $::openstack_integration::config::ssl,
    debug               => true,
  }
  if $volume_encryption {
    $keymgr_api_class           = 'castellan.key_manager.barbican_key_manager.BarbicanKeyManager'
    $keymgr_encryption_api_url  = "${::openstack_integration::config::base_url}:9311"
    $keymgr_encryption_auth_url = "${::openstack_integration::config::keystone_auth_uri}/v3"
  } else {
    $keymgr_api_class           = undef
    $keymgr_encryption_api_url  = undef
    $keymgr_encryption_auth_url = undef
  }
  class { '::cinder::keystone::authtoken':
    password            => 'a_big_secret',
    user_domain_name    => 'Default',
    project_domain_name => 'Default',
    auth_url            => $::openstack_integration::config::keystone_admin_uri,
    auth_uri            => $::openstack_integration::config::keystone_auth_uri,
    memcached_servers   => $::openstack_integration::config::memcached_servers,
  }
  class { '::cinder::api':
    default_volume_type        => 'BACKEND_1',
    public_endpoint            => "${::openstack_integration::config::base_url}:8776",
    service_name               => 'httpd',
    keymgr_api_class           => $keymgr_api_class,
    keymgr_encryption_api_url  => $keymgr_encryption_api_url,
    keymgr_encryption_auth_url => $keymgr_encryption_auth_url,
  }
  include ::apache
  class { '::cinder::wsgi::apache':
    bind_host => $::openstack_integration::config::ip_for_url,
    ssl       => $::openstack_integration::config::ssl,
    ssl_key   => "/etc/cinder/ssl/private/${::fqdn}.pem",
    ssl_cert  => $::openstack_integration::params::cert_path,
    workers   => 2,
  }
  class { '::cinder::quota': }
  class { '::cinder::scheduler': }
  class { '::cinder::scheduler::filter': }
  class { '::cinder::volume':
    volume_clear => 'none',
  }
  class { '::cinder::cron::db_purge': }
  class { '::cinder::glance':
    glance_api_servers => "${::openstack_integration::config::base_url}:9292",
  }
  case $backend {
    'iscsi': {
      class { '::cinder::setup_test_volume':
        size => '15G',
      }
      cinder::backend::iscsi { 'BACKEND_1':
        iscsi_ip_address => '127.0.0.1',
      }
    }
    'rbd': {
      cinder::backend::rbd { 'BACKEND_1':
        rbd_user        => 'openstack',
        rbd_pool        => 'cinder',
        rbd_secret_uuid => '7200aea0-2ddd-4a32-aa2a-d49f66ab554c',
      }
      # make sure ceph pool exists before running Cinder API & Volume
      Exec['create-cinder'] -> Service['httpd']
      Exec['create-cinder'] -> Service['cinder-volume']
    }
    default: {
      fail("Unsupported backend (${backend})")
    }
  }
  class { '::cinder::backends':
    enabled_backends => ['BACKEND_1'],
  }
  cinder_type { 'BACKEND_1':
    ensure     => present,
    properties => ['volume_backend_name=BACKEND_1'],
  }

  if $cinder_backup == swift {
    include ::cinder::backup
    class { '::cinder::backup::swift':
      backup_swift_user_domain    => 'Default',
      backup_swift_project_domain => 'Default',
      backup_swift_project        => 'Default',
    }
  }

}
