# == Class bamboo::ruby
# Installs rbenv into the bamboo user's home dir. This is to enable the ruby plugin
class bamboo::ruby($rubyver = '2.1.2') {
  class { 'rbenv': }
  rbenv::plugin { 'sstephenson/ruby-build': }
  rbenv::build { '2.1.2':
    owner => hiera('bamboo::users::username', 'bamboo'),
    group => hiera('bamboo::users::username', 'bamboo'),
  }
}
