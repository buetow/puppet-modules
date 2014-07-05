define jail::create (
  $ensure = present,
  $use_zfs = true,
  $zfs_tank = 'zroot',
  $mountpoint = "/jails/${name}",
) {
  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  file { $mountpoint:
    ensure => $ensure_directory,
    force  => $force,
  }

  if $use_zfs {
    zfs::zfs_create { "${zfs_tank}${mountpoint}":
      ensure     => $ensure,
      filesystem => $mountpoint,
    }
  }
}
