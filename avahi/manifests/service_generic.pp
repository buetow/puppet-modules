define avahi::service_generic (
  $descr,
  $ensure = present
) {

  file { "/etc/avahi/services/${name}.service":
    ensure  => $ensure,
    content => template("avahi/${name}.service.erb"),
  }
}

