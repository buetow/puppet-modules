class freebsd::update (
  $mailto = 'root',
  $cron_update_fetch_ensure = present,
  $cron_update_fetch_hour = '0',
  $cron_update_fetch_minute = '7',
  $cron_update_fetch_reboot_ensure = present,
  $cron_pkg_upgrade_ensure = absent,
  $cron_pkg_upgrade_hour = '1',
  $cron_pkg_upgrade_minute = '7',
  $cron_pkg_upgrade_reboot_ensure = absent,
  $cron_pkg_audit_ensure = present,
  $cron_pkg_audit_hour = '2',
  $cron_pkg_audit_minute = '7',
  $cron_pkg_audit_reboot_ensure = present,
  $conf_manage = true,
  $conf_components = 'world kernel',
){
  $environment = "MAILTO=${mailto}"

  ## freebsd-update
  cron { 'freebsd_fetch':
    ensure      => $cron_update_fetch_ensure,
    environment => $environment,
    command     => '/usr/sbin/freebsd-update cron',
    hour        => $cron_update_fetch_hour,
    minute      => $cron_update_fetch_minute,
    user        => root,
  }

  ## freebsd-update at boot
  cron { 'freebsd_fetch_reboot':
    ensure  => $cron_update_fetch_reboot_ensure,
    environment => $environment,
    command => '/usr/sbin/freebsd-update cron',
    user    => root,
    special => 'reboot',
  }

  ## pkg upgrade
  cron { 'freebsd_pkg_upgrade':
    ensure  => $cron_pkg_upgrade_ensure,
    environment => $environment,
    command => '/usr/bin/yes | /usr/sbin/pkg upgrade',
    hour    => $cron_pkg_upgrade_hour,
    minute  => $cron_pkg_upgrade_minute,
    user    => root,
  }

  ## pkg upgrade at boot
  cron { 'freebsd_pkg_upgrade_reboot':
    ensure  => $cron_pkg_upgrade_reboot_ensure,
    environment => $environment,
    command => '/usr/bin/yes | /usr/sbin/pkg upgrade',
    user    => root,
    special => 'reboot',
  }

  ## pkg audit
  cron { 'freebsd_pkg_audit':
    ensure  => $cron_pkg_audit_ensure,
    environment => $environment,
    command => '/usr/bin/yes | /usr/sbin/pkg audit',
    hour    => $cron_pkg_audit_hour,
    minute  => $cron_pkg_audit_minute,
    user    => root,
  }

  ## pkg audit at boot
  cron { 'freebsd_pkg_audit_reboot':
    ensure  => $cron_pkg_audit_reboot_ensure,
    environment => $environment,
    command => '/usr/bin/yes | /usr/sbin/pkg audit',
    user    => root,
    special => 'reboot',
  }


  if $conf_manage {
    file { '/etc/freebsd-update.conf':
      ensure  => file,
      content => template('freebsd/freebsd-update.conf.erb'),
    }
  }
}
