class jail (
  $ensure = present,
  $use_zfs = true,
  $mountpoint = '/jails',
  $zfs_tank = 'zroot',
  $jail_config = {},
) {
  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  $jail_config_default = {
  }

  $config = merge($jail_config_default, $jail_config)

  freebsd::rc_hash { 'jail':
    ensure => $ensure,
    hash   => $config,
  }

  file { $mountpoint:
    ensure => $ensure_directory,
    force  => true,
  }

  if $use_zfs {
    zfs::zfs_create { "${zfs_tank}${mountpoint}":
      ensure     => $ensure,
      filesystem => $mountpoint,

      require => File[$mountpoint],
    }
  }
}

