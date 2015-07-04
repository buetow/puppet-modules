class yum_cron (
  $ensure = running,
  $records_file = '/var/spool/yum_cron/records',
  $apply_updates = 'yes',
  $email_from = 'yum-cron@mx.buetow.org',
  $email_to = 'yum-cron@mx.buetow.org',
) {
  case $ensure {
    'running': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
      $ensure_service = running
      $ensure_enabled = enabled
      $service_enable = true
    }
    'stopped': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
      $ensure_service = stopped
      $service_enable = false
    }
    'present': {
      $ensure_package = present
      $ensure_file = present
      $ensure_directory = directory
      $ensure_service = stopped
      $service_enable = false
    }
    'absent': {
      $ensure_package = absent
      $ensure_file = absent
      $ensure_directory = absent
      $ensure_service = stopped
      $service_enable = false
    }
  }

  class { 'yum_cron::packages':
    ensure => $ensure_package,
  }

  file { '/etc/yum/yum-cron.conf':
    ensure  => $ensure_file,
    content => template('yum_cron/yum-cron.conf.erb'),
  }

  service { 'yum-cron':
    ensure => $ensure_service,
    enable => $ensure_enable,

    require => File['/etc/yum/yum-cron.conf']
  }
}
