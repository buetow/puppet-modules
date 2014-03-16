define avahi::service_nfsshare (
  $mountpoint,
  $descr = '',
  $ensure = present
) {
  if $descr == '' {
    $description = "NFS share ${name}"
  } else {
    $description = $descr
  }

  file { "/etc/avahi/services/nfsshare-${name}.service":
    ensure  => $ensure,
    content => template('avahi/nfsshare.service.erb'),
  }
}

