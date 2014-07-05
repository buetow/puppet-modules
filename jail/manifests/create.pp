define jail::create (
  $ensure = present,
  $use_zfs = true,
  $zfs_tank = 'zroot',
  $mountpoint = "/jails/${name}",
  $config_add = {},
) {
  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  $config_default = {
    'rootdir'      => $mountpoint,
    'hostname'     => $name,
    'devfs_enable' => 'NO',
  }
  $jail_config = merge($config_default, $config_add)

  $jail_name = regsubst($name, '\.', '', 'G')

  file { "/etc/jail.d/jail_${jail_name}":
    ensure   => $ensure,
    content  => template('jail/jail_config.erb'),
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
