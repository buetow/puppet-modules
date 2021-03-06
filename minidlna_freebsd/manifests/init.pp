# This module has been tested on FreeBSD 10 only
class minidlna_freebsd (
  $service = 'minidlna',
  $package = 'minidlna',
  $config = '/usr/local/etc/minidlna.conf',
  $config_template = 'minidlnad_freebsd/minidlna.conf.erb',
  $ensure = present,
  $media_dirs = [ 'P,/srv/data/pictures' ],
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

  package { $package:
    ensure => $ensure_package
  }

  file { $config:
    ensure  => $ensure_file,
    content => template($config_template),

    require => Package[$package],
  }

  service { $service:
    enable  => $service_enable,
    ensure  => $ensure_service,

    subscribe => File[$config],
    require   => File[$config],
  }
}

