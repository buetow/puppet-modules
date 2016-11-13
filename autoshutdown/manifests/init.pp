class autoshutdown (
    $ensure = present,
    $up_hours = 24,
    $autoclear_use = true,
    $cron_use = true,
    $cron_hour = '16',
    $cron_minute = '0',
    $halt_command = '/sbin/halt -p',
    $test_path = '/bin/test',
    $install_prefix = '/usr/local/bin',
    $disable_file = '/var/run/autoshutdown.disable',
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
            unless  => "${test_path} -f ${disable_file}"
          }
        }
      } else {
        $cron_ensure = absent
      }
    }
    default: {
      $cron_ensure = absent
    }
  }

  file { "${install_prefix}/autoshutdown":
    ensure => $ensure,
    source => 'puppet:///modules/autoshutdown/autoshutdown',
    owner  => root,
    group  => $root_group,
    mode   => '0755',
  }

  if $autoclear_use {
    $autoclear_ensure = present
  } else {
    $autoclear_ensure = absent
  }

  cron { 'autoshutdown_clear':
    ensure  => $autoclear_ensure,
    command => "/bin/rm ${disable_file}",
    user    => root,
    special => 'reboot',
  }

  cron { 'autoshutdown':
    ensure  => $cron_ensure,
    user    => root,
    command => "/bin/test -f ${disable_file} || ${halt_command}",
    hour    => $cron_hour,
    minute  => $cron_minute,
  }
}

