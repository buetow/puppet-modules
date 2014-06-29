define freebsd::rc_enable (
  $ensure = present,
  $option = 'YES',
){
  file { "/etc/rc.conf.d/${name}_enable":
    content => "${name}_enable='${option}'",
    ensure  => $ensure,
  }
}
