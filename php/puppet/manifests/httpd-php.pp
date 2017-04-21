node 'my1.max.com' {
   include apt
   Class['apt::update'] -> Package<| |>

   apt::ppa { 'ppa:mc3man/trusty-media': }
   ->
   package {['graphicsmagick','imagemagick','ffmpeg']: 
     ensure => "installed"
   }
   
   lamp::php::cli{"php5": }
   ->
   lamp::apache2::install {"apache2":   }

   class {"lamp::mysql::mysql_server": }
}
