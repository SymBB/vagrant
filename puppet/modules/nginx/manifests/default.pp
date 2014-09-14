class nginx {

  ##################
  ## Default Ngnix #
  ##################
  
  ################################################################################################
  # Build ngnix with pagespeed                                                                   #
  # https://developers.google.com/speed/pagespeed/module/build_ngx_pagespeed_from_source?hl=de   #
  ################################################################################################
  
	$pagespeed_version = "1.8.31.4"
	$nginx_version = "1.7.3"

	debug("starting compiling ngnix ${nginx_version} with pagespeed ${pagespeed_version}!")

	exec { 'cd':
		path => '/usr/bin',
	}
	
	# Install the install build-essential zlib1g-dev libpcre3 libpcre3-dev packages
	package { ['build-essential','zlib1g-dev', 'libpcre3', 'libpcre3-dev']:
		ensure => present,
		require => Exec['apt-get update'],
	}

	exec { 'wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${pagespeed_version}-beta.zip':
		path => '/usr/bin',
	}

	exec { 'unzip release-${pagespeed_version}-beta.zip':
		path => '/usr/bin',
	}

	exec { 'cd ngx_pagespeed-release-${pagespeed_version}-beta/':
		path => '/usr/bin',
	}

	exec { 'wget https://dl.google.com/dl/page-speed/psol/${pagespeed_version}.tar.gz':
		path => '/usr/bin',
	}

	exec { 'tar -xzvf ${pagespeed_version}.tar.gz  # extracts to psol/':
		path => '/usr/bin',
	}

	exec { 'cd':
		path => '/usr/bin',
	}

	exec { 'wget http://nginx.org/download/nginx-${nginx_version}.tar.gz':
		path => '/usr/bin',
	}

	exec { 'tar -xvzf nginx-${nginx_version}.tar.gz':
		path => '/usr/bin',
	}

	exec { 'cd nginx-${nginx_version}/':
		path => '/usr/bin',
	}

	exec { './configure --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --lock-path=/var/lock/nginx.lock --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --user=www-data --group=www-data --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --without-http_uwsgi_module --without-http_scgi_module --with-ipv6 --with-http_ssl_module --with-http_spdy_module --with-http_stub_status_module --with-http_gzip_static_module --with-http_realip_module --add-module=$HOME/ngx_pagespeed-release-${pagespeed_version}-beta':
		path => '/usr/bin',
	}

	exec { 'make':
		path => '/usr/bin',
	}

	exec { 'make install':
		path => '/usr/bin',
	}
	
	debug("ngnix is now compiled with pagespeed!")

	###################
	# default config  #
	###################

	# Make sure that the nginx service is running
	service { 'nginx':
		ensure => running,
		require => Package['nginx'],
	}

	# Disable the default nginx vhost
	file { 'default-nginx-disable':
		path => '/etc/nginx/sites-enabled/default',
		ensure => absent,
		require => Package['nginx'],
	}
	
	# ngnix configuration
	file { 'vagrant-nginx-conf':
		path => '/etc/nginx/nginx.conf',
		ensure => file,
		require => Package['nginx'],
		  source => 'puppet:///modules/nginx/nginx.conf',
	}
	
	# pagespeed cache dir
	file { "/var/cache/ngx_pagespeed_cache":
		ensure => "directory",
		mode   => 750,
	}
	
	# Add a vhost template for symfony applications
	file { 'vagrant-nginx-default-symfony2':
		path => '/etc/nginx/default-symfony2',
		ensure => file,
		require => Package['nginx'],
		  source => 'puppet:///modules/nginx/default-symfony2.vhost',
	}
	file { 'vagrant-nginx-default-symfony2-dev':
		path => '/etc/nginx/default-symfony2-dev',
		ensure => file,
		require => Package['nginx'],
		  source => 'puppet:///modules/nginx/default-symfony2-dev.vhost',
	}
	
	debug("ngnix is now configured!")

	##################
	## symbb vhost   #
	##################
	
	debug("adding symbb ngnix vhost")

	# Symlink /var/www/symbb on our guest with 
	# host /path/to/vagrant/symbb on our system
	file { '/var/www/symbb':
		ensure  => 'link',
		target  => '/vagrant/symbb',
	}

	# Add a vhost template for symbb
	file { 'vagrant-nginx':
		path => '/etc/nginx/sites-available/symbb',
		ensure => file,
		require => Package['nginx'],
		  source => 'puppet:///modules/nginx/symbb.vhost',
	}

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
	}
	
	debug("symbb ngnix vhost is complete!")
	
	exec { 'cd /var/www/symbb':
		path => '/usr/bin',
	}
	
	exec { 'git clone git@github.com:SymBB/symbb_sandbox.git':
		path => '/usr/bin',
	}
	
	debug("cloning symbb_sandbox finished!")
}