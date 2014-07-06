class jail::debian_kfreebsd (
  $ensure = present,
) {
  $exec_start = '/etc/rc.jail.start'
  $exec_stop = '/etc/rc.jail.stop'

  package { 'debootstrap':
    ensure => $ensure,
  }
}

