# This module has been tested on FreeBSD 10 only
class bind_freebsd (
  String $package = 'bind910',
  String $service = 'named',
  String $ensure = running,
  String $config = '',
  String $dynamic_config = '',
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

  if $config != '' {
    file { '/usr/local/etc/namedb/named.conf':
      ensure    => $ensure_file,
      purge     => true,
      recurse   => true,
      force     => true,
      source    => $config,
      require   => Package[$package],
      notify    => Service[$service],
    }
  }

  if $dynamic_config != '' {
    file { '/usr/local/etc/named/dynamic':
      ensure    => $ensure_file,
      purge     => true,
      recurse   => true,
      force     => true,
      source    => $dynamic_config,
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

