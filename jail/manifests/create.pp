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

  $jail_hostname = regsubst($name, '\..*', '', 'G')

  file { $mountpoint:
    ensure => $ensure_directory,
    force  => true,
  }

  if $use_zfs {
    zfs::zfs_create { "${zfs_tank}${mountpoint}":
      ensure     => $ensure,
      filesystem => $mountpoint,
    }
  }
}
