# == Class Bamboo
class bamboo {

  user { 'bamboo':
    ensure     => present,
    managehome => true,
    password   => '$6$mFuIDZDa52$U8BZQEEt9qZcoZzZFcx0Wm1JzZro02VBm0Ih2usngmjM7yJtYlLXYBzKJJFcnznlS63qC955pVk7bishWB9J.0',
  }
  file { '/home/bamboo':
    ensure => directory,
    owner  => bamboo,
    group  => bamboo;
  }

  class { 'tomcat':
  }

  class { 'postgresql::globals':
    version             => $common::pgver,
    manage_package_repo => true,
    encoding            => 'UTF8'
  }
  class { 'postgresql::server':
  }
  postgresql::server::db { 'bamboo':
    user     => 'bamboo',
    password => postgresql_password('bamboo', 'ohmypostgres1')
  }
}
