define avahi::service_rsyncd (
  $descr = '',
  $ensure = present
) {
  if $descr == '' {
    $description = "rsyncd modulee ${name}"
  } else {
    $description = $descr
  }

  file { "/etc/avahi/services/rsyncd-${name}.service":
    ensure  => $ensure,
    content => template('avahi/rsyncd.service.erb'),
  }
}

