class roundcube_freebsd (
  $ensure = present,
) {
  case $ensure {
    'running': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
    }
    'stopped': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
    }
    'present': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
    }
    'absent': {
      $ensure_package = absent
      $ensure_file = absent
      $ensure_directory = absent
    }
  }

  package { 'roundcube':
    ensure => $ensure_package
  }
}
