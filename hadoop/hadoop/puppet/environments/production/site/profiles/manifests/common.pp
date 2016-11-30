# Config common to all nodes
class profiles::common {
   include stdlib
   include apt
   include jdk_oracle

   class { '::ntp':
      servers => [ 'cn.ntp.org.cn' ],
   }


   class { 'firewall': ensure=> 'stopped'}

}
