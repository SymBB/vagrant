exec { 'apt-get update':
  path => '/usr/bin',
}

file { '/var/www/':
   ensure => 'directory',
 }

file { '/home/install/':
   ensure => 'directory',
 }

include utils, mysql, php, nginx, varnish, symbb