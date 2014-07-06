class jail (
  $ensure = present,
  $use_zfs = true,
  $mountpoint = '/jail',
  $zfs_tank = 'zroot',
  $jails_base_config = {},
  $jails_config = {},
) {
  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  $jail_default_path = "${mountpoint}/\$name"

  # Keys with leading _ are not added to jail.conf
  # (..). is for line order in resulting jail.conf
  $jails_base_config_default = {
    'exec.start'      => "'/etc/rc'",
    'exec.stop'       => "'/etc/rc.shutdown'",
    'mount.devfs; //' => '',
    'path'            => "\"${jail_default_path}\"",
  }

  $base_config = merge($jails_base_config_default, $jails_base_config)

  file { $mountpoint:
    ensure => $ensure_directory,
  }

  zfs::zfs_create { "${zfs_tank}${mountpoint}":
    ensure     => $ensure,
    filesystem => $mountpoint,
    noop       => !$use_zfs,

    require    => File[$mountpoint],
  }

  freebsd::rc_enable { 'jail':
    ensure => $ensure,
  }

  file { '/etc/jail.conf':
    ensure  => $ensure,
    content => template('jail/jail.conf.erb')
  }

  $jail_names = keys($jails_config)
  jail::create { $jail_names:
    use_zfs         => $use_zfs,
    base_mountpoint => $mountpoint,
    zfs_tank        => $zfs_tank,
    jails_config    => $jails_config,
  }
}

