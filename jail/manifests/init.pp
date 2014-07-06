class jail (
  $ensure = present,
  $use_zfs = true,
  $mountpoint = '/jails',
  $zfs_tank = 'zroot',
  $jail_base_config = {},
  $jails_config = [],
) {
  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  # (..) is for line order in resulting jail.conf
  $jail_base_config_default = {
    '(01)exec.start'      => '"/bin/sh /etc/rc"',
    '(02)exec.start'      => '"/bin/sh /etc/rc.shutdown"',
    '(03)exec.clean; //'  => '',
    '(04)mount.devfs; //' => '',
    '(05)path'            => '"/var/jail/$name"',
  }

  $base_config = merge($jail_base_config_default, $jail_base_config)

  file { $mountpoint:
    ensure => $ensure_directory,
    force  => true,
  }

  if $use_zfs {
    zfs::zfs_create { "${zfs_tank}${mountpoint}":
      ensure     => $ensure,
      filesystem => $mountpoint,

      require    => File[$mountpoint],
    }
  }

  freebsd::rc_enable { 'jail':
    ensure => $ensure,
  }

  file { '/etc/jail.conf':
    ensure  => $ensure,
    content => template('jail/jail.conf.erb')
  }
}

