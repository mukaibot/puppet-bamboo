class bamboo::params {

  $username           = 'bamboo'
  $pass_hash          = undef
  $bamboo_version     = '5.6.1'
  $bamboo_home        = '/opt/atlassian/bamboo'
  $bamboo_data        = '/var/atlassian/application-data/bamboo'
  $bamboo_url         = 'http://www.atlassian.com/software/bamboo/downloads/binary'

  $db_manage          = true
  $db_type            = 'postgresql'
  $db_name            = 'bamboo'
  $db_user            = 'bamboo'
  $db_pass            = 'changeme'

  $java_manage        = true
  $java_distribution  = 'jdk'
  $java_version       = 'present'
  $java_package       = undef

  $service_manage     = true
  $service_ensure     = 'running'
  $service_enable     = true
  $service_name       = 'bamboo'


  case $db_type {
    'postgresql': {
      $db_version     = '9.3'
      $db_manage_repo = true
      $db_encoding    = 'UTF8'
    }

    'mysql': {
      fail ('Error: MySQL is not yet supported.  Really, just use postgresql')
    }

    default: { fail ("Error: ${db_type} is not a supported database yet.") }
  }

  case $::osfamily {
    /^(RedHat|Debian)$/ : { }
    default             : { fail("Error: ${::osfamily} is not supported yet") }
  }
}
