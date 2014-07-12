# == Class Bamboo
class bamboo(
  $username    = 'bamboo',
  $password    = 'changeme',
  $javapackage = 'java-1.7.0-openjdk.x86_64', # default is for Centos
  $version     = '5.5.1',
  $home        = '/home/bamboo/bamboo-home',
  $pgver       = '9.3',
  $dbname      = 'bamboo',
  $pguser      = 'bamboo',
  $pgpass      = 'changeme') {

  include bamboo::users
  include bamboo::database
  include bamboo::setup

}
