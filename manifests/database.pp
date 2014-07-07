# == Class Bamboo::Database
# Installs and configures Postgres for Bamboo
class bamboo::database($pgver='9.3',$dbname='bamboo',$pguser='bamboo',$pgpass='changeme') {
  class { 'postgresql::globals':
    version             => $pgver,
    manage_package_repo => true,
    encoding            => 'UTF8'
  }
  class { 'postgresql::server':
  }
  postgresql::server::db { $dbname:
    user     => $pguser,
    password => postgresql_password($pguser, $pgpass)
  }
}
