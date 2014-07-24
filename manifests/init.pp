# == Class Bamboo
# Installs Bamboo. By default, you get Bamboo 5.5.1, Postgres 9.3 and Java 1.7
# Bamboo will be installed into /home/bamboo, and bamboo home set to /home/bamboo/bamboo-home
# make sure you at least set the passwords - $password and $pgpass
class bamboo (
  $username           = $bamboo::params::username,
  $pass_hash          = $bamboo::params::pass_hash,
  $bamboo_version     = $bamboo::params::bamboo_version,
  $bamboo_home        = $bamboo::params::bamboo_home,
  $bamboo_data        = $bamboo::params::bamboo_data,
  $bamboo_url         = $bamboo::params::bamboo_url,

  $db_manage          = $bamboo::params::db_manage,
  $db_type            = $bamboo::params::db_type,
  $db_name            = $bamboo::params::db_name,
  $db_user            = $bamboo::params::db_type,
  $db_pass            = $bamboo::params::db_pass,
  $db_version         = $bamboo::params::db_version,
  $db_manage_repo     = $bamboo::params::db_manage_repo,
  $db_encoding        = $bamboo::params::db_encoding,

  $java_manage        = $bamboo::params::java_manage,
  $java_distribution  = $bamboo::params::java_distribution,
  $java_version       = $bamboo::params::java_version,
  $java_package       = $bamboo::params::java_package,

  $service_manage     = $bamboo::params::service_manage,
  $service_ensure     = $bamboo::params::service_ensure,
  $service_enable     = $bamboo::params::service_enable,
  $service_name       = $bamboo::params::service_name,

) inherits bamboo::params {

  anchor { '::bamboo::start': } ->
    class { '::bamboo::user': } ->
    class { '::bamboo::java': } ->
    class { '::bamboo::database': } ->
    class { '::bamboo::install': } ->
    class { '::bamboo::service': } ->
  anchor { '::bamboo::end': }

}
