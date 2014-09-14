class utils {

	# Install the install needed stuff
	package { ['mcrypt', 'imagemagick', 'libssl-dev', 'libbz2-dev', 'memcached', 'curl', 'git', 'ant', 'openssh-server', 'unzip', 'tar', 'openjdk-6-jdk', 'acl']:
		ensure => present,
		require => Exec['apt-get update'],
	}
}