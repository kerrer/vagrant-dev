# Config common to all nodes
class profiles::common {

   include '::tuned'
   include disable_transparent_hugepage

   class { '::ntp':
      servers => [ 'cn.ntp.org.cn' ],
   }

   class { 'firewall': ensure=> 'stopped'}

   Class['tuned'] -> Class['disable_transparent_hugepage']
}
