define jail::create (
  $use_zfs,
  $zpool,
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
    $type = nooper
    notify { "${name}: Using default type=${type}": }
  }

  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  file { $mountpoint:
    ensure => $ensure_directory,
  }

  zfs::create { "${zpool}${mountpoint}":
    ensure     => $ensure,
    filesystem => $mountpoint,
    nooper     => !$use_zfs,

    require => File[$mountpoint],
  }

  # Ensure directories inside of the Jail (e.g. for custom /opt structure)
  if $ensure == present {
    if has_key($jail_config, '_ensure_directories') {
      $directories = prefix($jail_config['_ensure_directories'], $mountpoint)
      file { $directories:
        ensure  => $ensure_directory,
        replace => false,
        #group   => $root_group,

        require => Zfs::Create["${zpool}${mountpoint}"],
      }
    }
    if has_key($jail_config, '_ensure_zfs') {
      $ensure_zfs = $jail_config['_ensure_zfs']
      jail::ensure_zfs { $ensure_zfs:
        ensure     => $ensure,
        zpool      => $zpool,
        mountpoint => $mountpoint,

        require => File[$mountpoint],
      }
    }
  }

  case $type {
    nooper: {
      file { "/etc/fstab.jail.${name}":
        ensure  => $ensure,
        content => "\n",
      }
      notify { "${name}: type=nooper, so don't do any further jail post processing/installing": }
    }
    freebsd: {
      jail::freebsd::create { $name:
        ensure      => $ensure,
        mountpoint  => $mountpoint,
        jail_config => $jail_config,

        require => Zfs::Create["${zpool}${mountpoint}"],
      }
    }
    debian_kfreebsd: {
      jail::debian_kfreebsd::create { $name:
        ensure      => $ensure,
        mountpoint  => $mountpoint,
        jail_config => $jail_config,

        require => Zfs::Create["${zpool}${mountpoint}"],
      }
    }
    default: {
      fail("Type ${type} not yet implemented")
    }
  }
}
