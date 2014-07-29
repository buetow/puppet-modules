class jail::freebsd (
  $ensure = present,
) {
  $exec_start = '/bin/sh /etc/rc'
  $exec_stop = '/bin/sh /etc/rc.shutdown'
}

