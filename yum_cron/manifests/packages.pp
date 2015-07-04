class yum_cron::packages (
  $ensure,
){

  package { 'yum-cron':
    ensure => $ensure,
  }
}
