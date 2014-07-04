define maildelayed (
  $user = $name,
  $home = "/home/${user}",
  $ensure = present,
  $cron_hour = '*',
  $cron_minute = '*',
) {

  File {
    owner  => $user,
  }

  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  file { "${home}/bin/maildelayed":
    ensure => $ensure,
    source => 'puppet:///maildelayed/maildelayed',
    mode   => '0755',
  }

  cron { 'maildelayed':
    ensure  => $ensure,
    command => "${home}/bin/maildelayed cron",
    user    => $user,
    hour    => $cron_hour,
    minute  => $cron_minute,
  }
}
