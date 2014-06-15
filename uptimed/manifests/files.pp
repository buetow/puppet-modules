class uptimed::files (
  $ensure,
) {
  File { 
    owner => root, 
    group => $root_group,
    mode => '0644',
  }

  file { "${default_prefix}/etc/uptimed.conf":
    ensure  => $ensure,
    content => template('uptimed/uptimed.conf.erb'),
  }
}
