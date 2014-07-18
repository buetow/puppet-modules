class jail::debian_kfreebsd (
  $ensure = present,
) {
  $exec_start = '/etc/rc'
  $exec_stop = '/etc/rc.shutdown'

  file { '/tmp/jailbootstrap':
    ensure => directory,
  }
}

