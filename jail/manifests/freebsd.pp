class jail::freebsd (
  $ensure = present,
) {
  $exec_start = '/etc/rc'
  $exec_stop = '/etc/rc.shutdown'

  file { '/tmp/jailbootstrap':
    ensure => directory,
  }
}

