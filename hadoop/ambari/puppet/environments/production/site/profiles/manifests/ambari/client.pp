# Config common to all nodes
class profiles::ambari::client {
   class { '::ambari::agent':
       ambari_server => 'master.ambari'
   }
}
