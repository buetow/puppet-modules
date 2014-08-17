define jail::freebsd::create (
  $ensure,
  $mountpoint,
  $bootstrapdir = "${mountpoint}/.jailbootstrap",
  $jail_config = {},
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
    '_fstab_lines' => [],
    '_dists'       => [
      'base.txz',
      'doc.txz',
      'games.txz',
    ],
  }

  $config = merge($jail_config_default, $jail_config)

  if $ensure == present {
    $dists = $config['_dists']
    $mirror = $config['_mirror']
    $remote_path = $config['_remote_path']

    file { $bootstrapdir:
      ensure => directory,
    }

    file { "${bootstrapdir}/bootstrap.sh":
      ensure  => present,
      mode    => '0755',
      content => template('jail/bootstrap.freebsd.sh.erb'),

      require => File[$bootstrapdir],
    }

    exec { "${name}_bootstrap":
      path    => '/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin',
      command => "${bootstrapdir}/bootstrap.sh",
      timeout => 1800,

      require => File["${bootstrapdir}/bootstrap.sh"],
      unless  => "/bin/test -f ${bootstrapdir}/bootstrap.done",
    }
  }

  $fstab_lines = $config['_fstab_lines']
  file { "/etc/fstab.jail.${name}":
    ensure  => $ensure,
    content => template('jail/fstab.freebsd.erb'),
  }
}
