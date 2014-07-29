class jail::freebsd (
  $ensure = present,
) {
  $exec_start = '/bin/sh /etc/rc'
  $exec_stop = '/bin/sh /etc/rc.shutdown'

  if $ensure == present {
    file { '/tmp/jailbootstrap':
      ensure => directory,
    }
  } else {
    file { '/tmp/jailbootstrap':
      ensure  => absent,
      purge   => true,
      recurse => true,
    }
  }
}

