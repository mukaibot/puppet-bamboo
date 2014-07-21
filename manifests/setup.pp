# == Class Bamboo::Setup
# Downloads and installs Bamboo
class bamboo::setup {
  package { $bamboo::javapackage:
    ensure => present
  }

  $user = $bamboo::username
  $packagename = "atlassian-bamboo-${bamboo::version}"
  $bamboo_dir = "/home/${user}/${packagename}"
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
    creates => $bamboo_dir,
    cwd     => "/home/${user}",
    user    => $user,
  }

  file { '/etc/init.d/bamboo':
    ensure  => present,
    content => template("bamboo/bamboo.${::osfamily}.init.erb"),
    mode    => '0755'
  }

  file { 'bamboo-home':
    ensure   => 'present',
    require  => Exec['extract'],
    content  => "bamboo.home= ${bamboo::home}",
    path     => "${bamboo_dir}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties"
  }

}
