class ports (
  $ensure = present,
  $mountpoint = '/ports',
  $symlink = '/usr/ports',
  $use_zfs = true,
  $zfs_tank = 'zroot',
  $exec_timeout = 5400, # Initial portsnap cron got a random sleep of 3600
) {
  case $ensure {
    present: {
      $ensure_file = file
      $ensure_directory = directory
      $ensure_link = link
    }
    absent: {
      $ensure_file = absent
      $ensure_directory = absent
      $ensure_link = absent
    }
    default: {
      fail("No such ensure: ${ensure}")
    }
  }

  Exec {
    path    => '/bin:/sbin:/usr/bin:/usr/sbin/:/usr/local/bin:/usr/local/sbin',
    timeout => $exec_timeout,
  }

  file { $mountpoint:
    ensure => $ensure_directory,
  }

  if $symlink != '' {
    file { $symlink:
      ensure => $ensure_link,
      target => $mountpoint,
    }
  }

  zfs::create { "${zfs_tank}${mountpoint}":
    ensure     => $ensure,
    filesystem => $mountpoint,
    noop       => !$use_zfs,

    require    => File[$mountpoint],
  }

  $portsbootstrap = "${mountpoint}/.portsbootstrap"
  $bootstrapdone = "${portsbootstrap}/bootstrap.done"

  file { $portsbootstrap:
    ensure  => $ensure_directory,
    require => Zfs::Create["${zfs_tank}${mountpoint}"],
  }

  exec { 'clean_portsnap_db':
    command => 'sh -c "rm -Rf /var/db/portsnap/*; exit 0"',

    require => File[$portsbootstrap],
    unless  => "test -f ${bootstrapdone}"
  }

  notify { 'portsnap_fetch':
    message => 'portsnap cron DOES NOT RANDOMLY SLEEP UP TO 3600s! BE PATIENT!',

    require =>  Exec['clean_portsnap_db'],
  }

  exec { 'portsnap_fetch':
    command => 'portsnap cron',

    require => Notify['portsnap_fetch'],
    unless  => "test -f ${bootstrapdone}",
  }

  exec { 'portsnap_extract':
    command => 'portsnap extract',

    require => Exec['portsnap_fetch'],
    unless  => "test -f ${bootstrapdone}",
  }

  file { $bootstrapdone:
    ensure  => $ensure_file,

    require => Exec['portsnap_extract'],
  }
}

