define freebsd::rc_config (
  $value,
  $ensure = present,
){
  file { "/etc/rc.conf.d/${name}":
    ensure  => $ensure,
    content => "${name}=${value}\n",
  }
}
