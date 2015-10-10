class squid_freebsd (
  $ensure = present,
) {

  package { 'squid':
    ensure => $ensure,
  }

  freebsd::rc_enable { 'squid':
    ensure => $ensure,
  }
}
