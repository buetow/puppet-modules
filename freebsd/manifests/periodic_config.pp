define freebsd::periodic_config (
  $value,
  $ensure = present,
){
  file_line { $name:
    ensure  => $ensure,
    line    => "${name}=${value}",
    path    => '/etc/periodic.conf',
  }
}
