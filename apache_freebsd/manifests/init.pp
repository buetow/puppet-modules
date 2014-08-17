# This module has been tested on FreeBSD 10 only
class apache_freebsd (
  $package = 'apache24',
  $config_template = 'apache_freebsd/httpd.conf.erb',
  $ensure = running,
  $manage_package = true,
  $httpd_conf = {
    server_admin => 'web@mx.buetow.org'
  },
) {
  File {
    owner => root,
    group => $root_group,
    mode  => '0644',
  }

  $service = $package
  $config_dir = "/usr/local/etc/${service}"
  $httpd_conf_file = "${config_dir}/httpd.conf"
  $apache_log_dir = "/var/log/${package}"
  $vhosts_dir = "${config_dir}/vhosts.d"

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

  if $manage_package {
    package { $package:
      ensure => $ensure_package
    }

    file { $httpd_conf_file:
      ensure  => $ensure_file,
      content => template($config_template),

      require => Package[$package],
    }
  } else {
    file { $httpd_conf_file:
      ensure  => $ensure_file,
      content => template($config_template),
    }
  }

  file { $apache_log_dir:
    ensure => $ensure_directory,
    owner  => www,
    mode   => '0755',
    purge  => true,
  }

  file { '/usr/local/etc/apache':
    ensure => $ensure_link,
    target => $config_dir,
  }

  file { '/var/log/apache':
    ensure => $ensure_link,
    target => $apache_log_dir,
  }

  file { $vhosts_dir:
    ensure => $ensure_directory,
    mode   => '0755',
    purge  => true,
  }

  service { $service:
    enable  => $service_enable,
    ensure  => $ensure_service,

    subscribe => File[$httpd_conf_file],
    require   => [
      File[$httpd_conf_file],
      File[$apache_log_dir],
      File[$vhosts_dir],
    ],
  }
}

