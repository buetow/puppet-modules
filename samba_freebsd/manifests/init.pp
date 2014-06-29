# This module has been tested on FreeBSD 10 only
class samba_freebsd (
  $service = 'samba_server',
  $package = 'samba41',
  $config = '/usr/local/etc/smb4.conf',
  $config_template = 'samba_freebsd/smb4.conf.erb',
  $ensure = present,
  $manage_winbindd = true,
  $manage_smbd = true,
  $manage_nmdb = true,
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

  if $manage_winbindd {
    freebsd::rc_enable { 'winbindd': 
      ensure => $ensure_file
    }
  }

  if $manage_smbd {
    freebsd::rc_enable { 'smbd': 
      ensure => $ensure_file
    }
  }

  if $manage_nmdb {
    freebsd::rc_enable { 'nmdb': 
      ensure => $ensure_file
    }
  }
}

