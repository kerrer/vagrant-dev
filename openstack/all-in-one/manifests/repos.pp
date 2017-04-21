class openstack_integration::repos {

  case $::osfamily {
    'Debian': {
      include ::apt
      class { '::openstack_extras::repo::debian::ubuntu':
        release         => 'newton',
        package_require => true,
        uca_location    => $::uca_mirror_host,
      }
      # Ceph is both packaged on UCA & ceph.com
      # Official packages are on ceph.com so we want to make sure
      # Ceph will be installed from there.
      apt::pin { 'ceph':
        priority => 1001,
        origin   => 'download.ceph.com',
      }
    }
    'RedHat': {
      class { '::openstack_extras::repo::redhat::redhat':
        manage_rdo  => false,
        manage_epel => false,
        repo_hash   => {
          'ocata-puppet-passed-ci' => {
            'baseurl'  => 'https://trunk.rdoproject.org/centos7-master/puppet-passed-ci/',
            'descr'    => 'Ocata puppet-passed-ci',
            'gpgcheck' => 'no',
            'priority' => 1,
          },
          'ocata-delorean-deps'    => {
            'baseurl'  => 'http://buildlogs.centos.org/centos/7/cloud/x86_64/openstack-ocata',
            'descr'    => 'Ocata delorean-deps',
            'gpgcheck' => 'no',
            'priority' => 1,
          },
        }
      }
    }
    default: {
      fail("Unsupported osfamily (${::osfamily})")
    }
  }

  # On CentOS, deploy Ceph using SIG repository and get rid of EPEL.
  # https://wiki.centos.org/SpecialInterestGroup/Storage/
  if $::operatingsystem == 'CentOS' {
    $enable_sig  = true
    $enable_epel = false
  } else {
    $enable_sig  = false
    $enable_epel = true
  }

  class { '::ceph::repo':
    enable_sig  => $enable_sig,
    enable_epel => $enable_epel,
    ceph_mirror => $::ceph_mirror_host,
  }

}
