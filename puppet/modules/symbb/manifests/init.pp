class symbb {
    require nginx
    require utils
    require php
    require mysql

	$database_name = "symbb"
	$database_user = "root"
	$database_pw = "73wozGWmO1KgCBogtr8D"
	$secret = "sdff342tvgdf3hb3f35s"

	file { '/var/www/symbb/':
        ensure => absent ,
        recurse => true,
        purge => true,
        force => true,
    } ->
	exec { 'sudo git clone https://github.com/SymBB/symbb_sandbox.git /var/www/symbb/':
		path => '/usr/bin',
		cwd => '/var/www/'
	} ->
    file { '/vagrant/www/':
        ensure  => 'link',
        target  => '/var/www/',
    } ->
    file { 'vagrant-nginx-symbb':
        path => '/etc/nginx/sites-available/symbb',
        ensure => present,
        replace => true,
        source => 'puppet:///modules/symbb/symbb.vhost',
    } ->
    file { '/etc/nginx/sites-enabled/symbb':
        ensure  => 'link',
        target  => '/etc/nginx/sites-available/symbb',
    } ->
	file { 'vagrant-nginx-symbb-paramerters':
		path => '/var/www/symbb/app/config/parameters.yml',
		ensure => present,
        replace => true,
		content => template('symbb/parameters.yml.erb'),
	} ->
	#exec { 'sudo ant':
	#	path => '/usr/bin',
	#	timeout => 600,
	#	cwd => '/var/www/symbb/build/install/',
	#}
	exec { 'sudo /etc/init.d/nginx reload':
		path => '/usr/bin'
	}
}