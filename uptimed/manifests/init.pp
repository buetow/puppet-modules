class uptimed (
  $ensure = present,
  $records_file = '/var/spool/uptimed/records',
) {
  case $ensure {
    'running': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
      $ensure_service = running
      $enable_service = true
    }
    'stopped': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
      $ensure_service = stopped
      $enable_service = false
    }
    'present': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
      $ensure_service = stopped
      $enable_service = false
    }
    'absent': {
      $ensure_package = absent
      $ensure_file = absent
      $ensure_directory = absent
      $ensure_service = stopped
      $enable_service = false
    }
  }

  class { 'uptimed::packages':
    ensure => $ensure_package,
  }

  class { 'uptimed::files':
    ensure => $ensure_file,

    require => Class['uptimed::packages'],
  }

  service { 'uptimed':
    ensure => $ensure_service,
    enable => $enable_service,

    require => Class['uptimed::files'],
  }
}
