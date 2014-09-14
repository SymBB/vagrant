exec { 'apt-get update':
  path => '/usr/bin',
}

file { '/var/www/':
  ensure => 'directory',
}

include utils, mysql, php, nginx, varnish, symbb