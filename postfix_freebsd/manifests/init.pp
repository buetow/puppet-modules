# This module has been tested on FreeBSD 10 only
class postfix_freebsd (
  $service = 'postfix',
  $package = 'postfix',
  $ensure = present,
  $config_dir = '/usr/local/etc/postfix',
  $postfix_config_template = 'postfix_freebsd/main.cf.erb',
  $postfix_config_manage = false,
  $postfix_config = { },
  $master_config_template = 'postfix_freebsd/master.cf.erb',
  $master_config_manage = false,
  $master_config = { },
  $virtual_config_manage = false,
  $virtual_config = [ ],
  $transport_config_manage = false,
  $transport_config = [ ],
  $header_checks_manage = false,
  $header_checks_source = 'puppet:///files/postfix/header_checks',
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

  file { '/etc/mail/mailer.conf':
    ensure => $ensure_file,
    source => 'puppet:///postfix_freebsd/mailer.conf',
  }

  package { $package:
    ensure => $ensure_package
  }

  if $postfix_config_manage {
    file { "${config_dir}/main.cf":
      ensure  => $ensure_file,
      content => template($postfix_config_template),

      require => Package[$package],
      notify  => Service[$service],
    }
  }

  if $master_config_manage {
    file { "${config_dir}/master.cf":
      ensure  => $ensure_file,
      content => template($master_config_template),

      require => Package[$package],
      notify  => Service[$service],
    }
  }

  if $virtual_config_manage {
    file { "${config_dir}/virtual":
      ensure  => $ensure_file,
      content => template('postfix_freebsd/virtual.erb'),

      require => Package[$package],
    }

    exec { "/usr/local/sbin/postmap ${config_dir}/virtual":
      refreshonly => true,

      require   => File["${config_dir}/virtual"],
      subscribe => File["${config_dir}/virtual"],
    }
  }

  if $transport_config_manage {
    file { "${config_dir}/transport":
      ensure  => $ensure_file,
      content => template('postfix_freebsd/transport.erb'),

      require => Package[$package],
    }

    exec { "/usr/local/sbin/postmap ${config_dir}/transport":
      refreshonly => true,

      require   => File["${config_dir}/transport"],
      subscribe => File["${config_dir}/transport"],
    }
  }

  if $header_checks_manage {
    file { "${config_dir}/header_checks":
      ensure  => $ensure_file,
      source  => $header_checks_source,

      require => Package[$package],
      notify  => Service[$service],
    }
  }

  service { $service:
    enable  => $service_enable,
    ensure  => $ensure_service,

    require => [
      Package[$package],
      File['/etc/mail/mailer.conf'],
    ],
  }
}

