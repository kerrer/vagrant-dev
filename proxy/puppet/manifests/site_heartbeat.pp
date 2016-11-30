class { 'nginx': }
nginx::resource::vhost { 'rack.max.com':
  proxy => 'http://www.bing.com:80',
}
nginx::resource::vhost { 'rack2.max.com':
  proxy => 'http://www.yx129.com:80',
}
 $my_config = {
#    'ip_hash'=>'',
#    'zone http_backend'   => '64k',
#   'least_conn' => '',
   'keepalive' => '20'
 }
nginx::resource::upstream { 'puppet_rack_app':
  members => [
    'www.yx129.com max_fails=2',
#    'gzrimi.com',
#    'www.ysp168.com',
  ],
  upstream_cfg_prepend => $my_config,
}

nginx::resource::vhost { 'rack3.max.com':
  proxy => 'http://puppet_rack_app',
  proxy_set_header =>['host $host','X-Real-IP $remote_addr','X-Forwarded-For $proxy_add_x_forwarded_for'],
  client_max_body_size => "128M",
  ssl                  => true,
   ssl_cert              => 'puppet:///modules/nginx/self-ssl.crt',
   ssl_key               => 'puppet:///modules/nginx/self-ssl.key',
  ssl_port             => 443,
}
