# This module has been tested on FreeBSD 10 only
class bind_freebsd (
  $package = 'bind910',
  $service = 'named',
  $ensure = running,
  $conf_d_source = '',
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

  if $conf_d_source != '' {
    file { '/usr/local/etc/namedb/conf.d':
      ensure    => $ensure_directory,
      purge     => true,
      recurse   => true,
      force     => true,
      source    => $conf_d_source,
      require   => Package[$package],
      notify    => Service[$service],
    }
  }

  service { $service:
    enable  => $service_enable,
    ensure  => $ensure_service,
    require => [
      Package[$package],
    ],
  }
}

