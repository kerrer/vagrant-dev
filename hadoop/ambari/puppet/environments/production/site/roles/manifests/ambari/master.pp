# default server role
class roles::ambari::master {
    include profiles::common
    include profiles::mysql
    include profiles::ambari::server
    
}
