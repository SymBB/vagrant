exec { 'apt-get update':
  path => '/usr/bin',
} ->
file { 'link dir www':
  path => '/var/www/',
  ensure  => 'link',
  target  => '/vagrant/www/',
} ->
file { '/home/install/':
   ensure => 'directory',
}

include utils, mysql, php, nginx, varnish, symbb