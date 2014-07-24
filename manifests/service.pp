class bamboo::service inherits bamboo {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { "/etc/init.d/${service_name}":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template("${module_name}/bamboo.${::osfamily}.init.erb"),
  }

  if $service_manage == true {
    service { 'bamboo':
      ensure     => $service_ensure,
      enable     => $service_enable,
      name       => $service_name,
      hasstatus  => true,
      hasrestart => true,
      require    => File["/etc/init.d/${service_name}"],
    }
  }
}
