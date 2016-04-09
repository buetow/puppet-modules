class zfs::zpool_scrub (
  $ensure = present,
  $threshold = 30
){
  Exec {
    path => '/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin'
  }

  freebsd::periodic_config { 'daily_scrub_zfs_enable':
    ensure => $ensure,
    value  => 'YES',
  }

  freebsd::periodic_config { 'daily_scrub_zfs_default_threshold':
    ensure => $ensure,
    value  => $threshold
  }
}
