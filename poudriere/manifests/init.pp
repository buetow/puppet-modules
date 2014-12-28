class poudriere (
  $ensure = present,
  $zpool = 'zroot',
  $distfiles_cache = '/usr/ports/distfiles',
  $manage_myconf = true,
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
    # To put my own pkg lists files
    if $manage_myconf {
      file { '/usr/local/etc/poudriere.d/myconf':
        ensure  => directory,
      }
      file { '/root/poudriere':
        ensure => link,
        target => '/usr/local/etc/poudriere.d/myconf',
      }
    }
  } else {
    if $manage_myconf {
      file { '/usr/local/etc/poudriere.d/myconf':
        ensure  => absent,
        purge   => true,
        recurse => true,
      }
      file { '/root/poudriere':
        ensure => absent,
      }
    }
  }

  file { '/usr/local/etc/poudriere.conf':
    ensure  => $ensure_file,
    content => template('poudriere/poudriere.conf.erb'),
  }
}
