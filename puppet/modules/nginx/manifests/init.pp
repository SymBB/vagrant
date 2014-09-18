class nginx {

    require php
    require mysql
  
  ################################################################################################
  # Build nginx with pagespeed                                                                   #
  # https://developers.google.com/speed/pagespeed/module/build_ngx_pagespeed_from_source?hl=de   #
  ################################################################################################
  
	$pagespeed_version = "1.8.31.4"
	$nginx_version = "1.7.3"

	# Install the install build-essential zlib1g-dev libpcre3 libpcre3-dev packages
	package { ['build-essential','zlib1g-dev', 'libpcre3', 'libpcre3-dev']:
		ensure => present,
		require => Exec['apt-get update'],
	} -> # and then:
	exec { 'wget https://github.com/pagespeed/ngx_pagespeed/archive/release-1.8.31.4-beta.zip':
		path => '/usr/bin',
		cwd => '/home/install/'
	} -> # and then:
	file { 'remove old pagespeed folder':
    path => '/home/install/ngx_pagespeed-release-1.8.31.4-beta/',
    ensure => absent,
    recurse => true,
    purge => true,
    force => true,
  } ->
	exec { 'unzip release-1.8.31.4-beta.zip':
		path => '/usr/bin',
		cwd => '/home/install/'
	} -> # and then:
	exec { 'wget https://dl.google.com/dl/page-speed/psol/1.8.31.4.tar.gz':
		path => '/usr/bin',
		cwd => '/home/install/ngx_pagespeed-release-1.8.31.4-beta/'
	} -> # and then:
	file { 'remove old psol pagespeed folder':
    path => '/home/install/ngx_pagespeed-release-1.8.31.4-beta/psol',
    ensure => absent,
    recurse => true,
    purge => true,
    force => true,
  } ->
	exec { 'tar -xzvf 1.8.31.4.tar.gz':
    command => 'tar -xzvf 1.8.31.4.tar.gz',
    path => '/bin',
		cwd => '/home/install/ngx_pagespeed-release-1.8.31.4-beta/'
	} -> # and then:
	exec { 'wget http://nginx.org/download/nginx-1.7.3.tar.gz':
		path => '/usr/bin',
		cwd => '/home/install/'
	} -> # and then:
	file { 'remove old nginx folder':
    path => '/home/install/nginx-1.7.3/',
    ensure => absent,
    recurse => true,
    purge => true,
    force => true,
  } ->
	exec { 'tar -xvzf nginx-1.7.3.tar.gz':
    command => 'tar -xvzf nginx-1.7.3.tar.gz',
		path => '/bin',
		cwd => '/home/install/'
	} -> # and then:
	exec { 'sudo /home/install/nginx-1.7.3/configure --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --lock-path=/var/lock/nginx.lock --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=www-data --group=www-data --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --without-http_uwsgi_module --without-http_scgi_module --with-ipv6 --with-http_ssl_module --with-http_spdy_module --with-http_stub_status_module --with-http_gzip_static_module --with-http_realip_module --add-module=/home/install/ngx_pagespeed-release-1.8.31.4-beta':
		path => '/usr/bin',
		cwd => '/home/install/nginx-1.7.3/'
	} -> # and then:
	exec { 'sudo make':
		path => '/usr/bin',
		cwd => '/home/install/nginx-1.7.3/'
	} -> # and then:
	exec { 'sudo make install':
		path => '/usr/bin',
		cwd => '/home/install/nginx-1.7.3/'
	} -> # and then:
  file { 'vagrant-nginx-initscript':
    path => '/etc/init.d/nginx',
    ensure => present,
    replace => true,
    source => 'puppet:///modules/nginx/init.d/nginx',
  } ->
	file { '/etc/nginx/sites-available/':
    ensure => directory ,
  } ->
	file { '/etc/nginx/sites-enabled/':
    ensure => directory ,
  } ->
	file { 'default-nginx-disable':
		path => '/etc/nginx/sites-enabled/default',
		ensure => absent
	} ->
	file { 'vagrant-nginx-conf':
		path => '/etc/nginx/nginx.conf',
		ensure => present,
    replace => true,
		source => 'puppet:///modules/nginx/nginx.conf',
	} ->
	file { "/var/cache/ngx_pagespeed_cache":
		ensure => "directory",
		mode   => 750,
	} ->
	file { 'vagrant-nginx-default-symfony2':
		path => '/etc/nginx/default-symfony2',
		ensure => present,
    replace => true,
		source => 'puppet:///modules/nginx/vhost/default-symfony2.vhost',
	} ->
	file { 'vagrant-nginx-default-symfony2-dev':
		path => '/etc/nginx/default-symfony2-dev',
		ensure => present,
    replace => true,
		source => 'puppet:///modules/nginx/vhost/default-symfony2-dev.vhost',
	} ->
  file { '/etc/nginx/sites-available/phpmyadmin':
    ensure => present,
    replace => true,
    source => 'puppet:///modules/nginx/vhost/phpmyadmin.vhost',
  } ->
  file { '/etc/nginx/sites-enabled/phpmyadmin':
    ensure  => 'link',
    target  => '/etc/nginx/sites-available/phpmyadmin',
  } ->
  file { '/var/log/phpmyadmin':
    ensure => directory,
    owner  => "www-data"
  } ->
  file { '/var/log/phpmyadmin/access.log':
    ensure => present,
    owner  => "www-data"
  } ->
  file { '/var/log/phpmyadmin/error.log':
    ensure => present,
    owner  => "www-data"
  } ->
	service { 'nginx start':
    name => "nginx",
		ensure => running
	}
}