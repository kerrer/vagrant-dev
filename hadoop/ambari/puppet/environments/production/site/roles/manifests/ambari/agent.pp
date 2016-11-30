# default server role
class roles::ambari::agent {
    include profiles::common
    include profiles::ambari::client
    
}
