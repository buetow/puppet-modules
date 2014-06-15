class uptimed::files (
  $ensure,
) {
  File { 
    owner => root, 
    group => $::inter::rootgroup,
    mode => '0644',
  }

  file { "${::inter::defaultprefix}/etc/uptimed.conf":
    ensure  => $ensure,
    content => template('uptimed/uptimed.conf.erb'),
  }
}
