class autoshutdown (
    $ensure = present,
    $up_hours = 6,
    $halt_command = '/sbin/halt -p',
) {
  case $ensure {
    present: {
      if $uptime_hours >= $up_hours {
        exec { 'shutdown':
          command => $halt_command,
          user    => root,
        }
      }
    }
    default: {
    }
  }
}

