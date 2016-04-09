define freebsd::periodic_config (
  $value,
  $ensure = present,
){
  $periodic_file = '/etc/periodic.conf'

  unless (defined(File[$periodic_file])) {
    file { $periodic_file:
      ensure  => $ensure,
      content => '',
      replace => false,
      mode    => '0644',
      owner   => root,
      group   => wheel,
      before  => File_line[$name],
    }
  }

  file_line { $name:
    ensure  => $ensure,
    line    => "${name}=${value}",
    path    => $periodic_file,
  }
}
