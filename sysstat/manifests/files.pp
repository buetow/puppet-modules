class sysstat::files (
  $ensure = present
) {
  File { owner => root, group => root, ensure => $ensure }

  file { '/etc/default/sysstat':
    source => 'puppet:///modules/sysstat/default/sysstat',
  }

  file { '/etc/cron.d/sysstat':
    source => 'puppet:///modules/sysstat/cron.d/sysstat',
  }
}
