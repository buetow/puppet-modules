class freebsd::update (
  $cron_fetch_ensure = present,
  $cron_fetch_hour = '0',
  $cron_fetch_minute = '7',
  $cron_fetch_reboot_ensure = present,
){
  cron { 'freebsd_update_fetch':
    ensure  => $cron_fetch_ensure,
    command => '/usr/sbin/freebsd-update cron',
    hour    => $cron_fetch_hour,
    minute  => $cron_fetch_minute,
    user    => root,
  }

  cron { 'freebsd_update_fetch_reboot':
    ensure  => $cron_fetch_reboot_ensure,
    command => '/usr/sbin/freebsd-update cron',
    user    => root,
    special => 'reboot',
  }
}
