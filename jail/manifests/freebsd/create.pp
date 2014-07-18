define jail::freebsd::create (
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
    '_mirror'      => 'ftp://ftp.de.freebsd.org',
    '_remote_path' => 'FreeBSD/releases/amd64/10.0-RELEASE',
    '_dists'       => [ 
      'base.txz', 
      'docs.txz', 
      'games.txz', 
      'kernel.txz',
    ],
    '_fetch_dir'   => '/tmp',
  }

  $config = merge($jail_config_default, $jail_config)

  if $ensure == present {
    $dists = $config['_dists']
    $mirror = $config['_mirror']
    $remote_path = $config['_remote_path']
    $fetch_dir = $config['_fetch_dir']

    #   exec { "${name}_debootstrap":
    #     path    => '/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin',
    #     command => "debootstrap ${debootstrap_args} ${dist} ${mountpoint} ${mirror}",
    #     timeout => 3600,
    #
    #     unless  => "/bin/test -f ${mountpoint}/etc/debian_version",
    #   }

    # file { "${mountpoint}/etc/hostname":
    #   ensure  => present,
    #   content => "${name}\n",

    #   require => Exec["${name}_debootstrap"],
    # }

    # file { "${mountpoint}/dev":
    #   ensure  => directory,

    #   require => Exec["${name}_debootstrap"],
    # }

  }

  file { "/etc/fstab.jail.${name}":
    ensure  => $ensure,
    content => template('jail/fstab.freebsd.erb'),
  }
}
