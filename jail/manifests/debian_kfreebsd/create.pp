define jail::debian_kfreebsd::create (
  $ensure = present,
  $use_zfs = true,
  $mirror = 'http://http.debian.net/debian',
  $mountpoint = "/jails/${name}",
  $debootstrap_args = '--exclude=devd,dmidecode,isc-dhcp-client,isc-dhcp-common,kldutils,pf,vidcontrol',
  $dist = 'wheezy',
  $config_add = {}
) {
  case $ensure {
    present: { $ensure_mount = mounted }
    absent: { $ensure_mount = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  $config_default = {
  }

  $config = merge($config_default, $config_add)

  jail::create { $name:
    ensure     => $ensure,
    use_zfs    => $use_zfs,
    mountpoint => $mountpoint,
    config_add => $config,
  }

  if $ensure == present {
    exec { "${name}_debootstrap":
      path    => '/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin',
      command => "debootstrap ${debootstrap_args} ${dist} ${mountpoint} ${mirror}",

      unless  => "/bin/test -f ${mountpoint}/etc/debian_version",
      require => Jail::Create[$name],
    }

    file { "${mountpoint}/etc/hostname":
      ensure  => file,
      content => $name,

      require => Exec["${name}_debootstrap"],
    }
  }

  mount { "${name}_linprocfs":
    name    => "${mountpoint}/proc",
    ensure  => $ensure_mount,
    device  => 'linproc',
    fstype  => 'linprocfs',
    options => 'rw,noauto',
  }

  mount { "${name}_linsysfs":
    name    => "${mountpoint}/sys",
    ensure  => $ensure_mount,
    device  => 'linsys',
    fstype  => 'linsysfs',
    options => 'rw,noauto',
  }

  mount { "${name}_tmpfs":
    name    => "${mountpoint}/run",
    ensure  => $ensure_mount,
    device  => 'tmpfs',
    fstype  => 'tmpfs',
    options => 'rw,noauto',
  }

  mount { "${name}_devfs":
    name    => "${mountpoint}/dev",
    ensure  => $ensure_mount,
    device  => 'devfs',
    fstype  => 'devfs',
    options => 'ro,noauto',
  }
}
