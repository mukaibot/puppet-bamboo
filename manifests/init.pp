# == Class Bamboo
class bamboo {

  include bamboo::users
  include bamboo::database
  include bamboo::setup

}
