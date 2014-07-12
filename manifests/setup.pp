# == Class Bamboo::Setup
# Downloads and installs Bamboo
class bamboo::setup {
  package { $bamboo::javapackage:
    ensure => present
  }

  $user = $bamboo::username
  $packagename = "atlassian-bamboo-${bamboo::version}"
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
    cwd     => "/home/${user}",
    user    => $user,
  } ->
  file { '/etc/init.d/bamboo':
    ensure => link,
    target => "/home/${user}/${packagename}/bin/start-bamboo.sh"
  } ->
  file { '/etc/default/bamboo':
    ensure  => present,
    content => "RUN_AS_USER=${user}
BAMBOO_PID=/home/${user}/bamboo.pid
BAMBOO_LOG_FILE=/home/${user}/logs/bamboo.log",
  }

  file { 'bamboo-home':
    ensure   => 'present',
    require  => Exec['extract'],
    content  => "bamboo.home= ${bamboo::home}",
    path     => "/home/${user}/${packagename}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties"
  }

}
