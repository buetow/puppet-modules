class ports (
  $ensure = present,
  $mountpoint = '/ports',
  $symlink = '/usr/ports',
  $use_zfs = true,
  $zfs_tank = 'zroot',
) {
  case $ensure {
    present: {
      $ensure_directory = directory
      $ensure_link = link
    }
    absent: {
      $ensure_directory = absent
      $ensure_link = absent
    }
    default: {
      fail("No such ensure: ${ensure}")
    }
  }

  file { $mountpoint:
    ensure => $ensure_directory,
  }

  if $symlink != '' {
    file { $symlink:
      ensure => $ensure_link,
      target => $mountpoint,
    }
  }

  zfs::create { "${zfs_tank}${mountpoint}":
    ensure     => $ensure,
    filesystem => $mountpoint,
    noop       => !$use_zfs,

    require    => File[$mountpoint],
  }
}

