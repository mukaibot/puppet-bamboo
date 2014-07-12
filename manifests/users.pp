# == Class Bamboo::Users
# Configures the bamboo user account
class bamboo::users {
  user { $bamboo::username:
    ensure     => present,
    managehome => true,
    password   => $bamboo::password,
  }
  file { "/home/${bamboo::username}":
    ensure => directory,
    owner  => $bamboo::username,
    group  => $bamboo::username;
  }
  file { "/home/${bamboo::username}/logs":
    ensure => directory,
    owner  => $bamboo::username,
    group  => $bamboo::username;
  }
}
