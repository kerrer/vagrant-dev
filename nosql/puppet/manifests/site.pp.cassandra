#cassandra cluster 

$nodes=['192.168.56.41','192.168.56.42','192.168.56.43']


node 'my1.max.com' {
  class { 'jdk_oracle': }

 class {"lamp::nosql::cassandra":
     version=>"2.2.0",
     nodes=>$nodes,   
 }

}

node 'my2.max.com' {
  class { 'jdk_oracle': }

 class {"lamp::nosql::cassandra":
     version=>"2.2.0",
     nodes=>$nodes,   
 }
   
}

node 'my3.max.com' {
   class { 'jdk_oracle': }

 class {"lamp::nosql::cassandra":
     version=>"2.2.0",
     nodes=>$nodes,   
 }
}


