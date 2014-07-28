class bamboo::java inherits bamboo {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $java_manage == true {
    validate_re($java_distribution, ['^jre', '^jdk'])

    class { '::java':
      distribution => $java_distribution,
      version      => $java_version,
      package      => $java_package,
    }
  }
}
