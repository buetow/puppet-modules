class jail::debian_kfreebsd (
  $ensure = present,
  $use_zfs = true,
  $mountpoint = '/jails',
  $zfs_tank = 'zroot',
) {
  class { 'jail':
    ensure     => $ensure,
    use_zfs    => $use_zfs,
    mountpoint => $mountpoint,
    zfs_tank   => $zfs_tank
  }

  # Utils for Debian GNU/kFreeBSD Jais
  package { 'debootstrap':
    ensure => $ensure,
  }
}

