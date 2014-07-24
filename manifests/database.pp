class bamboo::database inherits bamboo {
  
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $db_manage == true {
    class { "::bamboo::database::${db_type}": }
  }
}
