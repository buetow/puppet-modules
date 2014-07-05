class jail (
  $ensure = present,
  $use_zfs = true,
  $mountpoint = '/jails',
  $zfs_tank = 'zroot',
) {
  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  # Utils for Debian GNU/kFreeBSD Jais
  package { 'debootstrap':
    ensure => $ensure,
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

