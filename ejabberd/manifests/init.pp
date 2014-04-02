class ejabberd {
  package { 'ejabberd':
    ensure => installed
  }

  class { 'ejabberd::files':
    require => Package['ejabberd'],
  }

  service { 'ejabberd':
    nsure    => running,
    #hasstatus => false,

    subscribe => [Class['ejabberd::files'],Package['ejabberd']],
    require   => Class['ejabberd::files'],
  }
}
