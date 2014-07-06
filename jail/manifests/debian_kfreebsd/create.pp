define jail::debian_kfreebsd::create (
  $ensure,
  $mountpoint,
  $jail_config = {}
) {
  case $ensure {
    present: { $ensure_mount = mounted }
    absent: { $ensure_mount = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  # Keys with preceeding _ are not added to jail.conf
  $jail_config_default = {
    '_mirror'           => 'http://http.debian.net/debian',
    '_debootstrap_args' => '--exclude=devd,dmidecode,isc-dhcp-client,isc-dhcp-common,kldutils,pf,vidcontrol',
    '_dist'             => 'wheezy',
  }

  $config = merge($jail_config_default, $jail_config)

  if $ensure == present {
    $debootstrap_args = $config['_debootstrap_args']
    $dist = $config['_dist']
    $mirror = $config['_mirror']

    exec { "${name}_debootstrap":
      path    => '/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin',
      command => "debootstrap ${debootstrap_args} ${dist} ${mountpoint} ${mirror}",
      timeout => 3600,

      unless  => "/bin/test -f ${mountpoint}/etc/debian_version",
    }

    file { "${mountpoint}/etc/hostname":
      ensure  => present,
      content => "${name}\n",

      require => Exec["${name}_debootstrap"],
    }

    file { "${mountpoint}/dev":
      ensure  => directory,

      require => Exec["${name}_debootstrap"],
    }

    file { "${mountpoint}/etc/rc.jail.start":
      ensure  => present,
      mode    => '0755',
      content => "#!/bin/sh\n/etc/init.d/rc S && /etc/init.d/rc 2\n",

      require => Exec["${name}_debootstrap"],
    }

    file { "${mountpoint}/etc/rc.jail.stop":
      ensure  => present,
      mode    => '0755',
      content => "#!/bin/sh\n/etc/init.d/rc 0\n",

      require => Exec["${name}_debootstrap"],
    }
  }

  file { "/etc/fstab.jail.${name}":
    ensure  => $ensure,
    content => template('jail/fstab.debian_kfreebsd.erb'),
  }
}
