class bhyve (
  $ensure = present,
  $use_zfs = true,
  $mountpoint = '/bhyve',
  $zpool = 'zroot',
  $bhyves_base_config = {},
  $bhyves_config = {},
) {
  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  $bhyve_default_path = "${mountpoint}/\$name"

  # Keys with leading _ are not added to bhyve.conf
  # (..). is for line order in resulting bhyve.conf
  $bhyves_base_config_default = {
  }

  $base_config = merge($bhyves_base_config_default, $bhyves_base_config)

  file { $mountpoint:
    ensure => $ensure_directory,
  }

  zfs::create { "${zpool}${mountpoint}":
    ensure     => $ensure,
    filesystem => $mountpoint,
    nooper     => !$use_zfs,

    require    => File[$mountpoint],
  }

  $bhyve_names = keys($bhyves_config)
  bhyve::create { $bhyve_names:
    use_zfs         => $use_zfs,
    base_mountpoint => $mountpoint,
    zpool           => $zpool,
    bhyves_config   => $bhyves_config,
  }
}

