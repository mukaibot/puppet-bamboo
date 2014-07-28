class bamboo::install inherits bamboo {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  staging::deploy { "bamboo-${bamboo_version}.tar.gz":
    source => "${bamboo_url}/atlassian-bamboo-${bamboo_version}.tar.gz",
    target  => "${bamboo_home}",
    creates => "${bamboo_home}/atlassian-bamboo-${bamboo_version}",
  }

  exec { 'make bamboo data dir':
    path    => [ '/bin', '/usr/bin' ],
    command => "mkdir -p ${bamboo_data}",
    creates => $bamboo_data,
  }

  file { $bamboo_data:
    ensure  => directory,
    owner   => $username,
    group   => $username,
    mode    => '0755',
    require => Exec['make bamboo data dir'],
  }

  file { "${bamboo_home}/current":
    ensure  => link,
    target  => "${bamboo_home}/atlassian-bamboo-${bamboo_version}",
    require => Staging::Deploy["bamboo-${bamboo_version}.tar.gz"],
  }

  file_line { 'Set bamboo data directory':
    ensure  => present,
    path    => "${bamboo_home}/current/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties",
    line    => "bamboo.home=${bamboo_data}\n",
    require => [ File["${bamboo_home}/current"], File[$bamboo_data] ],
  }
}
