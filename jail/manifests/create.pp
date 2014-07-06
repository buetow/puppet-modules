define jail::create (
  $use_zfs,
  $zfs_tank,
  $base_mountpoint,
  $jails_config,
) {

  if has_key($jails_config, $name) {
    $jail_config = $jails_config[$name]
  } else {
    fail("Could not find config for jail ${name}")
  }

  if has_key($jail_config, 'path') {
    $mountpoint = $jail_config['path']
  } else {
    $mountpoint = "${base_mountpoint}/${name}"
  }

  if has_key($jail_config, '_ensure') {
    $ensure = $jail_config['_ensure']
  } else {
    $ensure = present
    notify { "${name}: Using default ensure=${ensure}": }
  }

  if has_key($jail_config, '_type') {
    $type = $jail_config['_type']
  } else {
    $type = noop
    notify { "${name}: Using default type=${type}": }
  }

  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  file { $mountpoint:
    ensure => $ensure_directory,
    force  => true,
  }

  zfs::zfs_create { "${zfs_tank}${mountpoint}":
    ensure     => $ensure,
    filesystem => $mountpoint,
    noop       => !$use_zfs,

    require => File[$mountpoint],
  }

  case $type {
    noop: {
      notify { "${name}: type=noop, so don't do any jail post processing/installing": }
    }
    debian_kfreebsd: {
      jail::debian_kfreebsd::create { $name:
        ensure      => $ensure,
        use_zfs     => $use_zfs,
        mountpoint  => $mountpoint,
        jail_config => $jail_config,

        require => Zfs::Zfs_create["${zfs_tank}${mountpoint}"],
      }
    }
    default: {
      fail("Type ${type} not yet implemented")
    }
  }
}
