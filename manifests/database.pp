# == Class Bamboo::Database
# Installs and configures Postgres for Bamboo
class bamboo::database {
  class { 'postgresql::globals':
    version             => $bamboo::pgver,
    manage_package_repo => true,
    encoding            => 'UTF8'
  }
  class { 'postgresql::server': }
  class { 'postgresql::lib::devel': }
  postgresql::server::db { $bamboo::dbname:
    user     => $bamboo::pguser,
    password => postgresql_password($bamboo::pguser, $bamboo::pgpass)
  }
}
