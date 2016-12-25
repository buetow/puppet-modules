define bhyve::create (
  $use_zfs,
  $zpool,
  $base_mountpoint,
  $bhyves_config,
) {

  if has_key($bhyves_config, $name) {
    $bhyve_config = $bhyves_config[$name]
  } else {
    fail("Could not find config for bhyve ${name}")
  }

  if has_key($bhyve_config, 'path') {
    $mountpoint = $bhyve_config['path']
  } else {
    $mountpoint = "${base_mountpoint}/${name}"
  }

  if has_key($bhyve_config, '_ensure') {
    $ensure = $bhyve_config['_ensure']
  } else {
    $ensure = present
    notify { "${name}: Using default ensure=${ensure}": }
  }

  if has_key($bhyve_config, '_type') {
    $type = $bhyve_config['_type']
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
    if has_key($bhyve_config, '_ensure_directories') {
      $directories = prefix($bhyve_config['_ensure_directories'], $mountpoint)
      file { $directories:
        ensure  => $ensure_directory,
        replace => false,
        #group   => $root_group,

        require => Zfs::Create["${zpool}${mountpoint}"],
      }
    }
    if has_key($bhyve_config, '_ensure_zfs') {
      $ensure_zfs = $bhyve_config['_ensure_zfs']
      bhyve::ensure_zfs { $ensure_zfs:
        ensure     => $ensure,
        zpool      => $zpool,
        mountpoint => $mountpoint,

        require => File[$mountpoint],
      }
    }
  }

  case $type {
    nooper: {
    }
    generic: {
      bhyve::generic::create { $name:
        ensure       => $ensure,
        mountpoint   => $mountpoint,
        bhyve_config => $bhyve_config,

        require      => Zfs::Create["${zpool}${mountpoint}"],
      }
    }
    default: {
      fail("Type ${type} not yet implemented")
    }
  }
}
