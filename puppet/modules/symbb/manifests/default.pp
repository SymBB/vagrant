class symbb {

	debug("start install symbb sandbox version")

	$database_name = "symbb"
	$database_user = "root"
	$database_password = "73wozGWmO1KgCBogtr8D"
	
	exec { 'cd /var/www/symbb':
		path => '/usr/bin',
	}
	
	exec { 'git clone git@github.com:SymBB/symbb_sandbox.git':
		path => '/usr/bin',
	}
	
	debug("cloning symbb_sandbox finished!")
	
	file { 'vagrant-symbb-paramerters':
		path => '/var/www/symbb/app/config/parameters.yml',
		ensure => file,
		require => Package['nginx'],
		content => template('files/parameters.yml.erb'),
	}
	
	exec { 'cd /var/www/symbb/build/install/':
		path => '/usr/bin',
	}
	
	debug("starting build script!")
	
	exec { 'ant':
		path => '/usr/bin',
	}
	
	debug("install finished!")
	
}