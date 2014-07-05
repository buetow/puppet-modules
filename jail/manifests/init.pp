class jail (
  $ensure = present,
  $use_zfs = true,
  $mountpoint = '/jails',
  $zfs_tank = 'zroot',
  $jail_list = '',
  $config_add = {},
) {
  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  file { '/etc/jail.d/':
    ensure => $ensure_directory,
    force  => $force,
  }

  $config_default = {
    'jail_enable'        => 'YES',
    'jail_list'          => regsubst($jail_list, '\.', '', 'G'),
    '. /etc/jail.d/* # ' => 'Include jails',
  }

  $config = merge($config_default, $config_add)

  freebsd::rc_hash { 'jail':
    ensure => $ensure,
    hash   => $config,
  }

  file { $mountpoint:
    ensure => $ensure_directory,
    force  => $force,
  }

  if $use_zfs {
    zfs::zfs_create { "${zfs_tank}${mountpoint}":
      ensure     => $ensure,
      filesystem => $mountpoint,

      require => File[$mountpoint],
    }
  }
}

