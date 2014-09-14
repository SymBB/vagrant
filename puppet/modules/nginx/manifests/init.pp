class nginx {

    require php
    require mysql

  ##################
  ## Default nginx #
  ##################
  
  ################################################################################################
  # Build nginx with pagespeed                                                                   #
  # https://developers.google.com/speed/pagespeed/module/build_ngx_pagespeed_from_source?hl=de   #
  ################################################################################################
  
	$pagespeed_version = "1.8.31.4"
	$nginx_version = "1.7.3"

	notify {'starting compiling nginx ${nginx_version} with pagespeed ${pagespeed_version}!':}
     -> # and then:
	exec { 'cd for installing pagespeed':
	    command => "cd",
		path => '/usr/bin',
	} -> # and then:
	# Install the install build-essential zlib1g-dev libpcre3 libpcre3-dev packages
	package { ['build-essential','zlib1g-dev', 'libpcre3', 'libpcre3-dev']:
		ensure => present,
		require => Exec['apt-get update'],
	} -> # and then:
	exec { 'wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${pagespeed_version}-beta.zip':
		path => '/usr/bin',
	} -> # and then:
	exec { 'unzip release-${pagespeed_version}-beta.zip':
		path => '/usr/bin',
	} -> # and then:
	exec { 'cd ngx_pagespeed-release-${pagespeed_version}-beta/':
		path => '/usr/bin',
	} -> # and then:
	exec { 'wget https://dl.google.com/dl/page-speed/psol/${pagespeed_version}.tar.gz':
		path => '/usr/bin',
	} -> # and then:
	exec { 'tar -xzvf ${pagespeed_version}.tar.gz  # extracts to psol/':
		path => '/usr/bin',
	} -> # and then:
	exec { 'cd for installing nginx':
        command => "cd",
        path => '/usr/bin',
    } -> # and then:
	exec { 'wget http://nginx.org/download/nginx-${nginx_version}.tar.gz':
		path => '/usr/bin',
	} -> # and then:
	exec { 'tar -xvzf nginx-${nginx_version}.tar.gz':
		path => '/usr/bin',
	} -> # and then:
	exec { 'cd nginx-${nginx_version}/':
		path => '/usr/bin',
	} -> # and then:
	exec { './configure --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --lock-path=/var/lock/nginx.lock --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=www-data --group=www-data --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --without-http_uwsgi_module --without-http_scgi_module --with-ipv6 --with-http_ssl_module --with-http_spdy_module --with-http_stub_status_module --with-http_gzip_static_module --with-http_realip_module --add-module=$HOME/ngx_pagespeed-release-${pagespeed_version}-beta':
		path => '/usr/bin',
	} -> # and then:
	exec { 'make':
		path => '/usr/bin',
	} -> # and then:
	exec { 'make install':
		path => '/usr/bin',
	} -> # and then:
	notify {'nginx is now compiled with pagespeed!':}
	-> # and then:

	###################
	# default config  #
	###################

	# Make sure that the nginx service is running
	service { 'nginx':
		ensure => running
	} -> # and then:
	# Disable the default nginx vhost
	file { 'default-nginx-disable':
		path => '/etc/nginx/sites-enabled/default',
		ensure => absent
	} -> # and then:
	# nginx configuration
	file { 'vagrant-nginx-conf':
		path => '/etc/nginx/nginx.conf',
		ensure => file,
		source => 'puppet:///modules/nginx/nginx.conf',
	} -> # and then:
	# pagespeed cache dir
	file { "/var/cache/ngx_pagespeed_cache":
		ensure => "directory",
		mode   => 750,
	} -> # and then:
	# Add a vhost template for symfony applications
	file { 'vagrant-nginx-default-symfony2':
		path => '/etc/nginx/default-symfony2',
		ensure => file,
		source => 'puppet:///modules/nginx/default-symfony2.vhost',
	} -> # and then:
	file { 'vagrant-nginx-default-symfony2-dev':
		path => '/etc/nginx/default-symfony2-dev',
		ensure => file,
		source => 'puppet:///modules/nginx/default-symfony2-dev.vhost',
	} -> # and then:
	notify {'nginx is now configured!':}
    -> # and then:
	##################
	## symbb vhost   #
	##################
	notify {'adding symbb nginx vhost':}
     -> # and then:
	# Symlink /var/www/symbb on our guest with 
	# host /path/to/vagrant/symbb on our system
	file { '/var/www/symbb':
		ensure  => 'link',
		target  => '/vagrant/symbb',
	} -> # and then:

	# Add a vhost template for symbb
	file { 'vagrant-nginx':
		path => '/etc/nginx/sites-available/symbb',
		ensure => file,
		source => 'puppet:///modules/nginx/symbb.vhost',
	} -> # and then:

	# Symlink our vhost in sites-enabled to enable it
	file { 'vagrant-nginx-enable':
		path => '/etc/nginx/sites-enabled/symbb',
		target => '/etc/nginx/sites-available/symbb',
		ensure => link,
		notify => Service['nginx'],
		require => [
		  File['vagrant-nginx'],
		  File['default-nginx-disable'],
		],
	} -> # and then:

	notify {'symbb nginx vhost is complete!':}
}