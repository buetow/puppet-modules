class ports (
  $ensure = present,
  $use_zfs = true,
  $mountpoint = '/usr/ports',
  $zfs_tank = 'zroot',
) {
  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  file { $mountpoint:
    ensure => $ensure_directory,
  }

  zfs::create { "${zfs_tank}${mountpoint}":
    ensure     => $ensure,
    filesystem => $mountpoint,
    noop       => !$use_zfs,

    require    => File[$mountpoint],
  }
}

