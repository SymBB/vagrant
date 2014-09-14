class utils {

	# Install the install needed stuff
	package { ['mcrypt', 'imagemagick', 'libssl-dev', 'libbz2-dev', 'memcached', 'build-essential', 'curl', 'git', 'ant']:
		ensure => present,
		require => Exec['apt-get update'],
	}
	
	debug("utils install complete!")
}