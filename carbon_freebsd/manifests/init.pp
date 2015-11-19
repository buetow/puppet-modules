# This module has been tested on FreeBSD 10 only
class carbon_freebsd (
  $package = 'py27-carbon',
  $service = 'carbon',
  $ensure = running,
  $local_data_dir = '/carbon/whisper',
  $carbon_user = nobody,
) {
  $etc_dir = '/usr/local/etc/carbon/'

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

  file { "${etc_dir}/carbon.conf":
    ensure  => $ensure_file,
    content => template('carbon_freebsd/carbon.conf.erb'),
    require => Package[$package],
  }

  file { $local_data_dir:
    ensure => directory,
    owner  => $carbon_user,
  }

  service { $service:
    enable    => $service_enable,
    ensure    => $ensure_service,
    subscribe => File["${etc_dir}/carbon.conf"],
    require   => [
      File["${etc_dir}/carbon.conf"],
      File[$local_data_dir],
      Package[$package],
    ],
  }
}

