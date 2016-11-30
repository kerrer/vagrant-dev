node 'my1.max.com' {  
    class {"lamp::mysql::server":
      version =>"5.6.25",
      num =>2,
      sid=>4,
      port=>3306
   }
}

node 'my2.max.com' {
    class { 'supervisord':
       install_pip => true,    
    } 
    
   class {"lamp::mysql::server":
      version =>"5.6.25",
      num =>2,
      sid=>4,
      port=>3306
   }
   # class { "lamp::mysql::multidb::ha":
   #    sid => 4,
   #    num => 2,
   #    require => Class['supervisord']
   # }
}

node 'my3.max.com' {  
    class { 'supervisord':
       install_pip => true,    
    }  
    
     class { "lamp::mysql::multidb::ha":
       server_id=>8,
       require => Class['supervisord']
    }
}

node 'my4.max.com' {    
    class { 'supervisord':
       install_pip => true,    
    } 
    
    class { "lamp::mysql::multidb::ha":
       server_id=>12,
       require => Class['supervisord']
    }
}
