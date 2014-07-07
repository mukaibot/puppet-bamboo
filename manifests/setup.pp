# == Class Bamboo::Setup
# Downloads and installs Bamboo
class bamboo::setup($version = '5.5.1', $home='/home/bamboo/bamboo-home') {
  package { 'java-1.7.0-openjdk.x86_64':
    ensure => present
  }

  $user = hiera('bamboo::users::username', 'bamboo')
  $packagename = "atlassian-bamboo-${version}"
  $tarball = "${packagename}.tar.gz"

  exec { 'bamboo_tarball':
    path    => '/usr/bin',
    user    => $user,
    cwd     => "/home/${user}",
    command => "wget http://www.atlassian.com/software/bamboo/downloads/binary/${tarball}",
    creates => "/home/${user}/${tarball}"
  } ->
  exec { 'extract':
    command => "/bin/tar xvzf ${tarball}",
    creates => "/home/${user}/${packagename}",
    cmd     => "/home/${user}"
  } ->
  exec { '/etc/init.d/bamboo':
    ensure => link,
    target => "/home/${user}/${packagename}/bin/start-bamboo.sh"
  } ->
  exec { '/etc/default/bamboo':
    ensure  => present,
    content => "RUN_AS_USER=${user}
BAMBOO_PID=/home/${user}/bamboo.pid
BAMBOO_LOG_FILE=/home/${user}/logs/bamboo.log",
  }

  file { 'bamboo-home':
    ensure   => 'present',
    requires => Exec['bamboo_tarball'],
    content  => "bamboo.home= /home/${user}",
    path     => "/home/${user}/${packagename}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties"
  }

}
