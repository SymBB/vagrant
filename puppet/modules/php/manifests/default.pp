class php {

	# Install the install varnish
	package { ['php-pear', 'php5-dev', 'php5-mysql', 'php5-mcyrpt', 'php5-fpm', 'php5-apc', 'php5-common', 'php5-gd', 'php-auth', 'php5-imagick', 'php5-cgi', 'php5-curl', 'php5-intl', 'php5-memcached', 'php5-sqlite']:
		ensure => present,
		require => Exec['apt-get update'],
	}
	
	file { 'vagrant-php-ini':
		path => '/etc/php5/fpm/php.ini',
		ensure => file,
		require => Package['nginx'],
		  source => 'puppet:///modules/php/php.ini',
	}
	
	file { 'vagrant-php-pool-www':
		path => '/etc/php5/fpm/pool.d/www.conf',
		ensure => file,
		require => Package['nginx'],
		  source => 'puppet:///modules/php/www.conf',
	}
	
	debug("php install complete!")
}