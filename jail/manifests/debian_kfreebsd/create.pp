define jail::debian_kfreebsd::create (
  $ensure,
  $use_zfs,
  $mountpoint,
  $jail_config = {}
) {
  include jail::debian_kfreebsd

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

      unless  => "/bin/test -f ${mountpoint}/etc/debian_version",
    }
    #
    #   file { "${mountpoint}/etc/hostname":
    #     ensure  => file,
    #     content => $name,
    #
    #     require => Exec["${name}_debootstrap"],
    #   }
  }
  #
  # # ZFS mounts after fstab
  # if $use_zfs {
  #   $add_options = ',noauto'
  # } else {
  #   $add_options = ''
  # }
  #
  # mount { "${name}_linprocfs":
  #   name    => "${mountpoint}/proc",
  #   ensure  => $ensure_mount,
  #   device  => 'linproc',
  #   fstype  => 'linprocfs',
  #   options => "rw${add_options}",
  # }
  #
  # mount { "${name}_linsysfs":
  #   name    => "${mountpoint}/sys",
  #   ensure  => $ensure_mount,
  #   device  => 'linsys',
  #   fstype  => 'linsysfs',
  #   options => "rw${add_options}",
  # }
  #
  # mount { "${name}_tmpfs":
  #   name    => "${mountpoint}/run",
  #   ensure  => $ensure_mount,
  #   device  => 'tmpfs',
  #   fstype  => 'tmpfs',
  #   options => "rw${add_options}",
  # }
  #
  # # mount { "${name}_devfs":
  # #   name    => "${mountpoint}/dev",
  # #   ensure  => $ensure_mount,
  # #   device  => 'devfs',
  # #   fstype  => 'devfs',
  # #   options => "ro${add_options}",
  # # }
}
