class mysql {
    require utils

	$root_pw = "73wozGWmO1KgCBogtr8D"

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
		unless  => 'mysqladmin -uroot -proot status',
		command => "mysqladmin -uroot password ${root_pw}",
		path    => ['/bin', '/usr/bin'],
		require => Service['mysql'];
	} ->

	notify {'mysql install complete! root PW is: ${root_pw}':}
}