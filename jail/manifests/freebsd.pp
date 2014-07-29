class jail::freebsd (
  $ensure = present,
) {
  $exec_start = '/etc/rc'
  $exec_stop = '/etc/rc.shutdown'

  if $ensure == present {
    file { '/tmp/jailbootstrap':
      ensure => directory,
    }
  }
}

