define freebsd::rc_config (
  $value,
  $ensure = present,
){
  file_line { $name:
    ensure  => $ensure,
    line    => "${name}=${value}",
    path    => '/etc/rc.conf',
  }
}
