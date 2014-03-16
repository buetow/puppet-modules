class uptimed::files (
  $ensure,
) {
  File { owner => root, group => root, mode => '0644' }

  file { '/etc/uptimed.conf':
    ensure  => $ensure,
    content => template('uptimed/uptimed.conf.erb'),
  }
}
