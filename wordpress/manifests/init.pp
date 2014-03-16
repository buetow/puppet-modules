class wordpress (
  $ensure = present
) {

  package { 'wordpress':
    ensure => $ensure,
  }

  class { 'wordpress::files':
    ensure  => $ensure,

    require => Package['wordpress'],
  }

  exec { "${name}_reload_apache":
    command     => '/etc/init.d/apache2 reload',
    refreshonly => true,

    require   => Class['wordpress::files'],
    subscribe => Class['wordpress::files'],
  }
}

