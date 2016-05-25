# This module has been tested on FreeBSD 10 only
class owncloud_freebsd (
  String $ensure = running
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
  # Add to apache
  # Alias /owncloud /usr/local/www/owncloud
  # AcceptPathInfo On
  # <Directory /usr/local/www/owncloud>
  #   AllowOverride All
  #   Require all granted
  # </Directory>
  # service apache24 onestart
  }
