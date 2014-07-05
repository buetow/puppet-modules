class jail (
  $ensure = present,
  $use_zfs = true,
  $mountpoint = '/jails',
  $zfs_tank = 'zroot',
  $jail_list = '',
) {
  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  freebsd::rc_enable { 'jail':
    ensure => $ensure,
  }

  freebsd::rc_config { 'jail_list':
    ensure => $ensure,
    value => $jail_list,
  }

  file { $mountpoint:
    ensure => $ensure_directory,
    force  => $force,
  }

  if $use_zfs {
    zfs::zfs_create { "${zfs_tank}${mountpoint}":
      ensure     => $ensure,
      filesystem => $mountpoint,

      require => File[$mountpoint],
    }
  }
}

