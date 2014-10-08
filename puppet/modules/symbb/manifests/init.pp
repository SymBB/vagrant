class symbb {

  require nginx
  require utils
  require php
  require mysql

  $database_name = "symbb"
  $database_user = "root"
  $database_pw = "73wozGWmO1KgCBogtr8D"
  $secret = "sdff342tvgdf3hb3f35s"

  exec { 'sudo git clone https://github.com/SymBB/symbb_sandbox.git /var/www/symbb/':
    path => '/usr/bin',
    cwd  => '/var/www/',
    user => "www-data"
  } ->
  file { 'set owner of symbb dir':
    path    => '/var/www/symbb/',
    ensure  => directory ,
    owner   => "www-data",
    recurse => true,
    force   => true
  }  ->
  file { 'vagrant-nginx-symbb':
    path    => '/etc/nginx/sites-available/symbb',
    ensure  => present,
    replace => true,
    source  => 'puppet:///modules/symbb/symbb.vhost',
  } ->
  file { '/etc/nginx/sites-enabled/symbb':
    ensure  => 'link',
    target  => '/etc/nginx/sites-available/symbb',
  } ->
  file { 'vagrant-nginx-symbb-paramerters':
    path    => '/var/www/symbb/app/config/parameters.yml',
    ensure  => present,
    replace => true,
    content => template('symbb/parameters.yml.erb'),
  } ->
  file { '/var/www/symbb/app/logs/':
    ensure => directory ,
    owner  => "www-data"
  } ->
  file { '/var/www/symbb/app/cache/':
    ensure => directory ,
    owner  => "www-data"
  } ->
  file { '/var/log/symbb':
    ensure => directory,
    owner  => "www-data"
  } ->
  file { '/var/log/symbb/access.log':
    ensure => present,
    owner  => "www-data"
  } ->
  file { '/var/log/symbb/error.log':
    ensure => present,
    owner  => "www-data"
  } ->
  exec { 'sudo ant':
    path    => '/usr/bin',
    timeout => 0,
    cwd     => '/var/www/symbb/build/install/',
  } ->
  exec { 'sudo /etc/init.d/nginx restart':
    path => '/usr/bin'
  }
}
