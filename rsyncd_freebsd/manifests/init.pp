# This module has been tested on FreeBSD 10 only
class rsyncd_freebsd (
  $service = 'rsyncd',
  $package = 'rsync',
  $config = '/usr/local/etc/rsync/rsyncd.conf',
  $config_template = 'rsyncd_freebsd/rsyncd.conf.erb',
  $ensure = present,
  $volumes = {},
  $manage_package = false,
) {
  File {
    owner => root,
    group => $root_group,
    mode  => '0644',
  }

  case $ensure {
    'running': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
      $ensure_service = running
      $ensure_enabled = enabled
      $service_enable = true
    }
    'stopped': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
      $ensure_service = stopped
      $service_enable = false
    }
    'present': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
      $ensure_service = stopped
      $service_enable = false
    }
    'absent': {
      $ensure_package = absent
      $ensure_file = absent
      $ensure_directory = absent
      $ensure_service = stopped
      $service_enable = false
    }
  }

  if $manage_package {
    package { $package:
      ensure => $ensure_package
    }

    file { $config:
      ensure  => $ensure_file,
      content => template($config_template),

      require => Package[$package],
    }
  } else {
    file { $config:
      ensure  => $ensure_file,
      content => template($config_template),
    }
  }

  service { $service:
    enable  => $service_enable,
    ensure  => $ensure_service,

    subscribe => File[$config],
    require   => File[$config],
  }
}

