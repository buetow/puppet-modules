class poudriere (
  $ensure = present,
  $zpool = 'zroot',
  $distfiles_cache = '/usr/ports/distfiles',
) {
  case $ensure {
    present: {
      $ensure_file = file
      $ensure_package = present
    }
    absent: {
      $ensure_file = absent
      $ensure_package = absent
    }
    default: {
      fail("No such ensure: ${ensure}")
    }
  }

  package { 'poudriere':
    ensure => $ensure_package,
  }

  # Don't deinstall if this class is ensure absent 
  if $ensure == present {
    package { 'dialog4ports':
      ensure => $ensure_package
    }
  }

  file { '/usr/local/etc/poudriere.conf':
    ensure  => $ensure_file,
    content => template('poudriere/poudriere.conf.erb'),
  }
}
