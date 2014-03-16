class icinga (
  $ensure = running,
  $enable_web = false,
){
  case $ensure {
    running: {
      $ensure_packages = installed
      $ensure_files = present
      $ensure_directory = directory
      $ensure_service = running
      $enable_service = true
    }
    stopped: {
      $ensure_packages = installed
      $ensure_files = present
      $ensure_directory = directory
      $ensure_service = stopped
      $enable_service = false
    }
    present: {
      $ensure_packages = installed
      $ensure_files = present
      $ensure_directory = directory
      $ensure_service = stopped
      $enable_service = false
    }
    absent: {
      $ensure_packages = absent
      $ensure_files = absent
      $ensure_directory = absent
      $ensure_service = stopped
      $enable_service = false
    }
    default: {
    }
  }

  File { owner => root, group => root }

  class { 'icinga::packages':
    ensure => $ensure_packages,
  }

  class { 'icinga::files':
    ensure => $ensure_files,

    require => Class['icinga::packages'],
  }

  file { '/etc/icinga/puppet-objects':
    ensure => $ensure_directory,
    force  => true,
    mode   => '0755',
  }

  if $ensure_service != '' {
    service { 'icinga':
      ensure    => $ensure_service,
      hasstatus => false,
      enable    => $enable_service,

      require   => Class['icinga::files'],
      subscribe => [Class['icinga::files'],Class['icinga::packages']],
    }
    if $ensure == absent {
      file { '/etc/icinga':
        ensure   => absent,
        force    => true,
        recurese => true,

        require => Service['icinga'],
      }
    }
  }

  if $enable_web == false {
    file { '/etc/apache2/conf.d/icinga.conf':
      ensure => absent
    }
  }
}
