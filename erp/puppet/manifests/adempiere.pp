#
# build for adempiereERP
#

class { 'jdk_oracle': }

package { "ant":
    ensure => "installed"
}
->
file { "/etc/profile.d/cus_env.sh":
  content => "export ANT_OPTS='-Xmx1024M -XX:MaxPermSize=128M'"
}

