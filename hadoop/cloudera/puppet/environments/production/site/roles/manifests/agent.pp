# OpenVPN server role
class roles::agent {
    include profiles::common
    include profiles::ssh::all
    include profiles::cloudera::agent
}
