# This module has been tested on FreeBSD 10 only
class dovecot_freebsd (
  $service = 'dovecot',
  $package = 'dovecot2', # Maybe you should build dovecot from ports with all options you want first
  $ensure = present,
  $config_dir = '/usr/local/etc/dovecot',
  $dovecot_config_manage = false,
  # Put your own version of the dovecot config here
  $dovecot_config_source = 'puppet:///files/dovecot/config',
  $ssl_manage = true,
  $ssl_cert_source = 'puppet:///files/doveot/ssl.crt',
  $ssl_key_source = 'puppet:///files/doveot/ssl.key',
  $cert_dir = '/usr/local/etc/mail-ssl-certs',
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

  if $dovecot_config_manage {
    notify { "Using ${dovecot_config_source} as source": }
    file { $config_dir:
      ensure  => $ensure_directory,
      source  => $dovecot_config_source,
      recurse => true,
      purge   => true,
      force   => true,

      require => Package[$package],
      notify  => Service[$service],
    }
  }
  if $ssl_manage {
    file { $cert_dir:
      ensure => $ensure_directory,
    }

    file { "${cert_dir}/ssl.crt":
      source => $ssl_cert_source,
      ensure => $ensure_file,
      owner  => root,
      mode   => '0600',

      require => [
        Package[$package],
        File[$cert_dir],
      ],
      notify  => Service[$service],
    }
    file { "${cert_dir}/ssl.key":
      source => $ssl_key_source,
      ensure => $ensure_file,
      owner  => root,
      mode   => '0600',

      require => [
        Package[$package],
        File[$cert_dir],
      ],
      notify  => Service[$service],
    }
  }

  # Dovecot bug in FreeBSD? Had to write /etc/rc.conf.d/dovecot manually
  # Put dovecot_enable="YES" into it
  service { $service:
    enable  => $service_enable,
    ensure  => $ensure_service,

    require => [
      Package[$package],
    ],
  }
}
