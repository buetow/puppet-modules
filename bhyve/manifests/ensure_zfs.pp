define bhyve::ensure_zfs (
  $ensure,
  $mountpoint,
  $zpool,
) {
  zfs::create { "${zpool}${mountpoint}${name}":
    ensure     => $ensure,
    filesystem => "${mountpoint}${name}",

    require => File[$mountpoint],
  }
}
