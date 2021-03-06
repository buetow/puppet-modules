class ejabberd {
  package { 'ejabberd':
    ensure => installed
  }

  class { 'ejabberd::files':
    require => Package['ejabberd'],
  }

  service { 'ejabberd':
    ensure    => running,
    hasstatus => true,

    subscribe => [Class['ejabberd::files'],Package['ejabberd']],
    require   => Class['ejabberd::files'],
  }
}
