# Config common to all nodes
class profiles::common {
    include apt 
    class { '::ntp':
      servers => [ 'cn.ntp.org.cn' ],
   }
   class { 'firewall': ensure=> 'stopped'}

}
