class symbb {
    require nginx
    require utils
    require php
    require mysql

	$database_name = "symbb"
	$database_user = "root"
	$database_password = "73wozGWmO1KgCBogtr8D"

	notify {
	    'start install symbb sandbox version':
	} ->
    exec { 'cd to sf dir for cloning':
        command => "cd /var/www/symbb",
        path => '/usr/bin',
    } ->
	exec { 'git clone git@github.com:SymBB/symbb_sandbox.git':
		path => '/usr/bin',
	} ->
	notify {
	    'cloning symbb_sandbox finished!':
	} ->
	file { 'vagrant-symbb-paramerters':
		path => '/var/www/symbb/app/config/parameters.yml',
		ensure => file,
		content => template('symbb/parameters.yml.erb'),
	} ->
	exec { 'cd /var/www/symbb/build/install/':
		path => '/usr/bin',
	} ->
	notify {
	    'starting build script!':
	} ->
	exec { 'ant':
		path => '/usr/bin',
	} ->
	notify {
        'install finished!':
    }
}