# == Class Bamboo::Users
# Configures the bamboo user account
class bamboo::users($username='bamboo',$password='changeme') {
  user { $username:
    ensure     => present,
    managehome => true,
    password   => $password,
  }
  file { "/home/${username}":
    ensure => directory,
    owner  => $username,
    group  => $username;
  }
  file { "/home/${username}/logs":
    ensure => directory,
    owner  => $username,
    group  => $username;
  }
}
