class icinga::files (
  $ensure,
){
  file { '/etc/icinga/icinga.cfg':
    ensure  => $ensure,
    content => template('icinga/icinga.cfg.erb'),
  }
}
