# This module has been tested on FreeBSD 10 only
class collectd_freebsd (
  $package = 'collectd5',
  $service = 'collectd',
  $ensure = running,
  $graphite_host = 'graphite.buetow.org',
) {
  $conf = '/usr/local/etc/collectd.conf'

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
      $ensure_link = link
      $ensure_service = running
      $ensure_enabled = enabled
      $service_enable = true
    }
    'stopped': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
      $ensure_link = link
      $ensure_service = stopped
      $service_enable = false
    }
    'present': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
      $ensure_link = link
      $ensure_service = stopped
      $service_enable = false
    }
    'absent': {
      $ensure_package = absent
      $ensure_file = absent
      $ensure_directory = absent
      $ensure_link = absent
      $ensure_service = stopped
      $service_enable = false
    }
  }

  package { $package:
    ensure => $ensure_package
  }

  file { $conf:
    ensure  => $ensure_file,
    content => template('collectd_freebsd/collectd.conf.erb'),
    require => Package[$package],
  }

  service { $service:
    enable    => $service_enable,
    ensure    => $ensure_service,
    subscribe => File[$conf],
    require   => [
      File[$conf],
      Package[$package],
    ],
  }
}

