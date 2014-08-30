class bamboo::user inherits bamboo {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $home_parent = dirname($bamboo_home)

  exec { 'Make home parent if needed':
    path    => [ '/bin', '/usr/bin' ],
    command => "mkdir -p ${home_parent}",
    creates => $home_parent,
  }

  user { $username:
    ensure     => present,
    password   => $pass_hash,
    managehome => true,
    home       => $bamboo_home,
    require    => Exec['Make home parent if needed'],
  }

  file { "${bamboo_home}/logs":
    ensure => directory,
    owner  => $username,
    group  => $username,
    mode   => '0755',
  }

}
