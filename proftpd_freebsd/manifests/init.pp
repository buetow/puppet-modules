class proftpd_freebsd (
  $ensure = present,
  $config_dir = '/usr/local/etc/proftpd',
  $config_manage = false,
) {

  package { 'proftpd':
    ensure => $ensure,
  }

  freebsd::rc_enable { 'proftpd':
    ensure => $ensure,
  }

  if $config_manage {
    file { $config_dir:
      ensure  => directory,
      recurse => true,
      force   => true,
      mode    => '0700',
    }
  }
}
