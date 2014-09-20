class mysql {

  require utils

	# Install the install mysql server
	package { ['mysql-server']:
		ensure => present,
		require => Exec['apt-get update'],
	} ->
	# Run mysql
	service { 'mysql':
		ensure  => running,
		require => Package['mysql-server'],
	} ->
  # We set the root password here
	exec { 'set-mysql-password':
        subscribe => [ Package["mysql-server"] ],
        refreshonly => true,
        unless => "mysqladmin -uroot -p 73wozGWmO1KgCBogtr8D status",
        path => "/bin:/usr/bin",
        command => "mysqladmin -uroot password 73wozGWmO1KgCBogtr8D",
	} ->
  # clone phpmyadmin
  file { '/var/www/phpmyadmin/':
    ensure => absent ,
    recurse => true,
    purge => true,
    force => true,
  } ->
  exec { 'sudo git clone https://github.com/phpmyadmin/phpmyadmin.git /var/www/phpmyadmin/':
    path => '/usr/bin',
    timeout => 600,
    cwd => '/var/www/'
  }
}