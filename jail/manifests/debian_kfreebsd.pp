class jail::debian_kfreebsd (
  $ensure = present,
) {
  $exec_start = '/etc/init.d/rc.jail.start'
  $exec_stop = '/etc/init.d/rc.jail.stop'

  package { 'debootstrap':
    ensure => $ensure,
  }
}

