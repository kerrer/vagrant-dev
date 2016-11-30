# Config common to all nodes

class profiles::hadoop::install {
  
  class{'hbase':
  hdfs_hostname => "hadoop.max.com",
  master_hostname => "hadoop.max.com",
  zookeeper_hostnames => [ "hadoop.max.com" ],
  external_zookeeper => true,
  slaves => [ "hadoop.max.com" ],
  frontends => [ "hadoop.max.com" ],
  realm => '',
  features => {
    hbmanager => true,
  },
}


class{"hadoop":
  hdfs_hostname => "hadoop.max.com",
  yarn_hostname => "hadoop.max.com",
  slaves => [ "hadoop.max.com" ],
  frontends => [ "hadoop.max.com" ],
  properties => {
    'dfs.replication' => 1,
  },
  zookeeper_hostnames => [ "hadoop.max.com" ],
  zookeeper_deployed      => true
}
  include hadoop::namenode
  # YARN
  include hadoop::resourcemanager
  # MAPRED
  include hadoop::historyserver
  # slave (HDFS)
  include hadoop::datanode
  # slave (YARN)
  include hadoop::nodemanager
  # client
  include hadoop::frontend

  include hbase::master
  include hbase::regionserver
  include hbase::frontend
  include hbase::hdfs

  class{'zookeeper':
    hostnames => [ "hadoop.max.com" ],
    realm => '',
  }

  Class['hadoop::namenode::service'] -> Class['hbase::hdfs']
  Class['hadoop::namenode::service'] -> Class['hbase::master::service']
}
