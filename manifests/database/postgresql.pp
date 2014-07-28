class bamboo::database::postgresql inherits bamboo {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  anchor { 'bamboo::database::start':
    before => [
      Class['postgresql::globals'],
      Class['postgresql::server'],
      Class['postgresql::server::contrib'],
      Class['postgresql::lib::devel'],
      Postgresql::Server::Db[$db_name],
    ],
  }

  class { '::postgresql::globals':
    version             => $db_version,
    manage_package_repo => $db_manage_repo,
    encoding            => $db_encoding,
  }

  class { '::postgresql::server': }
  class { '::postgresql::server::contrib': }
  class { '::postgresql::lib::devel': }

  postgresql::server::db { $db_name:
    user     => $db_user,
    password => postgresql_password($db_user, $db_pass)
  } 

  anchor { '::bamboo::database::end': 
    require => [
      Anchor['bamboo::database::start'],
      Class['postgresql::globals'],
      Class['postgresql::server'],
      Class['postgresql::server::contrib'],
      Class['postgresql::lib::devel'],
      Postgresql::Server::Db[$db_name],
    ],
  }
}
