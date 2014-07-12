# == Class Bamboo
# Installs Bamboo. By default, you get Bamboo 5.5.1, Postgres 9.3 and Java 1.7
# Bamboo will be installed into /home/bamboo, and bamboo home set to /home/bamboo/bamboo-home
# make sure you at least set the passwords - $password and $pgpass
class bamboo(
  $username    = 'bamboo',
  $password    = 'changeme',
  $version     = '5.5.1',
  $javaver     = '7',
  $home        = '/home/bamboo/bamboo-home',
  $pgver       = '9.3',
  $dbname      = 'bamboo',
  $pguser      = 'bamboo',
  $pgpass      = 'changeme') {

  case $::osfamily {
    'RedHat': {
      $javapackage = "java-1.${bamboo::javaver}.0-openjdk.x86_64"
    }

    'Debian': {
      $javapackage = "openjdk-${bamboo::javaver}-jdk"
    }

    default: {
      fail('Sorry, only Redhat or Debian is supported.')
    }
  }

  include bamboo::users
  include bamboo::database
  include bamboo::setup

}
