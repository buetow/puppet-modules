define jail::ensure_zfs (
  $ensure,
  $mountpoint,
  $zfs_tank,
) {
  zfs::create { "${zfs_tank}${mountpoint}${name}":
    ensure     => $ensure,
    filesystem => "${mountpoint}${name}",

    require => File[$mountpoint],
  }
}
