class varnish {

	# Install the install varnish
	package { ['varnish']:
		ensure => present,
		require => Exec['apt-get update'],
	}

}