class autoshutdown (
    $ensure = present,
    $up_hours = 6,
    $halt_command = '/sbin/halt -p',
    $test_path = '/bin/test',
) {
  case $ensure {
    present: {
      if $uptime_hours >= $up_hours {
        exec { 'shutdown':
          command => $halt_command,
          user    => root,
          unless  => "${test_path} -f /var/run/autoshutdown.disable",
        }
      }
    }
    default: {
    }
  }
}

