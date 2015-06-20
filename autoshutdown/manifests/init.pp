class autoshutdown (
    $ensure = present,
    $up_hours = 6,
    $cron_use = true,
    $cron_hour = '2',
    $cron_minute = '0',
    $halt_command = '/sbin/halt -p',
    $test_path = '/bin/test',
    $install_prefix = '/usr/local/bin',
    $auto_clear = true,
) {
  case $ensure {
    present: {
      if $uptime_hours >= $up_hours {
        if $cron_use {
          $cron_ensure = present
        } else {
          $cron_ensure = absent
          exec { 'shutdown':
            command => $halt_command,
            user    => root,
            unless  => "${test_path} -f /var/run/autoshutdown.disable",
          }
        }
      }
    }
    default: {
      $cron_ensure = absent
    }
  }

  cron { 'autoshutdown':
    ensure  => $cron_ensure,
    user    => root,
    command => "/bin/test -f /var/run/autoshutdown.disable || ${halt_command}",
    hour    => $cron_hour,
    minute  => $cron_minute,
  }

  file { "${install_prefix}/autoshutdown":
    ensure => $ensure,
    source => 'puppet:///modules/autoshutdown/autoshutdown',
    owner  => root,
    group  => $root_group,
    mode   => '0755',
  }

  if $auto_clear {
    $auto_clear_present = $present
  } else {
    $auto_clear_present = absent
  }

  cron { 'autoshutdown_clear':
    ensure  => $auto_clear_present,
    command => 'rm /var/run/autoshutdown.disable',
    user    => root,
    special => 'reboot',
  }
}

