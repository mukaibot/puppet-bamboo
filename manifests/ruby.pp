# == Class bamboo::ruby
# Installs rbenv into the bamboo user's home dir. This is to enable the ruby plugin
class bamboo::ruby($rubyver = '2.1.2') {
  $user = hiera('bamboo::users::username', 'bamboo')

  class { 'rbenv': }
  rbenv::plugin { 'sstephenson/ruby-build': }
  rbenv::build { '2.1.2':
    owner       => $user,
    group       => $user,
    global      => true,
    install_dir => "/home/${user}"
  }
}
