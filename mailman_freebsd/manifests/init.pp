# This module has been tested on FreeBSD 10 only
class mailman_freebsd (
  $service = 'mailman',
  $package = 'mailman', 
  $ensure = running,
  $links_manage = true,
  $links_dest_base = '/mail/mailman',
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

  service { $service:
    enable  => $service_enable,
    ensure  => $ensure_service,

    require => [
      Package[$package],
    ],
  }

  freebsd::rc_enable { $service:
    ensure => $ensure_file,
  }

  file { '/usr/local/mailman/postfix-to-mailman.py':
    source => 'puppet:///modules/mailman_freebsd/postfix-to-mailman.py',
    ensure => $ensure_file,
    owner  => 'root',
    group  => 'mailman',
    mode   => '0755',
  }

  file { '/usr/local/mailman/approve.sh':
    source => 'puppet:///modules/mailman_freebsd/approve.sh',
    ensure => $ensure_file,
    owner  => 'root',
    group  => 'mailman',
    mode   => '0755',
  }

  file { '/usr/local/mailman/HOWTO':
    source => 'puppet:///modules/mailman_freebsd/HOWTO',
    ensure => $ensure_file,
    owner  => 'root',
    group  => 'mailman',
    mode   => '0644',
  }

  if $links_manage {
    file { '/usr/local/mailman/archives':
      ensure => link,
      force  => true,
      target => "${links_dest_base}/archives",
      owner  => 'root',
      group  => 'mailman',
      mode   => '0766',
    }

    file { '/usr/local/mailman/lists':
      ensure => link,
      force  => true,
      target => "${links_dest_base}/lists",
      owner  => 'root',
      group  => 'mailman',
      mode   => '0766',
    }

    file { '/usr/local/mailman/data':
      ensure => link,
      force  => true,
      target => "${links_dest_base}/data",
      owner  => 'root',
      group  => 'mailman',
      mode   => '0766',
    }
  }
}
