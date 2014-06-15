class uptimed (
  $ensure = present,
  $records_file = '/var/spool/uptimed/records',
) {

  class { 'uptimed::packages':
    ensure => $ensure,
  }

  class { 'uptimed::files':
    ensure => $ensure,

    require => Class['uptimed::packages'],
  }

  service { 'uptimed':
    ensure => running,
    enable => true,

    require => Class['uptimed::files'],
  }
}
