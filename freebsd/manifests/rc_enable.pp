define freebsd::rc_enable (
  $ensure = present,
  $option = 'YES',
){
  file { "/etc/rc.conf.d/${name}_enable":
    ensure  => absent,
    content => "${name}_enable='${option}'\n",
  }
  file { "/etc/rc.conf.d/${name}":
    ensure  => $ensure,
    content => "${name}_enable='${option}'\n",
  }
}
