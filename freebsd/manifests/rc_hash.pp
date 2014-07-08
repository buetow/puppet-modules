define freebsd::rc_hash (
  $hash,
  $ensure = present,
){
  file { "/etc/rc.conf.d/${name}":
    ensure  => $ensure,
    content => template('freebsd/rc_hash.erb'),
  }
}
