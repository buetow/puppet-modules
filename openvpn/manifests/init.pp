class openvpn (
  $role,
  $ensure = present,
){
  case $ensure {
    present: {
      $ensure_package = present
    }
    absent: {
      $ensure_package = absent
    }
    running: {
      $ensure_package = present
    }
    stopped: {
      $ensure_package = present
    }
    default: {
      fail("No such ensure: ${ensure}")
    }
  }

  package { 'openvpn':
    ensure => $ensure_package
  }

  # case $role: {
  #   #    server: {
  #   #  file { '/etc/
  #   #}
  #   default: {
  #     fail("Role must be client or server")
  #   }
  # }
}
