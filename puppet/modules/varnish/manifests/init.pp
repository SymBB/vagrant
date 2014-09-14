class varnish {
	# Install the install varnish
	package { ['varnish']:
		ensure => present,
		require => Exec['apt-get update'],
	} ->
    file { 'vagrant-varnish-conf':
        path => '/etc/varnish/default.vcl',
        ensure => present,
        replace => true,
        source => 'puppet:///modules/varnish/default.vcl',
    } ->
    service { 'varnish':
        ensure => running
    }
}