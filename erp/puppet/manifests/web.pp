#$jdk_pacakge    = hiera('jdk_oracle::package')
#file {"/usr/local/java":
#    ensure=>"directory"
#}
#file {"copy jdk package":
#   path => "/usr/local/java/${jdk_pacakge}",
#   source => "/vagrant/${jdk_pacakge}",
#}
lamp::php::install{"php5":}

lamp::nginx::install{"erp.max.com":}
