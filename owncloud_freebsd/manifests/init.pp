# This module has been tested on FreeBSD 10 only
class owncloud_freebsd (
  String $ensure = running,
  String $cron_ensure = absent,
  Integer $cron_hour = 5,
) {

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

  package { [
    'mysql56-server',
    'php56',
    'owncloud',
    'apache24',
  ]:
    ensure => $ensure_package
  }

  package { 'mod_php56':
    ensure  => $ensure_package,

    require => Package['apache24'],
  }

  service { 'apache24':
    enable => $service_enable,
    ensure => $ensure_service,
  }

  service { 'mysql-server':
    enable => $service_enable,
    ensure => $ensure_service,
  }

  $includes_dir = '/usr/local/etc/apache24/Includes'

  file { "${includes_dir}/owncloud.conf":
    ensure  => $ensure_file,
    content => template('owncloud_freebsd/owncloud.conf.erb'),
    notify  => Service['apache24'],
  }

  file { "${includes_dir}/php.conf":
    ensure  => $ensure_file,
    content => template('owncloud_freebsd/php.conf.erb'),
    notify  => Service['apache24'],
  }

  cron { 'cron_scan':
    ensure  => $cron_ensure,
    minute  => 0,
    hour    => $cron_hour,
    user    => www,
    command => '/usr/local/www/owncloud/occ files:scan --all',
  }

}
