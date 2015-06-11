class autoshutdown (
    $ensure = present,
    $up_hours = 6,
    $halt_command = '/sbin/halt -p',
    $test_path = '/bin/test',
    $install_prefix = '/usr/local/bin',
    $auto_clear = true,
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

