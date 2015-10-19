class squid_freebsd (
  $ensure = present,
  $http_port = '127.0.0.1:3128',
) {

  package { 'squid':
    ensure => $ensure,
  }

  file { '/usr/local/etc/squid/squid.conf':
    ensure  => $ensure,
    content => template('squid_freebsd/squid.conf.erb'),
  }

  freebsd::rc_enable { 'squid':
    ensure    => $ensure,
    subscribe => File['/usr/local/etc/squid/squid.conf'],
    require   => File['/usr/local/etc/squid/squid.conf'],
  }
}
