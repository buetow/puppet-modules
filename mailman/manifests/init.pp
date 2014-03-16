class mailman {
  package { 'mailman':
    ensure => installed
  }

  class { 'mailman::files':
    require => Package['mailman'],
  }

  exec { '/etc/init.d/apache2 reload':
    refreshonly => true,

    require     => Class['mailman::files'],
    subscribe   => Class['mailman::files'],
  }
}
