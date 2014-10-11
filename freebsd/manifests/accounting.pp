class freebsd::accounting (
  $ensure = present,
){
  file { '/var/account/acct':
    ensure  => $ensure,
    content => '',
    replace => false,
    mode    => '0600',
  }

  if $ensure == present {
    exec { '/usr/sbin/accton':
      refreshonly => true,
      subscribe   => File['/var/account/acct'],
      require     => File['/var/account/acct'],
    }
  }

  freebsd::rc_enable { 'accounting':
    ensure => $ensure,
  }
}
