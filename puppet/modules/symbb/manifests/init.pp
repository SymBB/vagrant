class symbb {
    require nginx
    require utils
    require php
    require mysql

	$database_name = "symbb"
	$database_user = "root"
	$database_password = "73wozGWmO1KgCBogtr8D"

    file { '/var/www/symbb':
        ensure  => 'link',
        target  => '/vagrant/symbb',
    } ->
    file { 'vagrant-nginx':
        path => '/etc/nginx/sites-available/symbb',
        ensure => present,
        source => 'puppet:///modules/symbb/symbb.vhost',
    } ->
    file { 'vagrant-nginx-enable':
        path => '/etc/nginx/sites-enabled/symbb',
        target => '/etc/nginx/sites-available/symbb',
        ensure => link
    } ->
	exec { 'git clone git@github.com:SymBB/symbb_sandbox.git':
		path => '/usr/bin',
		cwd => '/var/www/symbb'
	} ->
	file { 'vagrant-symbb-paramerters':
		path => '/var/www/symbb/app/config/parameters.yml',
		ensure => file,
		content => template('symbb/parameters.yml.erb'),
	} ->
	exec { 'ant':
		path => '/usr/bin',
		cwd => '/var/www/symbb/build/install/',
	}
}